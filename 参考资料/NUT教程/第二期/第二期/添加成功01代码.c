function checkExecutableSkill_Zskill00(obj)  
{
	if (!obj) return false;
	
	local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);
	
	if (isUse) 
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(0);//将向量写入值“0”
		obj.sq_AddSetStatePacket(STATE_ZSKILL00 , STATE_PRIORITY_IGNORE_FORCE, true);//发送“STATE_ZSKILL00”状态
		return true;
	}

	return false;
}

function checkCommandEnable_Zskill00(obj)//检查按键开关
{
	if (!obj) return false;
	local state = obj.sq_GetState();//获取当前角色的状态
	
	if (state == STATE_STAND)//获取角色的状态 等于“站立”时
	
		return true;//返回 [真],也就是说可以使用技能 若为 [假]时，将会不能使用；
	
	return true;
}



function onSetState_Zskill00(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	
	local substate = obj.sq_GetVectorData(datas, 0);//获取之前定义好的向量数据
	local sq_var = obj.getVar();
	obj.setSkillSubState(substate);//设置技能的“substate”状态
	
	obj.sq_StopMove();//停止移动
	
	if(substate == 0)//当设置技能的“substate”状态 等于 = 0 时，执行下列ANI动作
	{
		sq_var.setInt(0,0);
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_0);	//调用银月普攻动作-1动作
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//受到攻击速度影响
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色调用(CUSTOM_ATK_01)指向的AtK数据
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//定义伤害百分比（技能编号，技能状态，对应动态数据号位，技能伤害倍率）
		obj.sq_SetCurrentAttackBonusRate(damage);//设置伤害百分比
	}
	else if(substate == 1)//当设置技能的“substate”状态 等于 = 1 时，执行下列ANI动作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_1);	//调用银月普攻动作-2动作
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//受到攻击速度影响
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色调用(CUSTOM_ATK_01)指向的AtK数据
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.5);//定义伤害百分比（技能编号，技能状态，对应动态数据号位，技能伤害倍率）
		obj.sq_SetCurrentAttackBonusRate(damage);//设置伤害百分比
	}
	else if(substate == 2)//当设置技能的“substate”状态 等于 = 2 时，执行下列ANI动作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_2);	//调用银月普攻动作-3动作
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//受到攻击速度影响
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色调用(CUSTOM_ATK_01)指向的AtK数据
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 2.0);//定义伤害百分比（技能编号，技能状态，对应动态数据号位，技能伤害倍率）
		obj.sq_SetCurrentAttackBonusRate(damage);//设置伤害百分比
	}
	else if(substate == 3)//当设置技能的“substate”状态 等于 = 3 时，执行下列ANI动作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_3);	//调用银月普攻动作-4动作
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//受到攻击速度影响
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色调用(CUSTOM_ATK_01)指向的AtK数据
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 2.5);//定义伤害百分比（技能编号，技能状态，对应动态数据号位，技能伤害倍率）
		obj.sq_SetCurrentAttackBonusRate(damage);//设置伤害百分比
	}
	
}




function onEndCurrentAni_Zskill00(obj)
{
	
	local substate = obj.getSkillSubState();//获取当前技能的SUB状态
	local sq_var = obj.getVar();
	local currentHitCount = sq_var.getInt(0);
	local maxHitCount = 13;
	



	sq_var.setInt(0,currentHitCount+1);
	
	print(" currentHitCount:" + currentHitCount);
	


	
	if(substate == 0)//当设置技能的“substate”状态 等于 = 0 时，执行下列向量写入
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(1);//将向量写入值“1” （*解释：在执行完ANI-[CUSTOM_ANI_STAGE_ATTACK_0]的动作后，发送“substate” = 1，衔接ANI-[CUSTOM_ANI_STAGE_ATTACK_1]）
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);//发送“STATE_ZSKILL00”状态
	}
	else if(substate == 1)
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(2);//将向量写入值“2” （*解释：在执行完ANI-[CUSTOM_ANI_STAGE_ATTACK_1]的动作后，发送“substate” = 2，衔接ANI-[CUSTOM_ANI_STAGE_ATTACK_2]）
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
		if(currentHitCount >= maxHitCount)
		{
			obj.sq_IntVectClear();//清除向量
			obj.sq_IntVectPush(3);//将向量写入值“3” （*解释：在执行完ANI-[CUSTOM_ANI_STAGE_ATTACK_2]的动作后，发送“substate” = 3，衔接ANI-[CUSTOM_ANI_STAGE_ATTACK_3]）
			obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
		}
	}
	else if(substate == 2)
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(1);//将向量写入值“3” （*解释：在执行完ANI-[CUSTOM_ANI_STAGE_ATTACK_2]的动作后，发送“substate” = 3，衔接ANI-[CUSTOM_ANI_STAGE_ATTACK_3]）
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
			if(currentHitCount >= maxHitCount)
		{
			obj.sq_IntVectClear();//清除向量
			obj.sq_IntVectPush(3);//将向量写入值“3” （*解释：在执行完ANI-[CUSTOM_ANI_STAGE_ATTACK_2]的动作后，发送“substate” = 3，衔接ANI-[CUSTOM_ANI_STAGE_ATTACK_3]）
			obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
		}
	}
	else if(substate == 3)
	{
	//当角色使用(CUSTOM_ANI_STAGE_ATTACK_3)的ANI动作演出结束后，发送“STATE_STAND”状态，也就是说(CUSTOM_ANI_STAGE_ATTACK_3）动作执行完就恢复站立的状态；
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}

}
