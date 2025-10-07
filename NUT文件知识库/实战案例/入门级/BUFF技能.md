# BUFF技能实战案例

## 📖 案例概述

本案例演示如何创建一个完整的BUFF技能，包含状态增益、持续时间管理、视觉效果、状态叠加等核心功能。BUFF技能是游戏中非常重要的技能类型，掌握BUFF技能的实现对理解NUT脚本的状态管理和AP（Appendage）系统至关重要。

## 🎯 学习目标

- 掌握AP（Appendage）系统的使用
- 学会BUFF状态的创建和管理
- 理解持续时间和刷新机制
- 掌握状态叠加和互斥逻辑
- 学会BUFF的视觉效果实现

## 📋 技能需求

**技能名称：** 力量祝福  
**技能类型：** 自身BUFF技能  
**BUFF效果：** 增加50%物理攻击力  
**持续时间：** 30秒  
**施法时间：** 0.5秒  
**冷却时间：** 60秒  
**特殊效果：** 可叠加3层，每层增加50%攻击力  

## 🔧 完整实现

### 技能主文件 (skill_power_blessing.nut)

```nut
// =====================================
// 力量祝福BUFF技能 - 完整实现
// 作者：NUT脚本教程
// 版本：1.0
// =====================================

// 技能配置常量
const SKILL_ID = 2001;                    // 技能ID
const BUFF_ID = 2001;                     // BUFF状态ID
const CAST_TIME = 500;                    // 施法时间(毫秒)
const BUFF_DURATION = 30000;              // BUFF持续时间(毫秒)
const COOLDOWN_TIME = 60000;              // 冷却时间(毫秒)
const ATTACK_BONUS_PER_STACK = 0.5;       // 每层攻击力加成(50%)
const MAX_STACK = 3;                      // 最大叠加层数
const MP_COST = 30;                       // MP消耗

// =====================================
// 技能检查函数
// =====================================
function checkExecutableSkill_PowerBlessing(obj)
{
    if (!obj || obj.isObjectType(OBJECTTYPE_ACTIVE) == false)
        return false;
    
    // 检查角色状态
    if (obj.getState() == STATE_STUN || 
        obj.getState() == STATE_FLOAT || 
        obj.getState() == STATE_DOWN)
        return false;
    
    // 检查MP消耗
    if (obj.getMp() < MP_COST)
        return false;
    
    // 检查技能冷却
    if (obj.isSkillCoolTime(SKILL_ID) == true)
        return false;
    
    return true;
}

// =====================================
// 技能释放函数
// =====================================
function onSetSkill_PowerBlessing(obj, skillIndex, datas)
{
    if (!obj) return;
    
    // 消耗MP
    obj.addMp(-MP_COST);
    
    // 设置技能冷却
    obj.setSkillCoolTime(SKILL_ID, COOLDOWN_TIME);
    
    // 进入施法状态
    obj.setState(STATE_SKILL);
    
    // 播放施法动画
    obj.setCurrentAnimation(0);
    
    // 创建施法数据
    local castData = {
        startTime = getTimer(),
        isCompleted = false
    };
    
    obj.setData("PowerBlessing_Cast", castData);
    
    // 播放施法音效
    obj.playSound("buff_cast.wav");
    
    // 创建施法特效
    createCastEffect(obj);
}

// =====================================
// 技能状态更新函数
// =====================================
function onSetState_PowerBlessing(obj, state, datas, isResetTimer)
{
    if (state != STATE_SKILL) return;
    
    local castData = obj.getData("PowerBlessing_Cast");
    if (!castData) return;
    
    local currentTime = getTimer();
    local elapsedTime = currentTime - castData.startTime;
    
    // 检查是否完成施法
    if (elapsedTime >= CAST_TIME && !castData.isCompleted)
    {
        // 施法完成，应用BUFF
        applyPowerBlessingBuff(obj);
        castData.isCompleted = true;
        
        // 结束施法状态
        obj.setState(STATE_NORMAL);
        obj.setData("PowerBlessing_Cast", null);
    }
}

// =====================================
// 应用力量祝福BUFF
// =====================================
function applyPowerBlessingBuff(obj)
{
    // 检查是否已有相同BUFF
    local existingBuff = obj.getAppendage(BUFF_ID);
    
    if (existingBuff)
    {
        // 已有BUFF，处理叠加逻辑
        handleBuffStack(obj, existingBuff);
    }
    else
    {
        // 创建新的BUFF
        createNewBuff(obj);
    }
    
    // 播放BUFF获得音效
    obj.playSound("buff_gain.wav");
    
    // 显示BUFF获得提示
    obj.showMessage("获得力量祝福！", MESSAGE_TYPE_BUFF);
}

// =====================================
// 处理BUFF叠加
// =====================================
function handleBuffStack(obj, existingBuff)
{
    // 获取当前层数
    local currentStack = existingBuff.getData("stack") || 1;
    
    if (currentStack < MAX_STACK)
    {
        // 可以叠加，增加层数
        currentStack++;
        existingBuff.setData("stack", currentStack);
        
        // 刷新持续时间
        existingBuff.setTimeEvent(0, BUFF_DURATION, 1, false);
        
        // 更新攻击力加成
        updateAttackBonus(obj, existingBuff, currentStack);
        
        // 更新视觉效果
        updateBuffEffect(obj, existingBuff, currentStack);
        
        obj.showMessage("力量祝福叠加至" + currentStack + "层！", MESSAGE_TYPE_BUFF);
    }
    else
    {
        // 已达最大层数，只刷新持续时间
        existingBuff.setTimeEvent(0, BUFF_DURATION, 1, false);
        obj.showMessage("力量祝福持续时间刷新！", MESSAGE_TYPE_BUFF);
    }
}

// =====================================
// 创建新的BUFF
// =====================================
function createNewBuff(obj)
{
    // 使用AP系统创建BUFF
    local buff = sq_AppendAppendage(obj, obj, BUFF_ID, true, 
                                   "character/common/appendage/power_blessing.nut", 
                                   BUFF_DURATION);
    
    if (buff)
    {
        // 设置初始层数
        buff.setData("stack", 1);
        
        // 设置BUFF拥有者
        buff.setData("owner", obj);
        
        // 应用攻击力加成
        updateAttackBonus(obj, buff, 1);
        
        // 创建视觉效果
        createBuffEffect(obj, buff, 1);
        
        obj.showMessage("获得力量祝福（1层）！", MESSAGE_TYPE_BUFF);
    }
}

// =====================================
// 更新攻击力加成
// =====================================
function updateAttackBonus(obj, buff, stackCount)
{
    // 计算总加成
    local totalBonus = ATTACK_BONUS_PER_STACK * stackCount;
    
    // 移除旧的攻击力加成（如果有）
    local oldBonus = buff.getData("attackBonus") || 0;
    if (oldBonus > 0)
    {
        obj.addPhysicalAttackRate(-oldBonus);
    }
    
    // 应用新的攻击力加成
    obj.addPhysicalAttackRate(totalBonus);
    
    // 保存当前加成值
    buff.setData("attackBonus", totalBonus);
    
    // 更新BUFF描述
    local description = "物理攻击力增加" + (totalBonus * 100).tointeger() + "%";
    buff.setData("description", description);
}

// =====================================
// 创建BUFF视觉效果
// =====================================
function createBuffEffect(obj, buff, stackCount)
{
    // 创建光环特效
    local auraEffect = sq_CreateDrawOnlyObject(obj, "character/common/effect/power_aura.ani", 
                                              LAYER_BOTTOM, true);
    if (auraEffect)
    {
        // 绑定到角色
        auraEffect.setParent(obj, true);
        auraEffect.setXPos(0);
        auraEffect.setYPos(0);
        auraEffect.setZPos(0);
        
        // 根据层数调整特效强度
        local scale = 1.0 + (stackCount - 1) * 0.2;  // 每层增加20%大小
        auraEffect.setScale(scale, scale);
        
        // 设置特效颜色（根据层数变化）
        local color = getStackColor(stackCount);
        auraEffect.setColor(color.r, color.g, color.b);
        
        // 保存特效引用
        buff.setData("auraEffect", auraEffect);
    }
    
    // 创建头顶图标
    createBuffIcon(obj, buff, stackCount);
}

// =====================================
// 更新BUFF视觉效果
// =====================================
function updateBuffEffect(obj, buff, stackCount)
{
    // 更新光环特效
    local auraEffect = buff.getData("auraEffect");
    if (auraEffect)
    {
        local scale = 1.0 + (stackCount - 1) * 0.2;
        auraEffect.setScale(scale, scale);
        
        local color = getStackColor(stackCount);
        auraEffect.setColor(color.r, color.g, color.b);
    }
    
    // 更新头顶图标
    updateBuffIcon(obj, buff, stackCount);
}

// =====================================
// 获取层数对应的颜色
// =====================================
function getStackColor(stackCount)
{
    switch (stackCount)
    {
        case 1:
            return { r = 255, g = 255, b = 255 };  // 白色
        case 2:
            return { r = 255, g = 255, b = 0 };    // 黄色
        case 3:
            return { r = 255, g = 0, b = 0 };      // 红色
        default:
            return { r = 255, g = 255, b = 255 };
    }
}

// =====================================
// 创建BUFF图标
// =====================================
function createBuffIcon(obj, buff, stackCount)
{
    // 创建头顶BUFF图标
    local icon = sq_CreateDrawOnlyObject(obj, "ui/buff_icons/power_blessing.ani", 
                                        LAYER_TOP, true);
    if (icon)
    {
        // 绑定到角色头顶
        icon.setParent(obj, true);
        icon.setXPos(0);
        icon.setYPos(-80);  // 头顶位置
        icon.setZPos(0);
        
        // 设置图标大小
        icon.setScale(0.8, 0.8);
        
        // 保存图标引用
        buff.setData("buffIcon", icon);
        
        // 如果有多层，显示层数文字
        if (stackCount > 1)
        {
            createStackText(obj, buff, stackCount);
        }
    }
}

// =====================================
// 更新BUFF图标
// =====================================
function updateBuffIcon(obj, buff, stackCount)
{
    // 更新层数文字
    if (stackCount > 1)
    {
        createStackText(obj, buff, stackCount);
    }
    else
    {
        // 移除层数文字
        local stackText = buff.getData("stackText");
        if (stackText)
        {
            stackText.destroy();
            buff.setData("stackText", null);
        }
    }
}

// =====================================
// 创建层数文字
// =====================================
function createStackText(obj, buff, stackCount)
{
    // 移除旧的层数文字
    local oldText = buff.getData("stackText");
    if (oldText)
    {
        oldText.destroy();
    }
    
    // 创建新的层数文字
    local stackText = sq_CreateDrawOnlyObject(obj, "ui/common/number.ani", 
                                             LAYER_TOP, true);
    if (stackText)
    {
        // 绑定到BUFF图标位置
        stackText.setParent(obj, true);
        stackText.setXPos(15);   // 图标右下角
        stackText.setYPos(-65);
        stackText.setZPos(1);
        
        // 设置数字
        stackText.setCurrentFrame(stackCount);
        stackText.setScale(0.6, 0.6);
        
        // 保存引用
        buff.setData("stackText", stackText);
    }
}

// =====================================
// 创建施法特效
// =====================================
function createCastEffect(obj)
{
    // 创建施法光环
    local castEffect = sq_CreateDrawOnlyObject(obj, "character/common/effect/cast_circle.ani", 
                                              LAYER_BOTTOM, true);
    if (castEffect)
    {
        castEffect.setParent(obj, true);
        castEffect.setXPos(0);
        castEffect.setYPos(0);
        castEffect.setZPos(0);
        
        // 设置施法特效持续时间
        castEffect.setTimeEvent(0, CAST_TIME, 1, false);
    }
    
    // 创建施法粒子效果
    local particles = sq_CreateParticle(obj, "effect/buff_cast.ptl");
    if (particles)
    {
        particles.setXPos(obj.getXPos());
        particles.setYPos(obj.getYPos());
        particles.setZPos(obj.getZPos());
    }
}

// =====================================
// 技能中断处理
// =====================================
function onEndCurrentAni_PowerBlessing(obj)
{
    // 清理施法数据
    local castData = obj.getData("PowerBlessing_Cast");
    if (castData)
    {
        obj.setData("PowerBlessing_Cast", null);
        obj.setState(STATE_NORMAL);
    }
}
```

