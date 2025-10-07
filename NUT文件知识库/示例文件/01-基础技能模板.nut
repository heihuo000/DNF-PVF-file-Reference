// ===================================================================
// 基础技能模板 - NUT脚本示例
// 功能：演示一个简单的主动攻击技能实现
// 适用：初学者学习NUT脚本基础结构
// ===================================================================

// 状态定义（需要在header.nut中注册）
// STATE_BASIC_SKILL <- 101

// 时间事件定义
ENUM_BASIC_SKILL_TIMER_ATTACK <- 0      // 攻击判定时机
ENUM_BASIC_SKILL_TIMER_END <- 1         // 技能结束时机

// ===================================================================
// 1. 技能可执行性检查
// ===================================================================
function checkExecutableSkill_BasicSkill(obj)
{
    // 基础对象检查
    if(!obj) return false;
    
    // 检查技能是否在冷却中
    if(obj.sq_IsUseSkill(SKILL_BASIC_SKILL)) return false;
    
    // 检查MP是否足够
    local needMp = obj.sq_GetIntData(SKILL_BASIC_SKILL, SKL_MP_CONSUMPTION);
    if(obj.sq_GetMp() < needMp) return false;
    
    // 检查角色状态（可选）
    local state = obj.sq_GetState();
    if(state == STATE_ATTACK || state == STATE_DAMAGE) return false;
    
    return true;
}

// ===================================================================
// 2. 状态设置处理
// ===================================================================
function onSetState_BasicSkill(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    // 设置角色动画
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_BASIC_SKILL);
    
    // 停止角色移动
    obj.sq_StopMove();
    
    // 设置攻击速度影响
    obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, 
        SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, 
        SPEED_VALUE_DEFAULT, 1.0, 1.0);
    
    // 设置时间事件
    if(isResetTimer)
    {
        // 攻击判定时机（动画播放到50%时）
        obj.sq_AddSetStatePacket(STATE_BASIC_SKILL, STATE_PRIORITY_USER, false);
        obj.sq_SetCurrentAttackInfo(ENUM_BASIC_SKILL_TIMER_ATTACK);
        
        // 技能结束时机（动画播放完毕）
        obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
        obj.sq_SetCurrentAttackInfo(ENUM_BASIC_SKILL_TIMER_END);
    }
}

// ===================================================================
// 3. 时间事件处理
// ===================================================================
function onTimeEvent_BasicSkill(obj, timeEventIndex, timeEventCount)
{
    if(!obj) return;
    
    switch(timeEventIndex)
    {
        case ENUM_BASIC_SKILL_TIMER_ATTACK:
            // 创建攻击判定区域
            obj.sq_StartWrite();
            obj.sq_WriteDword(timeEventIndex);
            obj.sq_WriteDword(obj.sq_GetSkillLevel(SKILL_BASIC_SKILL));
            obj.sq_SendCreatePassiveObjectPacket(24210, 0, 100, 0, 0);
            break;
            
        case ENUM_BASIC_SKILL_TIMER_END:
            // 技能结束，返回站立状态
            obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, true);
            break;
    }
}

// ===================================================================
// 4. 攻击判定处理
// ===================================================================
function onAttack_BasicSkill(obj, damager, boundingBox, isStuck)
{
    if(!obj || !damager) return;
    
    // 获取技能等级
    local skillLevel = obj.sq_GetSkillLevel(SKILL_BASIC_SKILL);
    
    // 设置基础伤害倍率（100% + 技能等级 * 10%）
    local damageRate = 100 + (skillLevel * 10);
    damager.sq_SetDamageRate(damageRate);
    
    // 设置攻击类型为物理攻击
    damager.sq_SetAttackInfo(SAI_IS_MAGIC, false);
    
    // 添加硬直效果（持续500毫秒）
    damager.sq_SetChangeStatusIntoAttackInfo(ACTIVESTATUS_STUCK, 
        0, 500, 1000, 0);
    
    // 设置击退效果
    damager.sq_SetKnockInfo(100, 0, 0, 0);
    
    // 播放命中音效（可选）
    obj.sq_PlaySound(`BASIC_SKILL_HIT`);
}

// ===================================================================
// 使用说明：
// 1. 将此文件放入对应职业的技能目录
// 2. 在header.nut中注册STATE_BASIC_SKILL常量
// 3. 在chr文件中添加对应的动画序列
// 4. 在skill文件中定义SKILL_BASIC_SKILL技能数据
// 5. 创建对应的被动对象文件处理攻击判定
// ===================================================================