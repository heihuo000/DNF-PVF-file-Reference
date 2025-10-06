# STK文件制作模板

## 📋 概述

本文档提供各种类型STK文件的标准模板，开发者可以直接复制使用，只需修改相应的数值和内容。

## 🧪 基础消耗品模板

### HP恢复药水模板
```
#PVF_File

[name]
	`高级恢复药水`

[flavor text]
	`恢复大量HP的高级药水
	适合在危险的地下城中使用`

[grade]
	35

[rarity]
	2

[attach type]
	`[trade]`

[creation rate]
	5

[weight]
	3

[usable job]
	`[all]`
[/usable job]

[minimum level]
	30

[stackable type]
	`[consumable]`	0

[sub type]
	0

[icon]
	`ItemIcon.img`	25

[field image]
	`FieldIcon.img`	12

[price]
	2000

[value]
	1000

[move wav]
	`ITEM_TOUCH`

[use wav]
	`ITEM_USE`

[stack limit]
	100

[cool time]
	3000

[cool time group]
	1

[action type]
	1

[casting time]
	1000

[HP]
	800	0

[usable place]
	`[all]`
[/usable place]
```

### MP恢复药水模板
```
[name]
	`高级魔力药水`

[explain]
	`恢复大量MP的高级药水
	适合法师职业使用`
[/explain]

[grade]
	35

[rarity]
	2

[attach type]
	`[trade]`

[creation rate]
	5

[weight]
	3

[usable job]
	`[mage]`
	`[priest]`
[/usable job]

[minimum level]
	30

[stackable type]
	`[consumable]`	0

[sub type]
	0

[icon]
	`ItemIcon.img`	26

[field image]
	`FieldIcon.img`	13

[price]
	2000

[value]
	1000

[move wav]
	`ITEM_TOUCH`

[use wav]
	`ITEM_USE`

[stack limit]
	100

[cool time]
	3000

[cool time group]
	2

[action type]
	1

[casting time]
	1000

[MP]
	600	0

[usable place]
	`[all]`
[/usable place]
```

### 属性增强药水模板
```
[name] `力量增强药水`
[explain]
`临时提升力量属性的药水
持续时间较长，适合战斗前使用`
[/explain]
[grade] 40
[rarity] 3
[attach type] `[trade]`
[creation rate] 3
[weight] 4
[usable job]
`[all]`
[/usable job]
[minimum level] 35
[stackable type] `[consumable]` 0
[sub type] 2
[icon] `ItemIcon.img` 30
[field image] `FieldIcon.img` 15
[price] 5000
[value] 2500
[move wav] `ITEM_TOUCH`
[use wav] `ITEM_USE`
[stack limit] 50
[cool time] 5000
[cool time group] 3
[action type] 1
[casting time] 1500
[strength] 25 300000
[usable place]
`[all]`
[/usable place]
```

## 🔧 材料道具模板

### 普通材料模板
```
[name] `铁矿石`
[explain]
`制作武器和防具的基础材料
在各种制作配方中都有用途`
[/explain]
[grade] 20
[rarity] 1
[attach type] `[trade]`
[creation rate] 8
[weight] 10
[usable job]
`[all]`
[/usable job]
[minimum level] 1
[stackable type] `[material]` 0
[sub type] 0
[icon] `MaterialIcon.img` 15
[field image] `MaterialField.img` 8
[price] 500
[value] 250
[move wav] `MATERIAL_TOUCH`
[stack limit] 999
```

### 怪物卡片模板
```
[name] `哥布林卡片`
[explain]
`哥布林的怪物卡片
可以附魔到装备上增加属性`
[/explain]
[grade] 15
[rarity] 2
[attach type] `[trade]`
[creation rate] 3
[weight] 1
[usable job]
`[all]`
[/usable job]
[minimum level] 10
[stackable type] `[material]` 1
[sub type] 1
[icon] `CardIcon.img` 10
[field image] `CardField.img` 5
[price] 1000
[value] 500
[move wav] `CARD_TOUCH`
[stack limit] 100
[int data]
1001
101
[/int data]
[string data]
`MonsterCard/goblin.img`
`weapon`
`normal`
`none`
[/string data]
[enchant]
[physical attack] 5
[strength] 3
[/enchant]
```

## 🎁 增强剂/抽奖盒模板

### 基础增强剂模板
```
[name] `新手福利盒`
[explain]
`为新手冒险者准备的福利盒
包含各种有用的装备和道具`
[/explain]
[grade] 10
[rarity] 2
[attach type] `[account]`
[creation rate] 0
[weight] 5
[usable job]
`[all]`
[/usable job]
[minimum level] 1
[stackable type] `[booster]` 0
[sub type] 0
[icon] `BoosterIcon.img` 10
[field image] `BoosterField.img` 5
[price] 0
[value] 1000
[move wav] `BOOSTER_TOUCH`
[use wav] `BOOSTER_OPEN`
[stack limit] 10
[booster info]
[stackable] 20001 100 5
[stackable] 20002 80 3
[equipment] 10001 50 1 0 0
[cera] 1000 30
[other] 30001 20 1
[/booster info]
```

