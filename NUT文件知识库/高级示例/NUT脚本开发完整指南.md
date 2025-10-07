# NUT脚本开发完整指南

## 📖 目录
- [教程概述](#教程概述)
- [基础理论知识](#基础理论知识)
- [DNF引擎脚本调用机制](#dnf引擎脚本调用机制)
- [实践教学案例](#实践教学案例)
- [核心函数体系](#核心函数体系)
- [对象方法详解](#对象方法详解)
- [常用常量参考](#常用常量参考)
- [开发流程指导](#开发流程指导)
- [进阶技术要点](#进阶技术要点)
- [学习路径规划](#学习路径规划)

---

## 教程概述

本教程整合了NUT脚本开发的完整知识体系，结合理论与实践，为DNF技能开发提供系统化的学习指导。通过递进式的教学方式，帮助开发者从基础概念到高级技巧的全面掌握。

### 教程特色
- **理论实践结合**: 以实际职业为例，提供完整代码示例
- **递进式学习**: 从基础动画到复杂特效的三阶段教学
- **系统化知识**: 涵盖函数、对象、常量的完整体系
- **实用性强**: 提供真实可用的开发流程和规范

---

## 基础理论知识

### NUT脚本核心概念

#### Squirrel语言基础
NUT脚本基于Squirrel语言，是DNF引擎使用的脚本语言。文件后缀为`.nut`（"Squirrel"意为"松鼠"，"nut"意为"坚果"，设计上有"松鼠-坚果"的趣味关联）。

#### State（状态）系统
- **定义**: State是NUT脚本的核心概念，代表角色或对象的当前状态
- **作用**: 控制技能执行流程、动画播放、伤害计算等
- **状态转换**: 通过特定函数实现状态间的切换

#### 主要组成部分
1. **状态定义**: 使用枚举定义各种状态
2. **时间事件**: 控制技能的时序逻辑  
3. **变量管理**: 存储和传递数据
4. **函数实现**: 具体的逻辑处理

### 文件结构体系

#### PVF文件组织架构
```
PVF文件/
├── character/thief/attackinfo/uppercut.atk    # 攻击信息文件
├── skill/thief/zskill00.skl                   # 技能定义文件
└── sqr/                                       # 脚本文件目录
    ├── character/
    │   ├── thief/
    │   │   ├── thief_header.nut               # 头文件定义
    │   │   └── zskill00/                      # 技能脚本目录
    │   └── thief_load_state.nut               # 状态加载文件
    └── loadstate.nut                          # 主加载文件
```

#### 关键文件说明

**loadstate.nut - 主加载文件**
```nut
// 加载基础脚本
sq_RunScript("sqr/dnf_enum_header.nut");
sq_RunScript("sqr/common.nut");

// 加载各职业状态脚本
sq_RunScript("sqr/character/avenger/avenger_load_state.nut");
sq_RunScript("sqr/character/thief/thief_load_state.nut");
// ... 其他职业
```

**thief_header.nut - 头文件定义**
```nut
// 状态编号 - 必须唯一，避免冲突
STATE_ZSKILL00 <- 95;    

// 技能编号 - 对应技能列表
SKILL_ZSKILL00 <- 220;   

// 动画文件索引 - 指向CHR文件中的[etc motion]
CUSTOM_ANI_01 <- 0;      

// 攻击信息索引 - 指向CHR文件中的[etc attack info]
CUSTOM_ATK_01 <- 0;      

// 向量标志常量
ENUM_VECTOR_FLAG_01 <- 0;
ENUM_VECTOR_FLAG_02 <- 1;

// 静态整数索引
ENUM_STATIC_INT_01 <- 0;
ENUM_STATIC_INT_02 <- 1;

// 技能等级列索引
ENUM_SKILL_LEVEL_COLUMN_01 <- 0;
ENUM_SKILL_LEVEL_COLUMN_02 <- 1;
```

**thief_load_state.nut - 状态加载**
```nut
// 加载头文件
IRDSQRCharacter.pushScriptFiles("Character/thief/thief_header.nut");

// 注册技能状态
IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_THIEF, 
                         "Character/Thief/Zskill00/Zskill00.nut", 
                         "Zskill00", 
                         STATE_ZSKILL00, 
                         SKILL_ZSKILL00);
```

---

## DNF引擎脚本调用机制

### 脚本加载机制

#### 入口文件：`loadstate.nut`
`loadstate.nut`是DNF脚本加载的**核心入口**，路径为`sqr/loadstate.nut`。它在引擎启动游戏时自动预加载，功能类似编程语言中的"头文件/引用包"，负责通过内部函数加载后续脚本文件及代码。

#### 关键加载函数对比

| 对比维度    | `sq_RunScript()`        | `dofile()`           |
| ------- | ----------------------- | -------------------- |
| 核心用途    | 加载游戏封包内的`.nut`脚本        | 加载文件系统中的`.nut`脚本     |
| 路径规则    | 基于游戏资源目录的**相对路径**       | 绝对路径或基于项目目录的**相对路径** |
| 读取速度    | 直接从内存封包读取，速度快（多文件时优势明显） | 依赖磁盘 I/O，速度较慢        |
| 修改后生效方式 | 需重新打包 PVF 文件才能生效        | 实时生效（无需额外操作）         |
| 适用场景    | 成品脚本（追求性能，避免磁盘开销）       | 开发/测试阶段（方便实时调试修改）  |

### 脚本加载策略

#### `pushScriptFiles` vs `pushState`

| 对比维度      | `pushScriptFiles`         | `pushState`（全称：`IRDSQRCharacter.pushState`） |
| --------- | ------------------------- | ------------------------------------------- |
| 加载策略      | 预加载（全局加载），类似"全局变量"       | 动态加载（状态触发加载）                                |
| 内存/性能开销 | 始终占用内存，开销较大               | 仅状态激活时占用内存，开销低、效率高                          |
| 触发方式      | 全局调用状态下，需开发者**手动检测状态 ID** | 检测到指定状态后，引擎**自动调用**对应脚本                     |
| 响应速度      | 因需手动检测，响应速度略慢             | 状态触发即调用，响应速度更快                              |
| 适用场景      | 逻辑通用、需全局复用的脚本（如基础角色逻辑）    | 特定状态触发的脚本（如技能释放、角色受伤）                       |

### DNF引擎双轨触发机制

#### 第一轨：函数签名驱动机制（主要方式）

**核心原理**: 引擎通过**预定义的函数名模式（签名）**扫描全局已加载脚本，只要函数存在且签名匹配，无需注册即可在对应事件发生时自动调用。

**关键规则与示例**:
```nut
// 所有技能释放后触发（ATGunner为"女枪手"职业标识）
function useSkill_after_ATGunner(...) 

// 角色受伤时触发
function onDamage_ATGunner(...)      

// 全局状态开始时回调（无职业限制）
function onStateStart(...)
```

#### 第二轨：状态注册驱动机制（辅助方式）

**核心原理**: 需先通过`pushState`函数建立"状态ID与脚本"的映射关系，仅当指定状态激活时，引擎才会调用脚本中带固定后缀的函数。

**注册状态示例**:
```nut
IRDSQRCharacter.pushState(
    ENUM_CHARACTERJOB_SWORDMAN,         // 指定职业：剑魂（剑系职业）
    "Character/swordman/swordman_aaa.nut", // 脚本文件路径
    "swordman_aaa",                   // 函数前缀（后续函数需包含此前缀）
    13,                               // 处理的状态类型（如"技能释放中"）
    -1                                // 优先级（-1为默认）
);
```

**自动调用规则**:
| 函数格式                     | 触发时机        | 示例                               |
| ------------------------ | ----------- | -------------------------------- |
| `"onStart"+函数前缀`         | 状态开始时       | `onStart_swordman_aaa()`         |
| `"proc"+函数前缀`            | 状态持续中（每帧更新） | `proc_swordman_aaa()`            |
| `"onEnd"+函数前缀`           | 状态结束时       | `onEnd_swordman_aaa()`           |
| `"onAfterSetState"+函数前缀` | 状态设置完成后     | `onAfterSetState_swordman_aaa()` |

---

## 实践教学案例

### 案例概述
以盗贼职业的"教学技能"(zskill00)为例，通过三个递进的代码示例，展示从基础动画到复杂特效的完整开发过程。

### 第一阶段：基础动画技能

#### 代码示例1 - 基础框架
```nut
// 检查技能可执行性
function checkExecutableSkill_Zskill00(obj)
{
    if (!obj) return false;
    local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);
    
    if (isUse) {
        obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_USER, false);
        return true;
    }
    
    return false;
}

// 检查按键开关
function checkCommandEnable_Zskill00(obj)
{
    if (!obj) return false;
    local state = obj.sq_GetState();
    
    if (state == STATE_STAND)  // 仅在站立状态可使用
        return true;
    
    return false;
}

// 设置状态
function onSetState_Zskill00(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    obj.sq_StopMove();                              // 停止移动
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);      // 设置动画
}

// 动画结束处理
function onEndCurrentAni_Zskill00(obj)
{
    obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}
```

**学习要点**:
- 基础函数框架的建立
- 状态检查和转换机制
- 动画控制的基本方法

### 第二阶段：添加攻击系统

#### 代码示例2 - 攻击系统
```nut
function onSetState_Zskill00(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    obj.sq_StopMove();                              // 停止移动
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);      // 设置动画
    obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);     // 设置攻击信息
    
    // 设置攻击速度影响
    obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                             SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
    
    // 计算伤害倍率
    local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00, STATE_ZSKILL00, 0, 1.0);
    obj.sq_SetCurrentAttackBonusRate(damage);
}
```

**学习要点**:
- 攻击信息的设置方法
- 伤害计算和倍率应用
- 攻击速度的控制机制

### 第三阶段：特效增强

#### 代码示例3 - 完整特效
```nut
function onSetState_Zskill00(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    obj.sq_StopMove();                              // 停止移动
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);      // 设置动画
    obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);     // 设置攻击信息
    
    // 设置攻击速度影响
    obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                             SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
    
    // 计算伤害倍率
    local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00, STATE_ZSKILL00, 0, 1.0);
    obj.sq_SetCurrentAttackBonusRate(damage);
    
    // 添加自定义命中效果
    obj.sq_setCustomHitEffectFileName("Character/Mage/Effect/Animation/ATIceSword/05_2_smoke_dodge.ani");
    
    // 屏幕震动效果
    obj.sq_SetShake(obj, 2, 150);
    
    // 闪屏效果
    sq_flashScreen(obj, 30, 30, 30, 200, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
}

// 攻击命中处理
function onAttack_Zskill00(obj, damager, boundingBox, isStuck)
{
    if (!obj || !damager) return;
    
    // 对命中目标添加颜色光谱效果
    sq_EffectLayerAppendage(damager, sq_RGB(46, 204, 113), 150, 0, 0, 240);
}
```

**学习要点**:
- 视觉特效的实现方法
- 命中反馈系统的建立
- 屏幕效果的控制技巧

### 技能文件配置 (zskill00.skl)

```
[name]
`教學技能`                    # 技能显示名称

[name2]
`Shuriken`                   # 技能英文名

[basic explain]
`教學技能`                    # 基础说明

[explain]
`教學技能`                    # 详细说明

[executable states]
8	0	14                   # 可执行状态列表

[required level]
1                            # 需求等级

[type]
`[active]`                   # 技能类型：主动技能

[skill class]
1                            # 技能分类

[maximum level]
70                           # 最大等级

[durability decrease rate]
10                           # 耐久度降低率

[weapon effect type]
`[physical]`                 # 武器效果类型：物理

[icon]
`Character/Thief/Effect/Skill/Shuriken/Icon.img`  # 技能图标

[command]
`skill_active`	'z'	'z'      # 释放指令
```

---

## 核心函数体系

### 技能检查函数

#### checkExecutableSkill_[技能名](obj)
**功能**: 检查技能是否可以执行
**返回值**: true/false
**常用检查**: MP消耗、冷却时间、前置条件等

```nut
function checkExecutableSkill_技能名(obj)
{
    if (!obj) return false;
    
    // 检查技能可用性
    local isUse = obj.sq_IsUseSkill(SKILL_技能编号);
    
    // 检查MP消耗
    local needMP = obj.sq_GetSkillNeedMp(SKILL_技能编号, obj.sq_GetSkillLevel(SKILL_技能编号));
    if (obj.sq_GetMp() < needMP) return false;
    
    // 检查冷却时间
    if (obj.sq_IsSkillInCooltime(SKILL_技能编号)) return false;
    
    if (isUse) {
        obj.sq_AddSetStatePacket(STATE_技能状态, STATE_PRIORITY_USER, false);
        return true;
    }
    
    return false;
}
```

#### checkCommandEnable_[技能名](obj)
**功能**: 检查按键输入条件
**作用**: 限制技能的使用时机

```nut
function checkCommandEnable_技能名(obj)
{
    if (!obj) return false;
    local state = obj.sq_GetState();
    
    // 可执行状态检查
    if (state == STATE_STAND || state == STATE_WALK || state == STATE_RUN)
        return true;
    
    return false;
}
```

### 状态设置函数

#### onSetState_[技能名](obj, state, datas, isResetTimer)
**功能**: 技能状态设置时的初始化操作
**作用**: 设置动画、初始化变量、播放音效等

```nut
function onSetState_技能名(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    // 基础设置
    obj.sq_StopMove();                              // 停止移动
    obj.sq_SetCurrentAnimation(动画编号);            // 设置动画
    obj.sq_SetCurrentAttackInfo(攻击信息编号);       // 设置攻击信息
    
    // 速度控制
    obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                             SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
    
    // 伤害计算
    local damage = obj.sq_GetBonusRateWithPassive(SKILL_技能编号, STATE_技能状态, 0, 1.0);
    obj.sq_SetCurrentAttackBonusRate(damage);
    
    // 特效设置
    obj.sq_setCustomHitEffectFileName("特效文件路径");
    obj.sq_SetShake(obj, 震动强度, 震动时间);
}
```

### 时间事件函数

#### onTimeEvent_[技能名](obj, timeEventIndex, timeEventCount)
**功能**: 处理技能执行过程中的时间事件
**用途**: 控制技能的各个阶段、触发特效等

```nut
function onTimeEvent_技能名(obj, timeEventIndex, timeEventCount)
{
    if (!obj) return;
    
    switch(timeEventIndex)
    {
        case 0:  // 第一个时间点
            // 执行特定操作
            break;
        case 1:  // 第二个时间点
            // 执行其他操作
            break;
    }
}
```

### 攻击函数

#### onAttack_[技能名](obj, damager, boundingBox, isStuck)
**功能**: 处理技能的攻击逻辑
**包含**: 伤害计算、命中判定、特殊效果等

```nut
function onAttack_技能名(obj, damager, boundingBox, isStuck)
{
    if (!obj || !damager) return;
    
    // 命中特效
    sq_EffectLayerAppendage(damager, sq_RGB(255, 0, 0), 200, 0, 0, 300);
    
    // 额外伤害计算
    local extraDamage = obj.sq_GetSTR() * 0.5;
    damager.sq_AddDamage(extraDamage);
    
    // 状态效果
    damager.sq_AddState(STATE_STUN, 1000);  // 添加1秒眩晕
}
```

### 结束函数

#### onEndCurrentAni_[技能名](obj)
**功能**: 动画结束时的处理
**作用**: 状态转换、清理操作

```nut
function onEndCurrentAni_技能名(obj)
{
    if (!obj) return;
    
    // 恢复站立状态
    obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}
```

#### onEndState_[技能名](obj)
**功能**: 技能状态结束时的清理操作
**作用**: 重置变量、清除效果、恢复状态等

```nut
function onEndState_技能名(obj)
{
    if (!obj) return;
    
    // 清理临时效果
    obj.sq_RemoveAllAppendage();
    
    // 重置变量
    obj.sq_SetStaticInt(ENUM_STATIC_INT_01, 0);
}
```

---

## 对象方法详解

### obj对象常用方法

#### 技能相关
- `obj.sq_IsUseSkill(skillIndex)` - 检查是否正在使用技能
- `obj.sq_AddSetStatePacket(state, priority, isResetTimer)` - 添加状态设置包
- `obj.sq_GetSkillLevel(skillIndex)` - 获取技能等级
- `obj.sq_GetSkillNeedMp(skillIndex, level)` - 获取技能所需MP
- `obj.sq_IsSkillInCooltime(skillIndex)` - 检查技能是否在冷却中

#### 动画控制
- `obj.sq_SetCurrentAnimation(aniIndex)` - 设置当前动画
- `obj.sq_GetCurrentAnimation()` - 获取当前动画
- `obj.sq_IsEndCurrentAni()` - 检查当前动画是否结束
- `obj.sq_SetAnimationSpeedRate(rate)` - 设置动画播放速度

#### 移动控制
- `obj.sq_StopMove()` - 停止移动
- `obj.sq_SetVelocity(x, y, z)` - 设置速度
- `obj.sq_GetDistancePos(distance, direction)` - 获取距离位置
- `obj.sq_MoveWithVelocity(x, y, z, time)` - 以指定速度移动指定时间

#### 状态管理
- `obj.sq_GetState()` - 获取当前状态
- `obj.sq_SetState(state)` - 设置状态
- `obj.sq_IsState(state)` - 检查是否为指定状态
- `obj.sq_AddState(state, time)` - 添加状态效果

#### 属性获取
- `obj.sq_GetLevel()` - 获取等级
- `obj.sq_GetSTR()` - 获取力量
- `obj.sq_GetINT()` - 获取智力
- `obj.sq_GetMaxHP()` - 获取最大HP
- `obj.sq_GetHP()` - 获取当前HP
- `obj.sq_GetMaxMp()` - 获取最大MP
- `obj.sq_GetMp()` - 获取当前MP

#### 攻击相关
- `obj.sq_SetCurrentAttackInfo(atkIndex)` - 设置攻击信息
- `obj.sq_SetCurrentAttackBonusRate(rate)` - 设置攻击伤害倍率
- `obj.sq_GetBonusRateWithPassive(skillIndex, state, column, defaultRate)` - 获取包含被动的伤害倍率

#### 特效控制
- `obj.sq_setCustomHitEffectFileName(fileName)` - 设置自定义命中特效
- `obj.sq_SetShake(target, power, time)` - 设置震动效果
- `obj.sq_PlaySound(soundFileName)` - 播放音效

### damager对象方法
- `damager.sq_SetDamage(damage)` - 设置伤害值
- `damager.sq_AddDamage(damage)` - 增加伤害值
- `damager.sq_SetAttackInfo(atkInfo)` - 设置攻击信息
- `damager.sq_SetHitInfo(hitInfo)` - 设置命中信息
- `damager.sq_AddState(state, time)` - 对目标添加状态效果

---

## 常用常量参考

### 攻击类型
- `ATTACKTYPE_PHYSICAL` - 物理攻击
- `ATTACKTYPE_MAGICAL` - 魔法攻击
- `ATTACKTYPE_INDEPENDENT` - 固定伤害

### 属性类型
- `ENUM_STAT_PHYSICAL_ATTACK` - 物理攻击力
- `ENUM_STAT_MAGICAL_ATTACK` - 魔法攻击力
- `ENUM_STAT_PHYSICAL_DEFENSE` - 物理防御力
- `ENUM_STAT_MAGICAL_DEFENSE` - 魔法防御力
- `ENUM_STAT_STR` - 力量
- `ENUM_STAT_INT` - 智力
- `ENUM_STAT_VIT` - 体力
- `ENUM_STAT_SPR` - 精神

### 状态效果
- `STATE_STAND` - 站立状态
- `STATE_WALK` - 行走状态
- `STATE_RUN` - 跑步状态
- `STATE_STUN` - 眩晕状态
- `STATE_FREEZE` - 冰冻状态
- `STATE_BURN` - 燃烧状态
- `STATE_POISON` - 中毒状态

### 方向常量
- `ENUM_DIRECTION_LEFT` - 左方向
- `ENUM_DIRECTION_RIGHT` - 右方向
- `ENUM_DIRECTION_UP` - 上方向
- `ENUM_DIRECTION_DOWN` - 下方向

### 速度类型
- `SPEED_TYPE_ATTACK_SPEED` - 攻击速度
- `SPEED_TYPE_MOVE_SPEED` - 移动速度
- `SPEED_TYPE_CAST_SPEED` - 施法速度
- `SPEED_VALUE_DEFAULT` - 默认速度值

### 状态优先级
- `STATE_PRIORITY_USER` - 用户优先级
- `STATE_PRIORITY_IGNORE_FORCE` - 忽略强制优先级
- `STATE_PRIORITY_FORCE` - 强制优先级

---

## 开发流程指导

### 第一阶段：基础准备

#### 1. 文件创建
1. **技能文件** (.skl) - 定义技能基本属性
2. **头文件** (.nut) - 定义常量和编号
3. **脚本文件** (.nut) - 实现技能逻辑
4. **攻击信息文件** (.atk) - 定义攻击属性

#### 2. 编号分配
- **状态编号**: 选择未使用的编号（建议95以上）
- **技能编号**: 对应技能列表中的空位
- **动画编号**: 指向CHR文件中的动画索引
- **攻击信息编号**: 指向CHR文件中的攻击信息索引

#### 3. 基础配置
```nut
// 在头文件中定义
STATE_技能名 <- 95;        // 状态编号
SKILL_技能名 <- 220;       // 技能编号
CUSTOM_ANI_01 <- 0;       // 动画编号
CUSTOM_ATK_01 <- 0;       // 攻击信息编号
```

### 第二阶段：基础实现

#### 1. 实现核心函数框架
```nut
// 必需的四个基础函数
function checkExecutableSkill_技能名(obj) { }
function checkCommandEnable_技能名(obj) { }
function onSetState_技能名(obj, state, datas, isResetTimer) { }
function onEndCurrentAni_技能名(obj) { }
```

#### 2. 配置状态加载
```nut
// 在load_state文件中注册
IRDSQRCharacter.pushState(职业枚举, 
                         "脚本路径", 
                         "脚本名称", 
                         状态编号, 
                         技能编号);
```

#### 3. 测试基础功能
- 技能是否能正常释放
- 动画是否正确播放
- 状态转换是否正常

### 第三阶段：功能完善

#### 1. 添加攻击系统
```nut
// 在onSetState中添加
obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);
local damage = obj.sq_GetBonusRateWithPassive(SKILL_技能编号, STATE_技能状态, 0, 1.0);
obj.sq_SetCurrentAttackBonusRate(damage);
```

#### 2. 实现特殊效果
```nut
// 命中效果
function onAttack_技能名(obj, damager, boundingBox, isStuck)
{
    // 添加视觉效果
    sq_EffectLayerAppendage(damager, sq_RGB(255, 0, 0), 200, 0, 0, 300);
}
```

#### 3. 优化用户体验
- 添加音效和特效
- 优化动画流畅度
- 调整技能数值平衡

### 第四阶段：测试调试

#### 1. 功能测试
- 技能释放条件检查
- 伤害计算验证
- 特效显示确认

#### 2. 兼容性测试
- 与其他技能的交互
- 不同状态下的表现
- 网络同步验证

#### 3. 性能优化
- 减少不必要的计算
- 优化特效资源使用
- 提高代码执行效率

---

## 进阶技术要点

### 多动作技能实现

#### 状态机设计
```nut
// 定义子状态
ENUM_技能名_SUBSTATE_READY = 0;      // 准备状态
ENUM_技能名_SUBSTATE_ATTACK = 1;     // 攻击状态
ENUM_技能名_SUBSTATE_END = 2;        // 结束状态

function onSetState_技能名(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    // 设置初始子状态
    obj.sq_SetStaticInt(ENUM_STATIC_INT_01, ENUM_技能名_SUBSTATE_READY);
    
    // 根据子状态执行不同逻辑
    local subState = obj.sq_GetStaticInt(ENUM_STATIC_INT_01);
    switch(subState)
    {
        case ENUM_技能名_SUBSTATE_READY:
            // 准备阶段逻辑
            break;
        case ENUM_技能名_SUBSTATE_ATTACK:
            // 攻击阶段逻辑
            break;
        case ENUM_技能名_SUBSTATE_END:
            // 结束阶段逻辑
            break;
    }
}
```

#### 时间事件控制
```nut
function onTimeEvent_技能名(obj, timeEventIndex, timeEventCount)
{
    if (!obj) return;
    
    local subState = obj.sq_GetStaticInt(ENUM_STATIC_INT_01);
    
    switch(timeEventIndex)
    {
        case 0:  // 第一个时间点 - 切换到攻击状态
            obj.sq_SetStaticInt(ENUM_STATIC_INT_01, ENUM_技能名_SUBSTATE_ATTACK);
            obj.sq_SetCurrentAnimation(CUSTOM_ANI_02);
            break;
        case 1:  // 第二个时间点 - 切换到结束状态
            obj.sq_SetStaticInt(ENUM_STATIC_INT_01, ENUM_技能名_SUBSTATE_END);
            obj.sq_SetCurrentAnimation(CUSTOM_ANI_03);
            break;
    }
}
```

### BUFF技能开发

#### 被动技能结构
```nut
// 被动技能检查
function checkExecutableSkill_被动技能名(obj)
{
    if (!obj) return false;
    
    // 被动技能通常总是可执行
    return true;
}

// 被动效果应用
function onSetState_被动技能名(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    // 添加被动效果
    local appendage = obj.sq_AddAppendage("appendage/character/thief/被动效果.app");
    if (appendage) {
        appendage.sq_SetValidTime(持续时间);
    }
}
```

#### 主动BUFF实现
```nut
function onSetState_BUFF技能名(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    // 播放BUFF动画
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_BUFF);
    
    // 添加BUFF效果
    local buffAppendage = obj.sq_AddAppendage("appendage/character/thief/BUFF效果.app");
    if (buffAppendage) {
        buffAppendage.sq_SetValidTime(BUFF持续时间);
        
        // 设置BUFF属性
        buffAppendage.sq_SetData(APPENDAGE_STAT_PHYSICAL_ATTACK, 攻击力增加值);
        buffAppendage.sq_SetData(APPENDAGE_STAT_ATTACK_SPEED, 攻击速度增加值);
    }
}
```

### 抓取技能开发

#### 抓取判定实现
```nut
function onSetState_抓取技能名(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    // 创建抓取区域
    local grabArea = obj.sq_CreateAttackArea(
        抓取范围X, 抓取范围Y, 抓取范围Z,
        抓取偏移X, 抓取偏移Y, 抓取偏移Z
    );
    
    if (grabArea) {
        grabArea.sq_SetAttackInfo(CUSTOM_ATK_GRAB);
        grabArea.sq_SetGrabMode(true);  // 设置为抓取模式
    }
}

// 抓取成功处理
function onGrab_抓取技能名(obj, target)
{
    if (!obj || !target) return;
    
    // 将目标移动到指定位置
    target.sq_SetPosition(obj.sq_GetXPos(), obj.sq_GetYPos(), obj.sq_GetZPos());
    
    // 播放抓取动画
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_GRAB_SUCCESS);
    target.sq_SetCurrentAnimation(CUSTOM_ANI_GRABBED);
    
    // 设置目标为被抓取状态
    target.sq_AddState(STATE_GRABBED, 3000);  // 3秒被抓取状态
}
```

---

## 学习路径规划

### 入门阶段（1-2周）
1. **基础概念理解**
   - 学习State概念和状态转换
   - 了解主要函数结构和命名规范
   - 掌握基本语法和数据类型

2. **简单技能制作**
   - 单动作攻击技能
   - 基础伤害应用
   - 动画设置和播放

3. **环境搭建**
   - 配置开发工具
   - 理解文件结构
   - 学会基础调试方法

### 进阶阶段（3-4周）
1. **多动作技能**
   - 技能连招系统
   - 强制中断机制
   - 状态转换控制

2. **特殊技能类型**
   - 抓取技能实现
   - 镜头移动控制
   - 距离移动技巧

3. **数据传递**
   - 变量管理系统
   - 参数传递机制
   - 状态数据保存

### 高级阶段（5-8周）
1. **BUFF系统**
   - 主动BUFF技能
   - 被动技能机制
   - 状态叠加处理

2. **复杂机制**
   - 特效真伤系统
   - 体术技能开发
   - 动态调试技术

3. **性能优化**
   - 代码优化技巧
   - 内存管理
   - 网络同步优化

### 专家阶段（持续学习）
1. **引擎深度理解**
   - DNF引擎机制研究
   - 底层API调用
   - 高级调试技术

2. **创新技能开发**
   - 独特机制设计
   - 复杂交互系统
   - 跨职业技能整合

3. **社区贡献**
   - 分享开发经验
   - 参与开源项目
   - 指导新手学习

---

## 开发实践建议

### 1. 加载函数选择
- **开发/测试阶段**: 使用`dofile()`（实时生效，方便调试）
- **成品脚本**: 改用`sq_RunScript()`（内存读取，提升性能）

### 2. 加载策略选择
- **通用逻辑**: 使用`pushScriptFiles`（全局预加载）
- **特定状态逻辑**: 使用`pushState`（动态加载，节省内存）

### 3. 函数命名规范
- 使用"函数签名驱动"时，严格遵循"事件前缀 + 职业名"格式
- 避免引擎无法识别的命名方式

### 4. 代码管理
- 统一代码风格和注释规范
- 使用版本控制系统
- 建立代码审查机制

### 5. 调试技巧
- 使用日志输出调试信息
- 分阶段测试功能模块
- 建立完整的测试用例

---

## 总结

NUT脚本开发是一个需要理论与实践相结合的技术领域。通过系统学习本指南的内容，结合大量的实际练习，开发者可以逐步掌握从基础技能到复杂机制的完整开发能力。

记住，优秀的NUT脚本开发者不仅要掌握技术细节，更要理解游戏设计的本质，创造出既有趣又平衡的游戏体验。

---

*本指南基于多个权威教程资源整理，持续更新中...*