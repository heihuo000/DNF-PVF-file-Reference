// ===================================================================
// 多动作技能模板 - NUT脚本示例
// 功能：演示具有多个动作阶段的复杂技能实现
// 适用：中级开发者学习多阶段技能设计
// ===================================================================

// 状态定义（需要在header.nut中注册）
// STATE_MULTI_ACTION_SKILL <- 102

// 子状态定义
ENUM_MULTI_ACTION_SUBSTATE_PREPARE <- 0     // 准备阶段
ENUM_MULTI_ACTION_SUBSTATE_ATTACK1 <- 1     // 第一段攻击
ENUM_MULTI_ACTION_SUBSTATE_ATTACK2 <- 2     // 第二段攻击
ENUM_MULTI_ACTION_SUBSTATE_FINISH <- 3      // 结束阶段

// 时间事件定义
ENUM_MULTI_ACTION_TIMER_PREPARE_END <- 0    // 准备阶段结束
ENUM_MULTI_ACTION_TIMER_ATTACK1 <- 1        // 第一段攻击判定
ENUM_MULTI_ACTION_TIMER_ATTACK1_END <- 2    // 第一段攻击结束
ENUM_MULTI_ACTION_TIMER_ATTACK2 <- 3        // 第二段攻击判定
ENUM_MULTI_ACTION_TIMER_SKILL_END <- 4      // 技能完全结束

// 技能变量定义
VAR_MULTI_ACTION_SUBSTATE <- 0              // 当前子状态
VAR_MULTI_ACTION_HIT_COUNT <- 1             // 命中次数统计

// ===================================================================
// 1. 技能可执行性检查
// ===================================================================
function checkExecutableSkill_MultiActionSkill(obj)
{
    if(!obj) return false;
    
    // 检查技能冷却
    if(obj.sq_IsUseSkill(SKILL_MULTI_ACTION_SKILL)) return false;
    
    // 检查MP消耗
    local needMp = obj.sq_GetIntData(SKILL_MULTI_ACTION_SKILL, SKL_MP_CONSUMPTION);
    if(obj.sq_GetMp() < needMp) return false;
    
    // 检查角色状态
    local state = obj.sq_GetState();
    if(state == STATE_DAMAGE || state == STATE_DOWN) return false;
    
    return true;
}

// ===================================================================
// 2. 状态设置处理
// ===================================================================
function onSetState_MultiActionSkill(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    if(isResetTimer)
    {
        // 初始化技能变量
        obj.sq_SetIntData(SKILL_MULTI_ACTION_SKILL, VAR_MULTI_ACTION_SUBSTATE, 
            ENUM_MULTI_ACTION_SUBSTATE_PREPARE);
        obj.sq_SetIntData(SKILL_MULTI_ACTION_SKILL, VAR_MULTI_ACTION_HIT_COUNT, 0);
        
        // 开始准备阶段
        setSubState_MultiActionSkill(obj, ENUM_MULTI_ACTION_SUBSTATE_PREPARE);
    }
}

// ===================================================================
// 3. 子状态设置函数
// ===================================================================
function setSubState_MultiActionSkill(obj, subState)
{
    if(!obj) return;
    
    // 更新子状态变量
    obj.sq_SetIntData(SKILL_MULTI_ACTION_SKILL, VAR_MULTI_ACTION_SUBSTATE, subState);
    
    switch(subState)
    {
        case ENUM_MULTI_ACTION_SUBSTATE_PREPARE:
            // 准备阶段：播放蓄力动画
            obj.sq_SetCurrentAnimation(CUSTOM_ANI_MULTI_ACTION_PREPARE);
            obj.sq_StopMove();
            
            // 设置准备阶段结束时间
            obj.sq_AddSetStatePacket(STATE_MULTI_ACTION_SKILL, STATE_PRIORITY_USER, false);
            obj.sq_SetCurrentAttackInfo(ENUM_MULTI_ACTION_TIMER_PREPARE_END);
            
            // 播放蓄力特效
            obj.sq_PlaySound(`MULTI_ACTION_PREPARE`);
            break;
            
        case ENUM_MULTI_ACTION_SUBSTATE_ATTACK1:
            // 第一段攻击
            obj.sq_SetCurrentAnimation(CUSTOM_ANI_MULTI_ACTION_ATTACK1);
            
            // 设置攻击判定时机
            obj.sq_AddSetStatePacket(STATE_MULTI_ACTION_SKILL, STATE_PRIORITY_USER, false);
            obj.sq_SetCurrentAttackInfo(ENUM_MULTI_ACTION_TIMER_ATTACK1);
            
            // 设置第一段结束时机
            obj.sq_AddSetStatePacket(STATE_MULTI_ACTION_SKILL, STATE_PRIORITY_USER, false);
            obj.sq_SetCurrentAttackInfo(ENUM_MULTI_ACTION_TIMER_ATTACK1_END);
            break;
            
        case ENUM_MULTI_ACTION_SUBSTATE_ATTACK2:
            // 第二段攻击
            obj.sq_SetCurrentAnimation(CUSTOM_ANI_MULTI_ACTION_ATTACK2);
            
            // 设置攻击判定时机
            obj.sq_AddSetStatePacket(STATE_MULTI_ACTION_SKILL, STATE_PRIORITY_USER, false);
            obj.sq_SetCurrentAttackInfo(ENUM_MULTI_ACTION_TIMER_ATTACK2);
            
            // 设置技能结束时机
            obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
            obj.sq_SetCurrentAttackInfo(ENUM_MULTI_ACTION_TIMER_SKILL_END);
            break;
            
        case ENUM_MULTI_ACTION_SUBSTATE_FINISH:
            // 结束阶段
            obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, true);
            break;
    }
}

