APID_ZSKILL00				<- 243	

function ProcPassiveSkill_Thief(obj, skill_index, skill_level)
{
	if (skill_index == SKILL_ZSKILL00)
	{

		if(skill_level > 0)
		{

		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skill_index, false, "character/thief/zskill00/ap_buffzskill00.nut", true);

		if(appendage)
			{
				//appendage.sq_SetValidTime(60000);//ap存在時間即BUFF存在時間。
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
	}

}