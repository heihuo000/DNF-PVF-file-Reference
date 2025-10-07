//蝏?芰銵??
function drawMonsterBlood(obj) {
	if (!obj || sq_GetCurrentModuleType() != 3) return;

	if (!CNSquirrelAppendage.sq_IsAppendAppendage(obj, "yusheng_1535201866/monster_blood/ap_monster_blood.nut")) {
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, 174, false, "yusheng_1535201866/monster_blood/ap_monster_blood.nut", true);
	}

	local appendage = obj.GetSquirrelAppendage("yusheng_1535201866/monster_blood/ap_monster_blood.nut");
	local target = appendage.getVar("damagerSta").get_vector(1);
	local object = sq_GetObjectByObjectId(obj, target);
	object = sq_GetCNRDObjectToActiveObject(object);

	local stage = sq_GetGlobaludpModuleStage();
	if (!stage) return hp;
	local dungeon = sq_GetDungeonByStage(stage);
	local dungeonIndex = sq_GetDuegonIndex(dungeon);

	if (object && !object.isDead() && object.isBoss()) {
		drawBossWarnEffect(obj, object);
		drawMonsterBloodEffect(obj, object, target);
	}
	drawMonsterActiveEffect(obj, object);
}

//蝏???内??瘜?呛?蝷?
function drawBossWarnEffect(obj, object) {
	if (!object.isInDamagableState(obj)) {
		local ani = obj.getVar().GetAnimationMap("invincibility_back", "common/monster/blood_warn/invincibility_back.ani");

		if (sq_IsEnd(ani)) sq_Rewind(ani);
		sq_AnimationProc(ani);
		sq_drawCurrentFrame(ani, 35, 98, false);

		ani = obj.getVar().GetAnimationMap("invincibility", "common/monster/blood_warn/invincibility.ani");
		sq_DrawSpecificFrame(ani, 0, 99, false, 0, false, 1.0);
	} else if (!sq_IsGrabable(obj, object)) {
		local ani = obj.getVar().GetAnimationMap("holding_back", "common/monster/blood_warn/holding_back.ani");

		if (sq_IsEnd(ani)) sq_Rewind(ani);
		sq_AnimationProc(ani);
		sq_drawCurrentFrame(ani, 35, 99, false);

		ani = obj.getVar().GetAnimationMap("holding", "common/monster/blood_warn/holding.ani");
		sq_DrawSpecificFrame(ani, 0, 99, false, 0, false, 1.0);
	}
}

//蝏銵?饼?
function drawMonsterBloodEffect(obj, object, target) {
	local var = obj.getVar();
	local start_x = object.isBoss() ? 34 : 31;
	local start_y = 128;

	local black = var.GetAnimationMap("black", "common/monster/blood_black.ani");
	sq_DrawSpecificFrame(black, start_x, start_y, false, 0, false, 1.0);

	local cur_clip = start_x;
	local red = var.GetAnimationMap("red", "common/monster/blood_red.ani");

	if (object.getHp() > 0) {
		local hpRate = object.getHp().tofloat() / object.getHpMax().tofloat();
		cur_clip += (538.0 * hpRate).tointeger();
	}

	setClip(start_x, 120, cur_clip, 140);
	sq_DrawSpecificFrame(red, start_x, start_y, false, 0, false, 1.0);
	releaseClip();

	local record = object.getVar("record_clip");
	local size = record.size_vector();

	if (size == 0) record.push_vector(cur_clip);
	else if (cur_clip < record.get_vector(size - 1)) record.push_vector(cur_clip);

	local v = 0;
	local white = null;
	local next_clip = 0;
	local before_clip = 0;
	for (local i = size - 1; i >= 0; i--) {
		white = var.GetAnimationMap(target + "_white_" + i, "common/monster/blood_white.ani");

		if (sq_IsEnd(white)) break;

		before_clip = record.get_vector(i);
		if (i == 0) next_clip = start_x + 543;
		else next_clip = record.get_vector(i - 1);

		v = sq_GetAccel(255, 0, sq_GetCurrentTime(white), 600, true);
		white.setRGBA(255, v, v, v);

		setClip(before_clip, 120, next_clip, 140);
		sq_AnimationProc(white);
		sq_DrawSpecificFrame(white, start_x, start_y, false, 0, false, 1.0);
		releaseClip();
	}
}