### 高级增强剂模板
```
[name] `传说宝箱`
[explain]
`蕴含传说力量的宝箱
有机会获得极其珍贵的传说装备`
[/explain]
[grade] 70
[rarity] 5
[attach type] `[account]`
[creation rate] 0
[weight] 10
[usable job]
`[all]`
[/usable job]
[minimum level] 65
[stackable type] `[booster]` 0
[sub type] 3
[icon] `BoosterIcon.img` 50
[field image] `BoosterField.img` 25
[price] 0
[value] 50000
[move wav] `BOOSTER_TOUCH`
[use wav] `BOOSTER_OPEN`
[stack limit] 5
[booster info]
[equipment] 11001 10 1 0 10
[equipment] 11002 15 1 0 8
[stackable] 21001 200 10
[cera] 5000 50
[avatar] 30001 20 1 0
[creature] 40001 5 1 0
[/booster info]
```

## 🔧 配方模板

### 武器制作配方模板
```
[name] `钢剑制作配方`
[explain]
`制作钢剑的配方
需要基础工艺技能`
[/explain]
[grade] 25
[rarity] 2
[attach type] `[trade]`
[creation rate] 4
[weight] 2
[usable job]
`[all]`
[/usable job]
[minimum level] 20
[stackable type] `[recipe]` 0
[sub type] 1
[icon] `RecipeIcon.img` 15
[field image] `RecipeField.img` 8
[price] 3000
[value] 1500
[move wav] `RECIPE_TOUCH`
[use wav] `RECIPE_USE`
[stack limit] 1
[int data]
3
25001 5
25002 3
25003 1

1
10501 1

2
140 3
141 1

1
[/int data]
[string data]
`[craftmanship]`
[/string data]
```

### 药水制作配方模板
```
[name] `恢复药水配方`
[explain]
`制作恢复药水的配方
需要化学制作技能`
[/explain]
[grade] 20
[rarity] 1
[attach type] `[trade]`
[creation rate] 6
[weight] 1
[usable job]
`[all]`
[/usable job]
[minimum level] 15
[stackable type] `[recipe]` 0
[sub type] 0
[icon] `RecipeIcon.img` 12
[field image] `RecipeField.img` 6
[price] 1500
[value] 750
[move wav] `RECIPE_TOUCH`
[use wav] `RECIPE_USE`
[stack limit] 1
[int data]
2
26001 3
26002 2

1
21001 5

1
170 2

0
[/int data]
[string data]
`[chemistry]`
[/string data]
```

## 🎯 投掷物品模板

### 回旋镖模板
```
[name] `钢制回旋镖`
[explain]
`钢制的回旋镖
投掷后会自动返回使用者手中`
[/explain]
[grade] 30
[rarity] 2
[attach type] `[trade]`
[creation rate] 4
[weight] 6
[usable job]
`[all]`
[/usable job]
[minimum level] 25
[stackable type] `[throw item]` 0
[sub type] 2
[icon] `ThrowIcon.img` 12
[field image] `ThrowField.img` 6
[price] 4000
[value] 2000
[move wav] `THROW_TOUCH`
[use wav] `THROW_USE`
[stack limit] 50
[applying range] 200
[int data]
1001
3
80
150
0
250
400
140
110
[/int data]
[string data]
`PassiveObject/ThrowItem/boomerang.ptl`
`THROW_BOOMERANG`
[/string data]
```

### 爆炸物模板
```
[name] `手雷`
[explain]
`军用手雷
投掷后延迟爆炸，对范围内敌人造成伤害`
[/explain]
[grade] 25
[rarity] 2
[attach type] `[trade]`
[creation rate] 5
[weight] 8
[usable job]
`[gunner]`
[/usable job]
[minimum level] 20
[stackable type] `[throw item]` 0
[sub type] 1
[icon] `ThrowIcon.img` 15
[field image] `ThrowField.img` 8
[price] 3000
[value] 1500
[move wav] `THROW_TOUCH`
[use wav] `THROW_USE`
[stack limit] 30
[applying range] 250
[int data]
1002
3
150
250
1500
400
600
100
100
[/int data]
[string data]
`PassiveObject/ThrowItem/grenade.ptl`
`THROW_GRENADE`
[/string data]
```

## 📦 潘多拉魔盒模板

### 基础魔盒模板
```
[name] `神秘宝盒`
[explain]
`神秘的宝盒
打开后可以随机获得各种物品`
[/explain]
[grade] 30
[rarity] 3
[attach type] `[account]`
[creation rate] 0
[weight] 5
[usable job]
`[all]`
[/usable job]
[minimum level] 25
[stackable type] `[pandora box]` 0
[sub type] 1
[icon] `PandoraIcon.img` 20
[field image] `PandoraField.img` 10
[price] 0
[value] 5000
[move wav] `PANDORA_TOUCH`
[use wav] `PANDORA_OPEN`
[stack limit] 20
[int data]
30001
5
31001
30000
1
31002
25000
1
32001
20000
5
1
15000
10000
33001
10000
1
[/int data]
```

