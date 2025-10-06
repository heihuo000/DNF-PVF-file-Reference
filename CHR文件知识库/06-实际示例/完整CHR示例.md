# 完整CHR文件示例

## 概述

本文档提供了一个完整的CHR文件示例，展示了鬼剑士职业的完整配置，包括所有必要的标签和参数设置。

**重要提醒：本示例严格遵循PVF文件格式规范，使用制表符分隔参数，字符串使用反引号包围。**

## 完整CHR文件示例

### 基于真实CHR文件的标准格式

```
#PVF_File

[job]
	`[swordman]`

[growtype name]
	`鬼剑士`
	`剑魂`
	`鬼泣`
	`狂战士`
	`阿修罗`
	`剑影`

[width]
	40	10

[initial value]

[HP MAX]
	180.0

[MP MAX]
	140.0

[physical attack]
	7.5

[physical defense]
	7.5

[magical attack]
	4.5

[magical defense]
	4.5

[dark resistance]
	20.0

[light resistance]
	-20.0

[inventory limit]
	48000.0

[MP regen speed]
	50.0

[move speed]
	850.0

[attack speed]
	850.0

[cast speed]
	700.0

[hit recovery]
	600.0

[jump power]
	430.0

[weight]
	68000.0

[jump speed]
	95

[skill]
	181	2
	182	2
	184	1
	179	7
	5	1
	46	1
	169	1
	174	1
	254	1
[/skill]

[growtype 1]

[HP MAX]
	45.0

[MP MAX]
	25.0

[physical attack]
	4.8

[physical defense]
	4.8

[magical attack]
	4.2

[magical defense]
	4.2

[inventory limit]
	300.0

[MP regen speed]
	2.5

[hit recovery]
	1.5

[module damage rate]
	0.95	1.0	1.0	0.95

[awakening name]
	`剑影`
	`夜见罗刹`

[awakening 1]

[HP MAX]
	50.0

[MP MAX]
	20.0

[physical attack]
	5.0

[physical defense]
	5.0

[magical attack]
	4.0

[magical defense]
	4.0

[inventory limit]
	300.0

[MP regen speed]
	2.5

[hit recovery]
	2.0

[awakening skill]
	123	1	8	1	126	1	127	1	185	1	197	1	122	1
[/awakening skill]

[module damage rate]
	1.0	1.0	1.0	0.5

[awakening 2]

[HP MAX]
	50.0

[MP MAX]
	20.0

[physical attack]
	5.0

[physical defense]
	5.0

[magical attack]
	4.0

[magical defense]
	4.0

[inventory limit]
	300.0

[MP regen speed]
	2.5

[hit recovery]
	2.0

[awakening skill]
	123	1	8	1	126	1	127	1	209	1	185	1	197	1	122	1
[/awakening skill]

[module damage rate]
	1.0	1.0	1.0	0.5

[growtype 2]

[HP MAX]
	50.0

[MP MAX]
	20.0

[physical attack]
	5.0

[physical defense]
	5.0

[magical attack]
	4.0

[magical defense]
	4.0

[inventory limit]
	300.0

[MP regen speed]
	2.5

[hit recovery]
	2.0

[skill]
	27	1
	33	1
	37	1
	8	1
	25	1
	65	1
	94	1
	197	1
[/skill]

[module damage rate]
	0.7	1.0	1.1	0.7

[awakening name]
	`剑圣`
	`剑神`

[awakening 1]

[HP MAX]
	55.0

[MP MAX]
	25.0

[physical attack]
	5.5

[physical defense]
	5.5

[magical attack]
	4.5

[magical defense]
	4.5

[inventory limit]
	300.0

[MP regen speed]
	2.5

[hit recovery]
	2.5

[awakening skill]
	123	1	8	1	126	1	127	1	185	1	197	1	122	1	210	1
[/awakening skill]

[module damage rate]
	1.0	1.0	1.0	0.5

[awakening 2]

[HP MAX]
	55.0

[MP MAX]
	25.0

[physical attack]
	5.5

[physical defense]
	5.5

[magical attack]
	4.5

[magical defense]
	4.5

[inventory limit]
	300.0

[MP regen speed]
	2.5

[hit recovery]
	2.5

[awakening skill]
	123	1	8	1	126	1	127	1	209	1	185	1	197	1	122	1	211	1
[/awakening skill]

[module damage rate]
	1.0	1.0	1.0	0.5

[growtype 3]

[HP MAX]
	60.0

[MP MAX]
	30.0

[physical attack]
	6.0

[physical defense]
	6.0

[magical attack]
	5.0

[magical defense]
	5.0

[inventory limit]
	400.0

[MP regen speed]
	3.0

[hit recovery]
	3.0

[skill]
	27	1
	33	1
	37	1
	8	1
	25	1
	65	1
	94	1
	197	1
	210	1
[/skill]

[module damage rate]
	0.6	1.0	1.2	0.6

[awakening name]
	`剑神`
	`极·剑神`

[awakening 1]

[HP MAX]
	65.0

[MP MAX]
	35.0

[physical attack]
	6.5

[physical defense]
	6.5

[magical attack]
	5.5

[magical defense]
	5.5

[inventory limit]
	400.0

[MP regen speed]
	3.0

[hit recovery]
	3.5

[awakening skill]
	123	1	8	1	126	1	127	1	185	1	197	1	122	1	210	1	212	1
[/awakening skill]

[module damage rate]
	1.0	1.0	1.0	0.4

[awakening 2]

[HP MAX]
	65.0

[MP MAX]
	35.0

[physical attack]
	6.5

[physical defense]
	6.5

[magical attack]
	5.5

[magical defense]
	5.5

[inventory limit]
	400.0

[MP regen speed]
	3.0

[hit recovery]
	3.5

[awakening skill]
	123	1	8	1	126	1	127	1	209	1	185	1	197	1	122	1	211	1	213	1
[/awakening skill]

[module damage rate]
	1.0	1.0	1.0	0.4

[growtype 4]

[HP MAX]
	70.0

[MP MAX]
	40.0

[physical attack]
	7.0

[physical defense]
	7.0

[magical attack]
	6.0

[magical defense]
	6.0

[inventory limit]
	500.0

[MP regen speed]
	3.5

[hit recovery]
	4.0

[skill]
	27	1
	33	1
	37	1
	8	1
	25	1
	65	1
	94	1
	197	1
	210	1
	212	1
[/skill]

[module damage rate]
	0.5	1.0	1.3	0.5

[awakening name]
	`极·剑神`
	`真·剑神`

[awakening 1]

[HP MAX]
	75.0

[MP MAX]
	45.0

[physical attack]
	7.5

[physical defense]
	7.5

[magical attack]
	6.5

[magical defense]
	6.5

[inventory limit]
	500.0

[MP regen speed]
	3.5

[hit recovery]
	4.5

[awakening skill]
	123	1	8	1	126	1	127	1	185	1	197	1	122	1	210	1	212	1	214	1
[/awakening skill]

[module damage rate]
	1.0	1.0	1.0	0.3

[awakening 2]

[HP MAX]
	75.0

[MP MAX]
	45.0

[physical attack]
	7.5

[physical defense]
	7.5

[magical attack]
	6.5

[magical defense]
	6.5

[inventory limit]
	500.0

[MP regen speed]
	3.5

[hit recovery]
	4.5

[awakening skill]
	123	1	8	1	126	1	127	1	209	1	185	1	197	1	122	1	211	1	213	1	215	1
[/awakening skill]

[module damage rate]
	1.0	1.0	1.0	0.3

// 动作配置
[waiting motion]
	`character/swordman/animation/wait.ani`

[move motion]
	`character/swordman/animation/move.ani`

[sit motion]
	`character/swordman/animation/sit.ani`

[damage motion 1]
	`character/swordman/animation/damage1.ani`

[damage motion 2]
	`character/swordman/animation/damage2.ani`

[down motion]
	`character/swordman/animation/down.ani`

[overturn motion]
	`character/swordman/animation/overturn.ani`

[jump motion]
	`character/swordman/animation/jump.ani`

[jumpattack motion]
	`character/swordman/animation/jumpattack.ani`

[rest motion]
	`character/swordman/animation/rest.ani`

[throw motion 1-1]
	`character/swordman/animation/throw1_1.ani`

[throw motion 1-2]
	`character/swordman/animation/throw1_2.ani`

[throw motion 2-1]
	`character/swordman/animation/throw2_1.ani`

[throw motion 2-2]
	`character/swordman/animation/throw2_2.ani`

[dash motion]
	`character/swordman/animation/dash.ani`

[dashattack motion]
	`character/swordman/animation/dashattack.ani`

[getitem motion]
	`character/swordman/animation/getitem.ani`

[buff motion]
	`character/swordman/animation/buff.ani`

[simple rest motion]
	`character/swordman/animation/simple_rest.ani`

[simple move motion]
	`character/swordman/animation/simple_move.ani`

[back motion]
	`character/swordman/animation/back.ani`

[attack motion]
	`character/swordman/animation/attack.ani`

[ghost motion]
	`character/swordman/animation/ghost.ani`

[etc motion]
	`character/swordman/animation/etc.ani`

### 攻击信息配置
```
// 攻击信息文件
[attack info] attack1 `Attack1.atk`
[attack info] attack2 `Attack2.atk`
[attack info] attack3 `Attack3.atk`
[attack info] upper attack `UpperAttack.atk`
[attack info] down attack `DownAttack.atk`
[attack info] dash attack `DashAttack.atk`
[attack info] jump attack `JumpAttack.atk`

