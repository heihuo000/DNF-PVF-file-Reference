function checkExecutableSkill_Zskill00(obj)  
{
	if (!obj) return false;
	
	local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);
	
	if (isUse) 
	{
		obj.getVar().setInt(0,0);//�]�w��l�ƭȬ�0
		obj.sq_IntVectClear();//�M���V�q
		obj.sq_IntVectPush(0);//�N�V�q�g�J�ȡ�0��
		obj.sq_AddSetStatePacket(STATE_ZSKILL00 , STATE_PRIORITY_IGNORE_FORCE, true);//�o�e��STATE_ZSKILL00�����A
		return true;
	}
	return false;
}

function checkCommandEnable_Zskill00(obj)//�ˬd����}��
{
	if (!obj) return false;
	local state = obj.sq_GetState();//�����e���⪺���A
	
	if (state == STATE_STAND)//������⪺���A ���_�����ߡ���
	
		return true;//��^ [�u],�]�N�O���i�H�ϥΧޯ� �Y�� [��]�ɡA�N�|����ϥΡF
	
	return true;
}

function onSetState_Zskill00(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	
	local substate = obj.sq_GetVectorData(datas, 0);//������e�w�q�n���V�q�ƾ�
	obj.setSkillSubState(substate);//�]�m�ޯ઺��substate�����A
	
	obj.sq_StopMove();//�����
obj.sq_SetShake(obj,2,50);//�_��
sq_flashScreen(obj, 15, 15, 15, 200, sq_RGB(255,255,255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);//�{��
	if(substate == 0)//��]�m�ޯ઺��substate�����A ���_ = 0 �ɡA����U�CANI�ʧ@
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_0);	//�եλȤ봶��ʧ@-1�ʧ@
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//��������t�׼v�T
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//�]�m����ե�(CUSTOM_ATK_01)���V��AtK�ƾ�
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//�w�q�ˮ`�ʤ���]�ޯ�s���A�ޯબ�A�A�����ʺA�ƾڸ���A�ޯ�ˮ`���v�^
		obj.sq_SetCurrentAttackBonusRate(damage);//�]�m�ˮ`�ʤ���
		
	}
	else if(substate == 1)//��]�m�ޯ઺��substate�����A ���_ = 1 �ɡA����U�CANI�ʧ@
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_1);	//�եλȤ봶��ʧ@-2�ʧ@
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//��������t�׼v�T
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//�]�m����ե�(CUSTOM_ATK_01)���V��AtK�ƾ�
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.5);//�w�q�ˮ`�ʤ���]�ޯ�s���A�ޯબ�A�A�����ʺA�ƾڸ���A�ޯ�ˮ`���v�^
		obj.sq_SetCurrentAttackBonusRate(damage);//�]�m�ˮ`�ʤ���
	}
	else if(substate == 2)//��]�m�ޯ઺��substate�����A ���_ = 2 �ɡA����U�CANI�ʧ@
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_2);	//�եλȤ봶��ʧ@-3�ʧ@
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//��������t�׼v�T
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//�]�m����ե�(CUSTOM_ATK_01)���V��AtK�ƾ�
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 2.0);//�w�q�ˮ`�ʤ���]�ޯ�s���A�ޯબ�A�A�����ʺA�ƾڸ���A�ޯ�ˮ`���v�^
		obj.sq_SetCurrentAttackBonusRate(damage);//�]�m�ˮ`�ʤ���
	}
	else if(substate == 3)//��]�m�ޯ઺��substate�����A ���_ = 3 �ɡA����U�CANI�ʧ@
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_3);	//�եλȤ봶��ʧ@-4�ʧ@
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//��������t�׼v�T
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//�]�m����ե�(CUSTOM_ATK_01)���V��AtK�ƾ�
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 2.5);//�w�q�ˮ`�ʤ���]�ޯ�s���A�ޯબ�A�A�����ʺA�ƾڸ���A�ޯ�ˮ`���v�^
		obj.sq_SetCurrentAttackBonusRate(damage);//�]�m�ˮ`�ʤ���
	}
	else if(substate == 4)//��]�m�ޯ઺��substate�����A ���_ = 3 �ɡA����U�CANI�ʧ@
	{
			obj.sq_SetShake(obj,5,300);//�_��
			sq_flashScreen(obj, 100, 100, 100, 150, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);//�{��
			obj.sq_setCustomHitEffectFileName
("character/thief/effect/animation/silverstream/slashhitaddeffectspark1dodge.ani");//������쪺�����[�@�Ӱʵe�ĪG

		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_4);	//�եλȤ봶��ʧ@-4�ʧ@
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	//��������t�׼v�T
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_02);//�]�m����ե�(CUSTOM_ATK_01)���V��AtK�ƾ�
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 5.0);//�w�q�ˮ`�ʤ���]�ޯ�s���A�ޯબ�A�A�����ʺA�ƾڸ���A�ޯ�ˮ`���v�^
		obj.sq_SetCurrentAttackBonusRate(damage);//�]�m�ˮ`�ʤ���
	}
}

