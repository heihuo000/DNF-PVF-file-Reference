[world]
	[index]	1									// 월드 인덱스
	[level]	40	50								// 추천 최저/최고렙
	[point]	1	1								// 미니맵 좌표 점(x,y)
[/world]

[town]
	[index] 1									// 타운 인덱스
	[area]
		[index]	2								// area 인덱스
		[type]	1								// area type   0 일반, 1 게이트, 2 낚시터, 3 주점, 4 던전 입구
		[real rect]		1	1	100	100			// 실제 움직일수 있는 범위 시작/끝 점(x,y)	
		[project rect]	1	1	10	10			// 미니맵 좌표 시작/ 끝점(x,y)
		[npc]			10	10	20				// npc index, x, y
	[/area]
[/town]


[npc]
	[index] 1									// npc index
	[name]	`집샤`								// npc name
	[role]
		`[item shop]`
		`[recover stamina]`
		`[sera shop]`
		`[guild]`
		`[upgrade item]`
		`[disjoint item]`
		`[product item]`
		`[mouse register]`		// 집샤가 추가하였음
	[/role]
	[shop] 2									// shop type(0 WEAPON_SHOP, 1 ARMOR_SHOP, 2 ACCESSORY_SHOP, 3 MATERIAL_SHOP, 4 WASTE_SHOP, 5 LOTTERY_SHOP, 6 ARTIFACT_SHOP
		[level]	30	40							// minimum level, maximum level
		[job]	0	1	2	[/job]				// 0검사, 1격가, 2거너, 3법사, 4프리
	[/shop]
	[skill]	5									// 0검사, 1격가, 2거너, 3법사, 4프리, 5여거너, 6공통, 7훔쳐, 8길드
[/npc]
