function sq_AddFunctionName(appendage) {
	appendage.sq_AddFunctionName("proc", "proc_appendage_monster_blood")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_monster_blood")
	appendage.sq_AddFunctionName("onAttackParent", "onAttackParent_appendage_monster_blood")
}

function proc_appendage_monster_blood(appendage) {

	if (!appendage) {
		return;
	}

	local parentObj = appendage.getParent();
	local sourceObj = appendage.getSource();
	parentObj = sq_GetCNRDObjectToSQRCharacter(parentObj);

	local target = appendage.getVar("damagerHPHP").get_vector(1);
	local object = sq_GetObjectByObjectId(parentObj, target);
	object = sq_GetCNRDObjectToActiveObject(object);
	if (!object) return;
	local currhp = object.getHp();
	if (currhp <= 0) {
		appendage.getVar("damagerSta").set_vector(0, 1);
	}
	else {
		appendage.getVar("damagerSta").set_vector(0, 0);
	}

}

function onAttackParent_appendage_monster_blood(appendage, realAttacker, damager, boundingBox, isStuck) {
	if (!appendage) {
		return;
	}
	local parentObj = appendage.getParent();
	local sourceObj = appendage.getSource();
	parentObj = sq_GetCNRDObjectToSQRCharacter(parentObj);

	local object = sq_GetCNRDObjectToActiveObject(damager);
	local id = sq_GetObjectId(object);
	appendage.getVar("damagerSta").set_vector(1, id);

}

function onStart_appendage_monster_blood(appendage) {
	if (!appendage) {
		return;
	}

	local parentObj = appendage.getParent();
	local sourceObj = appendage.getSource();
	parentObj = sq_GetCNRDObjectToSQRCharacter(parentObj);

	appendage.getVar("damagerSta").clear_vector();
	appendage.getVar("damagerSta").push_vector(0);
	appendage.getVar("damagerSta").push_vector(0);
}