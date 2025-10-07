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

	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,SPEED_VALUE_DEFAULT,
	 SPEED_VALUE_DEFAULT, 1.0, 1.0);//�Ϩ���t�X�t�ר������t�׼v�T
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);//�]�m����ե�(CUSTOM_ATK_01)���V��AtK�ƾ�
	local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00 , STATE_ZSKILL00, 0, 1.0);//�w�q�ˮ`�ʤ���]�ޯ�s���A�ޯબ�A�A�����ʺA�ƾڸ���A�ޯ�ˮ`���v�^
	obj.sq_SetCurrentAttackBonusRate(damage);//�]�m�ˮ`�ʤ���

//---------�ᨽ�J��-------
obj.sq_setCustomHitEffectFileName
("Character/Mage/Effect/Animation/ATIceSword/05_2_smoke_dodge .ani");//������쪺�����[�@�Ӱʵe�ĪG
obj.sq_SetShake(obj,2,150);//�_��
sq_flashScreen(obj, 30, 30, 30, 200, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);//�{��
}

function onAttack_Zskill00(obj, damager, boundingBox, isStuck)//������R������H
{
	if (!obj || !damager) return;
	
	sq_EffectLayerAppendage(damager,sq_RGB(46, 204, 113),150,0,0,240);	//������R������H�|�[�@�h�C�����
}



function onEndCurrentAni_Zskill00(obj)//ANI�t�X����
{
	//����ϥ�(CUSTOM_ANI_01)��ANI�ʧ@�t�X�����Z�A�o�e��STATE_STAND�����A�A�]�N�O��(CUSTOM_ANI_01�^�ʧ@���槹�N��_���ߪ����A�F
obj.sq_setCustomHitEffectFileName
("Character/Mage/Effect/Animation/ATIceSword/x.ani");//�b�t�X�ʵe�����ɱN�����ʵe���V��Ū����
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

