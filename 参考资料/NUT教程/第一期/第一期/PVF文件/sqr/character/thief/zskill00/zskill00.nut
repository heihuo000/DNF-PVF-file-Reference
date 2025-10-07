function checkExecutableSkill_Zskill00(obj)//檢查技能可執行性
{
	if (!obj) return false;
	local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);//檢查技能的是否可使用
	
	if (isUse) //符合條件
	{
		obj.sq_AddSetStatePacket(STATE_ZSKILL00 , STATE_PRIORITY_USER, false);//符合可使用時，發送“STATE_ZSKILL00”狀態
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

function onSetState_Zskill00(obj, state, datas, isResetTimer)//接受到 發送“STATE_ZSKILL00”狀態 時，觸發內容；
{	
	if(!obj) return;
	
	obj.sq_StopMove();//停止角色的移動
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);//設置角色使用(CUSTOM_ANI_01)指向的ANI動作
}

function onEndCurrentAni_Zskill00(obj)//ANI演出結束
{
	//當角色使用(CUSTOM_ANI_01)的ANI動作演出結束后，發送“STATE_STAND”狀態，也就是說(CUSTOM_ANI_01）動作執行完就恢復站立的狀態；
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

