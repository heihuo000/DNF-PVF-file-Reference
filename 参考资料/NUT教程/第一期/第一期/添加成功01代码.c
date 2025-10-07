function checkExecutableSkill_Zskill00(obj)//检查技能可执行性
{
	if (!obj) return false;
	local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);//检查技能的是否可使用
	
	if (isUse) //符合条件
	{
		obj.sq_AddSetStatePacket(STATE_ZSKILL00 , STATE_PRIORITY_USER, false);//符合可使用时，发送“STATE_ZSKILL00”状态
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

function onSetState_Zskill00(obj, state, datas, isResetTimer)//接受到 发送“STATE_ZSKILL00”状态 时，触发内容；
{	
	if(!obj) return;
	
	obj.sq_StopMove();//停止角色的移动
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);//设置角色使用(CUSTOM_ANI_01)指向的ANI动作
}

function onEndCurrentAni_Zskill00(obj)//ANI演出结束
{
	//当角色使用(CUSTOM_ANI_01)的ANI动作演出结束后，发送“STATE_STAND”状态，也就是说(CUSTOM_ANI_01）动作执行完就恢复站立的状态；
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

