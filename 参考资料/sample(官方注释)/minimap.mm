[world]
	[index]	1									// ���� �ε���
	[level]	40	50								// ��õ ����/�ְ�
	[point]	1	1								// �̴ϸ� ��ǥ ��(x,y)
[/world]

[town]
	[index] 1									// Ÿ�� �ε���
	[area]
		[index]	2								// area �ε���
		[type]	1								// area type   0 �Ϲ�, 1 ����Ʈ, 2 ������, 3 ����, 4 ���� �Ա�
		[real rect]		1	1	100	100			// ���� �����ϼ� �ִ� ���� ����/�� ��(x,y)	
		[project rect]	1	1	10	10			// �̴ϸ� ��ǥ ����/ ����(x,y)
		[npc]			10	10	20				// npc index, x, y
	[/area]
[/town]


[npc]
	[index] 1									// npc index
	[name]	`����`								// npc name
	[role]
		`[item shop]`
		`[recover stamina]`
		`[sera shop]`
		`[guild]`
		`[upgrade item]`
		`[disjoint item]`
		`[product item]`
		`[mouse register]`		// ������ �߰��Ͽ���
	[/role]
	[shop] 2									// shop type(0 WEAPON_SHOP, 1 ARMOR_SHOP, 2 ACCESSORY_SHOP, 3 MATERIAL_SHOP, 4 WASTE_SHOP, 5 LOTTERY_SHOP, 6 ARTIFACT_SHOP
		[level]	30	40							// minimum level, maximum level
		[job]	0	1	2	[/job]				// 0�˻�, 1�ݰ�, 2�ų�, 3����, 4����
	[/shop]
	[skill]	5									// 0�˻�, 1�ݰ�, 2�ų�, 3����, 4����, 5���ų�, 6����, 7����, 8���
[/npc]
