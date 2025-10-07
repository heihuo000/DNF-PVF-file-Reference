// ===================================================================
// 被动技能模板 - NUT脚本示例
// 功能：演示被动技能的实现方式
// 适用：学习被动效果和触发机制的设计
// ===================================================================

// 被动技能不需要状态定义，通过事件触发实现

// 被动技能常量定义
PASSIVE_SKILL_TRIGGER_RATE <- 15        // 触发概率（百分比）
PASSIVE_SKILL_COOLDOWN <- 3000          // 内置冷却时间（毫秒）

// 被动技能变量定义
VAR_PASSIVE_LAST_TRIGGER_TIME <- 0      // 上次触发时间
VAR_PASSIVE_TRIGGER_COUNT <- 1          // 触发次数统计

// ===================================================================
// 1. 被动技能学习检查
// ===================================================================
function checkLearnSkill_PassiveSkill(obj)
{
    if(!obj) return false;
    
    // 检查前置技能
    if(obj.sq_GetSkillLevel(SKILL_PREREQUISITE) < 5) return false;
    
    // 检查角色等级
    if(obj.sq_GetLevel() < 20) return false;
    
    return true;
}

// ===================================================================
// 2. 攻击时触发的被动效果
// ===================================================================
function onAttack_PassiveSkill(obj, damager, boundingBox, isStuck)
{
    if(!obj || !damager) return;
    
    // 检查是否学习了被动技能
    local passiveLevel = obj.sq_GetSkillLevel(SKILL_PASSIVE_SKILL);
    if(passiveLevel <= 0) return;
    
    // 检查冷却时间
    local currentTime = obj.sq_GetCurrentTime();
    local lastTriggerTime = obj.sq_GetIntData(SKILL_PASSIVE_SKILL, VAR_PASSIVE_LAST_TRIGGER_TIME);
    
    if(currentTime - lastTriggerTime < PASSIVE_SKILL_COOLDOWN) return;
    
    // 计算触发概率
    local triggerRate = PASSIVE_SKILL_TRIGGER_RATE + (passiveLevel * 2);
    local randomValue = obj.sq_GetRandomInt(0, 100);
    
    if(randomValue < triggerRate)
    {
        // 触发被动效果
        triggerPassiveEffect(obj, damager, passiveLevel);
        
        // 更新触发时间
        obj.sq_SetIntData(SKILL_PASSIVE_SKILL, VAR_PASSIVE_LAST_TRIGGER_TIME, currentTime);
        
        // 更新触发次数
        local triggerCount = obj.sq_GetIntData(SKILL_PASSIVE_SKILL, VAR_PASSIVE_TRIGGER_COUNT);
        obj.sq_SetIntData(SKILL_PASSIVE_SKILL, VAR_PASSIVE_TRIGGER_COUNT, triggerCount + 1);
    }
}

// ===================================================================
// 3. 被动效果触发函数
// ===================================================================
function triggerPassiveEffect(obj, damager, passiveLevel)
{
    if(!obj || !damager) return;
    
    // 效果1：增加伤害
    local damageBonus = 20 + (passiveLevel * 5);  // 基础20%，每级+5%
    local currentDamage = damager.sq_GetDamageRate();
    damager.sq_SetDamageRate(currentDamage + damageBonus);
    
    // 效果2：添加元素属性
    damager.sq_SetAttackInfo(SAI_ELEMENT, ELEMENT_FIRE);
    damager.sq_SetAttackInfo(SAI_ELEMENT_DAMAGE, 50 + (passiveLevel * 10));
    
    // 效果3：添加状态效果
    damager.sq_SetChangeStatusIntoAttackInfo(ACTIVESTATUS_BURN, 
        0,                      // 异常等级
        2000 + (passiveLevel * 500),  // 持续时间
        1000,                   // 间隔时间
        0);                     // 重复次数
    
    // 播放触发特效
    createPassiveEffect(obj, passiveLevel);
    
    // 播放触发音效
    obj.sq_PlaySound(`PASSIVE_TRIGGER`);
}