// 武器音效
[weapon sound] attack1 `sword_swing1.wav`
[weapon sound] attack2 `sword_swing2.wav`
[weapon sound] attack3 `sword_swing3.wav`
[weapon sound] upper attack `sword_upper.wav`
[weapon sound] down attack `sword_down.wav`
[weapon sound] dash attack `sword_dash.wav`
[weapon sound] jump attack `sword_jump.wav`

// 武器命中音效
[weapon hit sound] attack1 `sword_hit1.wav`
[weapon hit sound] attack2 `sword_hit2.wav`
[weapon hit sound] attack3 `sword_hit3.wav`
[weapon hit sound] upper attack `sword_hit_upper.wav`
[weapon hit sound] down attack `sword_hit_down.wav`
[weapon hit sound] dash attack `sword_hit_dash.wav`
[weapon hit sound] jump attack `sword_hit_jump.wav`

// 武器命中信息（攻击动作 命中类型 伤害倍率 击退距离 硬直时间 特殊效果）
[weapon hit info] attack1 normal 1.0 50 300 none
[weapon hit info] attack2 normal 1.2 70 400 none
[weapon hit info] attack3 normal 1.5 100 500 knockdown
[weapon hit info] upper attack normal 1.3 80 600 launch
[weapon hit info] down attack normal 1.8 120 800 knockdown
[weapon hit info] dash attack normal 2.0 150 1000 stun
[weapon hit info] jump attack normal 1.6 90 700 knockback