### 高级魔盒模板
```
[name] `传说宝盒`
[explain]
`蕴含传说力量的宝盒
有机会获得极其珍贵的传说装备`
[/explain]
[grade] 60
[rarity] 5
[attach type] `[account]`
[creation rate] 0
[weight] 8
[usable job]
`[all]`
[/usable job]
[minimum level] 55
[stackable type] `[pandora box]` 0
[sub type] 4
[icon] `PandoraIcon.img` 40
[field image] `PandoraField.img` 20
[price] 0
[value] 30000
[move wav] `PANDORA_TOUCH`
[use wav] `PANDORA_OPEN`
[stack limit] 10
[int data]
40001
6
41001
5000
1
41002
8000
1
42001
15000
1
43001
25000
5
1
30000
50000
44001
17000
1
[/int data]
```

## 🏺 传承装备模板

### 武器传承模板
```
[name] `传说剑传承`
[explain]
`从传说级剑类武器中提取的传承精华
使用后可以随机获得一把传说剑`
[/explain]
[grade] 65
[rarity] 5
[attach type] `[account]`
[creation rate] 0
[weight] 8
[usable job]
`[swordman]`
[/usable job]
[minimum level] 60
[stackable type] `[legacy]` 0
[sub type] 0
[icon] `LegacyIcon.img` 30
[field image] `LegacyField.img` 15
[price] 0
[value] 40000
[move wav] `LEGACY_TOUCH`
[use wav] `LEGACY_EXTRACT`
[stack limit] 1
[int data]
50001
4
51001
25000
51002
30000
51003
25000
51004
20000
[/int data]
```

### 防具传承模板
```
[name] `史诗护甲传承`
[explain]
`从史诗级护甲中提取的传承精华
使用后可以随机获得一件史诗护甲`
[/explain]
[grade] 55
[rarity] 4
[attach type] `[account]`
[creation rate] 0
[weight] 10
[usable job]
`[all]`
[/usable job]
[minimum level] 50
[stackable type] `[legacy]` 0
[sub type] 1
[icon] `LegacyIcon.img` 25
[field image] `LegacyField.img` 12
[price] 0
[value] 25000
[move wav] `LEGACY_TOUCH`
[use wav] `LEGACY_EXTRACT`
[stack limit] 1
[int data]
52001
5
53001
20000
53002
25000
53003
20000
53004
15000
53005
20000
[/int data]
```

## 📝 任务道具模板

### 基础任务道具模板
```
[name] `神秘的信件`
[explain]
`一封神秘的信件
似乎与某个重要任务有关`
[/explain]
[grade] 1
[rarity] 1
[attach type] `[character]`
[creation rate] 0
[weight] 1
[usable job]
`[all]`
[/usable job]
[minimum level] 1
[stackable type] `[quest]` 0
[sub type] 0
[icon] `QuestIcon.img` 5
[field image] `QuestField.img` 3
[price] 0
[value] 0
[move wav] `QUEST_TOUCH`
[stack limit] 1
[impossible to delete] 1
[int data]
12345
[/int data]
```

### 活动道具模板
```
[name] `春节活动券`
[explain]
`春节活动期间的特殊道具
可以兑换节日奖励`
[/explain]
[grade] 1
[rarity] 2
[attach type] `[account]`
[creation rate] 0
[weight] 1
[usable job]
`[all]`
[/usable job]
[minimum level] 1
[stackable type] `[quest]` 0
[sub type] 1
[icon] `EventIcon.img` 10
[field image] `EventField.img` 5
[price] 0
[value] 100
[move wav] `EVENT_TOUCH`
[stack limit] 999
[event start date] 20240201
[event end date] 20240229
```

## 💡 使用说明

### 模板使用步骤
1. **选择合适的模板**: 根据要制作的物品类型选择对应模板
2. **修改基本信息**: 更改名称、说明、等级等基础属性
3. **调整数值**: 根据游戏平衡需求调整各项数值
4. **设置图标音效**: 配置合适的图标和音效文件
5. **测试验证**: 在游戏中测试物品功能是否正常

### 注意事项
1. **ID冲突**: 确保物品ID不与现有物品冲突
2. **数值平衡**: 注意属性数值的平衡性
3. **职业限制**: 合理设置职业使用限制
4. **经济影响**: 考虑对游戏经济的影响
5. **文件路径**: 确保图标和音效文件路径正确

### 自定义建议
1. **创意设计**: 在模板基础上添加创意元素
2. **主题统一**: 保持同类物品的设计风格统一
3. **功能扩展**: 根据需要添加特殊功能
4. **用户体验**: 考虑玩家的使用体验

## 🔗 相关链接

- [基础STK类型详解](../01-基础STK类型/)
- [高级STK类型详解](../02-高级STK类型/)
- [标签索引](../03-标签索引/)
- [实际示例](../05-实际示例/)
- [常见问题](../06-常见问题/)