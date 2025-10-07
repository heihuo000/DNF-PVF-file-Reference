// ===================================================================
// 函数合并示例 - NUT脚本教程
// 功能：演示如何正确合并多个NUT函数
// 适用：学习函数合并的标准流程和注意事项
// ===================================================================

// ===================================================================
// 1. setState函数合并示例
// ===================================================================

// 原始函数1：技能A的setState
function onSetState_SkillA(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    if(isResetTimer)
    {
        obj.sq_SetCurrentAnimation(CUSTOM_ANI_SKILL_A);
        obj.sq_StopMove();
        obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
        obj.sq_SetCurrentAttackInfo(0);
    }
}

// 原始函数2：技能B的setState
function onSetState_SkillB(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    if(isResetTimer)
    {
        obj.sq_SetCurrentAnimation(CUSTOM_ANI_SKILL_B);
        obj.sq_StopMove();
        obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
        obj.sq_SetCurrentAttackInfo(0);
    }
}

// 合并后的函数
function onSetState_CombinedSkills(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    // 根据状态分发到不同的处理函数
    switch(state)
    {
        case STATE_SKILL_A:
            onSetState_SkillA(obj, state, datas, isResetTimer);
            break;
            
        case STATE_SKILL_B:
            onSetState_SkillB(obj, state, datas, isResetTimer);
            break;
            
        // 可以继续添加更多技能状态
        case STATE_SKILL_C:
            onSetState_SkillC(obj, state, datas, isResetTimer);
            break;
    }
}

// ===================================================================
// 2. procAppend函数合并示例
// ===================================================================

// 原始函数1：装备A的procAppend
function procAppend_EquipmentA(obj)
{
    if(!obj) return;
    
    // 增加攻击力
    obj.sq_AddBonusPhysicalAttack(100);
    obj.sq_AddBonusMagicalAttack(100);
    
    // 增加暴击率
    obj.sq_AddBonusCriticalRate(5);
}

// 原始函数2：装备B的procAppend
function procAppend_EquipmentB(obj)
{
    if(!obj) return;
    
    // 增加防御力
    obj.sq_AddBonusPhysicalDefense(50);
    obj.sq_AddBonusMagicalDefense(50);
    
    // 增加HP
    obj.sq_AddBonusMaxHp(500);
}

// 合并后的函数
function procAppend_CombinedEquipments(obj)
{
    if(!obj) return;
    
    // 检查装备A是否存在
    if(obj.sq_IsEquipItem(ITEM_EQUIPMENT_A))
    {
        procAppend_EquipmentA(obj);
    }
    
    // 检查装备B是否存在
    if(obj.sq_IsEquipItem(ITEM_EQUIPMENT_B))
    {
        procAppend_EquipmentB(obj);
    }
    
    // 检查套装效果
    if(obj.sq_IsEquipItem(ITEM_EQUIPMENT_A) && obj.sq_IsEquipItem(ITEM_EQUIPMENT_B))
    {
        // 套装额外效果
        obj.sq_AddBonusAttackSpeed(10);
        obj.sq_AddBonusMoveSpeed(15);
    }
}

// ===================================================================
// 3. isUsableItem函数合并示例
// ===================================================================

// 原始函数1：消耗品A的使用检查
function isUsableItem_ConsumableA(obj, itemIndex)
{
    if(!obj) return false;
    
    // 检查HP是否满血
    if(obj.sq_GetHp() >= obj.sq_GetMaxHp()) return false;
    
    // 检查冷却时间
    if(obj.sq_IsUseItem(itemIndex)) return false;
    
    return true;
}

// 原始函数2：消耗品B的使用检查
function isUsableItem_ConsumableB(obj, itemIndex)
{
    if(!obj) return false;
    
    // 检查MP是否满蓝
    if(obj.sq_GetMp() >= obj.sq_GetMaxMp()) return false;
    
    // 检查冷却时间
    if(obj.sq_IsUseItem(itemIndex)) return false;
    
    return true;
}

// 合并后的函数
function isUsableItem_CombinedConsumables(obj, itemIndex)
{
    if(!obj) return false;
    
    // 根据物品ID分发检查
    switch(itemIndex)
    {
        case ITEM_CONSUMABLE_A:
            return isUsableItem_ConsumableA(obj, itemIndex);
            
        case ITEM_CONSUMABLE_B:
            return isUsableItem_ConsumableB(obj, itemIndex);
            
        case ITEM_CONSUMABLE_C:
            // 直接在这里处理简单的检查
            if(obj.sq_IsUseItem(itemIndex)) return false;
            return true;
    }
    
    return false;
}

// ===================================================================
// 4. onAttack函数合并示例
// ===================================================================

// 原始函数1：技能A的攻击处理
function onAttack_SkillA(obj, damager, boundingBox, isStuck)
{
    if(!obj || !damager) return;
    
    local skillLevel = obj.sq_GetSkillLevel(SKILL_A);
    local damageRate = 100 + (skillLevel * 10);
    
    damager.sq_SetDamageRate(damageRate);
    damager.sq_SetAttackInfo(SAI_IS_MAGIC, false);
}

// 原始函数2：技能B的攻击处理
function onAttack_SkillB(obj, damager, boundingBox, isStuck)
{
    if(!obj || !damager) return;
    
    local skillLevel = obj.sq_GetSkillLevel(SKILL_B);
    local damageRate = 150 + (skillLevel * 15);
    
    damager.sq_SetDamageRate(damageRate);
    damager.sq_SetAttackInfo(SAI_IS_MAGIC, true);
    damager.sq_SetAttackInfo(SAI_ELEMENT, ELEMENT_FIRE);
}