function onEndCurrentAni_Zskill00(obj)
{
	
	local substate = obj.getSkillSubState();//�����e�ޯ઺SUB���A
	local HitCount = obj.getVar().getInt(0);//�����e��
	obj.getVar().setInt(0,HitCount + 1);//�C�����@��ANI�ʧ@�ƭȥ[1
	if(substate == 0)//��]�m�ޯ઺��substate�����A ���_ = 0 �ɡA����U�C�V�q�g�J
	{
		obj.sq_IntVectClear();//�M���V�q
		obj.sq_IntVectPush(1);//�N�V�q�g�J�ȡ�1�� �]*�����G�b���槹ANI-[CUSTOM_ANI_STAGE_ATTACK_0]���ʧ@�Z�A�o�e��substate�� = 1�A�α�ANI-[CUSTOM_ANI_STAGE_ATTACK_1]�^
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);//�o�e��STATE_ZSKILL00�����A
	}
	else if(substate == 1)
	{
		obj.sq_IntVectClear();//�M���V�q
		obj.sq_IntVectPush(2);//�N�V�q�g�J�ȡ�2�� �]*�����G�b���槹ANI-[CUSTOM_ANI_STAGE_ATTACK_1]���ʧ@�Z�A�o�e��substate�� = 2�A�α�ANI-[CUSTOM_ANI_STAGE_ATTACK_2]�^
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == 2)
	{
		obj.sq_IntVectClear();//�M���V�q
		obj.sq_IntVectPush(3);//�N�V�q�g�J�ȡ�3�� �]*�����G�b���槹ANI-[CUSTOM_ANI_STAGE_ATTACK_2]���ʧ@�Z�A�o�e��substate�� = 3�A�α�ANI-[CUSTOM_ANI_STAGE_ATTACK_3]�^
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == 3)
	{
		obj.sq_IntVectClear();//�M���V�q
		obj.sq_IntVectPush(0);//�N�V�q�g�J�ȡ�0�� �]*�����G��^��substate = 0�A���_�Ĥ@�����ʧ@�^
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == 4)
	{
		obj.sq_setCustomHitEffectFileName
("Character/Mage/Effect/Animation/ATIceSword/x.ani");//�b�t�X�ʵe�����ɱN�����ʵe���V��Ū����
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);//�o�e���ߪ��A �]*�����G���_���_�ʧ@�^
	}
}

function onProc_Zskill00(obj)
{
	local HitCount = obj.getVar().getInt(0);
	local maxHitCount = obj.sq_GetIntData(SKILL_ZSKILL00, 0); // Ū��SKL�R�A�ƾڡ�0��
	print(" maxHitCount:" + maxHitCount);
	print(" Count:" + HitCount);
	if(HitCount >= maxHitCount)//��]�m�ޯ઺��substate�����A ���_ = 0 �ɡA����U�C�V�q�g�J
		{
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);//�o�e���ߪ��A �]*�����G���_���_�ʧ@�^
		}
		local substate = obj.getSkillSubState();//�����e�ޯ઺SUB���A
		if(substate <= 3)
		{
			if (sq_IsKeyDown(OPTION_HOTKEY_JUMP, ENUM_SUBKEY_TYPE_ALL))
			{

			sq_setFullScreenEffect(obj,"Character/Priest/Effect/Animation/execution/grabEx/finish.ani");	
			obj.sq_IntVectClear();//�M���V�q
			obj.sq_IntVectPush(4);//�N�V�q�g�J�ȡ�0�� �]*�����G��^��substate = 0�A���_�Ĥ@�����ʧ@�^
			obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);
			}
		}
}
