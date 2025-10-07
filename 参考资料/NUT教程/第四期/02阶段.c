
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
		
		local X_distance = 200;//设定人物X轴的最大移动距离
		local max_X = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), X_distance);//方向坐標
		local now_X = obj.getXPos();//不多赘述，前几期都有讲
		local max_Z = 150;//设定人物Z轴的最大移动距离
		local now_Z = obj.getZPos();//不多赘述，前几期都有讲
		
		obj.getVar().clear_vector();//数据清除
		obj.getVar().push_vector(max_X);//数据传递 写入 位号：0
		obj.getVar().push_vector(now_X);//数据传递 写入 位号：1
		obj.getVar().push_vector(max_Z);//数据传递 写入 位号：2
		obj.getVar().push_vector(now_Z);//数据传递 写入 位号：3
		
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

function onProc_Zskill00(obj)
{
	if(!obj) return;

	local substate = obj.getSkillSubState();//不多赘述，前几期都有讲

	if(substate == 0) //不多赘述，前几期都有讲
	{
		local max_X = obj.getVar().get_vector(0);//数据传递 获取 位号：0 对应之前传递的“max_X”
		local now_X = obj.getVar().get_vector(1);//数据传递 获取 位号：1 对应之前传递的“now_X”

		local max_Z = obj.getVar().get_vector(2);//数据传递 获取 位号：2 对应之前传递的“max_Z”
		local now_Z = obj.getVar().get_vector(3);//数据传递 获取 位号：3 对应之前传递的“now_Z”

		local stateTimer = obj.sq_GetStateTimer();//获取状态的时间
		local xPosVelocity = sq_GetUniformVelocity(now_X, max_X, stateTimer, 300);//计算X轴匀速运动
		local zPosVelocity = sq_GetUniformVelocity(now_Z, max_Z, stateTimer, 300);//计算Z轴匀速运动
		local stopX = sq_GetDistancePos(xPosVelocity, obj.getDirection(), 10);//设置遇到障碍物时的停止位

		local iX = obj.getXPos();//不多赘述，前几期都有讲
		local iY = obj.getYPos();//不多赘述，前几期都有讲

		sq_MoveToNearMovablePos(obj,xPosVelocity,iY , zPosVelocity, iX, iY, zPosVelocity, 20, -1, 3);//人物移动（遇到障碍物自行调整）

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


