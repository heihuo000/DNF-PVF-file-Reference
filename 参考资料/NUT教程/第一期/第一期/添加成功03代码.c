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
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色调用(CUSTOM_ATK_01)指向的AtK数据
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT,
	 SPEED_VALUE_DEFAULT, 1.0, 1.0);//使角色演出速度受攻击速度影响
	local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//定义伤害百分比（技能编号，技能状态，对应动态数据号位，技能伤害倍率）
	obj.sq_SetCurrentAttackBonusRate(damage);//设置伤害百分比

//---------花里胡哨-------
obj.sq_setCustomHitEffectFileName
("Character/Mage/Effect/Animation/ATIceSword/05_2_smoke_dodge .ani");//对攻击到的单位附加一个动画效果
obj.sq_SetShake(obj,2,150);//震动
sq_flashScreen(obj, 30, 30, 30, 200, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);//闪屏
}

function onAttack_Zskill00(obj, damager, boundingBox, isStuck)//对攻击命中的对象
{
	if (!obj || !damager) return;
	
	sq_EffectLayerAppendage(damager,sq_RGB(46, 204, 113),150,0,0,240);	//对攻击命中的对象叠加一层颜色光谱
}



function onEndCurrentAni_Zskill00(obj)//ANI演出結束
{
	//當角色使用(CUSTOM_ANI_01)的ANI動作演出結束后，發送“STATE_STAND”狀態，也就是說(CUSTOM_ANI_01）動作執行完就恢復站立的狀態；
obj.sq_setCustomHitEffectFileName
("Character/Mage/Effect/Animation/ATIceSword/x.ani");//在演出动画结束时将受击动画指向到空的文件
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

