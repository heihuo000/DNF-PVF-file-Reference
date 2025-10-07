
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
	obj.sq_StopMove();//停止移動

	if(substate == 0)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_0);	//調用動作 1
		
		
	}
	else if(substate == 1)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_1);	//調用動作 2
	}
	else if(substate == 2)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_2);	//調用動作 2
	}
	else if(substate == 3)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_3);	//調用動作 2
	}
}


function onEndCurrentAni_Zskill00(obj)
{
	if(!obj) return;
	local substate = obj.getSkillSubState();//獲取當前技能的SUB狀態

	if(substate == 0)//當設置技能的“substate”狀態 等于 = 0 時，執行下列向量寫入
	{
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(1);
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == 1)
	{

		obj.sq_IntVectClear();
		obj.sq_IntVectPush(2);
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == 2)
	{

		obj.sq_IntVectClear();
		obj.sq_IntVectPush(3);
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == 3)
	{

			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, true);//演出結束后，恢復站立。
	}
	
}


