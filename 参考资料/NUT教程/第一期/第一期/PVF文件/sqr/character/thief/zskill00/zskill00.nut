function checkExecutableSkill_Zskill00(obj)//�ˬd�ޯ�i�����
{
	if (!obj) return false;
	local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);//�ˬd�ޯ઺�O�_�i�ϥ�
	
	if (isUse) //�ŦX����
	{
		obj.sq_AddSetStatePacket(STATE_ZSKILL00 , STATE_PRIORITY_USER, false);//�ŦX�i�ϥήɡA�o�e��STATE_ZSKILL00�����A
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

function onSetState_Zskill00(obj, state, datas, isResetTimer)//������ �o�e��STATE_ZSKILL00�����A �ɡAĲ�o���e�F
{	
	if(!obj) return;
	
	obj.sq_StopMove();//����⪺����
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);//�]�m����ϥ�(CUSTOM_ANI_01)���V��ANI�ʧ@
}

function onEndCurrentAni_Zskill00(obj)//ANI�t�X����
{
	//����ϥ�(CUSTOM_ANI_01)��ANI�ʧ@�t�X�����Z�A�o�e��STATE_STAND�����A�A�]�N�O��(CUSTOM_ANI_01�^�ʧ@���槹�N��_���ߪ����A�F
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