// ===================================================================
// 4. 受击时触发的被动效果
// ===================================================================
function onDamage_PassiveSkill(obj, damager, boundingBox, damage)
{
    if(!obj || !damager) return;
    
    // 检查是否学习了被动技能
    local passiveLevel = obj.sq_GetSkillLevel(SKILL_PASSIVE_SKILL);
    if(passiveLevel <= 0) return;
    
    // 检查伤害阈值
    local damageThreshold = obj.sq_GetMaxHp() * 0.1;  // 最大HP的10%
    if(damage < damageThreshold) return;
    
    // 触发防御性被动效果
    triggerDefensivePassive(obj, passiveLevel);
}

// ===================================================================
// 5. 防御性被动效果
// ===================================================================
function triggerDefensivePassive(obj, passiveLevel)
{
    if(!obj) return;
    
    // 效果1：临时增加防御力
    local defenseBonus = 100 + (passiveLevel * 20);
    obj.sq_AddActiveStatus(ACTIVESTATUS_DEFENSE_UP, obj, obj, 
        defenseBonus, 5000, 0, 0);  // 持续5秒
    
    // 效果2：回复少量HP
    local healAmount = obj.sq_GetMaxHp() * (0.05 + passiveLevel * 0.01);
    obj.sq_AddHp(healAmount);
    
    // 效果3：短暂无敌时间
    obj.sq_AddActiveStatus(ACTIVESTATUS_INVINCIBLE, obj, obj, 
        1, 500, 0, 0);  // 0.5秒无敌
    
    // 播放防御特效
    obj.sq_StartWrite();
    obj.sq_WriteDword(passiveLevel);
    obj.sq_SendCreatePassiveObjectPacket(24215, 0, 0, 0, 0);
    
    obj.sq_PlaySound(`PASSIVE_DEFENSE`);
}

// ===================================================================
// 6. 技能升级时的被动效果增强
// ===================================================================
function onSkillLevelUp_PassiveSkill(obj, skillIndex, newLevel)
{
    if(!obj) return;
    if(skillIndex != SKILL_PASSIVE_SKILL) return;
    
    // 永久属性增益（每级提升）
    applyPermanentBonus(obj, newLevel);
    
    // 播放升级特效
    obj.sq_PlaySound(`PASSIVE_LEVELUP`);
}

// ===================================================================
// 7. 永久属性增益应用
// ===================================================================
function applyPermanentBonus(obj, skillLevel)
{
    if(!obj) return;
    
    // 移除之前等级的增益
    if(skillLevel > 1)
    {
        removePermanentBonus(obj, skillLevel - 1);
    }
    
    // 应用新等级的增益
    local strBonus = skillLevel * 5;        // 每级+5力量
    local intBonus = skillLevel * 5;        // 每级+5智力
    local hpBonus = skillLevel * 50;        // 每级+50HP
    local mpBonus = skillLevel * 30;        // 每级+30MP
    
    obj.sq_AddBonusStr(strBonus);
    obj.sq_AddBonusInt(intBonus);
    obj.sq_AddBonusMaxHp(hpBonus);
    obj.sq_AddBonusMaxMp(mpBonus);
    
    // 存储当前增益值（用于后续移除）
    obj.sq_SetIntData(SKILL_PASSIVE_SKILL, 10, strBonus);
    obj.sq_SetIntData(SKILL_PASSIVE_SKILL, 11, intBonus);
    obj.sq_SetIntData(SKILL_PASSIVE_SKILL, 12, hpBonus);
    obj.sq_SetIntData(SKILL_PASSIVE_SKILL, 13, mpBonus);
}

