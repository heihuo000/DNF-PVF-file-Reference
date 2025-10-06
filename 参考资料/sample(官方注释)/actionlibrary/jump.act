[MOTION]
[BASE ANI] `../Animation_Kinol/Attack1.ani`
[SUB ANI]
`../../../equipment/monster/goblin/LKinolPantsAnimation/attack1_100.ani` 0 100
`../../../equipment/monster/goblin/weapon09-animation/attack1_100.ani` 0 200
[/SUB ANI]
[/MOTION]
//[DEFAULT ATTACKINFO]	`../AttackInfo/Attack2.atk`


[TRIGGER] // 0
[FRAME] 0 0
[ZPOS] [<=] 0
[DO BEHAVIOR] [ME] 0 
[/TRIGGER]
[BEHAVIOR] // 0
	[SET SPEED]
	[X AXIS] 500
	[Z AXIS] 300
	[/SET SPEED]
[/BEHAVIOR] 


[TRIGGER] // 1
[FRAME] 3 3
[ZPOS] [>] 0
[DO BEHAVIOR] [ME] 1
[/TRIGGER]
[BEHAVIOR] // 1
	[SET SPEED]
	[Z AXIS] 0
	[/SET SPEED]
	[TRIGGER] 2 [ON]
[/BEHAVIOR] 

[TRIGGER] // 2
	[ENABLE] [OFF]
	//[CHECK] [ME]
	[ZSPEED] [<] 0
	[ZPOS] [<=] 0
	//[/CHECK]
[DO BEHAVIOR] [ME] 2
[/TRIGGER]
[BEHAVIOR] // 1
	[SET SPEED]
	[X AXIS] 0
	[Y AXIS] 0
	[/SET SPEED]
	[TRIGGER] 2 [OFF]
[/BEHAVIOR] 