//蝏撘虏?呛?
function drawMonsterActiveEffect(obj, object) {
	if (!object) return;

	local x = 10;
	local y = object.isBoss() ? 132 : 127;
	local active;

	local var = obj.getVar();
	local atkFlag = obj.getVar("activeAtk").getInt(0) == 1;
	obj.getVar("activeAtk").setInt(0, 0);

	local activeNumber = object.getVar("activeNumber");

	if (sq_IsValidActiveStatus(object, 0)) {
		x += 20
		active = var.GetAnimationMap("active0", "common/monster/activestatus/icon/slow.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);

		if (atkFlag) activeNumber.setInt(0, 1);
	}
	if (sq_IsValidActiveStatus(object, 1)) {
		x += 20
		active = var.GetAnimationMap("active1", "common/monster/activestatus/icon/freeze.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);

		if (atkFlag) activeNumber.setInt(1, 1);
	}
	if (sq_IsValidActiveStatus(object, 2)) {
		x += 20
		active = var.GetAnimationMap("active2", "common/monster/activestatus/icon/poison.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);

		if (atkFlag) activeNumber.setInt(2, 1);
	}
	if (sq_IsValidActiveStatus(object, 3)) {
		x += 20
		active = var.GetAnimationMap("active3", "common/monster/activestatus/icon/stun.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);

		if (atkFlag) activeNumber.setInt(3, 1)
	}
	if (sq_IsValidActiveStatus(object, 4)) {
		x += 20
		active = var.GetAnimationMap("active4", "common/monster/activestatus/icon/curse.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);

		if (atkFlag) activeNumber.setInt(4, 1);
	}
	if (sq_IsValidActiveStatus(object, 5)) {
		x += 20
		active = var.GetAnimationMap("active5", "common/monster/activestatus/icon/blind.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);

		if (atkFlag) activeNumber.setInt(5, 1);
	}
	if (sq_IsValidActiveStatus(object, 6)) {
		x += 20
		active = var.GetAnimationMap("active6", "common/monster/activestatus/icon/lightning.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);

		if (atkFlag) activeNumber.setInt(6, 1);
	}
	if (sq_IsValidActiveStatus(object, 7)) {
		x += 20
		active = var.GetAnimationMap("active7", "common/monster/activestatus/icon/stone.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);

		if (atkFlag) activeNumber.setInt(7, 1);
	}
	if (sq_IsValidActiveStatus(object, 8)) {
		x += 20
		active = var.GetAnimationMap("active8", "common/monster/activestatus/icon/sleep.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);

		if (atkFlag) activeNumber.setInt(8, 1);
	}
	if (sq_IsValidActiveStatus(object, 9)) {
		x += 20
		active = var.GetAnimationMap("active9", "common/monster/activestatus/icon/burn.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);
		if (atkFlag) activeNumber.setInt(9, 1);
	}
	if (sq_IsValidActiveStatus(object, 10)) {
		x += 20
		active = var.GetAnimationMap("active10", "common/monster/activestatus/icon/weaponbreak.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);
		if (atkFlag) activeNumber.setInt(10, 1);
	}
	if (sq_IsValidActiveStatus(object, 11)) {
		x += 20
		active = var.GetAnimationMap("active11", "common/monster/activestatus/icon/bleeding.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);

		if (atkFlag) activeNumber.setInt(11, 1);
	}
	if (sq_IsValidActiveStatus(object, 15)) {
		x += 20
		active = var.GetAnimationMap("active15", "common/monster/activestatus/icon/confuse.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);
		if (atkFlag) activeNumber.setInt(15, 1);
	}
	if (sq_IsValidActiveStatus(object, 16)) {
		x += 20
		active = var.GetAnimationMap("active16", "common/monster/activestatus/icon/hold.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);
		if (atkFlag) activeNumber.setInt(16, 1);
	}
	if (sq_IsValidActiveStatus(object, 17)) {
		x += 20
		active = var.GetAnimationMap("active17", "common/monster/activestatus/icon/armorbreak.ani");
		sq_DrawSpecificFrame(active, x, y, false, 0, false, 1.0);
		if (atkFlag) activeNumber.setInt(17, 1);
	}

	local mActive;
	local screenX = sq_GetScreenXPos(object);
	local screenY = sq_GetScreenYPos(object) - object.getObjectHeight() / 2;
	if (activeNumber.getInt(0) == 1) {
		mActive = var.GetAnimationMap("m_act0", "common/monster/activestatus/slow.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(0, 0);
		}
	}
	if (activeNumber.getInt(1) == 1) {
		mActive = var.GetAnimationMap("m_act1", "common/monster/activestatus/freeze.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(1, 0);
		}
	}
	if (activeNumber.getInt(2) == 1) {
		mActive = var.GetAnimationMap("m_act2", "common/monster/activestatus/poison.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(2, 0);
		}
	}
	if (activeNumber.getInt(3) == 1) {
		mActive = var.GetAnimationMap("m_act3", "common/monster/activestatus/stun.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(3, 0);
		}
	}
	if (activeNumber.getInt(4) == 1) {
		mActive = var.GetAnimationMap("m_act4", "common/monster/activestatus/curse.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(4, 0);
		}
	}
	if (activeNumber.getInt(5) == 1) {
		mActive = var.GetAnimationMap("m_act5", "common/monster/activestatus/blind.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(5, 0);
		}
	}
	if (activeNumber.getInt(6) == 1) {
		mActive = var.GetAnimationMap("m_act6", "common/monster/activestatus/lighting.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(6, 0);
		}
	}
	if (activeNumber.getInt(7) == 1) {
		mActive = var.GetAnimationMap("m_act7", "common/monster/activestatus/stone.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(7, 0);
		}
	}
	if (activeNumber.getInt(8) == 1) {
		mActive = var.GetAnimationMap("m_act8", "common/monster/activestatus/sleep.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(8, 0);
		}
	}
	if (activeNumber.getInt(9) == 1) {
		mActive = var.GetAnimationMap("m_act9", "common/monster/activestatus/burn.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(9, 0);
		}
	}
	if (activeNumber.getInt(10) == 1) {
		mActive = var.GetAnimationMap("m_act10", "common/monster/activestatus/weaponbreak.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(10, 0);
		}
	}
	if (activeNumber.getInt(11) == 1) {
		mActive = var.GetAnimationMap("m_act11", "common/monster/activestatus/bleeding.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(11, 0);
		}
	}
	if (activeNumber.getInt(15) == 1) {
		mActive = var.GetAnimationMap("m_act15", "common/monster/activestatus/confuse.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(15, 0);
		}
	}
	if (activeNumber.getInt(16) == 1) {
		mActive = var.GetAnimationMap("m_act16", "common/monster/activestatus/hold.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(16, 0);
		}
	}
	if (activeNumber.getInt(17) == 1) {
		mActive = var.GetAnimationMap("m_act17", "common/monster/activestatus/armorbreak.ani");
		if (!sq_IsEnd(mActive)) {
			sq_AnimationProc(mActive);
			sq_drawCurrentFrame(mActive, screenX, screenY, false);
		} else {
			sq_Rewind(mActive);
			activeNumber.setInt(17, 0);
		}
	}
}