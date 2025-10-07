
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_thief_skill00")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_thief_skill00")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_thief_skill00")
}


function sq_AddEffect(appendage)
{
	if(!appendage)
		return;
	appendage.sq_AddEffectFront("Character/Mage/Effect/Animation/ATManaBurst/00_mana_dodge_loop.ani")
	appendage.sq_AddEffectBack("character/mage/effect/animation/atmagicshield/00_shield_none_dodge.ani")
	appendage.sq_AddEffectFront("character/mage/effect/animation/atmagicshield/01_shield_none_dodge.ani")

}



function onStart_appendage_thief_skill00(appendage)
{
	if(!appendage) 
	{
		return;
	}


	local obj = appendage.getParent();		


}


function onEnd_appendage_thief_skill00(appendage)
{
	if(!appendage) 
	{
		return;
	}


}


function isEnd_appendage_thief_skill00(appendage)
{
	if(!appendage)
		return false;
		


	return false;
}