### BUFF AP文件 (power_blessing.nut)

```nut
// =====================================
// 力量祝福BUFF - AP实现
// 作者：NUT脚本教程
// 版本：1.0
// =====================================

// =====================================
// AP开始时调用
// =====================================
function onStart_PowerBlessing(appendage)
{
    if (!appendage) return;
    
    local obj = appendage.getParent();
    if (!obj) return;
    
    // 初始化BUFF数据
    appendage.setData("startTime", getTimer());
    appendage.setData("lastUpdateTime", getTimer());
    
    // 播放BUFF开始特效
    playBuffStartEffect(obj);
    
    // 添加到BUFF列表（用于UI显示）
    addToBuffList(obj, appendage);
}

// =====================================
// AP每帧更新
// =====================================
function proc_PowerBlessing(appendage)
{
    if (!appendage) return;
    
    local obj = appendage.getParent();
    if (!obj) return;
    
    local currentTime = getTimer();
    local lastUpdateTime = appendage.getData("lastUpdateTime") || currentTime;
    
    // 每秒更新一次（减少性能消耗）
    if (currentTime - lastUpdateTime >= 1000)
    {
        // 更新BUFF显示
        updateBuffDisplay(obj, appendage);
        
        // 检查BUFF是否应该结束
        checkBuffExpiration(obj, appendage);
        
        appendage.setData("lastUpdateTime", currentTime);
    }
}

// =====================================
// AP结束时调用
// =====================================
function onEnd_PowerBlessing(appendage)
{
    if (!appendage) return;
    
    local obj = appendage.getParent();
    if (!obj) return;
    
    // 移除攻击力加成
    local attackBonus = appendage.getData("attackBonus") || 0;
    if (attackBonus > 0)
    {
        obj.addPhysicalAttackRate(-attackBonus);
    }
    
    // 清理视觉效果
    cleanupBuffEffects(appendage);
    
    // 从BUFF列表移除
    removeFromBuffList(obj, appendage);
    
    // 播放BUFF结束特效
    playBuffEndEffect(obj);
    
    // 显示BUFF结束消息
    obj.showMessage("力量祝福效果结束", MESSAGE_TYPE_BUFF);
    
    // 播放BUFF结束音效
    obj.playSound("buff_end.wav");
}

// =====================================
// 角色受到伤害时调用
// =====================================
function onApplyHpDamage_PowerBlessing(appendage, attacker, damage, damageType)
{
    // 力量祝福不影响受伤逻辑，直接返回原伤害
    return damage;
}

// =====================================
// 角色攻击时调用
// =====================================
function onAttack_PowerBlessing(appendage, attacker, target, damage)
{
    // 攻击力加成已经在属性中处理，这里可以添加额外效果
    
    // 例如：攻击时有概率触发特殊效果
    if (rand() % 100 < 10)  // 10%概率
    {
        // 触发额外伤害
        local bonusDamage = damage * 0.2;  // 额外20%伤害
        target.addHp(-bonusDamage);
        
        // 显示额外伤害
        target.showDamage(bonusDamage, DAMAGE_TYPE_BONUS);
        
        // 播放特殊效果
        playBonusAttackEffect(target);
    }
}

// =====================================
// 播放BUFF开始特效
// =====================================
function playBuffStartEffect(obj)
{
    // 创建爆发特效
    local burstEffect = sq_CreateDrawOnlyObject(obj, "character/common/effect/power_burst.ani", 
                                               LAYER_TOP, true);
    if (burstEffect)
    {
        burstEffect.setParent(obj, true);
        burstEffect.setXPos(0);
        burstEffect.setYPos(0);
        burstEffect.setZPos(0);
        burstEffect.setTimeEvent(0, 1000, 1, false);  // 1秒后消失
    }
    
    // 屏幕闪光效果
    sq_FlashScreen(obj, 200, 255, 255, 255, 100);  // 白色闪光
}

// =====================================
// 更新BUFF显示
// =====================================
function updateBuffDisplay(obj, appendage)
{
    // 更新剩余时间显示
    local startTime = appendage.getData("startTime");
    local currentTime = getTimer();
    local elapsedTime = currentTime - startTime;
    local remainingTime = BUFF_DURATION - elapsedTime;
    
    if (remainingTime > 0)
    {
        // 更新UI显示的剩余时间
        local seconds = (remainingTime / 1000).tointeger();
        appendage.setData("remainingSeconds", seconds);
        
        // 如果剩余时间少于5秒，添加闪烁效果
        if (seconds <= 5)
        {
            addBlinkingEffect(obj, appendage);
        }
    }
}

// =====================================
// 检查BUFF过期
// =====================================
function checkBuffExpiration(obj, appendage)
{
    local startTime = appendage.getData("startTime");
    local currentTime = getTimer();
    local elapsedTime = currentTime - startTime;
    
    // 如果超过持续时间，手动结束BUFF
    if (elapsedTime >= BUFF_DURATION)
    {
        appendage.destroy();
    }
}

// =====================================
// 清理BUFF效果
// =====================================
function cleanupBuffEffects(appendage)
{
    // 清理光环特效
    local auraEffect = appendage.getData("auraEffect");
    if (auraEffect)
    {
        auraEffect.destroy();
    }
    
    // 清理BUFF图标
    local buffIcon = appendage.getData("buffIcon");
    if (buffIcon)
    {
        buffIcon.destroy();
    }
    
    // 清理层数文字
    local stackText = appendage.getData("stackText");
    if (stackText)
    {
        stackText.destroy();
    }
    
    // 清理闪烁效果
    local blinkEffect = appendage.getData("blinkEffect");
    if (blinkEffect)
    {
        blinkEffect.destroy();
    }
}

// =====================================
// 添加到BUFF列表
// =====================================
function addToBuffList(obj, appendage)
{
    // 获取角色的BUFF列表
    local buffList = obj.getData("BuffList") || [];
    
    // 添加当前BUFF
    buffList.append({
        id = BUFF_ID,
        appendage = appendage,
        name = "力量祝福",
        description = appendage.getData("description") || "增加物理攻击力"
    });
    
    // 保存更新后的列表
    obj.setData("BuffList", buffList);
}

// =====================================
// 从BUFF列表移除
// =====================================
function removeFromBuffList(obj, appendage)
{
    local buffList = obj.getData("BuffList") || [];
    
    // 查找并移除对应的BUFF
    for (local i = 0; i < buffList.len(); i++)
    {
        if (buffList[i].appendage == appendage)
        {
            buffList.remove(i);
            break;
        }
    }
    
    // 保存更新后的列表
    obj.setData("BuffList", buffList);
}

// =====================================
// 播放BUFF结束特效
// =====================================
function playBuffEndEffect(obj)
{
    // 创建消散特效
    local fadeEffect = sq_CreateDrawOnlyObject(obj, "character/common/effect/power_fade.ani", 
                                              LAYER_TOP, true);
    if (fadeEffect)
    {
        fadeEffect.setParent(obj, true);
        fadeEffect.setXPos(0);
        fadeEffect.setYPos(0);
        fadeEffect.setZPos(0);
        fadeEffect.setTimeEvent(0, 800, 1, false);
    }
}

// =====================================
// 添加闪烁效果
// =====================================
function addBlinkingEffect(obj, appendage)
{
    // 检查是否已有闪烁效果
    local blinkEffect = appendage.getData("blinkEffect");
    if (blinkEffect) return;
    
    // 创建闪烁特效
    blinkEffect = sq_CreateDrawOnlyObject(obj, "character/common/effect/blink.ani", 
                                         LAYER_TOP, true);
    if (blinkEffect)
    {
        blinkEffect.setParent(obj, true);
        blinkEffect.setXPos(0);
        blinkEffect.setYPos(-80);
        blinkEffect.setZPos(1);
        
        // 保存引用
        appendage.setData("blinkEffect", blinkEffect);
    }
}

// =====================================
// 播放额外攻击特效
// =====================================
function playBonusAttackEffect(target)
{
    // 创建额外伤害特效
    local bonusEffect = sq_CreateDrawOnlyObject(target, "character/common/effect/bonus_damage.ani", 
                                               LAYER_TOP, true);
    if (bonusEffect)
    {
        bonusEffect.setXPos(target.getXPos());
        bonusEffect.setYPos(target.getYPos() + 30);
        bonusEffect.setZPos(target.getZPos());
        bonusEffect.setTimeEvent(0, 500, 1, false);
    }
    
    // 播放特殊音效
    target.playSound("bonus_hit.wav");
}
```

