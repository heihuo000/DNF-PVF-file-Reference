// ===================================================================
// BUFF技能模板 - NUT脚本示例
// 功能：演示BUFF类技能的完整实现
// 适用：学习状态增益技能的设计模式
// ===================================================================

// 状态定义（需要在header.nut中注册）
// STATE_BUFF_SKILL <- 103

// BUFF状态定义
ACTIVESTATUS_CUSTOM_BUFF <- 200  // 自定义BUFF状态ID

// 时间事件定义
ENUM_BUFF_TIMER_CAST_END <- 0    // 施法结束
ENUM_BUFF_TIMER_EFFECT <- 1      // 特效播放

// 技能变量定义
VAR_BUFF_DURATION <- 0           // BUFF持续时间
VAR_BUFF_LEVEL <- 1              // BUFF等级

// ===================================================================
// 1. 技能可执行性检查
// ===================================================================
function checkExecutableSkill_BuffSkill(obj)
{
    if(!obj) return false;
    
    // 检查技能冷却
    if(obj.sq_IsUseSkill(SKILL_BUFF_SKILL)) return false;
    
    // 检查MP消耗
    local needMp = obj.sq_GetIntData(SKILL_BUFF_SKILL, SKL_MP_CONSUMPTION);
    if(obj.sq_GetMp() < needMp) return false;
    
    // 检查是否已有相同BUFF
    if(obj.sq_IsActiveStatus(ACTIVESTATUS_CUSTOM_BUFF))
    {
        // 可以选择刷新BUFF或者禁止重复施放
        return true;  // 允许刷新
    }
    
    return true;
}

// ===================================================================
// 2. 状态设置处理
// ===================================================================
function onSetState_BuffSkill(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    if(isResetTimer)
    {
        // 播放施法动画
        obj.sq_SetCurrentAnimation(CUSTOM_ANI_BUFF_CAST);
        obj.sq_StopMove();
        
        // 获取技能等级和持续时间
        local skillLevel = obj.sq_GetSkillLevel(SKILL_BUFF_SKILL);
        local duration = 30000 + (skillLevel * 2000);  // 基础30秒，每级+2秒
        
        // 存储BUFF信息
        obj.sq_SetIntData(SKILL_BUFF_SKILL, VAR_BUFF_DURATION, duration);
        obj.sq_SetIntData(SKILL_BUFF_SKILL, VAR_BUFF_LEVEL, skillLevel);
        
        // 设置施法结束时间
        obj.sq_AddSetStatePacket(STATE_BUFF_SKILL, STATE_PRIORITY_USER, false);
        obj.sq_SetCurrentAttackInfo(ENUM_BUFF_TIMER_CAST_END);
        
        // 播放施法音效
        obj.sq_PlaySound(`BUFF_CAST_START`);
        
        // 创建施法特效
        obj.sq_AddSetStatePacket(STATE_BUFF_SKILL, STATE_PRIORITY_USER, false);
        obj.sq_SetCurrentAttackInfo(ENUM_BUFF_TIMER_EFFECT);
    }
}

// ===================================================================
// 3. 时间事件处理
// ===================================================================
function onTimeEvent_BuffSkill(obj, timeEventIndex, timeEventCount)
{
    if(!obj) return;
    
    switch(timeEventIndex)
    {
        case ENUM_BUFF_TIMER_CAST_END:
            // 施法完成，应用BUFF效果
            applyBuffEffect(obj);
            
            // 返回站立状态
            obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, true);
            break;
            
        case ENUM_BUFF_TIMER_EFFECT:
            // 播放施法特效
            createCastEffect(obj);
            break;
    }
}

// ===================================================================
// 4. BUFF效果应用函数
// ===================================================================
function applyBuffEffect(obj)
{
    if(!obj) return;
    
    local skillLevel = obj.sq_GetIntData(SKILL_BUFF_SKILL, VAR_BUFF_LEVEL);
    local duration = obj.sq_GetIntData(SKILL_BUFF_SKILL, VAR_BUFF_DURATION);
    
    // 移除已存在的相同BUFF（刷新效果）
    if(obj.sq_IsActiveStatus(ACTIVESTATUS_CUSTOM_BUFF))
    {
        obj.sq_RemoveActiveStatus(ACTIVESTATUS_CUSTOM_BUFF);
    }
    
    // 应用新的BUFF状态
    obj.sq_AddActiveStatus(ACTIVESTATUS_CUSTOM_BUFF, 
        obj,                    // 施法者
        obj,                    // 目标
        skillLevel,             // BUFF等级
        duration,               // 持续时间
        0,                      // 间隔时间
        0);                     // 重复次数
    
    // 播放BUFF生效音效
    obj.sq_PlaySound(`BUFF_APPLY`);
    
    // 创建BUFF生效特效
    obj.sq_StartWrite();
    obj.sq_WriteDword(skillLevel);
    obj.sq_SendCreatePassiveObjectPacket(24213, 0, 0, 0, 0);
}

