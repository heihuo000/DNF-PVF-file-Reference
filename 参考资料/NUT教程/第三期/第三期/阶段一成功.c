function checkExecutableSkill_Zskill00(obj)  
{
	if (!obj) return false;
	
	local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);
	
	if (isUse) 
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(0);//將向量寫入值“0”
		obj.sq_AddSetStatePacket(STATE_ZSKILL00 , STATE_PRIORITY_IGNORE_FORCE, true);//發送“STATE_ZSKILL00”狀態
		return true;
	}
	return false;
}

function checkCommandEnable_Zskill00(obj)//檢查按鍵開關
{
	if (!obj) return false;
	local state = obj.sq_GetState();//獲取當前角色的狀態
	
	if (state == STATE_STAND)//獲取角色的狀態 等于“站立”時
	
		return true;//返回 [真],也就是說可以使用技能 若為 [假]時，將會不能使用；
	
	return true;
}

function onSetState_Zskill00(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	
	local substate = obj.sq_GetVectorData(datas, 0);//獲取之前定義好的向量數據
	obj.setSkillSubState(substate);//設置技能的“substate”狀態
	
	//obj.sq_StopMove();//停止移動

	if(substate == 0)//當設置技能的“substate”狀態 等于 = 0 時，執行下列ANI動作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_0);	//調用動作-1
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT,
	 SPEED_VALUE_DEFAULT, 1.0, 1.0);//使角色演出速度受攻擊速度影響
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色調用(CUSTOM_ATK_01)指向的AtK數據
	local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//定義傷害百分比（技能編號，技能狀態，對應動態數據號位，技能傷害倍率）
	obj.sq_SetCurrentAttackBonusRate(damage);//設置傷害百分比

	}
	else if(substate == 1)//當設置技能的“substate”狀態 等于 = 1 時，執行下列ANI動作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_1);	//調用動作-2
		
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT,
	 SPEED_VALUE_DEFAULT, 1.0, 1.0);//使角色演出速度受攻擊速度影響
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_02);//設置角色調用(CUSTOM_ATK_01)指向的AtK數據
	local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//定義傷害百分比（技能編號，技能狀態，對應動態數據號位，技能傷害倍率）
	obj.sq_SetCurrentAttackBonusRate(damage);//設置傷害百分比

	}

}

function onEndCurrentAni_Zskill00(obj)
{
	if(!obj) return;
	local substate = obj.getSkillSubState();//獲取當前技能的SUB狀態

	if(substate == 0)//當設置技能的“substate”狀態 等于 = 0 時，執行下列向量寫入
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(1);//將向量寫入值“1” （*解釋：在執行完ANI-[CUSTOM_ANI_STAGE_ATTACK_0]的動作后，發送“substate” = 1，銜接ANI-[CUSTOM_ANI_STAGE_ATTACK_1]）
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);//發送“STATE_ZSKILL00”狀態
	}
	else if(substate == 1)
	{
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, true);//演出结束后，恢复站立。
	}
	
}

