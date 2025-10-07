function checkExecutableSkill_Zskill00(obj)  
{
	if (!obj) return false;
	
	local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);
	
	if (isUse) 
	{
		obj.getVar().setInt(0,0);//设定初始数值为0
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
obj.sq_SetShake(obj,2,50);//震動
sq_flashScreen(obj, 15, 15, 15, 200, sq_RGB(255,255,255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);//閃屏
	if(substate == 0)//當設置技能的“substate”狀態 等于 = 0 時，執行下列ANI動作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_0);	//調用銀月普攻動作-1動作
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//受到攻擊速度影響
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色調用(CUSTOM_ATK_01)指向的AtK數據
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//定義傷害百分比（技能編號，技能狀態，對應動態數據號位，技能傷害倍率）
		obj.sq_SetCurrentAttackBonusRate(damage);//設置傷害百分比
		
	}
	else if(substate == 1)//當設置技能的“substate”狀態 等于 = 1 時，執行下列ANI動作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_1);	//調用銀月普攻動作-2動作
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//受到攻擊速度影響
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色調用(CUSTOM_ATK_01)指向的AtK數據
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.5);//定義傷害百分比（技能編號，技能狀態，對應動態數據號位，技能傷害倍率）
		obj.sq_SetCurrentAttackBonusRate(damage);//設置傷害百分比
	}
	else if(substate == 2)//當設置技能的“substate”狀態 等于 = 2 時，執行下列ANI動作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_2);	//調用銀月普攻動作-3動作
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//受到攻擊速度影響
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色調用(CUSTOM_ATK_01)指向的AtK數據
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 2.0);//定義傷害百分比（技能編號，技能狀態，對應動態數據號位，技能傷害倍率）
		obj.sq_SetCurrentAttackBonusRate(damage);//設置傷害百分比
	}
	else if(substate == 3)//當設置技能的“substate”狀態 等于 = 3 時，執行下列ANI動作
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_3);	//調用銀月普攻動作-4動作
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//受到攻擊速度影響
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//設置角色調用(CUSTOM_ATK_01)指向的AtK數據
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 2.5);//定義傷害百分比（技能編號，技能狀態，對應動態數據號位，技能傷害倍率）
		obj.sq_SetCurrentAttackBonusRate(damage);//設置傷害百分比
	}
	else if(substate == 4)//當設置技能的“substate”狀態 等于 = 3 時，執行下列ANI動作
	{
			obj.sq_SetShake(obj,5,300);//震動
			sq_flashScreen(obj, 100, 100, 100, 150, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);//閃屏
			obj.sq_setCustomHitEffectFileName
("character/thief/effect/animation/silverstream/slashhitaddeffectspark1dodge.ani");//對攻擊到的單位附加一個動畫效果

		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_4);	//調用銀月普攻動作-4動作
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//受到攻擊速度影響
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_02);//設置角色調用(CUSTOM_ATK_01)指向的AtK數據
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 5.0);//定義傷害百分比（技能編號，技能狀態，對應動態數據號位，技能傷害倍率）
		obj.sq_SetCurrentAttackBonusRate(damage);//設置傷害百分比
	}
}

function onEndCurrentAni_Zskill00(obj)
{
	
	local substate = obj.getSkillSubState();//獲取當前技能的SUB狀態
	local HitCount = obj.getVar().getInt(0);//获取当前值
	obj.getVar().setInt(0,HitCount + 1);//每完成一次ANI动作数值加1
	if(substate == 0)//當設置技能的“substate”狀態 等于 = 0 時，執行下列向量寫入
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(1);//將向量寫入值“1” （*解釋：在執行完ANI-[CUSTOM_ANI_STAGE_ATTACK_0]的動作后，發送“substate” = 1，銜接ANI-[CUSTOM_ANI_STAGE_ATTACK_1]）
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);//發送“STATE_ZSKILL00”狀態
	}
	else if(substate == 1)
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(2);//將向量寫入值“2” （*解釋：在執行完ANI-[CUSTOM_ANI_STAGE_ATTACK_1]的動作后，發送“substate” = 2，銜接ANI-[CUSTOM_ANI_STAGE_ATTACK_2]）
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == 2)
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(3);//將向量寫入值“3” （*解釋：在執行完ANI-[CUSTOM_ANI_STAGE_ATTACK_2]的動作后，發送“substate” = 3，銜接ANI-[CUSTOM_ANI_STAGE_ATTACK_3]）
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == 3)
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(0);//將向量寫入值“0” （*解釋：返回到substate = 0，重复第一次的动作）
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == 4)
	{
		obj.sq_setCustomHitEffectFileName
("Character/Mage/Effect/Animation/ATIceSword/x.ani");//在演出動畫結束時將受擊動畫指向到空的文件
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);//发送站立状态 （*解釋：中断重复动作）
	}
}

function onProc_Zskill00(obj)
{
	local HitCount = obj.getVar().getInt(0);
	local maxHitCount = obj.sq_GetIntData(SKILL_ZSKILL00, 0); // 读取SKL静态数据“0”
	print(" maxHitCount:" + maxHitCount);
	print(" Count:" + HitCount);
	if(HitCount >= maxHitCount)//當設置技能的“substate”狀態 等于 = 0 時，執行下列向量寫入
		{
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);//发送站立状态 （*解釋：中断重复动作）
		}
		local substate = obj.getSkillSubState();//獲取當前技能的SUB狀態
		if(substate <= 3)
		{
			if (sq_IsKeyDown(OPTION_HOTKEY_JUMP, ENUM_SUBKEY_TYPE_ALL))
			{

			sq_setFullScreenEffect(obj,"Character/Priest/Effect/Animation/execution/grabEx/finish.ani");	
			obj.sq_IntVectClear();//清除向量
			obj.sq_IntVectPush(4);//將向量寫入值“0” （*解釋：返回到substate = 0，重复第一次的动作）
			obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
			}
		}
}