// 武器技能信息
[weapon skill info] 1001 1 100
[weapon skill info] 1002 1 120
[weapon skill info] 1003 1 150
```

## 文件结构说明

### 标签顺序规范
1. **基础信息**：job, growtype name, width, weight, category
2. **模块配置**：module damage rate
3. **初始属性**：initial value, inventory limit, regen speed, move speed
4. **技能配置**：skill, critical, hit recovery
5. **成长类型**：growtype 0-4
6. **动画配置**：各种动画标签
7. **攻击配置**：attack info, weapon sound, weapon hit sound, weapon hit info, weapon skill info

### 注释规范
- 使用 `//` 进行行注释
- 重要区块使用分隔线注释
- 每个主要部分添加说明注释

### 数值设计原则
- **渐进性**：属性增长平滑渐进
- **平衡性**：各项属性保持合理比例
- **职业特色**：突出鬼剑士的近战特点
- **游戏体验**：确保良好的游戏体验

## 使用说明

### 文件保存
1. 将内容保存为 `.chr` 文件
2. 使用UTF-8编码
3. 确保文件路径正确

### 测试验证
1. 检查语法格式
2. 验证数值合理性
3. 测试游戏内效果
4. 调整参数配置

### 自定义修改
1. 根据需要调整属性值
2. 修改成长曲线
3. 更换动画文件
4. 调整音效配置

## 注意事项

1. **格式严格性**：严格遵循PVF文件格式规范
2. **字符串格式**：所有字符串值必须用反引号（`）包围
3. **文件引用**：确保引用的动画和音效文件存在
4. **数值范围**：保持属性值在合理范围内
5. **兼容性**：考虑与游戏版本的兼容性

## 相关文档

- [基础信息标签](../01-基础信息/基础信息标签.md)
- [属性标签详解](../02-属性标签/属性标签详解.md)
- [动画标签详解](../03-动画标签/动画标签详解.md)
- [攻击信息详解](../04-攻击信息/攻击信息详解.md)
- [成长类型详解](../05-成长类型/成长类型详解.md)