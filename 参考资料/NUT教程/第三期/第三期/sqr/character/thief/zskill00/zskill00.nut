function checkExecutableSkill_Zskill00(obj)  
{
	if (!obj) return false;
	
	local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);
	
	if (isUse) 
	{
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

	if(substate == 0)//��]�m�ޯ઺��substate�����A ���_ = 0 �ɡA����U�CANI�ʧ@
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_0);	//�եΰʧ@ 1
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT,
	 SPEED_VALUE_DEFAULT, 1.0, 1.0);//�Ϩ���t�X�t�ר������t�׼v�T
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//�]�m����ե�(CUSTOM_ATK_01)���V��AtK�ƾ�
	local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//�w�q�ˮ`�ʤ���]�ޯ�s���A�ޯબ�A�A�����ʺA�ƾڸ���A�ޯ�ˮ`���v�^
	obj.sq_SetCurrentAttackBonusRate(damage);//�]�m�ˮ`�ʤ���

	}
	else if(substate == 1)//��]�m�ޯ઺��substate�����A ���_ = 1 �ɡA����U�CANI�ʧ@
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_STAGE_ATTACK_1);	//�եΰʧ@ 2
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_02);//�]�m����ե�(CUSTOM_ATK_01)���V��AtK�ƾ�
	local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//�w�q�ˮ`�ʤ���]�ޯ�s���A�ޯબ�A�A�����ʺA�ƾڸ���A�ޯ�ˮ`���v�^
	obj.sq_SetCurrentAttackBonusRate(damage);//�]�m�ˮ`�ʤ���

	}

}


function onAttack_Zskill00(obj, damager, boundingBox, isStuck)//������쪺���

{
	if(!obj)
		return false;
	local substate = obj.getSkillSubState();//����H����sub state���A

	if(substate == 0)//�b�ʧ@ 1 �����쪺���� ���[AP���
	{
		damager.setCurrentDirection(sq_GetDirection(obj));

		local masterAppendage = CNSquirrelAppendage.sq_AppendAppendage(damager, obj, SKILL_ZSKILL00, false,
		"character/thief/zskill00/ap_zskill00.nut", true);//�ޥ�AP��󪺫��V

		if(masterAppendage) //�P�_��AP�����A�X�o�ĪG
		{
			masterAppendage.sq_SetValidTime(500);//ap����ɶ�
			sq_MoveToAppendageForce(damager, obj, obj, 100, 0, 0, 150, true, masterAppendage);//�N��AP�ЧӪ����A�Ԩ���H���e��100px����m
		}
	
	}
	if(substate == 1)//�b�ʧ@ 2 �����쪺����
	{
		damager.setCurrentDirection(sq_GetOppositeDirection(obj.getDirection()));
		if(damager)//�P�_�O�ˮ`����H
		CNSquirrelAppendage.sq_RemoveAppendage(damager, "character/thief/zskill00/ap_zskill00.nut");//�ĤG�������ɡA�M��ap�ЧӡC
			obj.sq_SetShake(obj,5,120);//�_��
			sq_setFullScreenEffect(obj,"Character/Priest/Effect/Animation/execution/grabEx/finish.ani");	
	}
}


function onEndCurrentAni_Zskill00(obj)
{
	if(!obj) return;
	local substate = obj.getSkillSubState();//�����e�ޯ઺SUB���A

	if(substate == 0)//��]�m�ޯ઺��substate�����A ���_ = 0 �ɡA����U�C�V�q�g�J
	{
		obj.sq_IntVectClear();//�M���V�q
		obj.sq_IntVectPush(1);//�N�V�q�g�J�ȡ�1�� �]*�����G�b���槹ANI-[CUSTOM_ANI_STAGE_ATTACK_0]���ʧ@�Z�A�o�e��substate�� = 1�A�α�ANI-[CUSTOM_ANI_STAGE_ATTACK_1]�^
		obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_IGNORE_FORCE, true);//�o�e��STATE_ZSKILL00�����A
	}
	else if(substate == 1)
	{
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, true);//�t�X�����Z�A��_���ߡC
	}
	
}


function getScrollBasisPos_Zskill00(obj)
{
	
	if(!obj) return;
	local substate = obj.getSkillSubState();//�����e�ޯ઺SUB���A
	
	if (obj.isMyControlObject())//
	{
		local xPos = obj.getXPos();//�����e�H����x�b����
		local distance = 150;//���Y���ʶZ��
		local destX = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), distance);//�p���V�����Z��
		local speedrate = 300;//���Y���ʳt�v�A�ƭȶV���A���ʪ��V��
		if(substate == 0)//��ʧ@ 1�ɡAĲ�o
		{
			local stateTimer = obj.sq_GetStateTimer();//�p��substate = 0 �����A�ɶ�
			xPos = sq_GetUniformVelocity(xPos, destX, stateTimer, speedrate);//�p�����Y�V�e�貾�ʪ����ót�ס]��l�Z���B�̲׶Z���B�ݭn���ɶ��B���ʳt�v�^�F
		print(" xPos:" + xPos);	print(" stateTimer:" + stateTimer);
		}
		else if(substate == 1)//��ʧ@ 2�ɡAĲ�o
		{
			local stateTimer = obj.sq_GetStateTimer();//�p��substate = 0 �����A�ɶ�
			xPos = sq_GetUniformVelocity(destX, xPos, stateTimer, speedrate);////�p�����Y�V�e�貾�ʪ����ót��
		}
		else
		{
			xPos = destX;//�^��̤j������V
		}
		obj.sq_SetCameraScrollPosition(xPos, obj.getYPos(), 0);//�ھګe�����P�_�N���P���ƾڶǻ������Y���ʥN�X���C*�ѼơG�]�ót��o�����СB�H����e�����СB�����^
		
		return true;
	}
	
	return false;
}