// ===================================================================
// 5. 施法特效创建函数
// ===================================================================
function createCastEffect(obj)
{
    if(!obj) return;
    
    // 创建环绕特效
    obj.sq_StartWrite();
    obj.sq_WriteDword(obj.sq_GetSkillLevel(SKILL_BUFF_SKILL));
    obj.sq_SendCreatePassiveObjectPacket(24214, 0, 0, 0, 0);
}

// ===================================================================
// 6. BUFF状态处理函数
// ===================================================================

// BUFF开始时调用
function onStart_CustomBuff(obj, activeStatus)
{
    if(!obj || !activeStatus) return;
    
    local buffLevel = activeStatus.sq_GetLevel();
    
    // 应用属性增益
    applyBuffStats(obj, buffLevel, true);
    
    // 播放BUFF开始特效
    obj.sq_PlaySound(`BUFF_START`);
}

// BUFF结束时调用
function onEnd_CustomBuff(obj, activeStatus)
{
    if(!obj || !activeStatus) return;
    
    local buffLevel = activeStatus.sq_GetLevel();
    
    // 移除属性增益
    applyBuffStats(obj, buffLevel, false);
    
    // 播放BUFF结束特效
    obj.sq_PlaySound(`BUFF_END`);
}

// BUFF持续期间调用（如果有间隔时间）
function onThink_CustomBuff(obj, activeStatus)
{
    if(!obj || !activeStatus) return;
    
    // 可以在这里添加持续效果
    // 例如：持续回复MP
    local buffLevel = activeStatus.sq_GetLevel();
    local mpRecover = 10 + (buffLevel * 2);
    obj.sq_AddMp(mpRecover);
}

// ===================================================================
// 7. 属性增益应用函数
// ===================================================================
function applyBuffStats(obj, buffLevel, isApply)
{
    if(!obj) return;
    
    // 计算增益数值
    local strBonus = 50 + (buffLevel * 10);      // 力量增益
    local intBonus = 50 + (buffLevel * 10);      // 智力增益
    local spdBonus = 20 + (buffLevel * 5);       // 攻击速度增益
    local moveBonus = 15 + (buffLevel * 3);      // 移动速度增益
    
    if(isApply)
    {
        // 应用增益
        obj.sq_AddBonusStr(strBonus);
        obj.sq_AddBonusInt(intBonus);
        obj.sq_AddBonusAttackSpeed(spdBonus);
        obj.sq_AddBonusMoveSpeed(moveBonus);
        
        // 添加特殊效果（例如：免疫某些状态）
        obj.sq_AddActiveStatus(ACTIVESTATUS_IMMUNE_STUCK, obj, obj, 1, 999999, 0, 0);
    }
    else
    {
        // 移除增益
        obj.sq_AddBonusStr(-strBonus);
        obj.sq_AddBonusInt(-intBonus);
        obj.sq_AddBonusAttackSpeed(-spdBonus);
        obj.sq_AddBonusMoveSpeed(-moveBonus);
        
        // 移除特殊效果
        obj.sq_RemoveActiveStatus(ACTIVESTATUS_IMMUNE_STUCK);
    }
}

// ===================================================================
// 8. 技能升级效果查询（用于技能说明）
// ===================================================================
function getSkillDescription_BuffSkill(skillLevel)
{
    local duration = (30 + skillLevel * 2);
    local strBonus = 50 + (skillLevel * 10);
    local spdBonus = 20 + (skillLevel * 5);
    
    return `增加力量/智力 ` + strBonus + ` 点，攻击速度 ` + spdBonus + `%，持续 ` + duration + ` 秒`;
}

// ===================================================================
// 9. 组队BUFF支持（可选扩展）
// ===================================================================
function applyPartyBuff(caster, targetObj)
{
    if(!caster || !targetObj) return;
    
    // 检查是否在组队状态
    if(!caster.sq_IsPartyMember(targetObj)) return;
    
    // 检查距离
    local distance = caster.sq_GetDistanceToObj(targetObj);
    if(distance > 300) return;  // 300像素范围内
    
    // 应用BUFF到队友
    local skillLevel = caster.sq_GetSkillLevel(SKILL_BUFF_SKILL);
    local duration = 30000 + (skillLevel * 2000);
    
    targetObj.sq_AddActiveStatus(ACTIVESTATUS_CUSTOM_BUFF, 
        caster, targetObj, skillLevel, duration, 0, 0);
}

// ===================================================================
// 使用说明：
// 1. 此模板展示了完整的BUFF技能实现
// 2. 包含施法过程、BUFF应用、属性增益等完整流程
// 3. 支持BUFF刷新和状态管理
// 4. 提供了组队BUFF的扩展示例
// 5. 包含完整的特效和音效系统
// 
// 注意事项：
// 1. ACTIVESTATUS_CUSTOM_BUFF需要在相应的状态文件中定义
// 2. 音效和特效资源需要在相应的资源文件中配置
// 3. 属性增益的数值需要根据游戏平衡性调整
// ===================================================================