## 📝 代码详解

### 1. 技能主文件结构
- **技能检查和释放：** 标准的技能释放流程
- **BUFF应用逻辑：** 处理新建和叠加的复杂逻辑
- **视觉效果管理：** 创建和更新各种特效

### 2. AP文件结构
- **生命周期管理：** `onStart`、`proc`、`onEnd` 三个核心函数
- **属性修改：** 在开始时应用，结束时移除
- **事件响应：** 响应攻击、受伤等事件

### 3. 叠加机制
```nut
function handleBuffStack(obj, existingBuff)
```
- 检查当前层数
- 判断是否可以叠加
- 更新属性和视觉效果
- 刷新持续时间

## 🎮 使用方法

### 1. 文件配置
- 主技能文件：`skill_power_blessing.nut`
- AP文件：`power_blessing.nut`（放在appendage目录下）

### 2. 技能配置
在 `.skl` 文件中添加：
```
[skill data]
	`skill_power_blessing.nut`
[/skill data]
```

### 3. 动画和特效
准备以下资源文件：
- 施法动画
- BUFF光环特效
- BUFF图标
- 各种粒子效果

## 🔍 常见问题

### Q1: BUFF无法叠加？
**A:** 检查以下几点：
- `BUFF_ID` 是否正确设置
- `getAppendage` 函数是否正确调用
- 叠加逻辑是否正确实现