// ===================================================================
// 8. 移除永久属性增益
// ===================================================================
function removePermanentBonus(obj, skillLevel)
{
    if(!obj) return;
    
    // 获取之前的增益值
    local oldStrBonus = obj.sq_GetIntData(SKILL_PASSIVE_SKILL, 10);
    local oldIntBonus = obj.sq_GetIntData(SKILL_PASSIVE_SKILL, 11);
    local oldHpBonus = obj.sq_GetIntData(SKILL_PASSIVE_SKILL, 12);
    local oldMpBonus = obj.sq_GetIntData(SKILL_PASSIVE_SKILL, 13);
    
    // 移除增益
    obj.sq_AddBonusStr(-oldStrBonus);
    obj.sq_AddBonusInt(-oldIntBonus);
    obj.sq_AddBonusMaxHp(-oldHpBonus);
    obj.sq_AddBonusMaxMp(-oldMpBonus);
}

// ===================================================================
// 9. 被动特效创建函数
// ===================================================================
function createPassiveEffect(obj, passiveLevel)
{
    if(!obj) return;
    
    // 创建触发特效
    obj.sq_StartWrite();
    obj.sq_WriteDword(passiveLevel);
    obj.sq_WriteDword(obj.sq_GetDirection());
    obj.sq_SendCreatePassiveObjectPacket(24216, 0, 50, 0, 0);
    
    // 创建环绕光效
    obj.sq_StartWrite();
    obj.sq_WriteDword(passiveLevel);
    obj.sq_SendCreatePassiveObjectPacket(24217, 0, 0, 0, 0);
}

// ===================================================================
// 10. 被动技能状态查询
// ===================================================================
function getPassiveSkillStatus(obj)
{
    if(!obj) return null;
    
    local passiveLevel = obj.sq_GetSkillLevel(SKILL_PASSIVE_SKILL);
    if(passiveLevel <= 0) return null;
    
    local status = {};
    status.level <- passiveLevel;
    status.triggerRate <- PASSIVE_SKILL_TRIGGER_RATE + (passiveLevel * 2);
    status.triggerCount <- obj.sq_GetIntData(SKILL_PASSIVE_SKILL, VAR_PASSIVE_TRIGGER_COUNT);
    status.lastTriggerTime <- obj.sq_GetIntData(SKILL_PASSIVE_SKILL, VAR_PASSIVE_LAST_TRIGGER_TIME);
    
    return status;
}

// ===================================================================
// 11. 组合被动效果（与其他技能联动）
// ===================================================================
function checkPassiveCombo(obj, skillIndex)
{
    if(!obj) return;
    
    local passiveLevel = obj.sq_GetSkillLevel(SKILL_PASSIVE_SKILL);
    if(passiveLevel <= 0) return;
    
    // 检查特定技能的联动效果
    switch(skillIndex)
    {
        case SKILL_FIREBALL:
            // 火球术联动：增加燃烧概率
            enhanceFireSkill(obj, passiveLevel);
            break;
            
        case SKILL_ICE_SPEAR:
            // 冰矛术联动：增加冰冻概率
            enhanceIceSkill(obj, passiveLevel);
            break;
    }
}

// ===================================================================
// 12. 技能说明生成
// ===================================================================
function getPassiveSkillDescription(skillLevel)
{
    local triggerRate = PASSIVE_SKILL_TRIGGER_RATE + (skillLevel * 2);
    local damageBonus = 20 + (skillLevel * 5);
    local strBonus = skillLevel * 5;
    
    return `攻击时有 ` + triggerRate + `% 概率触发，增加 ` + damageBonus + `% 伤害并附加火焰效果。\n` +
           `永久增加力量/智力 ` + strBonus + ` 点。`;
}

// ===================================================================
// 使用说明：
// 1. 被动技能通过事件触发实现，不需要主动释放
// 2. 支持攻击触发和受击触发两种模式
// 3. 包含永久属性增益和临时效果触发
// 4. 支持技能联动和组合效果
// 5. 提供完整的冷却和概率控制机制
// 
// 注意事项：
// 1. 被动技能的平衡性需要仔细调整
// 2. 触发概率和冷却时间要合理设置
// 3. 永久增益在技能重置时需要正确处理
// 4. 特效和音效不要过于频繁，避免影响游戏体验
// ===================================================================