// 合并后的函数
function onAttack_CombinedSkills(obj, damager, boundingBox, isStuck)
{
    if(!obj || !damager) return;
    
    // 获取攻击来源状态
    local attackerState = obj.sq_GetState();
    
    switch(attackerState)
    {
        case STATE_SKILL_A:
            onAttack_SkillA(obj, damager, boundingBox, isStuck);
            break;
            
        case STATE_SKILL_B:
            onAttack_SkillB(obj, damager, boundingBox, isStuck);
            break;
            
        default:
            // 通用攻击处理
            damager.sq_SetDamageRate(100);
            break;
    }
}

// ===================================================================
// 5. drawCustomUI函数合并示例
// ===================================================================

// 原始函数1：技能冷却显示
function drawCustomUI_SkillCooldown(obj, drawFlag)
{
    if(!obj) return;
    
    local skillLevel = obj.sq_GetSkillLevel(SKILL_CUSTOM);
    if(skillLevel <= 0) return;
    
    // 绘制技能冷却时间
    if(obj.sq_IsUseSkill(SKILL_CUSTOM))
    {
        local cooldownTime = obj.sq_GetSkillCoolTime(SKILL_CUSTOM);
        obj.sq_DrawText(10, 10, `技能冷却: ` + cooldownTime + `ms`, 0xFFFFFF);
    }
}

// 原始函数2：装备耐久度显示
function drawCustomUI_EquipmentDurability(obj, drawFlag)
{
    if(!obj) return;
    
    // 显示武器耐久度
    local weaponDurability = obj.sq_GetEquipmentDurability(EQUIPMENT_WEAPON);
    if(weaponDurability < 100)
    {
        local color = (weaponDurability < 20) ? 0xFF0000 : 0xFFFF00;  // 低耐久红色，中等黄色
        obj.sq_DrawText(10, 30, `武器耐久: ` + weaponDurability + `%`, color);
    }
}

// 合并后的函数
function drawCustomUI_Combined(obj, drawFlag)
{
    if(!obj) return;
    
    // 调用所有UI绘制函数
    drawCustomUI_SkillCooldown(obj, drawFlag);
    drawCustomUI_EquipmentDurability(obj, drawFlag);
    
    // 添加新的UI元素
    drawCustomUI_BuffStatus(obj, drawFlag);
    drawCustomUI_ComboCounter(obj, drawFlag);
}

// 新增的UI绘制函数
function drawCustomUI_BuffStatus(obj, drawFlag)
{
    if(!obj) return;
    
    local yPos = 50;
    
    // 显示当前BUFF状态
    if(obj.sq_IsActiveStatus(ACTIVESTATUS_CUSTOM_BUFF))
    {
        local buffTime = obj.sq_GetActiveStatusRemainTime(ACTIVESTATUS_CUSTOM_BUFF);
        obj.sq_DrawText(10, yPos, `BUFF剩余: ` + (buffTime / 1000) + `s`, 0x00FF00);
        yPos += 20;
    }
}

function drawCustomUI_ComboCounter(obj, drawFlag)
{
    if(!obj) return;
    
    // 显示连击数
    local comboCount = obj.sq_GetIntData(SKILL_COMBO, 0);
    if(comboCount > 0)
    {
        local color = (comboCount >= 10) ? 0xFF0000 : 0xFFFFFF;
        obj.sq_DrawText(10, 70, `连击: ` + comboCount, color);
    }
}

// ===================================================================
// 6. 函数合并的最佳实践
// ===================================================================

// 示例：使用表格驱动的函数合并
local skillHandlers = {
    [STATE_SKILL_A] = {
        setState = onSetState_SkillA,
        onAttack = onAttack_SkillA,
        timeEvent = onTimeEvent_SkillA
    },
    [STATE_SKILL_B] = {
        setState = onSetState_SkillB,
        onAttack = onAttack_SkillB,
        timeEvent = onTimeEvent_SkillB
    }
};

// 通用分发函数
function dispatchSkillFunction(obj, state, functionType, ...)
{
    if(!obj) return;
    
    if(state in skillHandlers && functionType in skillHandlers[state])
    {
        local handler = skillHandlers[state][functionType];
        return handler(obj, ...);
    }
    
    return false;
}

// 使用分发函数的合并示例
function onSetState_TableDriven(obj, state, datas, isResetTimer)
{
    return dispatchSkillFunction(obj, state, "setState", state, datas, isResetTimer);
}

function onAttack_TableDriven(obj, damager, boundingBox, isStuck)
{
    local state = obj.sq_GetState();
    return dispatchSkillFunction(obj, state, "onAttack", damager, boundingBox, isStuck);
}

// ===================================================================
// 使用说明：
// 1. 函数合并要保持原有功能的完整性
// 2. 使用switch语句或表格驱动方式进行分发
// 3. 合并后要测试所有原有功能是否正常
// 4. 注意函数名称的唯一性，避免冲突
// 5. 复杂的合并可以使用模块化设计
// 
// 注意事项：
// 1. 合并前备份原始文件
// 2. 逐步合并，每次合并后进行测试
// 3. 保持代码的可读性和可维护性
// 4. 注意性能影响，避免过度复杂的分发逻辑
// ===================================================================