// ===================================================================
// 4. 时间事件处理
// ===================================================================
function onTimeEvent_MultiActionSkill(obj, timeEventIndex, timeEventCount)
{
    if(!obj) return;
    
    switch(timeEventIndex)
    {
        case ENUM_MULTI_ACTION_TIMER_PREPARE_END:
            // 准备阶段结束，进入第一段攻击
            setSubState_MultiActionSkill(obj, ENUM_MULTI_ACTION_SUBSTATE_ATTACK1);
            break;
            
        case ENUM_MULTI_ACTION_TIMER_ATTACK1:
            // 第一段攻击判定
            createAttackArea_MultiActionSkill(obj, 1);
            break;
            
        case ENUM_MULTI_ACTION_TIMER_ATTACK1_END:
            // 第一段攻击结束，进入第二段
            setSubState_MultiActionSkill(obj, ENUM_MULTI_ACTION_SUBSTATE_ATTACK2);
            break;
            
        case ENUM_MULTI_ACTION_TIMER_ATTACK2:
            // 第二段攻击判定
            createAttackArea_MultiActionSkill(obj, 2);
            break;
            
        case ENUM_MULTI_ACTION_TIMER_SKILL_END:
            // 技能完全结束
            setSubState_MultiActionSkill(obj, ENUM_MULTI_ACTION_SUBSTATE_FINISH);
            break;
    }
}

// ===================================================================
// 5. 攻击区域创建函数
// ===================================================================
function createAttackArea_MultiActionSkill(obj, attackPhase)
{
    if(!obj) return;
    
    obj.sq_StartWrite();
    obj.sq_WriteDword(attackPhase);  // 攻击阶段
    obj.sq_WriteDword(obj.sq_GetSkillLevel(SKILL_MULTI_ACTION_SKILL));
    
    // 根据攻击阶段创建不同的攻击区域
    if(attackPhase == 1)
    {
        // 第一段：小范围攻击
        obj.sq_SendCreatePassiveObjectPacket(24211, 0, 80, 0, 0);
    }
    else if(attackPhase == 2)
    {
        // 第二段：大范围攻击
        obj.sq_SendCreatePassiveObjectPacket(24212, 0, 150, 0, 0);
    }
}

// ===================================================================
// 6. 攻击判定处理
// ===================================================================
function onAttack_MultiActionSkill(obj, damager, boundingBox, isStuck)
{
    if(!obj || !damager) return;
    
    // 获取当前攻击阶段
    local attackPhase = damager.sq_GetIntData(0);  // 从被动对象获取阶段信息
    local skillLevel = obj.sq_GetSkillLevel(SKILL_MULTI_ACTION_SKILL);
    
    // 根据攻击阶段设置不同的伤害
    local damageRate = 0;
    if(attackPhase == 1)
    {
        // 第一段：基础伤害
        damageRate = 80 + (skillLevel * 8);
        damager.sq_SetAttackInfo(SAI_IS_MAGIC, false);  // 物理攻击
    }
    else if(attackPhase == 2)
    {
        // 第二段：高伤害
        damageRate = 150 + (skillLevel * 15);
        damager.sq_SetAttackInfo(SAI_IS_MAGIC, true);   // 魔法攻击
        
        // 第二段添加特殊效果
        damager.sq_SetChangeStatusIntoAttackInfo(ACTIVESTATUS_STUCK, 
            0, 800, 1000, 0);
    }
    
    damager.sq_SetDamageRate(damageRate);
    
    // 更新命中次数
    local hitCount = obj.sq_GetIntData(SKILL_MULTI_ACTION_SKILL, VAR_MULTI_ACTION_HIT_COUNT);
    obj.sq_SetIntData(SKILL_MULTI_ACTION_SKILL, VAR_MULTI_ACTION_HIT_COUNT, hitCount + 1);
    
    // 播放命中音效
    obj.sq_PlaySound(`MULTI_ACTION_HIT_` + attackPhase.tostring());
}

// ===================================================================
// 7. 强制中断处理（可选）
// ===================================================================
function onEndState_MultiActionSkill(obj, new_state)
{
    if(!obj) return;
    
    // 清理技能变量
    obj.sq_SetIntData(SKILL_MULTI_ACTION_SKILL, VAR_MULTI_ACTION_SUBSTATE, 0);
    obj.sq_SetIntData(SKILL_MULTI_ACTION_SKILL, VAR_MULTI_ACTION_HIT_COUNT, 0);
    
    // 停止所有相关音效
    obj.sq_StopSound(`MULTI_ACTION_PREPARE`);
}

// ===================================================================
// 使用说明：
// 1. 此模板展示了多阶段技能的完整实现流程
// 2. 通过子状态管理实现复杂的技能逻辑
// 3. 使用变量系统跟踪技能进度和数据
// 4. 支持不同阶段的差异化攻击效果
// 5. 包含完整的状态转换和清理机制
// ===================================================================