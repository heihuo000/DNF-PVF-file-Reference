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

	if(substate == 0)//當設置技能的“substate”狀態 等于 = 0 時，執行下列ANI動作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_0);	//調用動作 1
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT,
	 SPEED_VALUE_DEFAULT, 1.0, 1.0);//使角色演出速度受攻擊速度影響
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色調用(CUSTOM_ATK_01)指向的AtK數據
	local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//定義傷害百分比（技能編號，技能狀態，對應動態數據號位，技能傷害倍率）
	obj.sq_SetCurrentAttackBonusRate(damage);//設置傷害百分比

	}
	else if(substate == 1)//當設置技能的“substate”狀態 等于 = 1 時，執行下列ANI動作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_1);	//調用動作 2
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_02);//設置角色調用(CUSTOM_ATK_01)指向的AtK數據
	local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//定義傷害百分比（技能編號，技能狀態，對應動態數據號位，技能傷害倍率）
	obj.sq_SetCurrentAttackBonusRate(damage);//設置傷害百分比

	}

}


function onAttack_Zskill00(obj, damager, boundingBox, isStuck)//對攻擊到的單位

{
	if(!obj)
		return false;
	local substate = obj.getSkillSubState();//獲取人物的sub state狀態

	if(substate == 0)//在動作 1 攻擊到的單位時 附加AP文件
	{
		damager.setCurrentDirection(sq_GetDirection(obj));

		local masterAppendage = CNSquirrelAppendage.sq_AppendAppendage(damager, obj, SKILL_ZSKILL00, false,
		"character/thief/zskill00/ap_zskill00.nut", true);//引用AP文件的指向

		if(masterAppendage) //判斷有AP的單位，出發效果
		{
			masterAppendage.sq_SetValidTime(500);//ap持續時間
			sq_MoveToAppendageForce(damager, obj, obj, 100, 0, 0, 150, true, masterAppendage);//將有AP標志的單位，拉取到人物前方100px的位置
		}
	
	}
	if(substate == 1)//在動作 2 攻擊到的單位時
	{
		damager.setCurrentDirection(sq_GetOppositeDirection(obj.getDirection()));
		if(damager)//判斷是傷害的對象
		CNSquirrelAppendage.sq_RemoveAppendage(damager, "character/thief/zskill00/ap_zskill00.nut");//第二次攻擊時，清除ap標志。
			obj.sq_SetShake(obj,5,120);//震動
			sq_setFullScreenEffect(obj,"Character/Priest/Effect/Animation/execution/grabEx/finish.ani");	
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
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, true);//演出結束后，恢復站立。
	}
	
}


function getScrollBasisPos_Zskill00(obj)
{
	
	if(!obj) return;
	local substate = obj.getSkillSubState();//獲取當前技能的SUB狀態
	
	if (obj.isMyControlObject())//
	{
		local xPos = obj.getXPos();//獲取當前人物的x軸坐標
		local distance = 150;//鏡頭移動距離
		local destX = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), distance);//計算方向偏移距離
		local speedrate = 300;//鏡頭移動速率，數值越高，移動的越快
		if(substate == 0)//當動作 1時，觸發
		{
			local stateTimer = obj.sq_GetStateTimer();//計算substate = 0 的狀態時間
			xPos = sq_GetUniformVelocity(xPos, destX, stateTimer, speedrate);//計算鏡頭向前方移動的均勻速度（初始距離、最終距離、需要的時間、移動速率）；
		print(" xPos:" + xPos);	print(" stateTimer:" + stateTimer);
		}
		else if(substate == 1)//當動作 2時，觸發
		{
			local stateTimer = obj.sq_GetStateTimer();//計算substate = 0 的狀態時間
			xPos = sq_GetUniformVelocity(destX, xPos, stateTimer, speedrate);////計算鏡頭向前方移動的均勻速度
		}
		else
		{
			xPos = destX;//回到最大偏移方向
		}
		obj.sq_SetCameraScrollPosition(xPos, obj.getYPos(), 0);//根據前面的判斷將不同的數據傳遞到鏡頭移動代碼中。*參數：（勻速獲得的坐標、人物當前的坐標、未知）
		
		return true;
	}
	
	return false;
}