### Q2: BUFF效果不生效？
**A:** 检查以下几点：
- AP文件路径是否正确
- `onStart` 函数是否正确实现
- 属性修改是否正确应用

### Q3: BUFF不会自动结束？
**A:** 检查以下几点：
- 持续时间设置是否正确
- `onEnd` 函数是否正确实现
- 时间事件是否正确设置

### Q4: 视觉效果异常？
**A:** 检查以下几点：
- 特效文件是否存在
- 绑定逻辑是否正确
- 清理逻辑是否完整

## 🚀 扩展建议

### 1. 添加BUFF互斥
```nut
// 检查互斥BUFF
if (obj.getAppendage(CONFLICTING_BUFF_ID))
{
    obj.removeAppendage(CONFLICTING_BUFF_ID);
}
```

### 2. 添加BUFF传播
```nut
// 传播给队友
local teammates = sq_GetTeammates(obj, 300);  // 300像素范围内队友
foreach (teammate in teammates)
{
    applyPowerBlessingBuff(teammate);
}
```

### 3. 添加BUFF升级
```nut
// 根据技能等级调整效果
local skillLevel = obj.getSkillLevel(SKILL_ID);
local bonusPerStack = ATTACK_BONUS_PER_STACK * (1 + skillLevel * 0.1);
```

### 4. 添加BUFF同步
```nut
// 同步BUFF状态到客户端
obj.sendBuffUpdate(BUFF_ID, stackCount, remainingTime);
```

## 📚 相关文档

- [标签参考.md](../../标签参考.md) - AP系统详细说明
- [高级示例/函数合并技术.md](../../高级示例/函数合并技术.md) - BUFF冲突处理
- [基础攻击技能.md](./基础攻击技能.md) - 基础技能实现
- [多段攻击技能.md](../进阶级/多段攻击技能.md) - 复杂技能状态管理

---

*BUFF技能是NUT脚本中最复杂的技能类型之一，涉及状态管理、时间控制、视觉效果等多个方面。掌握BUFF技能的实现对于理解整个NUT脚本系统非常重要。*