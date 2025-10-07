# DAF学院NUT脚本知识总结

## 📖 目录
- [概述](#概述)
- [NUT脚本基础理论](#nut脚本基础理论)
- [DNF引擎架构](#dnf引擎架构)
- [脚本编写规范](#脚本编写规范)
- [核心函数系统](#核心函数系统)
- [状态管理机制](#状态管理机制)
- [技能开发流程](#技能开发流程)
- [实战开发技巧](#实战开发技巧)
- [性能优化策略](#性能优化策略)
- [调试与测试](#调试与测试)
- [常见问题解决](#常见问题解决)
- [进阶开发指南](#进阶开发指南)

---

## 概述

本文档汇总了DAF学院在NUT脚本开发方面的核心知识和实践经验，为DNF技能开发者提供系统性的学习指南。内容涵盖从基础理论到高级实战的完整知识体系。

### 学习目标

完成本教程后，您将能够：
- 深入理解DNF引擎的NUT脚本机制
- 熟练掌握技能脚本的编写和调试
- 具备独立开发复杂技能的能力
- 掌握性能优化和问题排查技巧

---

## NUT脚本基础理论

### Squirrel语言特性

#### 1. 语言设计哲学
```squirrel
// Squirrel是一种轻量级、面向对象的脚本语言
// 设计目标：简洁、高效、易于嵌入C++应用

// 核心特性：
// - 动态类型系统
// - 自动内存管理
// - 函数式编程支持
// - 面向对象编程
// - 协程支持
```

#### 2. 数据类型系统
```squirrel
// 基本数据类型
local nullValue = null;              // 空值
local boolValue = true;              // 布尔值
local intValue = 42;                 // 整数
local floatValue = 3.14;             // 浮点数
local stringValue = "Hello DNF";     // 字符串

// 复合数据类型
local arrayValue = [1, 2, 3, "four"];           // 数组
local tableValue = { name = "技能", level = 1 }; // 表（哈希表）

// 函数类型
local funcValue = function(x) { return x * 2; };

// 类和实例
class Character {
    constructor(name) { this.name = name; }
}
local player = Character("战士");
```

#### 3. 作用域和生命周期
```squirrel
// 全局作用域
g_globalVar <- 100;  // 全局变量（推荐使用 <- 操作符）

function GlobalFunction()
{
    // 函数作用域
    local localVar = 200;  // 局部变量
    
    // 闭包作用域
    local closure = function() {
        return localVar + g_globalVar;  // 访问外层变量
    };
    
    return closure;
}

// 表作用域
local skillData = {
    name = "火球术",
    cast = function() {
        print("释放 " + this.name);  // this指向当前表
    }
};
```

### DNF中的Squirrel扩展

#### 1. 引擎对象扩展
```squirrel
// obj对象 - 角色/怪物实体
obj.sq_GetState()              // 获取当前状态
obj.sq_SetCurrentAnimation()   // 设置动画
obj.sq_AddSetStatePacket()     // 添加状态包
obj.sq_GetHP()                 // 获取生命值
obj.sq_GetMp()                 // 获取魔法值

// 全局函数扩展
sq_RGB(r, g, b)               // 创建颜色值
sq_flashScreen()              // 屏幕闪烁
sq_CreateObject()             // 创建对象
sq_CreateDrawOnlyObject()     // 创建纯显示对象
```

#### 2. 常量系统
```squirrel
// 状态常量
STATE_STAND <- 0;             // 站立状态
STATE_WALK <- 1;              // 行走状态
STATE_ATTACK <- 10;           // 攻击状态

// 技能常量
SKILL_ATTACK <- 0;            // 普通攻击
SKILL_FIREBALL <- 220;        // 火球术

// 动画常量
CUSTOM_ANI_01 <- 0;           // 自定义动画1
CUSTOM_ANI_02 <- 1;           // 自定义动画2

// 攻击信息常量
CUSTOM_ATK_01 <- 0;           // 自定义攻击信息1
CUSTOM_ATK_02 <- 1;           // 自定义攻击信息2
```

---

## DNF引擎架构

### 引擎层次结构

```
DNF游戏引擎架构
├── 表现层 (Presentation Layer)
│   ├── 用户界面 (UI)
│   ├── 渲染引擎 (Rendering)
│   ├── 音效系统 (Audio)
│   └── 输入处理 (Input)
├── 逻辑层 (Logic Layer)
│   ├── 游戏逻辑 (Game Logic)
│   ├── 脚本引擎 (Script Engine)
│   │   ├── Squirrel虚拟机
│   │   ├── 脚本加载器
│   │   └── 函数调用器
│   ├── 状态机 (State Machine)
│   └── 事件系统 (Event System)
├── 数据层 (Data Layer)
│   ├── 资源管理 (Resource Manager)
│   ├── 文件系统 (File System)
│   ├── 数据库 (Database)
│   └── 网络通信 (Network)
└── 平台层 (Platform Layer)
    ├── 操作系统接口
    ├── 硬件抽象
    └── 内存管理
```

### 脚本引擎详解

#### 1. Squirrel虚拟机
```cpp
// 伪代码：虚拟机核心结构
class SquirrelVM
{
private:
    HSQUIRRELVM vm;                    // Squirrel虚拟机实例
    map<string, HSQOBJECT> globals;    // 全局对象表
    vector<ScriptModule*> modules;     // 脚本模块列表
    
public:
    bool Initialize();                 // 初始化虚拟机
    bool LoadScript(const string& path); // 加载脚本文件
    bool CallFunction(const string& name, ...); // 调用脚本函数
    void CollectGarbage();            // 垃圾回收
};
```

#### 2. 脚本加载机制
```squirrel
// 脚本加载顺序
// 1. 系统启动时加载核心脚本
sq_RunScript("sqr/loadstate.nut");        // 主入口
sq_RunScript("sqr/common.nut");           // 公共函数
sq_RunScript("sqr/dnf_enum_header.nut");  // 枚举定义

// 2. 角色创建时加载职业脚本
sq_RunScript("sqr/character/thief/thief_header.nut");
sq_RunScript("sqr/character/thief/thief_load_state.nut");

// 3. 技能使用时动态加载技能脚本
sq_RunScript("sqr/character/thief/zskill00/zskill00.nut");
```

#### 3. 函数调用机制
```squirrel
// 引擎调用脚本的三种方式

// 方式1：直接函数调用
function onGameStart()
{
    print("游戏开始");
}

// 方式2：事件驱动调用
function useSkill_after_Thief(obj, skillIndex, isSuccess)
{
    if (isSuccess) {
        print("暗夜使者技能释放成功");
    }
}

// 方式3：状态驱动调用
function onSetState_CustomSkill(obj, state, datas, isResetTimer)
{
    print("进入自定义技能状态");
}
```

---

## 脚本编写规范

### 代码风格规范

#### 1. 命名约定
```squirrel
// 常量：全大写，下划线分隔
const SKILL_MAX_LEVEL = 60;
const STATE_CUSTOM_ATTACK = 95;

// 变量：驼峰命名法
local playerLevel = 70;
local skillCooldown = 3000;
local isSkillReady = true;

// 函数：驼峰命名法，动词开头
function calculateDamage(attack, defense) { }
function checkSkillRequirement(obj, skillIndex) { }
function applySkillEffect(target, effectType) { }

// 类：帕斯卡命名法
class SkillManager { }
class EffectController { }
```

#### 2. 代码组织
```squirrel
// 文件头部：版权和说明信息
/*
 * 文件名: fireball_skill.nut
 * 作者: DAF学院
 * 创建日期: 2024-01-01
 * 描述: 火球术技能实现
 * 版本: 1.0
 */

// 常量定义区域
const FIREBALL_DAMAGE_BASE = 100;
const FIREBALL_MP_COST = 50;
const FIREBALL_COOLDOWN = 3000;

// 全局变量区域
local g_fireballCount = 0;
local g_lastCastTime = 0;

// 工具函数区域
function isFireballReady(obj)
{
    local currentTime = GetCurrentTime();
    return (currentTime - g_lastCastTime) >= FIREBALL_COOLDOWN;
}

// 主要功能函数区域
function onSetState_Fireball(obj, state, datas, isResetTimer)
{
    // 主要实现逻辑
}

// 辅助函数区域
function calculateFireballDamage(casterLevel, targetDefense)
{
    // 伤害计算逻辑
}
```

#### 3. 注释规范
```squirrel
/**
 * 计算火球术伤害
 * @param {object} caster - 施法者对象
 * @param {object} target - 目标对象
 * @param {number} skillLevel - 技能等级
 * @return {number} 计算后的伤害值
 * @example
 * local damage = calculateFireballDamage(player, monster, 10);
 */
function calculateFireballDamage(caster, target, skillLevel)
{
    if (!caster || !target) {
        return 0;  // 参数验证失败
    }
    
    // 获取基础攻击力
    local baseAttack = caster.sq_GetPhysicalAttack();
    
    // 计算技能倍率 (每级增加10%伤害)
    local skillMultiplier = 1.0 + (skillLevel * 0.1);
    
    // 计算基础伤害
    local baseDamage = FIREBALL_DAMAGE_BASE + (baseAttack * skillMultiplier);
    
    // 应用目标防御
    local targetDefense = target.sq_GetPhysicalDefense();
    local damageReduction = targetDefense / (targetDefense + 1000.0);
    local finalDamage = baseDamage * (1.0 - damageReduction);
    
    return finalDamage.tointeger();
}
```

### 错误处理规范

#### 1. 参数验证
```squirrel
function safeSkillCast(obj, skillIndex, targetPos)
{
    // 空值检查
    if (!obj) {
        DebugLog("ERROR", "safeSkillCast: obj is null");
        return false;
    }
    
    // 范围检查
    if (skillIndex < 0 || skillIndex >= MAX_SKILL_COUNT) {
        DebugLog("ERROR", "safeSkillCast: invalid skillIndex " + skillIndex);
        return false;
    }
    
    // 类型检查
    if (typeof(targetPos) != "table" || !("x" in targetPos) || !("y" in targetPos)) {
        DebugLog("ERROR", "safeSkillCast: invalid targetPos format");
        return false;
    }
    
    // 状态检查
    local currentState = obj.sq_GetState();
    if (!isValidCastState(currentState)) {
        DebugLog("WARNING", "safeSkillCast: cannot cast in state " + currentState);
        return false;
    }
    
    return true;
}
```

#### 2. 异常处理
```squirrel
function robustFunction(obj, data)
{
    try {
        // 可能出错的操作
        local result = riskyOperation(obj, data);
        return result;
    }
    catch (e) {
        // 记录错误信息
        DebugLog("ERROR", "robustFunction failed: " + e);
        
        // 执行清理操作
        cleanupResources();
        
        // 返回安全的默认值
        return getDefaultValue();
    }
}
```

---

## 核心函数系统

### 生命周期函数

#### 1. 状态生命周期
```squirrel
// 状态开始时调用
function onSetState_SkillName(obj, state, datas, isResetTimer)
{
    if (!obj) return;
    
    // 初始化技能状态
    obj.sq_StopMove();                              // 停止移动
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);      // 设置动画
    obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);     // 设置攻击信息
    
    // 初始化技能变量
    obj.sq_SetStaticInt(ENUM_STATIC_INT_01, 0);     // 重置计数器
    obj.sq_SetStaticFloat(ENUM_STATIC_FLOAT_01, 0.0); // 重置浮点数
    
    // 播放音效
    obj.sq_PlaySound("skill_cast.wav");
}

// 状态持续期间每帧调用
function proc_SkillName(obj)
{
    if (!obj) return;
    
    // 检查输入
    local inputKey = obj.sq_GetInputKey();
    if (inputKey & INPUT_KEY_ATTACK) {
        // 处理攻击键输入
        handleAttackInput(obj);
    }
    
    // 更新技能逻辑
    updateSkillLogic(obj);
    
    // 检查结束条件
    if (shouldEndSkill(obj)) {
        obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
    }
}

// 状态结束时调用
function onEnd_SkillName(obj)
{
    if (!obj) return;
    
    // 清理技能效果
    cleanupSkillEffects(obj);
    
    // 重置变量
    obj.sq_SetStaticInt(ENUM_STATIC_INT_01, 0);
    
    // 播放结束音效
    obj.sq_PlaySound("skill_end.wav");
}
```

#### 2. 动画事件函数
```squirrel
// 动画结束时调用
function onEndCurrentAni_SkillName(obj)
{
    if (!obj) return;
    
    local currentAni = obj.sq_GetCurrentAnimation();
    
    switch (currentAni) {
        case CUSTOM_ANI_01:
            // 第一段动画结束，播放第二段
            obj.sq_SetCurrentAnimation(CUSTOM_ANI_02);
            break;
            
        case CUSTOM_ANI_02:
            // 技能动画全部结束
            obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
            break;
    }
}

// 时间事件触发
function onTimeEvent_SkillName(obj, timeEventIndex, timeEventCount)
{
    if (!obj) return;
    
    switch (timeEventIndex) {
        case 0:  // 第一个时间点
            // 创建攻击判定
            obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);
            break;
            
        case 1:  // 第二个时间点
            // 创建特效
            createSkillEffect(obj);
            break;
            
        case 2:  // 第三个时间点
            // 技能结束
            obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
            break;
    }
}
```

### 攻击系统函数

#### 1. 攻击判定函数
```squirrel
// 攻击命中时调用
function onAttack_SkillName(obj, damager, boundingBox, isStuck)
{
    if (!obj || !damager) return;
    
    // 获取技能等级
    local skillLevel = obj.sq_GetSkillLevel(SKILL_FIREBALL);
    
    // 计算伤害
    local damage = calculateSkillDamage(obj, damager, skillLevel);
    
    // 应用伤害
    damager.sq_AddDamage(damage);
    
    // 应用击退效果
    local knockbackForce = 200 + (skillLevel * 10);
    damager.sq_AddForce(knockbackForce, 0);
    
    // 播放命中特效
    local hitPos = damager.sq_GetPos();
    createHitEffect(hitPos);
    
    // 播放命中音效
    obj.sq_PlaySound("skill_hit.wav");
    
    // 记录命中次数
    local hitCount = obj.sq_GetStaticInt(ENUM_STATIC_INT_01);
    obj.sq_SetStaticInt(ENUM_STATIC_INT_01, hitCount + 1);
}

// 被攻击时调用
function onDamage_SkillName(obj, attacker, damage, damageType)
{
    if (!obj || !attacker) return;
    
    // 检查是否在技能状态中
    local currentState = obj.sq_GetState();
    if (currentState != STATE_SKILL_CUSTOM) return;
    
    // 技能被打断的处理
    if (damage > obj.sq_GetMaxHP() * 0.1) {  // 伤害超过最大HP的10%
        // 强制结束技能
        obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_INTERRUPT, false);
        
        // 播放被打断特效
        createInterruptEffect(obj);
    }
}
```

#### 2. 伤害计算系统
```squirrel
// 物理伤害计算
function calculatePhysicalDamage(attacker, target, skillMultiplier)
{
    if (!attacker || !target) return 0;
    
    // 获取攻击者属性
    local physicalAttack = attacker.sq_GetPhysicalAttack();
    local strength = attacker.sq_GetSTR();
    local weaponAttack = attacker.sq_GetWeaponPhysicalAttack();
    
    // 获取目标防御
    local physicalDefense = target.sq_GetPhysicalDefense();
    
    // 基础伤害计算
    local baseDamage = (physicalAttack + weaponAttack) * skillMultiplier;
    
    // 力量加成
    local strBonus = strength * 0.004;  // 每点力量增加0.4%伤害
    baseDamage *= (1.0 + strBonus);
    
    // 防御减免
    local defenseReduction = physicalDefense / (physicalDefense + 1000.0);
    local finalDamage = baseDamage * (1.0 - defenseReduction);
    
    // 随机浮动 (±5%)
    local randomFactor = 0.95 + (rand() % 11) * 0.01;
    finalDamage *= randomFactor;
    
    return finalDamage.tointeger();
}

// 魔法伤害计算
function calculateMagicalDamage(attacker, target, skillMultiplier)
{
    if (!attacker || !target) return 0;
    
    // 获取攻击者属性
    local magicalAttack = attacker.sq_GetMagicalAttack();
    local intelligence = attacker.sq_GetINT();
    local weaponMagicalAttack = attacker.sq_GetWeaponMagicalAttack();
    
    // 获取目标魔防
    local magicalDefense = target.sq_GetMagicalDefense();
    
    // 基础伤害计算
    local baseDamage = (magicalAttack + weaponMagicalAttack) * skillMultiplier;
    
    // 智力加成
    local intBonus = intelligence * 0.004;  // 每点智力增加0.4%伤害
    baseDamage *= (1.0 + intBonus);
    
    // 魔防减免
    local defenseReduction = magicalDefense / (magicalDefense + 1000.0);
    local finalDamage = baseDamage * (1.0 - defenseReduction);
    
    // 随机浮动
    local randomFactor = 0.95 + (rand() % 11) * 0.01;
    finalDamage *= randomFactor;
    
    return finalDamage.tointeger();
}
```

---

## 状态管理机制

### 状态注册系统

#### 1. 基础状态注册
```squirrel
// 在职业的load_state.nut文件中注册状态
function registerSkillStates()
{
    // 注册基础攻击技能
    IRDSQRCharacter.pushState(
        ENUM_CHARACTERJOB_THIEF,                    // 职业类型
        "Character/Thief/BasicAttack/BasicAttack.nut", // 脚本路径
        "BasicAttack",                              // 函数前缀
        STATE_BASIC_ATTACK,                         // 状态ID
        SKILL_BASIC_ATTACK                          // 技能ID
    );
    
    // 注册特殊技能
    IRDSQRCharacter.pushState(
        ENUM_CHARACTERJOB_THIEF,
        "Character/Thief/ShadowStep/ShadowStep.nut",
        "ShadowStep",
        STATE_SHADOW_STEP,
        SKILL_SHADOW_STEP
    );
}
```

#### 2. 高级状态注册
```squirrel
// 注册多阶段技能
function registerMultiStageSkill()
{
    // 第一阶段
    IRDSQRCharacter.pushState(
        ENUM_CHARACTERJOB_SWORDMAN,
        "Character/Swordman/ComboSlash/ComboSlash.nut",
        "ComboSlash_Stage1",
        STATE_COMBO_SLASH_1,
        SKILL_COMBO_SLASH
    );
    
    // 第二阶段
    IRDSQRCharacter.pushState(
        ENUM_CHARACTERJOB_SWORDMAN,
        "Character/Swordman/ComboSlash/ComboSlash.nut",
        "ComboSlash_Stage2",
        STATE_COMBO_SLASH_2,
        SKILL_COMBO_SLASH
    );
    
    // 第三阶段
    IRDSQRCharacter.pushState(
        ENUM_CHARACTERJOB_SWORDMAN,
        "Character/Swordman/ComboSlash/ComboSlash.nut",
        "ComboSlash_Stage3",
        STATE_COMBO_SLASH_3,
        SKILL_COMBO_SLASH
    );
}
```

### 状态转换控制

#### 1. 基础状态转换
```squirrel
function transitionToSkillState(obj, targetState, priority)
{
    if (!obj) return false;
    
    // 检查当前状态是否允许转换
    local currentState = obj.sq_GetState();
    if (!canTransitionFrom(currentState, targetState)) {
        return false;
    }
    
    // 执行状态转换
    obj.sq_AddSetStatePacket(targetState, priority, false);
    return true;
}

function canTransitionFrom(currentState, targetState)
{
    // 定义状态转换规则
    local transitionRules = {
        [STATE_STAND] = [STATE_WALK, STATE_ATTACK, STATE_SKILL_CAST],
        [STATE_WALK] = [STATE_STAND, STATE_ATTACK, STATE_SKILL_CAST],
        [STATE_ATTACK] = [STATE_STAND],  // 攻击状态只能转换到站立
        [STATE_SKILL_CAST] = [STATE_STAND, STATE_SKILL_CAST]  // 技能可以连招
    };
    
    if (!(currentState in transitionRules)) {
        return false;  // 未定义的状态
    }
    
    local allowedStates = transitionRules[currentState];
    return allowedStates.find(targetState) != null;
}
```

#### 2. 优先级管理
```squirrel
// 状态优先级常量
const STATE_PRIORITY_IGNORE = 0;        // 忽略
const STATE_PRIORITY_NORMAL = 1;        // 普通
const STATE_PRIORITY_USER = 2;          // 用户操作
const STATE_PRIORITY_INTERRUPT = 3;     // 中断
const STATE_PRIORITY_FORCE = 4;         // 强制

function addStateWithPriority(obj, state, priority, resetTimer)
{
    if (!obj) return;
    
    local currentState = obj.sq_GetState();
    local currentPriority = getStatePriority(currentState);
    
    // 检查优先级
    if (priority < currentPriority) {
        DebugLog("WARNING", "State transition blocked by priority: " + 
                 currentPriority + " > " + priority);
        return;
    }
    
    // 执行状态转换
    obj.sq_AddSetStatePacket(state, priority, resetTimer);
    
    // 记录状态转换
    DebugLog("INFO", "State transition: " + currentState + " -> " + state + 
             " (priority: " + priority + ")");
}
```

---

## 技能开发流程

### 完整开发流程

#### 1. 需求分析阶段
```squirrel
/*
技能设计文档：火焰冲击
======================

基本信息：
- 技能名称：火焰冲击 (Flame Rush)
- 技能类型：主动攻击技能
- 消耗：50 MP
- 冷却时间：8秒
- 施法距离：300像素

技能效果：
1. 角色向前冲刺300像素距离
2. 冲刺路径上的敌人受到火焰伤害
3. 冲刺结束后产生火焰爆炸
4. 爆炸范围内敌人受到额外伤害

动画需求：
- 冲刺准备动画 (0.2秒)
- 冲刺移动动画 (0.5秒)
- 爆炸动画 (0.3秒)

特效需求：
- 冲刺轨迹火焰特效
- 爆炸火焰特效
- 屏幕震动效果

音效需求：
- 技能施放音效
- 冲刺移动音效
- 爆炸音效
*/
```

#### 2. 技术设计阶段
```squirrel
// 技能状态设计
const STATE_FLAME_RUSH_PREPARE = 95;    // 准备阶段
const STATE_FLAME_RUSH_DASH = 96;       // 冲刺阶段
const STATE_FLAME_RUSH_EXPLODE = 97;    // 爆炸阶段

// 技能参数设计
const FLAME_RUSH_MP_COST = 50;          // MP消耗
const FLAME_RUSH_COOLDOWN = 8000;       // 冷却时间(毫秒)
const FLAME_RUSH_DISTANCE = 300;        // 冲刺距离
const FLAME_RUSH_SPEED = 600;           // 冲刺速度(像素/秒)
const FLAME_RUSH_EXPLOSION_RADIUS = 150; // 爆炸半径

// 伤害参数设计
const FLAME_RUSH_DASH_DAMAGE_RATE = 1.5;    // 冲刺伤害倍率
const FLAME_RUSH_EXPLOSION_DAMAGE_RATE = 2.0; // 爆炸伤害倍率
```

#### 3. 实现阶段
```squirrel
// 技能检查函数
function checkExecutableSkill_FlameRush(obj)
{
    if (!obj) return false;
    
    // 检查MP
    if (obj.sq_GetMp() < FLAME_RUSH_MP_COST) {
        return false;
    }
    
    // 检查冷却时间
    if (!isSkillReady(obj, SKILL_FLAME_RUSH, FLAME_RUSH_COOLDOWN)) {
        return false;
    }
    
    // 检查当前状态
    local currentState = obj.sq_GetState();
    if (!canCastSkill(currentState)) {
        return false;
    }
    
    return true;
}

// 技能准备阶段
function onSetState_FlameRush_Prepare(obj, state, datas, isResetTimer)
{
    if (!obj) return;
    
    // 停止移动
    obj.sq_StopMove();
    
    // 设置准备动画
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_FLAME_RUSH_PREPARE);
    
    // 消耗MP
    obj.sq_AddMp(-FLAME_RUSH_MP_COST);
    
    // 播放施法音效
    obj.sq_PlaySound("flame_rush_cast.wav");
    
    // 设置准备时间
    obj.sq_SetStaticInt(ENUM_STATIC_INT_01, GetCurrentTime());
}

function proc_FlameRush_Prepare(obj)
{
    if (!obj) return;
    
    local startTime = obj.sq_GetStaticInt(ENUM_STATIC_INT_01);
    local elapsed = GetCurrentTime() - startTime;
    
    // 准备时间结束，进入冲刺阶段
    if (elapsed >= 200) {  // 0.2秒准备时间
        obj.sq_AddSetStatePacket(STATE_FLAME_RUSH_DASH, STATE_PRIORITY_USER, false);
    }
}

// 技能冲刺阶段
function onSetState_FlameRush_Dash(obj, state, datas, isResetTimer)
{
    if (!obj) return;
    
    // 设置冲刺动画
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_FLAME_RUSH_DASH);
    
    // 设置攻击信息
    obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_FLAME_RUSH_DASH);
    
    // 计算冲刺目标位置
    local currentPos = obj.sq_GetPos();
    local direction = obj.sq_GetDirection();
    local targetX = currentPos.x + (FLAME_RUSH_DISTANCE * direction);
    
    // 开始冲刺移动
    obj.sq_SetMoveSpeed(FLAME_RUSH_SPEED);
    obj.sq_MoveToPos(targetX, currentPos.y, currentPos.z);
    
    // 创建冲刺轨迹特效
    createDashTrailEffect(obj);
    
    // 播放冲刺音效
    obj.sq_PlaySound("flame_rush_dash.wav");
    
    // 记录冲刺开始时间
    obj.sq_SetStaticInt(ENUM_STATIC_INT_01, GetCurrentTime());
}

function proc_FlameRush_Dash(obj)
{
    if (!obj) return;
    
    // 检查是否到达目标位置或超时
    local startTime = obj.sq_GetStaticInt(ENUM_STATIC_INT_01);
    local elapsed = GetCurrentTime() - startTime;
    local maxDashTime = (FLAME_RUSH_DISTANCE / FLAME_RUSH_SPEED) * 1000;
    
    if (elapsed >= maxDashTime || !obj.sq_IsMoving()) {
        // 冲刺结束，进入爆炸阶段
        obj.sq_AddSetStatePacket(STATE_FLAME_RUSH_EXPLODE, STATE_PRIORITY_USER, false);
    }
}

function onAttack_FlameRush_Dash(obj, damager, boundingBox, isStuck)
{
    if (!obj || !damager) return;
    
    // 计算冲刺伤害
    local damage = calculateMagicalDamage(obj, damager, FLAME_RUSH_DASH_DAMAGE_RATE);
    damager.sq_AddDamage(damage);
    
    // 应用火焰效果
    applyBurnEffect(damager, 3000);  // 3秒燃烧效果
    
    // 播放命中特效
    createHitEffect(damager.sq_GetPos(), "flame_hit.ani");
}

// 技能爆炸阶段
function onSetState_FlameRush_Explode(obj, state, datas, isResetTimer)
{
    if (!obj) return;
    
    // 停止移动
    obj.sq_StopMove();
    
    // 设置爆炸动画
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_FLAME_RUSH_EXPLODE);
    
    // 创建爆炸攻击判定
    obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_FLAME_RUSH_EXPLODE);
    
    // 创建爆炸特效
    local explosionPos = obj.sq_GetPos();
    createExplosionEffect(explosionPos);
    
    // 播放爆炸音效
    obj.sq_PlaySound("flame_rush_explode.wav");
    
    // 屏幕震动
    obj.sq_SetShake(obj, 5, 300);
    
    // 记录爆炸时间
    obj.sq_SetStaticInt(ENUM_STATIC_INT_01, GetCurrentTime());
}

function onAttack_FlameRush_Explode(obj, damager, boundingBox, isStuck)
{
    if (!obj || !damager) return;
    
    // 计算爆炸伤害
    local damage = calculateMagicalDamage(obj, damager, FLAME_RUSH_EXPLOSION_DAMAGE_RATE);
    damager.sq_AddDamage(damage);
    
    // 应用击飞效果
    damager.sq_AddForce(0, -300);  // 向上击飞
    
    // 应用强化燃烧效果
    applyBurnEffect(damager, 5000);  // 5秒强化燃烧
    
    // 播放爆炸命中特效
    createExplosionHitEffect(damager.sq_GetPos());
}

function onEndCurrentAni_FlameRush_Explode(obj)
{
    if (!obj) return;
    
    // 爆炸动画结束，返回站立状态
    obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}
```

#### 4. 测试阶段
```squirrel
// 调试和测试函数
function debugFlameRush(obj)
{
    if (!obj) return;
    
    DebugLog("DEBUG", "=== Flame Rush Debug Info ===");
    DebugLog("DEBUG", "Current State: " + obj.sq_GetState());
    DebugLog("DEBUG", "Current MP: " + obj.sq_GetMp());
    DebugLog("DEBUG", "Position: " + obj.sq_GetPos().x + ", " + obj.sq_GetPos().y);
    DebugLog("DEBUG", "Is Moving: " + obj.sq_IsMoving());
    
    // 输出技能相关变量
    local staticInt1 = obj.sq_GetStaticInt(ENUM_STATIC_INT_01);
    DebugLog("DEBUG", "Static Int 1: " + staticInt1);
    
    DebugLog("DEBUG", "=== End Debug Info ===");
}

// 性能测试函数
function performanceTestFlameRush()
{
    local startTime = GetCurrentTimeMs();
    
    // 执行100次伤害计算测试
    for (local i = 0; i < 100; i++) {
        local testDamage = calculateMagicalDamage(testCaster, testTarget, 1.5);
    }
    
    local endTime = GetCurrentTimeMs();
    local duration = endTime - startTime;
    
    DebugLog("PERF", "100 damage calculations took " + duration + "ms");
}
```

---

## 实战开发技巧

### 常用开发模式

#### 1. 状态机模式
```squirrel
// 复杂技能的状态机实现
class SkillStateMachine
{
    constructor(obj, skillName)
    {
        this.obj = obj;
        this.skillName = skillName;
        this.currentState = "idle";
        this.stateData = {};
        this.stateHandlers = {};
        
        this.initializeStates();
    }
    
    function initializeStates()
    {
        // 定义状态处理器
        this.stateHandlers["idle"] <- {
            enter = function(data) { this.onEnterIdle(data); },
            update = function() { this.onUpdateIdle(); },
            exit = function() { this.onExitIdle(); }
        };
        
        this.stateHandlers["casting"] <- {
            enter = function(data) { this.onEnterCasting(data); },
            update = function() { this.onUpdateCasting(); },
            exit = function() { this.onExitCasting(); }
        };
        
        this.stateHandlers["executing"] <- {
            enter = function(data) { this.onEnterExecuting(data); },
            update = function() { this.onUpdateExecuting(); },
            exit = function() { this.onExitExecuting(); }
        };
    }
    
    function changeState(newState, data = null)
    {
        if (this.currentState == newState) return;
        
        // 退出当前状态
        if (this.currentState in this.stateHandlers) {
            this.stateHandlers[this.currentState].exit();
        }
        
        // 进入新状态
        local oldState = this.currentState;
        this.currentState = newState;
        
        if (newState in this.stateHandlers) {
            this.stateHandlers[newState].enter(data);
        }
        
        DebugLog("DEBUG", this.skillName + " state: " + oldState + " -> " + newState);
    }
    
    function update()
    {
        if (this.currentState in this.stateHandlers) {
            this.stateHandlers[this.currentState].update();
        }
    }
}
```

#### 2. 组件化设计
```squirrel
// 技能组件基类
class SkillComponent
{
    constructor(name)
    {
        this.name = name;
        this.enabled = true;
    }
    
    function initialize(obj, skillData) { }
    function update(obj, deltaTime) { }
    function cleanup(obj) { }
}

// 伤害组件
class DamageComponent extends SkillComponent
{
    constructor()
    {
        base.constructor("DamageComponent");
        this.damageMultiplier = 1.0;
        this.damageType = "physical";
    }
    
    function initialize(obj, skillData)
    {
        if ("damageMultiplier" in skillData) {
            this.damageMultiplier = skillData.damageMultiplier;
        }
        if ("damageType" in skillData) {
            this.damageType = skillData.damageType;
        }
    }
    
    function applyDamage(attacker, target)
    {
        local damage = 0;
        
        if (this.damageType == "physical") {
            damage = calculatePhysicalDamage(attacker, target, this.damageMultiplier);
        } else if (this.damageType == "magical") {
            damage = calculateMagicalDamage(attacker, target, this.damageMultiplier);
        }
        
        target.sq_AddDamage(damage);
        return damage;
    }
}

// 特效组件
class EffectComponent extends SkillComponent
{
    constructor()
    {
        base.constructor("EffectComponent");
        this.effects = [];
    }
    
    function initialize(obj, skillData)
    {
        if ("effects" in skillData) {
            this.effects = skillData.effects;
        }
    }
    
    function playEffect(effectName, position)
    {
        if (this.effects.find(effectName) != null) {
            createEffect(effectName, position);
        }
    }
}

// 技能系统
class Skill
{
    constructor(name)
    {
        this.name = name;
        this.components = [];
        this.isActive = false;
    }
    
    function addComponent(component)
    {
        this.components.append(component);
    }
    
    function getComponent(componentName)
    {
        foreach (component in this.components) {
            if (component.name == componentName) {
                return component;
            }
        }
        return null;
    }
    
    function initialize(obj, skillData)
    {
        foreach (component in this.components) {
            component.initialize(obj, skillData);
        }
    }
    
    function update(obj, deltaTime)
    {
        if (!this.isActive) return;
        
        foreach (component in this.components) {
            if (component.enabled) {
                component.update(obj, deltaTime);
            }
        }
    }
}
```

#### 3. 配置驱动开发
```squirrel
// 技能配置数据
local g_skillConfigs = {
    "FireBall" = {
        name = "火球术",
        mpCost = 50,
        cooldown = 3000,
        castTime = 1000,
        range = 400,
        damageMultiplier = 1.5,
        damageType = "magical",
        effects = ["fireball_cast.ani", "fireball_projectile.ani", "fireball_hit.ani"],
        sounds = ["fireball_cast.wav", "fireball_hit.wav"],
        animations = {
            cast = CUSTOM_ANI_FIREBALL_CAST,
            projectile = CUSTOM_ANI_FIREBALL_PROJECTILE
        },
        attackInfo = {
            cast = CUSTOM_ATK_FIREBALL_CAST,
            projectile = CUSTOM_ATK_FIREBALL_PROJECTILE
        }
    },
    
    "LightningBolt" = {
        name = "闪电箭",
        mpCost = 80,
        cooldown = 5000,
        castTime = 800,
        range = 600,
        damageMultiplier = 2.0,
        damageType = "magical",
        effects = ["lightning_cast.ani", "lightning_bolt.ani", "lightning_hit.ani"],
        sounds = ["lightning_cast.wav", "lightning_hit.wav"],
        animations = {
            cast = CUSTOM_ANI_LIGHTNING_CAST
        },
        attackInfo = {
            cast = CUSTOM_ATK_LIGHTNING_CAST
        }
    }
};

// 通用技能处理函数
function executeConfigurableSkill(obj, skillName)
{
    if (!(skillName in g_skillConfigs)) {
        DebugLog("ERROR", "Skill config not found: " + skillName);
        return false;
    }
    
    local config = g_skillConfigs[skillName];
    
    // 检查MP
    if (obj.sq_GetMp() < config.mpCost) {
        return false;
    }
    
    // 检查冷却
    if (!isSkillReady(obj, skillName, config.cooldown)) {
        return false;
    }
    
    // 消耗MP
    obj.sq_AddMp(-config.mpCost);
    
    // 设置动画
    if ("animations" in config && "cast" in config.animations) {
        obj.sq_SetCurrentAnimation(config.animations.cast);
    }
    
    // 设置攻击信息
    if ("attackInfo" in config && "cast" in config.attackInfo) {
        obj.sq_SetCurrentAttackInfo(config.attackInfo.cast);
    }
    
    // 播放特效
    if ("effects" in config && config.effects.len() > 0) {
        createEffect(config.effects[0], obj.sq_GetPos());
    }
    
    // 播放音效
    if ("sounds" in config && config.sounds.len() > 0) {
        obj.sq_PlaySound(config.sounds[0]);
    }
    
    return true;
}
```

### 调试技巧

#### 1. 可视化调试
```squirrel
// 调试信息显示
function showDebugInfo(obj)
{
    if (!obj || !DEBUG_MODE) return;
    
    local pos = obj.sq_GetPos();
    local state = obj.sq_GetState();
    local hp = obj.sq_GetHP();
    local mp = obj.sq_GetMp();
    
    // 在角色头顶显示调试信息
    local debugText = "State: " + state + "\nHP: " + hp + "\nMP: " + mp;
    obj.sq_ShowDebugText(debugText, 1000);  // 显示1秒
    
    // 绘制攻击范围
    if (state >= STATE_ATTACK_START && state <= STATE_ATTACK_END) {
        drawAttackRange(obj);
    }
}

function drawAttackRange(obj)
{
    local pos = obj.sq_GetPos();
    local direction = obj.sq_GetDirection();
    local range = 200;  // 攻击范围
    
    // 绘制攻击范围矩形
    local startX = pos.x;
    local endX = pos.x + (range * direction);
    local startY = pos.y - 50;
    local endY = pos.y + 50;
    
    obj.sq_DrawDebugRect(startX, startY, endX, endY, sq_RGB(255, 0, 0));
}
```

#### 2. 性能分析
```squirrel
// 性能分析器
class PerformanceProfiler
{
    constructor()
    {
        this.timers = {};
        this.counters = {};
    }
    
    function startTimer(name)
    {
        this.timers[name] <- GetCurrentTimeMs();
    }
    
    function endTimer(name)
    {
        if (!(name in this.timers)) {
            DebugLog("WARNING", "Timer not found: " + name);
            return 0;
        }
        
        local duration = GetCurrentTimeMs() - this.timers[name];
        delete this.timers[name];
        
        DebugLog("PERF", name + " took " + duration + "ms");
        return duration;
    }
    
    function incrementCounter(name)
    {
        if (!(name in this.counters)) {
            this.counters[name] <- 0;
        }
        this.counters[name]++;
    }
    
    function getCounter(name)
    {
        return (name in this.counters) ? this.counters[name] : 0;
    }
    
    function printReport()
    {
        DebugLog("PERF", "=== Performance Report ===");
        foreach (name, count in this.counters) {
            DebugLog("PERF", name + ": " + count);
        }
        DebugLog("PERF", "=== End Report ===");
    }
}

// 全局性能分析器实例
local g_profiler = PerformanceProfiler();

// 使用示例
function profiledFunction(obj)
{
    g_profiler.startTimer("complexCalculation");
    
    // 执行复杂计算
    performComplexCalculation(obj);
    
    g_profiler.endTimer("complexCalculation");
    g_profiler.incrementCounter("functionCalls");
}
```

---

## 性能优化策略

### 内存优化

#### 1. 对象池管理
```squirrel
// 通用对象池
class ObjectPool
{
    constructor(createFunc, resetFunc, maxSize = 100)
    {
        this.createFunc = createFunc;
        this.resetFunc = resetFunc;
        this.maxSize = maxSize;
        this.pool = [];
        this.activeObjects = [];
    }
    
    function acquire()
    {
        local obj;
        
        if (this.pool.len() > 0) {
            obj = this.pool.pop();
        } else {
            obj = this.createFunc();
        }
        
        this.activeObjects.append(obj);
        return obj;
    }
    
    function release(obj)
    {
        // 从活跃列表中移除
        local index = this.activeObjects.find(obj);
        if (index != null) {
            this.activeObjects.remove(index);
        }
        
        // 重置对象状态
        this.resetFunc(obj);
        
        // 返回到池中（如果池未满）
        if (this.pool.len() < this.maxSize) {
            this.pool.append(obj);
        }
    }
    
    function cleanup()
    {
        this.pool.clear();
        this.activeObjects.clear();
    }
}

// 特效对象池
local g_effectPool = ObjectPool(
    function() {
        return {
            position = { x = 0, y = 0, z = 0 },
            animation = "",
            duration = 0,
            startTime = 0,
            isActive = false
        };
    },
    function(effect) {
        effect.position.x = 0;
        effect.position.y = 0;
        effect.position.z = 0;
        effect.animation = "";
        effect.duration = 0;
        effect.startTime = 0;
        effect.isActive = false;
    },
    50  // 最大50个特效对象
);

// 使用对象池创建特效
function createPooledEffect(animation, position, duration)
{
    local effect = g_effectPool.acquire();
    
    effect.position.x = position.x;
    effect.position.y = position.y;
    effect.position.z = position.z;
    effect.animation = animation;
    effect.duration = duration;
    effect.startTime = GetCurrentTime();
    effect.isActive = true;
    
    return effect;
}
```

#### 2. 缓存策略
```squirrel
// 计算结果缓存
class CalculationCache
{
    constructor(maxSize = 1000, ttl = 30000)  // 30秒TTL
    {
        this.cache = {};
        this.timestamps = {};
        this.maxSize = maxSize;
        this.ttl = ttl;
    }
    
    function get(key)
    {
        if (!(key in this.cache)) {
            return null;
        }
        
        // 检查是否过期
        local currentTime = GetCurrentTime();
        if (currentTime - this.timestamps[key] > this.ttl) {
            this.remove(key);
            return null;
        }
        
        return this.cache[key];
    }
    
    function set(key, value)
    {
        // 检查缓存大小
        if (this.cache.len() >= this.maxSize) {
            this.evictOldest();
        }
        
        this.cache[key] <- value;
        this.timestamps[key] <- GetCurrentTime();
    }
    
    function remove(key)
    {
        if (key in this.cache) {
            delete this.cache[key];
            delete this.timestamps[key];
        }
    }
    
    function evictOldest()
    {
        local oldestKey = null;
        local oldestTime = GetCurrentTime();
        
        foreach (key, timestamp in this.timestamps) {
            if (timestamp < oldestTime) {
                oldestTime = timestamp;
                oldestKey = key;
            }
        }
        
        if (oldestKey) {
            this.remove(oldestKey);
        }
    }
    
    function clear()
    {
        this.cache.clear();
        this.timestamps.clear();
    }
}

// 伤害计算缓存
local g_damageCache = CalculationCache(500, 10000);  // 500个条目，10秒TTL

function getCachedDamage(attackerStats, targetStats, skillMultiplier)
{
    // 生成缓存键
    local key = attackerStats.attack + "_" + attackerStats.str + "_" + 
                targetStats.defense + "_" + skillMultiplier;
    
    // 尝试从缓存获取
    local cachedResult = g_damageCache.get(key);
    if (cachedResult != null) {
        return cachedResult;
    }
    
    // 计算新值
    local damage = calculateComplexDamage(attackerStats, targetStats, skillMultiplier);
    
    // 存入缓存
    g_damageCache.set(key, damage);
    
    return damage;
}
```

### 执行优化

#### 1. 批处理操作
```squirrel
// 批处理管理器
class BatchProcessor
{
    constructor(batchSize = 10, processInterval = 16)  // 每16ms处理一批
    {
        this.batchSize = batchSize;
        this.processInterval = processInterval;
        this.pendingOperations = [];
        this.lastProcessTime = 0;
    }
    
    function addOperation(operation)
    {
        this.pendingOperations.append(operation);
    }
    
    function update()
    {
        local currentTime = GetCurrentTime();
        
        if (currentTime - this.lastProcessTime < this.processInterval) {
            return;  // 还未到处理时间
        }
        
        // 处理一批操作
        local processCount = min(this.batchSize, this.pendingOperations.len());
        
        for (local i = 0; i < processCount; i++) {
            local operation = this.pendingOperations[0];
            this.pendingOperations.remove(0);
            
            try {
                operation.execute();
            } catch (e) {
                DebugLog("ERROR", "Batch operation failed: " + e);
            }
        }
        
        this.lastProcessTime = currentTime;
    }
    
    function getPendingCount()
    {
        return this.pendingOperations.len();
    }
}

// 特效批处理器
local g_effectBatchProcessor = BatchProcessor(5, 16);

// 批量创建特效
function batchCreateEffect(animation, position)
{
    local operation = {
        animation = animation,
        position = position,
        execute = function() {
            createActualEffect(this.animation, this.position);
        }
    };
    
    g_effectBatchProcessor.addOperation(operation);
}
```

#### 2. 算法优化
```squirrel
// 优化的碰撞检测
function optimizedCollisionCheck(obj, targets)
{
    if (!obj || targets.len() == 0) return [];
    
    local objPos = obj.sq_GetPos();
    local objBounds = obj.sq_GetBoundingBox();
    local results = [];
    
    // 使用空间分割优化
    local nearbyTargets = getSpatiallyNearTargets(objPos, targets, 500);
    
    foreach (target in nearbyTargets) {
        // 快速距离检查
        local targetPos = target.sq_GetPos();
        local distance = abs(objPos.x - targetPos.x) + abs(objPos.y - targetPos.y);
        
        if (distance > 300) continue;  // 超出范围，跳过精确检测
        
        // 精确碰撞检测
        if (preciseCollisionCheck(objBounds, target.sq_GetBoundingBox())) {
            results.append(target);
        }
    }
    
    return results;
}

// 空间分割获取附近目标
function getSpatiallyNearTargets(position, allTargets, maxDistance)
{
    local nearbyTargets = [];
    
    foreach (target in allTargets) {
        local targetPos = target.sq_GetPos();
        local distance = abs(position.x - targetPos.x) + abs(position.y - targetPos.y);
        
        if (distance <= maxDistance) {
            nearbyTargets.append(target);
        }
    }
    
    return nearbyTargets;
}

// 优化的路径查找
function optimizedPathfinding(startPos, endPos, obstacles)
{
    // 简单的直线路径检查
    if (isDirectPathClear(startPos, endPos, obstacles)) {