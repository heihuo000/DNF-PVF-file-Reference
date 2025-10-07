
APID_ZSKILL00				<- 243	

function checkExecutableSkill_Zskill00(obj)  
{
	if (!obj) return false;
	
	local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);
	
	if (isUse) 
	{

	local isAppendApd = CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/thief/zskill00/ap_buffzskill00.nut");//判断ap附加
	if(!isAppendApd)//没有附加时，buff动作
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(0);//將向量寫入值“0”
		obj.sq_AddSetStatePacket(STATE_ZSKILL00 , STATE_PRIORITY_IGNORE_FORCE, true);//發送“STATE_ZSKILL00”狀態
		return true;
	}
	if(isAppendApd)//有附加时，攻击动作生成魔法旋风
	{
		obj.sq_IntVectClear();//清除向量
		obj.sq_IntVectPush(1);//將向量寫入值“1”
		obj.sq_AddSetStatePacket(STATE_ZSKILL00 , STATE_PRIORITY_IGNORE_FORCE, true);//發送“STATE_ZSKILL00”狀態
		return true;
	}
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
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_1);	//調用動作 1

		local skill = sq_GetSkill(obj, SKILL_ZSKILL00);//獲取技能指向
		local skill_level = sq_GetSkillLevel(obj, SKILL_ZSKILL00);;//獲取技能等級
		
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_ZSKILL00, false,
		 "character/thief/zskill00/ap_buffzskill00.nut", false);//指向AP附屬物路徑

		appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_ZSKILL00, skill_level);//設置buff存在時，左下角顯示圖標。
		
		CNSquirrelAppendage.sq_AppendAppendageID(appendage, obj, obj, APID_ZSKILL00, true);//附加AP的獨立ID編號 “APID_ZSKILL00	<- 243	“ 為了不使其與別的buff技能沖突
		
		appendage = obj.GetSquirrelAppendage("character/thief/zskill00/ap_buffzskill00.nut");//判斷 當AP等于 獲取到的正確的ap時
		
		if(appendage)
		{
			appendage.sq_SetValidTime(60000);//ap存在時間即BUFF存在時間。
			local PHYSICAL_ATTACK = 500;//力量增加值
			local MAGICAL_ATTACK = 500;//智力增加值
			local change_appendage = appendage.sq_getChangeStatus("zskill00");//獲取變化狀態
			if(!change_appendage)//當不為狀態變化時，添加狀態變化的ID
			{
				change_appendage = appendage.sq_AddChangeStatusAppendageID(obj, obj, 0, 
				CHANGE_STATUS_TYPE_PHYSICAL_ATTACK, 
				false, PHYSICAL_ATTACK, APID_COMMON);//物理攻擊
				change_appendage = appendage.sq_AddChangeStatusAppendageID(obj, obj, 0, 
				CHANGE_STATUS_TYPE_MAGICAL_ATTACK, 
				false, MAGICAL_ATTACK, APID_COMMON);//魔法攻擊
			}
			if(change_appendage) //當為狀態變化時
			{
				change_appendage.clearParameter();//清除參數
				change_appendage.addParameter(CHANGE_STATUS_TYPE_PHYSICAL_ATTACK, false, PHYSICAL_ATTACK.tofloat());//附加參數 -物理攻擊
				change_appendage.addParameter(CHANGE_STATUS_TYPE_MAGICAL_ATTACK, false, MAGICAL_ATTACK.tofloat());//附加參數 -魔法攻擊
			}
		}

	}


	if(substate == 1)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_0);	//調用動作 1
		obj.sq_SendCreatePassiveObjectPacket(24201, 0, 120, 1, 0);//魔法旋风
	}
}




function onEndCurrentAni_Zskill00(obj)
{
	if(!obj) return;
	local substate = obj.getSkillSubState();//獲取當前技能的SUB狀態

	if(substate == 0)//當設置技能的“substate”狀態 等于 = 0 時，執行下列向量寫入
	{
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, true);//演出結束后，恢復站立。
	}
	if(substate == 1)//當設置技能的“substate”狀態 等于 = 0 時，執行下列向量寫入
	{
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, true);//演出結束后，恢復站立。
	}
}


