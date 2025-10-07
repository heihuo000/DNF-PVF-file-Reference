# DNF引擎中Squirrel脚本调用机制详解

## 📖 目录
- [引言](#引言)
- [Squirrel语言基础](#squirrel语言基础)
- [DNF引擎脚本架构](#dnf引擎脚本架构)
- [脚本加载机制](#脚本加载机制)
- [双轨触发机制](#双轨触发机制)
- [函数签名驱动机制](#函数签名驱动机制)
- [状态注册驱动机制](#状态注册驱动机制)
- [脚本执行流程](#脚本执行流程)
- [性能优化策略](#性能优化策略)
- [调试与排错](#调试与排错)
- [最佳实践](#最佳实践)

---

## 引言

DNF（地下城与勇士）游戏引擎采用Squirrel脚本语言作为其核心脚本系统，用于实现技能逻辑、角色行为、游戏机制等功能。本文档深入解析DNF引擎中Squirrel脚本的调用机制，帮助开发者理解脚本系统的工作原理。

### 为什么选择Squirrel？

1. **轻量级**: 相比Lua等脚本语言，Squirrel更加轻量
2. **C++友好**: 与C++引擎集成度高，调用效率优秀
3. **语法简洁**: 类似JavaScript的语法，学习成本低
4. **内存安全**: 自动垃圾回收，减少内存泄漏风险

---

## Squirrel语言基础

### 语言特性

#### 1. 动态类型系统
```squirrel
// 变量无需声明类型
local name = "DNF";           // 字符串
local level = 70;             // 整数
local rate = 1.5;             // 浮点数
local isActive = true;        // 布尔值
```

#### 2. 表（Table）数据结构
```squirrel
// 表是Squirrel的核心数据结构
local player = {
    name = "战士",
    level = 70,
    hp = 1000,
    skills = ["剑气", "拔刀斩", "鬼剑术"]
};

// 访问表成员
print(player.name);           // 输出: 战士
print(player["level"]);       // 输出: 70
```

#### 3. 函数定义
```squirrel
// 普通函数
function calculateDamage(attack, defense)
{
    return attack - defense;
}

// 匿名函数
local multiply = function(a, b) { return a * b; };

// 表中的方法
local skill = {
    name = "火球术",
    cast = function(target) {
        print("对 " + target + " 释放 " + this.name);
    }
};
```

#### 4. 类和继承
```squirrel
// 类定义
class Character
{
    constructor(name, level)
    {
        this.name = name;
        this.level = level;
    }
    
    function attack(target)
    {
        print(this.name + " 攻击 " + target);
    }
}

// 继承
class Warrior extends Character
{
    constructor(name, level, weapon)
    {
        base.constructor(name, level);
        this.weapon = weapon;
    }
    
    function slash(target)
    {
        print(this.name + " 用 " + this.weapon + " 斩击 " + target);
    }
}
```

### DNF中的Squirrel扩展

#### 1. 全局对象扩展
```squirrel
// DNF引擎提供的全局对象
IRDSQRCharacter    // 角色管理对象
sq_RGB()           // 颜色函数
sq_flashScreen()   // 屏幕闪烁函数
```

#### 2. 对象方法扩展
```squirrel
// obj对象的扩展方法（由引擎提供）
obj.sq_GetState()              // 获取状态
obj.sq_SetCurrentAnimation()   // 设置动画
obj.sq_AddSetStatePacket()     // 添加状态包
```

---

## DNF引擎脚本架构

### 整体架构图

```mermaid
graph TB
    subgraph "DNF游戏引擎"
        subgraph "C++核心引擎"
            A[渲染系统] 
            B[物理系统]
            C[网络系统]
            subgraph "Squirrel虚拟机"
                D[脚本加载器]
                E[函数调用器]
                F[内存管理器]
            end
        end
        
        subgraph "Squirrel脚本层"
            G["loadstate.nut 入口文件"]
            subgraph "职业脚本"
                H[thief_header.nut]
                I[thief_load_state.nut]
                J[技能脚本文件]
            end
            subgraph "公共脚本"
                K[common.nut]
                L[dnf_enum_header.nut]
            end
            M[工具脚本]
        end
        
        subgraph "游戏数据层"
            N[PVF文件]
            O[技能配置]
            P[角色数据]
        end
    end
    
    %% 依赖关系
    D --> G
    G --> H
    G --> K
    G --> L
    H --> I
    I --> J
    E --> J
    J --> N
    J --> O
    J --> P
    
    %% 样式
    classDef coreEngine fill:#e1f5fe
    classDef scriptLayer fill:#f3e5f5
    classDef dataLayer fill:#e8f5e8
    
    class A,B,C,D,E,F coreEngine
    class G,H,I,J,K,L,M scriptLayer
    class N,O,P dataLayer
```

### 脚本依赖关系图

```mermaid
graph LR
    subgraph "脚本加载顺序"
        A[loadstate.nut] --> B[dnf_enum_header.nut]
        A --> C[common.nut]
        A --> D[职业_header.nut]
        D --> E[职业_load_state.nut]
        E --> F[职业_common.nut]
        E --> G[技能脚本.nut]
        G --> H[技能_appendage.nut]
    end
    
    subgraph "依赖类型"
        I[常量定义] -.-> B
        J[公共函数] -.-> C
        K[职业常量] -.-> D
        L[状态注册] -.-> E
        M[职业函数] -.-> F
        N[技能逻辑] -.-> G
        O[附加效果] -.-> H
    end
    
    %% 样式
    classDef loadOrder fill:#bbdefb
    classDef depType fill:#c8e6c9
    
    class A,B,C,D,E,F,G,H loadOrder
    class I,J,K,L,M,N,O depType
```

### 脚本文件层次结构

#### 1. 核心层（Core Layer）
- **loadstate.nut**: 脚本系统入口点
- **common.nut**: 公共函数库
- **dnf_enum_header.nut**: 枚举常量定义

#### 2. 职业层（Class Layer）
- **[职业]_header.nut**: 职业专用常量定义
- **[职业]_load_state.nut**: 职业状态加载器
- **[职业]_common.nut**: 职业公共函数

#### 3. 技能层（Skill Layer）
- **[技能名].nut**: 具体技能实现
- **[技能名]_appendage.nut**: 技能附加效果

---

## 脚本加载机制

### 加载时机与顺序

#### 1. 游戏启动时加载流程图

```mermaid
flowchart TD
    A[游戏启动] --> B[初始化Squirrel虚拟机]
    B --> C[加载 loadstate.nut]
    C --> D[执行 sq_RunScript 加载基础脚本]
    D --> E[加载 dnf_enum_header.nut]
    D --> F[加载 common.nut]
    E --> G[执行各职业的 load_state.nut]
    F --> G
    G --> H[注册技能状态和脚本映射]
    H --> I[构建函数签名映射表]
    I --> J[脚本系统就绪]
    
    %% 样式
    classDef startProcess fill:#ffcdd2
    classDef loadProcess fill:#c8e6c9
    classDef readyProcess fill:#bbdefb
    
    class A,B startProcess
    class C,D,E,F,G,H,I loadProcess
    class J readyProcess
```

#### 2. 运行时动态加载流程图

```mermaid
flowchart TD
    A[技能触发/事件发生] --> B{检查函数签名映射}
    B -->|找到匹配| C[直接调用函数]
    B -->|未找到| D{检查状态映射表}
    D -->|找到映射| E{脚本是否已加载?}
    D -->|未找到映射| F[忽略事件]
    E -->|已加载| G[调用对应脚本函数]
    E -->|未加载| H[动态加载脚本文件]
    H --> I[缓存脚本到内存]
    I --> G
    C --> J[执行脚本逻辑]
    G --> J
    J --> K{是否需要卸载?}
    K -->|是| L[卸载脚本释放内存]
    K -->|否| M[保持脚本在内存中]
    L --> N[执行完毕]
    M --> N
    F --> N
    
    %% 样式
    classDef triggerProcess fill:#fff3e0
    classDef checkProcess fill:#e1f5fe
    classDef executeProcess fill:#e8f5e8
    classDef endProcess fill:#f3e5f5
    
    class A triggerProcess
    class B,D,E,K checkProcess
    class C,G,H,I,J executeProcess
    class F,L,M,N endProcess
```

### 加载函数对比分析

#### sq_RunScript() - 封包内脚本加载
```squirrel
// 语法
sq_RunScript("相对路径/脚本文件.nut");

// 示例
sq_RunScript("sqr/dnf_enum_header.nut");
sq_RunScript("sqr/character/thief/thief_header.nut");
```

**特点**:
- 从游戏封包（PVF）内加载
- 路径基于封包根目录的相对路径
- 加载速度快（内存读取）
- 修改后需重新打包才能生效

#### dofile() - 文件系统脚本加载
```squirrel
// 语法
dofile("绝对路径或相对路径");

// 示例
dofile("D:/DNF/scripts/test.nut");
dofile("./scripts/debug.nut");
```

**特点**:
- 从文件系统直接加载
- 支持绝对路径和相对路径
- 修改后立即生效（便于调试）
- 依赖磁盘I/O，速度相对较慢

### 加载策略选择

#### 开发阶段策略
```squirrel
// 开发时使用dofile便于调试
if (DEBUG_MODE) {
    dofile("D:/DNF_Dev/scripts/skill_test.nut");
} else {
    sq_RunScript("sqr/character/thief/skill_test.nut");
}
```

#### 生产环境策略
```squirrel
// 生产环境统一使用sq_RunScript
sq_RunScript("sqr/loadstate.nut");
```

---

## 双轨触发机制

DNF引擎采用独特的"双轨触发机制"来调用Squirrel脚本，这种设计兼顾了性能和灵活性。

### 机制概述图

```mermaid
flowchart TD
    A[事件发生] --> B{双轨触发机制}
    
    subgraph "第一轨道 - 函数签名驱动"
        B --> C[扫描全局函数签名]
        C --> D{函数名匹配?}
        D -->|是| E[直接调用函数]
        D -->|否| F[转入第二轨道]
    end
    
    subgraph "第二轨道 - 状态注册驱动"
        F --> G[检查状态映射表]
        G --> H{找到状态映射?}
        H -->|是| I[调用对应脚本]
        H -->|否| J[忽略事件]
    end
    
    E --> K[执行脚本逻辑]
    I --> K
    K --> L[脚本执行完毕]
    J --> L
    
    %% 样式
    classDef eventNode fill:#ffeb3b
    classDef track1 fill:#4caf50
    classDef track2 fill:#2196f3
    classDef executeNode fill:#ff9800
    classDef endNode fill:#9c27b0
    
    class A eventNode
    class C,D,E,F track1
    class G,H,I,J track2
    class K executeNode
    class L endNode
```

### 双轨机制性能对比图

```mermaid
graph LR
    subgraph "性能对比"
        A["函数签名驱动 第一轨道"] --> A1["O(1) 直接调用"]
        B["状态注册驱动 第二轨道"] --> B1["O(log n) 映射查找"]
    end
    
    subgraph "使用场景"
        C["高频事件 如攻击、移动"] --> A
        D["低频事件 如状态变化"] --> B
    end
    
    subgraph "优势特点"
        A1 --> E[性能最优]
        B1 --> F[灵活性强]
        E --> G[适合固定事件]
        F --> H[适合动态事件]
    end
    
    %% 样式
    classDef performance fill:#c8e6c9
    classDef scenario fill:#bbdefb
    classDef advantage fill:#fff3e0
    
    class A,B,A1,B1 performance
    class C,D scenario
    class E,F,G,H advantage
```

### 双轨机制的优势

1. **性能优化**: 第一轨道避免了状态查找的开销
2. **灵活性**: 第二轨道支持动态状态管理
3. **兼容性**: 两种机制可以并存，互不冲突
4. **扩展性**: 便于添加新的触发方式

---

## 函数签名驱动机制

### 工作原理

函数签名驱动机制是DNF引擎的主要脚本调用方式，通过预定义的函数名模式来自动识别和调用脚本函数。

#### 1. 函数签名模式

```squirrel
// 基本模式：事件名_职业名
function 事件名_职业名(参数列表)
{
    // 函数实现
}

// 具体示例
function useSkill_after_ATGunner(obj, skillIndex, isSuccess)
{
    // 女枪手技能使用后的处理
}

function onDamage_Swordman(obj, damager, damage)
{
    // 剑魂受伤时的处理
}
```

#### 2. 职业标识符对照表

| 职业中文名 | 职业标识符 | 示例函数 |
|---------|----------|----------|
| 鬼剑士 | Swordman | `useSkill_Swordman` |
| 格斗家 | Fighter | `onDamage_Fighter` |
| 神枪手 | Gunner | `onAttack_Gunner` |
| 魔法师 | Mage | `onStateChange_Mage` |
| 圣职者 | Priest | `onLevelUp_Priest` |
| 暗夜使者 | Thief | `onSkillCast_Thief` |
| 女枪手 | ATGunner | `useSkill_after_ATGunner` |

#### 3. 事件类型分类

**技能相关事件**:
```squirrel
function useSkill_before_职业名(obj, skillIndex)     // 技能使用前
function useSkill_after_职业名(obj, skillIndex)      // 技能使用后
function onSkillCast_职业名(obj, skillIndex)         // 技能施放时
function onSkillEnd_职业名(obj, skillIndex)          // 技能结束时
```

**战斗相关事件**:
```squirrel
function onAttack_职业名(obj, target, damage)        // 攻击时
function onDamage_职业名(obj, attacker, damage)      // 受伤时
function onKill_职业名(obj, target)                  // 击杀时
function onDeath_职业名(obj, killer)                 // 死亡时
```

**状态相关事件**:
```squirrel
function onStateStart_职业名(obj, state)             // 状态开始
function onStateEnd_职业名(obj, state)               // 状态结束
function onStateChange_职业名(obj, oldState, newState) // 状态改变
```

**全局事件（无职业限制）**:
```squirrel
function onGameStart()                               // 游戏开始
function onLevelLoad(mapName)                        // 关卡加载
function onPlayerJoin(playerObj)                     // 玩家加入
function onPlayerLeave(playerObj)                    // 玩家离开
```

### 函数签名扫描机制

#### 1. 扫描时机流程图

```mermaid
sequenceDiagram
    participant Engine as DNF引擎
    participant VM as Squirrel虚拟机
    participant Script as 脚本文件
    participant Map as 映射表
    
    Engine->>VM: 初始化虚拟机
    Engine->>Script: 加载脚本文件
    Script->>VM: 注册全局函数
    VM->>Engine: 脚本加载完成
    Engine->>VM: 扫描全局函数表
    VM-->>Engine: 返回函数列表
    
    loop 遍历每个函数
        Engine->>Engine: 解析函数签名
        alt 签名匹配成功
            Engine->>Map: 注册事件处理器
        else 签名不匹配
            Engine->>Engine: 忽略该函数
        end
    end
    
    Engine->>Map: 映射表构建完成
    Note over Engine,Map: 系统就绪，等待事件触发
```

#### 2. 签名解析算法流程图

```mermaid
flowchart TD
    A[输入函数名] --> B[按'_'分割字符串]
    B --> C{分割结果 >= 2?}
    C -->|否| D[返回false - 无效签名]
    C -->|是| E["提取事件类型 parts[0]"]
    E --> F["提取职业类型 parts[last]"]
    F --> G{验证事件类型}
    G -->|无效| D
    G -->|有效| H{验证职业类型}
    H -->|无效| D
    H -->|有效| I[构建映射键值]
    I --> J[注册到映射表]
    J --> K[返回true - 成功注册]
    
    %% 样式
    classDef inputNode fill:#e3f2fd
    classDef processNode fill:#e8f5e8
    classDef decisionNode fill:#fff3e0
    classDef errorNode fill:#ffebee
    classDef successNode fill:#e1f5fe
    
    class A inputNode
    class B,E,F,I,J processNode
    class C,G,H decisionNode
    class D errorNode
    class K successNode
```

#### 3. 事件-函数映射表结构图

```mermaid
erDiagram
    EventMap {
        string EventType
        string ClassType
        string FunctionName
        pointer FunctionPtr
        int Priority
    }
    
    EventType ||--o{ EventMap : contains
    ClassType ||--o{ EventMap : contains
    
    EventType {
        string useSkill
        string onAttack
        string onDamage
        string onStateChange
        string onLevelUp
    }
    
    ClassType {
        string Swordman
        string Fighter
        string Gunner
        string Mage
        string Priest
        string Thief
        string ATGunner
    }
```

#### 4. 签名解析算法代码

```cpp
// 伪代码：引擎内部的签名解析逻辑
bool ParseFunctionSignature(string functionName)
{
    // 分割函数名
    vector<string> parts = split(functionName, "_");
    
    if (parts.size() < 2) return false;
    
    string eventType = parts[0];
    string classType = parts[parts.size() - 1];
    
    // 验证事件类型
    if (!IsValidEventType(eventType)) return false;
    
    // 验证职业类型
    if (!IsValidClassType(classType)) return false;
    
    // 注册到映射表
    RegisterEventHandler(eventType, classType, functionName);
    
    return true;
}
```

#### 3. 调用优先级
当多个函数匹配同一事件时，调用优先级如下：
1. **具体职业函数** > **通用函数**
2. **后加载的函数** > **先加载的函数**
3. **用户脚本** > **系统脚本**

### 实际应用示例

#### 示例1：技能使用监听
```squirrel
// 监听所有剑魂的技能使用
function useSkill_after_Swordman(obj, skillIndex, isSuccess)
{
    if (!obj || !isSuccess) return;
    
    // 获取技能信息
    local skillName = obj.sq_GetSkillName(skillIndex);
    local skillLevel = obj.sq_GetSkillLevel(skillIndex);
    
    // 记录技能使用
    print("剑魂使用了技能: " + skillName + " (等级: " + skillLevel + ")");
    
    // 特殊技能处理
    switch(skillIndex)
    {
        case SKILL_WAVE_SWORD:
            // 波动剑特殊处理
            obj.sq_AddBuff(BUFF_SWORD_MASTERY, 5000);
            break;
        case SKILL_GHOST_SLASH:
            // 鬼斩特殊处理
            obj.sq_PlayEffect("ghost_slash_effect.ani");
            break;
    }
}
```

#### 示例2：全局伤害监听
```squirrel
// 监听所有角色的受伤事件
function onDamage(obj, attacker, damage, damageType)
{
    if (!obj || !attacker) return;
    
    // 记录伤害信息
    local targetName = obj.sq_GetName();
    local attackerName = attacker.sq_GetName();
    
    print(attackerName + " 对 " + targetName + " 造成了 " + damage + " 点伤害");
    
    // 暴击判定
    if (damageType == DAMAGE_TYPE_CRITICAL) {
        // 播放暴击特效
        obj.sq_PlayEffect("critical_hit.ani");
        obj.sq_SetShake(obj, 3, 200);
    }
    
    // 低血量警告
    if (obj.sq_GetHPRate() < 0.2) {
        obj.sq_PlaySound("low_hp_warning.wav");
    }
}
```

---

## 状态注册驱动机制

### 工作原理

状态注册驱动机制通过显式注册状态与脚本的映射关系，实现精确的状态控制和脚本调用。

### 状态注册流程图

```mermaid
flowchart TD
    A[游戏启动] --> B[加载职业脚本]
    B --> C[执行load_state.nut]
    C --> D[调用IRDSQRCharacter.pushState]
    D --> E[注册状态映射]
    E --> F{是否还有状态?}
    F -->|是| D
    F -->|否| G[构建状态映射表]
    G --> H[系统就绪]
    
    subgraph "状态触发流程"
        I[技能/事件触发] --> J[查找状态映射]
        J --> K{找到映射?}
        K -->|是| L[加载对应脚本]
        K -->|否| M[忽略事件]
        L --> N[调用生命周期函数]
        N --> O[执行脚本逻辑]
    end
    
    H --> I
    
    %% 样式
    classDef initProcess fill:#e1f5fe
    classDef registerProcess fill:#e8f5e8
    classDef triggerProcess fill:#fff3e0
    classDef executeProcess fill:#f3e5f5
    
    class A,B,C initProcess
    class D,E,F,G,H registerProcess
    class I,J,K,L triggerProcess
    class M,N,O executeProcess
```

### 状态生命周期图

```mermaid
stateDiagram-v2
    [*] --> 状态注册: pushState()
    状态注册 --> 等待触发: 映射建立
    等待触发 --> 状态开始: 事件触发
    状态开始 --> onStart: 调用onStart_前缀()
    onStart --> 状态运行: 初始化完成
    状态运行 --> proc: 每帧调用proc_前缀()
    proc --> 状态运行: 继续执行
    状态运行 --> 动画结束: onEndCurrentAni_前缀()
    状态运行 --> 时间事件: onTimeEvent_前缀()
    状态运行 --> 攻击事件: onAttack_前缀()
    状态运行 --> 受伤事件: onDamage_前缀()
    动画结束 --> 状态结束: 条件满足
    时间事件 --> 状态运行: 事件处理完成
    攻击事件 --> 状态运行: 事件处理完成
    受伤事件 --> 状态运行: 事件处理完成
    状态结束 --> onEnd: 调用onEnd_前缀()
    onEnd --> [*]: 状态清理完成
```

#### 1. 注册函数详解

```squirrel
IRDSQRCharacter.pushState(
    职业枚举,           // ENUM_CHARACTERJOB_XXX
    "脚本文件路径",      // 相对于sqr目录的路径
    "函数前缀",         // 函数名前缀
    状态编号,           // 唯一的状态ID
    技能编号            // 对应的技能ID（可选，-1表示无关联）
);
```

#### 2. 参数详细说明

**职业枚举**:
```squirrel
ENUM_CHARACTERJOB_SWORDMAN     // 鬼剑士
ENUM_CHARACTERJOB_FIGHTER      // 格斗家
ENUM_CHARACTERJOB_GUNNER       // 神枪手
ENUM_CHARACTERJOB_MAGE         // 魔法师
ENUM_CHARACTERJOB_PRIEST       // 圣职者
ENUM_CHARACTERJOB_THIEF        // 暗夜使者
ENUM_CHARACTERJOB_ATGUNNER     // 女枪手
```

**脚本文件路径**:
```squirrel
// 路径规范
"Character/职业名/技能名/脚本文件.nut"

// 示例
"Character/Thief/Zskill00/Zskill00.nut"
"Character/Swordman/WaveSword/WaveSword.nut"
```

**函数前缀**:
```squirrel
// 前缀命名规范
"技能名"              // 简单命名
"职业名_技能名"        // 带职业前缀
"技能名_v2"           // 版本标识
```

#### 3. 自动调用函数模式

注册状态后，引擎会自动查找并调用以下模式的函数：

```squirrel
// 基本生命周期函数
function onStart_前缀(obj, state, datas, isResetTimer)    // 状态开始
function proc_前缀(obj)                                   // 状态持续（每帧）
function onEnd_前缀(obj)                                  // 状态结束
function onAfterSetState_前缀(obj, state, datas)         // 状态设置后

// 扩展事件函数
function onTimeEvent_前缀(obj, timeEventIndex, timeEventCount)  // 时间事件
function onAttack_前缀(obj, damager, boundingBox, isStuck)      // 攻击事件
function onDamage_前缀(obj, attacker, damage)                   // 受伤事件
function onEndCurrentAni_前缀(obj)                              // 动画结束
```

### 注册示例详解

#### 示例1：基础技能注册
```squirrel
// 在thief_load_state.nut中注册
IRDSQRCharacter.pushState(
    ENUM_CHARACTERJOB_THIEF,                    // 暗夜使者职业
    "Character/Thief/Zskill00/Zskill00.nut",   // 脚本路径
    "Zskill00",                                 // 函数前缀
    STATE_ZSKILL00,                             // 状态编号：95
    SKILL_ZSKILL00                              // 技能编号：220
);

// 对应的脚本函数（在Zskill00.nut中）
function onStart_Zskill00(obj, state, datas, isResetTimer)
{
    if (!obj) return;
    
    // 技能开始逻辑
    obj.sq_StopMove();
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);
    obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);
}

function proc_Zskill00(obj)
{
    if (!obj) return;
    
    // 每帧执行的逻辑
    // 例如：检查输入、更新位置等
}

function onEnd_Zskill00(obj)
{
    if (!obj) return;
    
    // 技能结束清理
    obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}
```

#### 示例2：复杂技能注册
```squirrel
// 注册多阶段技能
IRDSQRCharacter.pushState(
    ENUM_CHARACTERJOB_SWORDMAN,
    "Character/Swordman/ComboSlash/ComboSlash.nut",
    "ComboSlash",
    STATE_COMBO_SLASH,
    SKILL_COMBO_SLASH
);

// 对应的脚本实现
function onStart_ComboSlash(obj, state, datas, isResetTimer)
{
    if (!obj) return;
    
    // 初始化连击计数
    obj.sq_SetStaticInt(ENUM_STATIC_INT_01, 0);
    
    // 设置第一段动画
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_COMBO_01);
    obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_COMBO_01);
}

function onTimeEvent_ComboSlash(obj, timeEventIndex, timeEventCount)
{
    if (!obj) return;
    
    local comboCount = obj.sq_GetStaticInt(ENUM_STATIC_INT_01);
    
    switch(timeEventIndex)
    {
        case 0:  // 第一段结束
            comboCount++;
            obj.sq_SetStaticInt(ENUM_STATIC_INT_01, comboCount);
            
            if (comboCount < 3) {
                // 继续下一段
                obj.sq_SetCurrentAnimation(CUSTOM_ANI_COMBO_02);
                obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_COMBO_02);
            }
            break;
            
        case 1:  // 第二段结束
            comboCount++;
            obj.sq_SetStaticInt(ENUM_STATIC_INT_01, comboCount);
            
            // 最终段
            obj.sq_SetCurrentAnimation(CUSTOM_ANI_COMBO_03);
            obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_COMBO_03);
            break;
    }
}

function onAttack_ComboSlash(obj, damager, boundingBox, isStuck)
{
    if (!obj || !damager) return;
    
    local comboCount = obj.sq_GetStaticInt(ENUM_STATIC_INT_01);
    
    // 根据连击段数应用不同效果
    switch(comboCount)
    {
        case 1:
            // 第一段：普通攻击
            break;
        case 2:
            // 第二段：增加击退
            damager.sq_AddForce(200, 0);
            break;
        case 3:
            // 第三段：暴击伤害
            local extraDamage = obj.sq_GetSTR() * 2.0;
            damager.sq_AddDamage(extraDamage);
            break;
    }
}
```

### 状态映射表管理

#### 1. 内部映射表结构
```cpp
// 伪代码：引擎内部的状态映射表
struct StateMapping
{
    int characterJob;        // 职业ID
    string scriptPath;       // 脚本路径
    string functionPrefix;   // 函数前缀
    int stateID;            // 状态ID
    int skillID;            // 技能ID
    bool isLoaded;          // 是否已加载
    ScriptObject* script;   // 脚本对象指针
};

map<int, StateMapping> g_stateMappings;  // 全局状态映射表
```

#### 2. 状态查找算法
```cpp
// 伪代码：状态查找和脚本调用
bool CallStateScript(int characterJob, int stateID, string functionName, params...)
{
    // 构造查找键
    int key = (characterJob << 16) | stateID;
    
    // 查找映射
    auto it = g_stateMappings.find(key);
    if (it == g_stateMappings.end()) {
        return false;  // 未找到映射
    }
    
    StateMapping& mapping = it->second;
    
    // 延迟加载脚本
    if (!mapping.isLoaded) {
        mapping.script = LoadScript(mapping.scriptPath);
        mapping.isLoaded = true;
    }
    
    // 构造完整函数名
    string fullFunctionName = functionName + "_" + mapping.functionPrefix;
    
    // 调用脚本函数
    return mapping.script->CallFunction(fullFunctionName, params...);
}
```

---

## 脚本执行流程

### 完整执行时序图

```mermaid
sequenceDiagram
    participant User as 用户操作
    participant Engine as DNF引擎
    participant Dispatcher as 事件分发器
    participant FuncSig as 函数签名匹配
    participant StateMap as 状态映射查找
    participant Script as Squirrel脚本
    participant VM as 虚拟机环境
    
    User->>Engine: 游戏事件/用户输入
    Engine->>Dispatcher: 事件检测
    
    par 双轨机制并行处理
        Dispatcher->>FuncSig: 扫描全局函数签名
        FuncSig->>FuncSig: 匹配函数名模式
        alt 匹配成功
            FuncSig->>Script: 直接调用函数
        else 匹配失败
            FuncSig->>StateMap: 转入第二轨道
        end
    and
        Dispatcher->>StateMap: 查找状态映射表
        StateMap->>StateMap: 检查状态注册
        alt 找到映射
            StateMap->>Script: 加载/调用脚本
        else 未找到映射
            StateMap->>Engine: 忽略事件
        end
    end
    
    Script->>VM: 进入脚本执行环境
    
    rect rgb(240, 248, 255)
        Note over VM: 脚本执行环境
        VM->>VM: 局部变量栈管理
        VM->>VM: 全局变量表访问
        VM->>VM: 函数调用栈维护
        VM->>Engine: 引擎API接口调用
    end
    
    VM->>Script: 执行脚本逻辑
    Script->>Engine: 返回执行结果
    Engine->>Engine: 引擎后处理
    Engine->>User: 事件处理完成
```

### 脚本执行环境架构图

```mermaid
graph TB
    subgraph "Squirrel虚拟机环境"
        subgraph "内存管理"
            A[局部变量栈]
            B[全局变量表]
            C[函数调用栈]
            D[垃圾回收器]
        end
        
        subgraph "执行引擎"
            E[字节码解释器]
            F[JIT编译器]
            G[异常处理器]
        end
        
        subgraph "API接口层"
            H[引擎API绑定]
            I[游戏对象接口]
            J[系统函数库]
        end
    end
    
    subgraph "DNF引擎核心"
        K[渲染系统]
        L[物理系统]
        M[音频系统]
        N[网络系统]
    end
    
    %% 连接关系
    A --> E
    B --> E
    C --> E
    E --> F
    E --> G
    H --> K
    H --> L
    H --> M
    H --> N
    I --> H
    J --> H
    
    %% 样式
    classDef memoryNode fill:#e3f2fd
    classDef engineNode fill:#e8f5e8
    classDef apiNode fill:#fff3e0
    classDef coreNode fill:#fce4ec
    
    class A,B,C,D memoryNode
    class E,F,G engineNode
    class H,I,J apiNode
    class K,L,M,N coreNode
```

### 技能释放完整流程

```mermaid
flowchart TD
    A[玩家按键输入] --> B[输入系统捕获]
    B --> C{当前状态允许技能释放?}
    C -->|否| D[忽略输入]
    C -->|是| E[调用checkCommandEnable_技能名]
    E --> F{命令检查通过?}
    F -->|否| D
    F -->|是| G[调用checkExecutableSkill_技能名]
    
    G --> H{技能可用性检查}
    H --> H1{MP足够?}
    H1 -->|否| I[显示MP不足]
    H1 -->|是| H2{冷却结束?}
    H2 -->|否| J[显示冷却中]
    H2 -->|是| H3{前置条件满足?}
    H3 -->|否| K[显示条件不足]
    H3 -->|是| H4{技能等级有效?}
    H4 -->|否| L[显示等级不足]
    H4 -->|是| M[添加状态包到队列]
    
    M --> N[引擎处理状态队列]
    N --> O[查找状态映射表]
    O --> P[找到脚本和函数前缀]
    P --> Q[调用onStart_技能名]
    
    Q --> R[设置技能初始状态]
    R --> R1[停止移动]
    R --> R2[设置动画]
    R --> R3[设置攻击信息]
    R --> R4[初始化变量]
    
    R1 --> S[技能状态激活]
    R2 --> S
    R3 --> S
    R4 --> S
    
    S --> T[每帧调用proc_技能名]
    T --> U[处理持续逻辑]
    U --> U1[检查输入]
    U --> U2[更新位置]
    U --> U3[处理特效]
    U --> U4[检查结束条件]
    
    U4 --> V{是否触发时间事件?}
    V -->|是| W[调用onTimeEvent_技能名]
    V -->|否| X{是否有攻击判定?}
    W --> X
    
    X -->|是| Y[攻击框激活]
    X -->|否| Z{技能是否结束?}
    Y --> Y1[碰撞检测]
    Y1 --> Y2{发现目标?}
    Y2 -->|是| Y3[调用onAttack_技能名]
    Y2 -->|否| Z
    Y3 --> Y4[处理攻击逻辑]
    Y4 --> Z
    
    Z -->|否| T
    Z -->|是| AA[动画播放完毕]
    AA --> BB[调用onEndCurrentAni_技能名]
    BB --> CC[状态转换]
    CC --> DD[调用onEnd_技能名]
    DD --> EE[清理资源]
    EE --> FF[技能释放完成]
    
    %% 样式
    classDef inputNode fill:#e3f2fd
    classDef checkNode fill:#fff3e0
    classDef executeNode fill:#e8f5e8
    classDef endNode fill:#f3e5f5
    classDef errorNode fill:#ffebee
    
    class A,B inputNode
    class C,E,F,G,H,H1,H2,H3,H4,V,X,Y2,Z checkNode
    class M,N,O,P,Q,R,R1,R2,R3,R4,S,T,U,U1,U2,U3,U4,W,Y,Y1,Y3,Y4,AA,BB,CC,DD,EE executeNode
    class FF endNode
    class D,I,J,K,L errorNode
```

### 错误处理流程

```mermaid
flowchart TD
    subgraph "脚本加载错误处理"
        A1[脚本加载失败] --> A2[记录错误日志]
        A2 --> A3[使用默认行为]
        A3 --> A4[通知开发者]
        A4 --> A5[继续游戏运行]
    end
    
    subgraph "函数调用错误处理"
        B1[函数不存在或参数错误] --> B2[捕获异常]
        B2 --> B3[记录错误信息]
        B3 --> B4[跳过当前调用]
        B4 --> B5[继续后续处理]
    end
    
    subgraph "运行时错误处理"
        C1[脚本执行异常] --> C2[保存错误上下文]
        C2 --> C3[安全退出脚本]
        C3 --> C4[恢复游戏状态]
        C4 --> C5[显示错误提示]
        C5 --> C6[记录崩溃报告]
    end
    
    subgraph "错误恢复策略"
        D1[检测错误类型] --> D2{错误严重程度}
        D2 -->|轻微| D3[忽略并继续]
        D2 -->|中等| D4[回退到安全状态]
        D2 -->|严重| D5[重启脚本系统]
        D2 -->|致命| D6[游戏安全退出]
    end
    
    A1 --> D1
    B1 --> D1
    C1 --> D1
    
    %% 样式
    classDef errorNode fill:#ffebee
    classDef processNode fill:#e8f5e8
    classDef recoveryNode fill:#e3f2fd
    classDef severityNode fill:#fff3e0
    
    class A1,B1,C1 errorNode
    class A2,A3,A4,A5,B2,B3,B4,B5,C2,C3,C4,C5,C6 processNode
    class D1,D3,D4,D5,D6 recoveryNode
    class D2 severityNode
```

---

## 性能优化策略

### 脚本加载优化

```mermaid
graph TD
    subgraph "预加载策略架构"
        A[游戏启动] --> B[检测可用内存]
        B --> C{内存充足?}
        C -->|是| D[全量预加载]
        C -->|否| E[按需预加载]
        
        D --> F[加载核心脚本]
        D --> G[加载职业脚本]
        D --> H[加载通用工具]
        
        E --> I[加载必需脚本]
        E --> J[延迟加载其他]
        
        F --> K[脚本缓存池]
        G --> K
        H --> K
        I --> K
        J --> K
        
        K --> L[运行时调用]
    end
    
    subgraph "缓存管理策略"
        M[LRU缓存算法] --> N[热点脚本识别]
        N --> O[优先级排序]
        O --> P[内存回收策略]
        P --> Q[缓存更新机制]
    end
    
    L --> M
    
    %% 样式
    classDef startNode fill:#e8f5e8
    classDef decisionNode fill:#fff3e0
    classDef processNode fill:#e3f2fd
    classDef cacheNode fill:#f3e5f5
    
    class A startNode
    class C decisionNode
    class B,D,E,F,G,H,I,J,L processNode
    class K,M,N,O,P,Q cacheNode
```

#### 1. 预加载策略
```squirrel
// 游戏启动时预加载常用脚本
function PreloadCommonScripts()
{
    // 预加载基础脚本
    sq_RunScript("sqr/common.nut");
    sq_RunScript("sqr/dnf_enum_header.nut");
    
    // 预加载当前角色相关脚本
    local characterJob = GetCurrentCharacterJob();
    switch(characterJob)
    {
        case ENUM_CHARACTERJOB_SWORDMAN:
            sq_RunScript("sqr/character/swordman/swordman_header.nut");
            sq_RunScript("sqr/character/swordman/swordman_common.nut");
            break;
        // ... 其他职业
    }
}
```

#### 2. 延迟加载策略
```squirrel
// 技能首次使用时才加载
function LazyLoadSkillScript(skillIndex)
{
    if (!IsSkillScriptLoaded(skillIndex)) {
        local scriptPath = GetSkillScriptPath(skillIndex);
        sq_RunScript(scriptPath);
        MarkSkillScriptLoaded(skillIndex);
    }
}
```

#### 3. 脚本缓存机制
```cpp
// 伪代码：脚本缓存管理
class ScriptCache
{
private:
    map<string, ScriptObject*> m_cache;
    int m_maxCacheSize;
    
public:
    ScriptObject* GetScript(const string& path)
    {
        auto it = m_cache.find(path);
        if (it != m_cache.end()) {
            return it->second;  // 缓存命中
        }
        
        // 缓存未命中，加载脚本
        ScriptObject* script = LoadScriptFromFile(path);
        
        // 检查缓存大小
        if (m_cache.size() >= m_maxCacheSize) {
            EvictLeastRecentlyUsed();
        }
        
        m_cache[path] = script;
        return script;
    }
};
```

### 函数调用优化

#### 1. 函数签名缓存
```cpp
// 伪代码：函数签名缓存
class FunctionSignatureCache
{
private:
    map<string, vector<string>> m_eventFunctionMap;
    
public:
    void BuildCache()
    {
        // 扫描所有已加载的脚本
        for (auto& script : g_loadedScripts) {
            auto functions = script->GetAllFunctions();
            for (auto& func : functions) {
                string eventType = ExtractEventType(func.name);
                if (!eventType.empty()) {
                    m_eventFunctionMap[eventType].push_back(func.name);
                }
            }
        }
    }
    
    vector<string> GetEventFunctions(const string& eventType)
    {
        auto it = m_eventFunctionMap.find(eventType);
        return (it != m_eventFunctionMap.end()) ? it->second : vector<string>();
    }
};
```

#### 2. 参数传递优化
```squirrel
// 避免频繁的参数拷贝
function OptimizedFunction(obj)
{
    // 缓存常用属性
    local objState = obj.sq_GetState();
    local objHP = obj.sq_GetHP();
    local objMP = obj.sq_GetMp();
    
    // 使用缓存的值进行计算
    if (objState == STATE_STAND && objHP > 100 && objMP > 50) {
        // 执行逻辑
    }
}
```

### 内存管理优化

#### 1. 对象池模式
```squirrel
// 对象池管理临时对象
class EffectObjectPool
{
    constructor()
    {
        this.pool = [];
        this.activeObjects = [];
    }
    
    function GetObject()
    {
        local obj;
        if (this.pool.len() > 0) {
            obj = this.pool.pop();  // 从池中获取
        } else {
            obj = CreateNewEffectObject();  // 创建新对象
        }
        
        this.activeObjects.append(obj);
        return obj;
    }
    
    function ReturnObject(obj)
    {
        // 重置对象状态
        obj.Reset();
        
        // 从活跃列表移除
        local index = this.activeObjects.find(obj);
        if (index != null) {
            this.activeObjects.remove(index);
        }
        
        // 返回到池中
        this.pool.append(obj);
    }
}
```

#### 2. 垃圾回收优化
```squirrel
// 手动触发垃圾回收
function OptimizeMemory()
{
    // 清理不需要的引用
    ClearTemporaryReferences();
    
    // 触发垃圾回收
    sq_collectgarbage();
    
    // 压缩内存
    sq_compactmemory();
}

// 在适当时机调用
function onLevelEnd()
{
    OptimizeMemory();
}
```

### 执行效率优化

#### 1. 条件判断优化
```squirrel
// 优化前：多次函数调用
function SlowFunction(obj)
{
    if (obj.sq_GetState() == STATE_STAND && 
        obj.sq_GetHP() > 100 && 
        obj.sq_GetMp() > 50 &&
        obj.sq_GetLevel() >= 20) {
        // 执行逻辑
    }
}

// 优化后：缓存结果，短路求值
function FastFunction(obj)
{
    local state = obj.sq_GetState();
    if (state != STATE_STAND) return;  // 快速退出
    
    local hp = obj.sq_GetHP();
    if (hp <= 100) return;
    
    local mp = obj.sq_GetMp();
    if (mp <= 50) return;
    
    local level = obj.sq_GetLevel();
    if (level < 20) return;
    
    // 执行逻辑
}
```

#### 2. 循环优化
```squirrel
// 优化前：每次循环都调用函数
function SlowLoop(obj)
{
    for (local i = 0; i < obj.sq_GetSkillCount(); i++) {
        local skill = obj.sq_GetSkill(i);
        // 处理技能
    }
}

// 优化后：缓存循环条件
function FastLoop(obj)
{
    local skillCount = obj.sq_GetSkillCount();
    for (local i = 0; i < skillCount; i++) {
        local skill = obj.sq_GetSkill(i);
        // 处理技能
    }
}
```

---

## 调试与排错

### 调试工具和方法

```mermaid
graph TD
    subgraph "调试工具架构"
        A[调试请求] --> B{调试类型}
        B -->|日志调试| C[日志输出系统]
        B -->|断点调试| D[条件断点系统]
        B -->|性能调试| E[性能监控系统]
        B -->|错误调试| F[错误追踪系统]
        
        C --> G[控制台输出]
        C --> H[文件日志]
        C --> I[网络日志]
        
        D --> J[条件检查]
        D --> K[状态快照]
        D --> L[调用栈追踪]
        
        E --> M[执行时间统计]
        E --> N[内存使用监控]
        E --> O[函数调用频率]
        
        F --> P[异常捕获]
        F --> Q[错误上下文]
        F --> R[恢复策略]
    end
    
    subgraph "调试数据流"
        S[原始调试数据] --> T[数据过滤]
        T --> U[格式化处理]
        U --> V[输出路由]
        V --> W[存储/显示]
    end
    
    G --> S
    H --> S
    I --> S
    J --> S
    K --> S
    L --> S
    M --> S
    N --> S
    O --> S
    P --> S
    Q --> S
    R --> S
    
    %% 样式
    classDef debugNode fill:#e8f5e8
    classDef toolNode fill:#e3f2fd
    classDef outputNode fill:#fff3e0
    classDef dataNode fill:#f3e5f5
    
    class A debugNode
    class B debugNode
    class C,D,E,F toolNode
    class G,H,I,J,K,L,M,N,O,P,Q,R outputNode
    class S,T,U,V,W dataNode
```

#### 1. 日志输出系统
```squirrel
// 自定义日志函数
function DebugLog(level, message)
{
    local timestamp = GetCurrentTime();
    local logMessage = "[" + timestamp + "] [" + level + "] " + message;
    
    // 输出到控制台
    print(logMessage);
    
    // 写入日志文件
    WriteToLogFile(logMessage);
}

// 使用示例
function onSetState_TestSkill(obj, state, datas, isResetTimer)
{
    DebugLog("INFO", "TestSkill state set, obj: " + obj + ", state: " + state);
    
    if (!obj) {
        DebugLog("ERROR", "TestSkill: obj is null!");
        return;
    }
    
    DebugLog("DEBUG", "TestSkill: Setting animation and attack info");
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);
    obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);
}
```

#### 2. 断点调试模拟
```squirrel
// 条件断点
function ConditionalBreakpoint(condition, message)
{
    if (condition) {
        DebugLog("BREAKPOINT", message);
        // 在这里可以输出更多调试信息
        PrintStackTrace();
        PrintVariableStates();
    }
}

// 使用示例
function proc_TestSkill(obj)
{
    local hp = obj.sq_GetHP();
    
    // 当HP低于100时触发断点
    ConditionalBreakpoint(hp < 100, "HP is critically low: " + hp);
    
    // 继续执行逻辑
}
```

#### 3. 性能监控
```squirrel
// 性能计时器
class PerformanceTimer
{
    constructor(name)
    {
        this.name = name;
        this.startTime = 0;
        this.endTime = 0;
    }
    
    function Start()
    {
        this.startTime = GetCurrentTimeMs();
    }
    
    function End()
    {
        this.endTime = GetCurrentTimeMs();
        local duration = this.endTime - this.startTime;
        DebugLog("PERF", this.name + " took " + duration + "ms");
    }
}

// 使用示例
function onSetState_ComplexSkill(obj, state, datas, isResetTimer)
{
    local timer = PerformanceTimer("ComplexSkill_onSetState");
    timer.Start();
    
    // 执行复杂逻辑
    PerformComplexCalculations(obj);
    
    timer.End();
}
```

### 常见错误类型和解决方案

```mermaid
graph TD
    subgraph "常见错误分类"
        A[脚本错误] --> B[空指针错误]
        A --> C[函数签名错误]
        A --> D[状态注册错误]
        A --> E[变量作用域错误]
        A --> F[资源泄漏错误]
        A --> G[性能问题]
    end
    
    subgraph "错误检测机制"
        H[静态检查] --> I[语法验证]
        H --> J[类型检查]
        H --> K[依赖分析]
        
        L[运行时检查] --> M[空指针检测]
        L --> N[边界检查]
        L --> O[状态验证]
        
        P[性能监控] --> Q[执行时间]
        P --> R[内存使用]
        P --> S[调用频率]
    end
    
    subgraph "错误处理策略"
        T[预防策略] --> U[防御性编程]
        T --> V[参数验证]
        T --> W[资源管理]
        
        X[恢复策略] --> Y[优雅降级]
        X --> Z[状态回滚]
        X --> AA[重试机制]
        
        BB[监控策略] --> CC[日志记录]
        BB --> DD[性能统计]
        BB --> EE[错误报告]
    end
    
    B --> M
    C --> I
    D --> O
    E --> J
    F --> R
    G --> Q
    
    M --> U
    I --> V
    O --> W
    J --> Y
    R --> Z
    Q --> AA
    
    U --> CC
    V --> DD
    W --> EE
    
    %% 样式
    classDef errorType fill:#ffebee
    classDef detection fill:#e8f5e8
    classDef strategy fill:#e3f2fd
    classDef connection fill:#fff3e0
    
    class A,B,C,D,E,F,G errorType
    class H,I,J,K,L,M,N,O,P,Q,R,S detection
    class T,U,V,W,X,Y,Z,AA,BB,CC,DD,EE strategy
```

#### 1. 空指针错误
```squirrel
// 错误示例
function BadFunction(obj)
{
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);  // 如果obj为null会崩溃
}

// 正确做法
function GoodFunction(obj)
{
    if (!obj) {
        DebugLog("ERROR", "GoodFunction: obj is null");
        return;
    }
    
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);
}
```

#### 2. 函数名错误
```squirrel
// 错误：函数名不符合签名规范
function onSetState_wrongname(obj, state, datas, isResetTimer)  // 不会被调用
{
    // 逻辑代码
}

// 正确：函数名符合规范
function onSetState_CorrectName(obj, state, datas, isResetTimer)  // 会被正确调用
{
    // 逻辑代码
}
```

#### 3. 状态注册错误
```squirrel
// 错误：状态ID冲突
IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_THIEF, "path1.nut", "skill1", 95, -1);
IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_THIEF, "path2.nut", "skill2", 95, -1);  // 冲突！

// 正确：使用唯一的状态ID
IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_THIEF, "path1.nut", "skill1", 95, -1);
IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_THIEF, "path2.nut", "skill2", 96, -1);  // 正确
```

#### 4. 变量作用域错误
```squirrel
// 错误：变量作用域混乱
local globalVar = 100;

function Function1()
{
    globalVar = 200;  // 修改了全局变量
}

function Function2()
{
    local globalVar = 300;  // 创建了同名局部变量，可能引起混乱
    print(globalVar);  // 输出300，不是200
}

// 正确：明确变量作用域
g_globalVar <- 100;  // 明确的全局变量

function Function1()
{
    g_globalVar = 200;  // 明确修改全局变量
}

function Function2()
{
    local localVar = 300;  // 使用不同的变量名
    print(g_globalVar);    // 输出200
    print(localVar);       // 输出300
}
```

### 调试最佳实践

#### 1. 分层调试策略
```squirrel
// 第一层：基础功能验证
function DebugLevel1_BasicFunction(obj)
{
    DebugLog("DEBUG", "=== Level 1 Debug: Basic Function ===");
    DebugLog("DEBUG", "obj exists: " + (obj != null));
    
    if (obj) {
        DebugLog("DEBUG", "obj state: " + obj.sq_GetState());
        DebugLog("DEBUG", "obj HP: " + obj.sq_GetHP());
        DebugLog("DEBUG", "obj MP: " + obj.sq_GetMp());
    }
}

// 第二层：逻辑流程验证
function DebugLevel2_LogicFlow(obj, step)
{
    DebugLog("DEBUG", "=== Level 2 Debug: Logic Flow Step " + step + " ===");
    
    switch(step)
    {
        case 1:
            DebugLog("DEBUG", "Step 1: Initialization");
            break;
        case 2:
            DebugLog("DEBUG", "Step 2: Animation Setting");
            break;
        case 3:
            DebugLog("DEBUG", "Step 3: Attack Processing");
            break;
    }
}

// 第三层：性能和优化验证
function DebugLevel3_Performance(functionName, executionTime)
{
    DebugLog("DEBUG", "=== Level 3 Debug: Performance ===");
    DebugLog("DEBUG", "Function: " + functionName);
    DebugLog("DEBUG", "Execution Time: " + executionTime + "ms");
    
    if (executionTime > 16) {  // 超过一帧的时间
        DebugLog("WARNING", "Function " + functionName + " is too slow!");
    }
}
```

#### 2. 错误恢复机制
```squirrel
// 安全的函数调用包装器
function SafeCall(func, params, defaultReturn = null)
{
    try {
        return func.acall(this, params);
    } catch (e) {
        DebugLog("ERROR", "SafeCall failed: " + e);
        return defaultReturn;
    }
}

// 使用示例
function onSetState_SafeSkill(obj, state, datas, isResetTimer)
{
    // 安全地调用可能出错的函数
    local result = SafeCall(RiskyFunction, [obj, state], false);
    
    if (result) {
        // 成功执行
        ContinueNormalFlow(obj);
    } else {
        // 执行失败，使用备用方案
        ExecuteFallbackPlan(obj);
    }
}
```

---

## 最佳实践

### 代码组织和结构

#### 1. 文件组织规范
```
sqr/
├── loadstate.nut                    # 主入口文件
├── common.nut                       # 公共函数库
├── dnf_enum_header.nut             # 全局枚举定义
├── character/                       # 角色相关脚本
│   ├── common/                     # 角色公共脚本
│   │   ├── character_common.nut    # 角色通用函数
│   │   └── buff_system.nut         # BUFF系统
│   ├── thief/                      # 暗夜使者
│   │   ├── thief_header.nut        # 暗夜使者常量定义
│   │   ├── thief_load_state.nut    # 状态加载器
│   │   ├── thief_common.nut        # 暗夜使者公共函数
│   │   └── skills/                 # 技能脚本目录
│   │       ├── zskill00/           # 教学技能
│   │       │   └── zskill00.nut
│   │       └── shuriken/           # 手里剑
│   │           └── shuriken.nut
│   └── swordman/                   # 鬼剑士
│       ├── swordman_header.nut
│       ├── swordman_load_state.nut
│       └── skills/
└── utils/                          # 工具脚本
    ├── debug_utils.nut             # 调试工具
    ├── math_utils.nut              # 数学工具
    └── effect_utils.nut            # 特效工具
```

#### 2. 命名规范
```squirrel
// 常量命名：全大写，下划线分隔
STATE_SKILL_CAST <- 95;
SKILL_FIREBALL <- 220;
CUSTOM_ANI_ATTACK <- 0;

// 函数命名：驼峰式，动词开头
function calculateDamage(attack, defense) { }
function checkSkillCooldown(obj, skillIndex) { }
function applyBuffEffect(target, buffType) { }

// 变量命名：驼峰式，名词性
local playerLevel = obj.sq_GetLevel();
local skillDamage = calculateDamage(attack, defense);
local isSkillReady = checkSkillCooldown(obj, SKILL_FIREBALL);

// 类命名：帕斯卡式
class SkillManager { }
class EffectController { }
class BuffSystem { }
```

#### 3. 注释规范
```squirrel
/**
 * 计算技能伤害
 * @param {object} caster - 施法者对象
 * @param {object} target - 目标对象
 * @param {number} skillIndex - 技能索引
 * @param {number} skillLevel - 技能等级
 * @return {number} 最终伤害值
 */
function calculateSkillDamage(caster, target, skillIndex, skillLevel)
{
    if (!caster || !target) return 0;
    
    // 获取基础攻击力
    local baseAttack = caster.sq_GetPhysicalAttack();
    
    // 获取技能倍率
    local skillRate = GetSkillDamageRate(skillIndex, skillLevel);
    
    // 计算基础伤害
    local baseDamage = baseAttack * skillRate;
    
    // 应用防御减免
    local defense = target.sq_GetPhysicalDefense();
    local finalDamage = baseDamage * (1.0 - defense / (defense + 1000));
    
    return finalDamage.tointeger();
}
```

### 性能优化指南

#### 1. 避免频繁的对象创建
```squirrel
// 不好的做法：每次都创建新对象
function BadPractice(obj)
{
    for (local i = 0; i < 100; i++) {
        local tempData = {
            x = i,
            y = i * 2,
            z = i * 3
        };
        ProcessData(tempData);
    }
}

// 好的做法：重用对象
local g_tempData = { x = 0, y = 0, z = 0 };  // 全局重用对象

function GoodPractice(obj)
{
    for (local i = 0; i < 100; i++) {
        g_tempData.x = i;
        g_tempData.y = i * 2;
        g_tempData.z = i * 3;
        ProcessData(g_tempData);
    }
}
```

#### 2. 缓存计算结果
```squirrel
// 缓存系统
class CalculationCache
{
    constructor()
    {
        this.cache = {};
        this.maxSize = 1000;
    }
    
    function GetOrCalculate(key, calculationFunc)
    {
        if (key in this.cache) {
            return this.cache[key];  // 缓存命中
        }
        
        // 计算新值
        local result = calculationFunc();
        
        // 检查缓存大小
        if (this.cache.len() >= this.maxSize) {
            this.ClearOldEntries();
        }
        
        this.cache[key] <- result;
        return result;
    }
    
    function ClearOldEntries()
    {
        // 简单的清理策略：清空一半
        local keysToRemove = [];
        local count = 0;
        foreach (key, value in this.cache) {
            keysToRemove.append(key);
            count++;
            if (count >= this.maxSize / 2) break;
        }
        
        foreach (key in keysToRemove) {
            delete this.cache[key];
        }
    }
}

// 使用缓存
local g_damageCache = CalculationCache();

function GetCachedDamage(attackPower, skillLevel)
{
    local key = attackPower + "_" + skillLevel;
    return g_damageCache.GetOrCalculate(key, function() {
        return CalculateComplexDamage(attackPower, skillLevel);
    });
}
```

### 错误处理和容错

#### 1. 防御性编程
```squirrel
// 参数验证
function ValidateParameters(obj, skillIndex, targetPos)
{
    if (!obj) {
        DebugLog("ERROR", "ValidateParameters: obj is null");
        return false;
    }
    
    if (skillIndex < 0 || skillIndex >= MAX_SKILL_COUNT) {
        DebugLog("ERROR", "ValidateParameters: invalid skillIndex " + skillIndex);
        return false;
    }
    
    if (!targetPos || typeof(targetPos) != "table") {
        DebugLog("ERROR", "ValidateParameters: invalid targetPos");
        return false;
    }
    
    if (!("x" in targetPos) || !("y" in targetPos)) {
        DebugLog("ERROR", "ValidateParameters: targetPos missing coordinates");
        return false;
    }
    
    return true;
}

// 安全的技能释放函数
function SafeCastSkill(obj, skillIndex, targetPos)
{
    // 参数验证
    if (!ValidateParameters(obj, skillIndex, targetPos)) {
        return false;
    }
    
    // 状态检查
    local currentState = obj.sq_GetState();
    if (!IsValidCastState(currentState)) {
        DebugLog("WARNING", "Cannot cast skill in state " + currentState);
        return false;
    }
    
    // 资源检查
    local needMP = GetSkillMPCost(skillIndex);
    if (obj.sq_GetMp() < needMP) {
        DebugLog("WARNING", "Not enough MP to cast skill");
        return false;
    }
    
    // 执行技能
    try {
        return ExecuteSkill(obj, skillIndex, targetPos);
    } catch (e) {
        DebugLog("ERROR", "Skill execution failed: " + e);
        return false;
    }
}
```

#### 2. 优雅降级
```squirrel
// 特效系统的优雅降级
function PlayEffectWithFallback(effectPath, position, fallbackEffect = null)
{
    try {
        // 尝试播放主要特效
        local effect = CreateEffect(effectPath);
        if (effect) {
            effect.SetPosition(position);
            effect.Play();
            return true;
        }
    } catch (e) {
        DebugLog("WARNING", "Primary effect failed: " + e);
    }
    
    // 主要特效失败，尝试备用特效
    if (fallbackEffect) {
        try {
            local backupEffect = CreateEffect(fallbackEffect);
            if (backupEffect) {
                backupEffect.SetPosition(position);
                backupEffect.Play();
                return true;
            }
        } catch (e) {
            DebugLog("WARNING", "Fallback effect failed: " + e);
        }
    }
    
    // 所有特效都失败，使用最简单的视觉反馈
    CreateSimpleFlash(position);
    return false;
}
```

### 代码复用和模块化

```mermaid
graph TD
    subgraph "模块化架构"
        A[核心模块] --> B[基础工具模块]
        A --> C[角色管理模块]
        A --> D[技能系统模块]
        A --> E[特效系统模块]
        A --> F[UI交互模块]
        
        B --> G[数学计算]
        B --> H[字符串处理]
        B --> I[数据结构]
        B --> J[时间管理]
        
        C --> K[角色属性]
        C --> L[状态管理]
        C --> M[动画控制]
        
        D --> N[技能逻辑]
        D --> O[伤害计算]
        D --> P[冷却管理]
        
        E --> Q[粒子效果]
        E --> R[音效播放]
        E --> S[屏幕震动]
        
        F --> T[按键响应]
        F --> U[界面更新]
        F --> V[消息提示]
    end
    
    subgraph "依赖关系"
        W[高级模块] --> X[中级模块]
        X --> Y[基础模块]
        Y --> Z[核心库]
        
        AA[技能脚本] --> BB[角色模块]
        AA --> CC[特效模块]
        BB --> DD[基础工具]
        CC --> DD
    end
    
    subgraph "复用策略"
        EE[接口标准化] --> FF[统一API]
        EE --> GG[参数规范]
        EE --> HH[返回值约定]
        
        II[组件化设计] --> JJ[功能封装]
        II --> KK[松耦合]
        II --> LL[高内聚]
        
        MM[版本管理] --> NN[向后兼容]
        MM --> OO[渐进升级]
        MM --> PP[废弃策略]
    end
    
    D --> W
    E --> W
    F --> W
    B --> Y
    C --> X
    
    %% 样式
    classDef coreModule fill:#e8f5e8
    classDef subModule fill:#e3f2fd
    classDef dependency fill:#fff3e0
    classDef strategy fill:#f3e5f5
    
    class A coreModule
    class B,C,D,E,F subModule
    class G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V subModule
    class W,X,Y,Z,AA,BB,CC,DD dependency
    class EE,FF,GG,HH,II,JJ,KK,LL,MM,NN,OO,PP strategy
```

#### 1. 公共函数库
```squirrel
// character_common.nut - 角色公共函数
function GetCharacterDisplayName(obj)
{
    if (!obj) return "Unknown";
    
    local name = obj.sq_GetName();
    local level = obj.sq_GetLevel();
    return name + " (Lv." + level + ")";
}

function IsCharacterInCombat(obj)
{
    if (!obj) return false;
    
    local state = obj.sq_GetState();
    return (state >= STATE_ATTACK_START && state <= STATE_ATTACK_END) ||
           (state >= STATE_SKILL_START && state <= STATE_SKILL_END);
}

function GetCharacterDirection(obj)
{
    if (!obj) return DIRECTION_RIGHT;
    
    return obj.sq_GetDirection();
}

// 距离计算工具
function CalculateDistance2D(pos1, pos2)
{
    local dx = pos1.x - pos2.x;
    local dy = pos1.y - pos2.y;
    return sqrt(dx * dx + dy * dy);
}

function CalculateDistance3D(pos1, pos2)
{
    local dx = pos1.x - pos2.x;
    local dy = pos1.y - pos2.y;
    local dz = pos1.z - pos2.z;
    return sqrt(dx * dx + dy * dy + dz * dz);
}
```

#### 2. 技能基类系统
```squirrel
// skill_base.nut - 技能基类
class SkillBase
{
    constructor(skillIndex, stateIndex)
    {
        this.skillIndex = skillIndex;
        this.stateIndex = stateIndex;
        this.isActive = false;
        this.startTime = 0;
        this.duration = 0;
    }
    
    // 虚函数，子类需要重写
    function OnStart(obj, state, datas, isResetTimer) { }
    function OnUpdate(obj) { }
    function OnEnd(obj) { }
    function OnAttack(obj, damager, boundingBox, isStuck) { }
    
    // 公共方法
    function Start(obj, state, datas, isResetTimer)
    {
        this.isActive = true;
        this.startTime = GetCurrentTime();
        this.OnStart(obj, state, datas, isResetTimer);
    }
    
    function Update(obj)
    {
        if (!this.isActive) return;
        this.OnUpdate(obj);
    }
    
    function End(obj)
    {
        this.isActive = false;
        this.OnEnd(obj);
    }
}
```

---

## 总结

### DNF引擎Squirrel脚本调用机制全景图

```mermaid
graph TB
    subgraph "DNF引擎架构层次"
        A[C++核心引擎] --> B[Squirrel虚拟机]
        B --> C[脚本执行环境]
        C --> D[游戏逻辑脚本]
    end
    
    subgraph "脚本加载机制"
        E[游戏启动] --> F[loadstate.nut]
        F --> G[职业脚本加载]
        G --> H[技能脚本注册]
        H --> I[运行时动态加载]
    end
    
    subgraph "双轨触发机制"
        J[事件触发] --> K{触发类型}
        K -->|函数签名驱动| L[签名扫描匹配]
        K -->|状态注册驱动| M[状态映射查找]
        L --> N[直接函数调用]
        M --> O[状态生命周期管理]
    end
    
    subgraph "脚本执行流程"
        P[输入检测] --> Q[技能检查]
        Q --> R[状态设置]
        R --> S[脚本执行]
        S --> T[攻击判定]
        T --> U[技能结束]
    end
    
    subgraph "性能优化体系"
        V[预加载策略] --> W[缓存管理]
        W --> X[内存优化]
        X --> Y[执行效率优化]
    end
    
    subgraph "调试与错误处理"
        Z[调试工具] --> AA[错误检测]
        AA --> BB[错误处理]
        BB --> CC[性能监控]
    end
    
    subgraph "模块化设计"
        DD[核心模块] --> EE[功能模块]
        EE --> FF[工具模块]
        FF --> GG[复用策略]
    end
    
    %% 连接关系
    D --> J
    I --> V
    N --> P
    O --> P
    U --> Z
    Y --> DD
    
    %% 样式定义
    classDef engineLayer fill:#e8f5e8
    classDef loadingMech fill:#e3f2fd
    classDef triggerMech fill:#fff3e0
    classDef execFlow fill:#f3e5f5
    classDef optimization fill:#fce4ec
    classDef debugging fill:#e0f2f1
    classDef modular fill:#f1f8e9
    
    class A,B,C,D engineLayer
    class E,F,G,H,I loadingMech
    class J,K,L,M,N,O triggerMech
    class P,Q,R,S,T,U execFlow
    class V,W,X,Y optimization
    class Z,AA,BB,CC debugging
    class DD,EE,FF,GG modular
```

### 关键技术要点总结

1. **架构设计**：C++引擎 + Squirrel虚拟机的双层架构
2. **加载机制**：启动时预加载 + 运行时动态加载的混合策略
3. **触发机制**：函数签名驱动 + 状态注册驱动的双轨并行
4. **执行流程**：从输入检测到技能结束的完整生命周期管理
5. **性能优化**：多层次缓存 + 内存管理 + 执行效率优化
6. **调试支持**：完整的调试工具链和错误处理机制
7. **模块化**：高内聚低耦合的组件化设计

### 最佳实践建议

1. **遵循命名规范**：严格按照函数签名规范命名
2. **防御性编程**：充分的参数验证和错误处理
3. **性能意识**：合理使用缓存和避免不必要的计算
4. **模块化思维**：将复杂逻辑拆分为可复用的模块
5. **调试友好**：添加充分的日志和调试信息
6. **版本兼容**：考虑向后兼容性和渐进升级

通过深入理解这些机制和最佳实践，开发者可以更高效地开发DNF技能脚本，创造出更丰富的游戏体验。