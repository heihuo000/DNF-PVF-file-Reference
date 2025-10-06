# 完整STK文件示例

## 📋 概述

本文档提供各种类型STK文件的完整实际示例，这些示例都是经过测试的完整文件，可以直接在游戏中使用。

## 🧪 消耗品示例

### 高级恢复药水
```stk
[name]
	`高级恢复药水配方`

[explain]
	`制作高级恢复药水的秘方
	需要化学制作技能等级2
	制作的药水恢复效果显著`

[grade]
	25

[rarity]
	2

[attach type]
	`[trade]`

[creation rate]
	5

[weight]
	1

[usable job]
	`[all]`

[minimum level]
	20

[stackable type]
	`[recipe]`	0

[sub type]
	0

[icon]
	`RecipeIcon.img`	15

[field image]
	`RecipeField.img`	8

[price]
	3000

[value]
	1500

[move wav]
	`RECIPE_TOUCH`

[use wav]
	`RECIPE_USE`

[stack limit]
	1

[int data]
	3
	26001	5
	26002	3
	26003	1
	
	1
	21001	10
	
	1
	170	2
	
	2

[string data]
	`[chemistry]`
```

## 🎯 投掷物品示例

### 钢制回旋镖
```stk
[name]
	`精钢回旋镖`

[explain]
	`由精钢打造的回旋镖
	投掷后会自动返回使用者手中
	对敌人造成持续伤害`

[grade]
	35

[rarity]
	3

[attach type]
	`[trade]`

[creation rate]
	3

[weight]
	8

[usable job]
	`[all]`

[minimum level]
	30

[stackable type]
	`[throw item]`	0

[sub type]
	2

[icon]
	`ThrowIcon.img`	15

[field image]
	`ThrowField.img`	8

[price]
	6000

[value]
	3000

[move wav]
	`THROW_TOUCH`

[use wav]
	`THROW_USE`

[stack limit]
	50

[applying range]
	250

[int data]
	1001
	3
	120
	200
	0
	300
	500
	180
	150

[string data]
	`PassiveObject/ThrowItem/steel_boomerang.ptl`
	`THROW_BOOMERANG`
```

### 爆裂手雷
```stk
[name]
	`爆裂手雷`

[explain]
	`威力强大的军用手雷
	投掷后延迟3秒爆炸
	对范围内所有敌人造成巨大伤害`

[grade]
	30

[rarity]
	3

[attach type]
	`[trade]`

[creation rate]
	4

[weight]
	12

[usable job]
	`[gunner]`

[minimum level]
	25

[stackable type]
	`[throw item]`	0

[sub type]
	1

[icon]
	`ThrowIcon.img`	20

[field image]
	`ThrowField.img`	10

[price]
	5000

[value]
	2500

[move wav]
	`THROW_TOUCH`

[use wav]
	`THROW_USE`

[stack limit]
	30

[applying range]
	300

[int data]
	1002
	3
	200
	350
	3000
	500
	800
	150
	120

[string data]
	`PassiveObject/ThrowItem/explosive_grenade.ptl`
	`THROW_GRENADE`
```

## 📦 潘多拉魔盒示例

### 神秘宝盒
```stk
[name]
	`神秘的古代宝盒`

[explain]
	`来自古代文明的神秘宝盒
	打开后可以随机获得各种珍贵物品
	每次开启都是一次惊喜的冒险`

[grade]
	40

[rarity]
	4

[attach type]
	`[account]`

[creation rate]
	0

[weight]
	8

[usable job]
	`[all]`

[minimum level]
	35

[stackable type]
	`[pandora box]`	0

[sub type]
	2

[icon]
	`PandoraIcon.img`	30

[field image]
	`PandoraField.img`	15

[price]
	0

[value]
	10000

[move wav]
	`PANDORA_TOUCH`

[use wav]
	`PANDORA_OPEN`

[stack limit]
	20

[int data]
	40001
	6
	41001
	35000
	1
	41002
	30000
	1
	42001
	20000
	3
	43001
	10000
	5
	1
	3000
	5000
	44001
	2000
	1
```

### 幸运宝盒
```stk
[name]
	`四叶草幸运宝盒`

[explain]
	`带有四叶草标记的幸运宝盒
	据说能带来好运气
	开启时有更高概率获得稀有物品`

[grade]
	50

[rarity]
	4

[attach type]
	`[account]`

[creation rate]
	0

[weight]
	6

[usable job]
	`[all]`

[minimum level]
	45

[stackable type]
	`[pandora box]`	0

[sub type]
	3

[icon]
	`PandoraIcon.img`	35

[field image]
	`PandoraField.img`	18

[price]
	0

[value]
	15000

[move wav]
	`PANDORA_TOUCH`

[use wav]
	`PANDORA_OPEN`

[stack limit]
	15

[int data]
	50001
	7
	51001
	25000
	1
	51002
	20000
	1
	52001
	18000
	2
	53001
	15000
	3
	54001
	12000
	5
	1
	8000
	10000
	55001
	2000
	1
```

## 🏺 传承装备示例

### 传说剑传承
```stk
[name]
	`传说之剑传承精华`

[explain]
	`从传说级剑类武器中提取的精华
	蕴含着无数英雄的意志
	使用后可以随机获得一把传说级剑`

[grade]
	65

[rarity]
	5

[attach type]
	`[account]`

[creation rate]
	0

[weight]
	10

[usable job]
	`[swordman]`

[minimum level]
	60

[stackable type]
	`[legacy]`	0

[sub type]
	0

[icon]
	`LegacyIcon.img`	40

[field image]
	`LegacyField.img`	20

[price]
	0

[value]
	80000

[move wav]
	`LEGACY_TOUCH`

[use wav]
	`LEGACY_EXTRACT`

[stack limit]
	1

[int data]
	60001
	5
	61001
	25000
	61002
	25000
	61003
	20000
	61004
	20000
	61005
	10000
```

### 史诗护甲传承
```stk
[name]
	`史诗护甲传承精华`

[explain]
	`从史诗级护甲中提取的传承精华
	凝聚了无数战士的防御意志
	使用后可以随机获得一件史诗级护甲`

[grade]
	55

[rarity]
	4

[attach type]
	`[account]`

[creation rate]
	0

[weight]
	12

[usable job]
	`[all]`

[minimum level]
	50

[stackable type]
	`[legacy]`	0

[sub type]
	1

[icon]
	`LegacyIcon.img`	30

[field image]
	`LegacyField.img`	15

[price]
	0

[value]
	50000

[move wav]
	`LEGACY_TOUCH`

[use wav]
	`LEGACY_EXTRACT`

[stack limit]
	1

[int data]
	55001
	6
	56001	20000
	56002	20000
	56003	18000
	56004	18000
	56005	12000
	56006	12000
```

## 📝 任务道具示例

### 神秘信件
```stk
[name]
	`封印的神秘信件`

[explain]
	`一封被神秘力量封印的信件
	似乎与某个重要的任务有关
	只有特定的人才能打开`

[grade]
	1

[rarity]
	1

[attach type]
	`[character]`

[creation rate]
	0

[weight]
	1

[usable job]
	`[all]`

[minimum level]
	1

[stackable type]
	`[quest]`	0

[sub type]
	0

[icon]
	`QuestIcon.img`	10

[field image]
	`QuestField.img`	5

[price]
	0

[value]
	0

[move wav]
	`QUEST_TOUCH`

[stack limit]
	1

[impossible to delete]
	1

[int data]
	12345
```

### 活动纪念币
```stk
[name]
	`春节庆典纪念币`

[explain]
	`春节庆典活动的纪念币
	可以在活动商店兑换各种奖励
	活动结束后将自动消失`

[grade]
	1

[rarity]
	2

[attach type]
	`[account]`

[creation rate]
	0

[weight]
	1

[usable job]
	`[all]`

[minimum level]
	1

[stackable type]
	`[quest]`	0

[sub type]
	1

[icon]
	`EventIcon.img`	15

[field image]
	`EventField.img`	8

[price]
	0

[value]
	100

[move wav]
	`EVENT_TOUCH`

[stack limit]
	999

[event start date]
	20240201

[event end date]
	20240229
```

## 🎨 特殊效果示例

### 变身药水
```stk
[name]
	`哥布林变身药水`

[explain]
	`神奇的变身药水
	使用后会变成哥布林的外观
	持续10分钟，期间移动速度提升`

[grade]
	20

[rarity]
	3

[attach type]
	`[trade]`

[creation rate]
	2

[weight]
	3

[usable job]
	`[all]`

[minimum level]
	15

[stackable type]
	`[consumable]`	0

[sub type]
	4

[icon]
	`ItemIcon.img`	40

[field image]
	`FieldIcon.img`	20

[price]
	8000

[value]
	4000

[move wav]
	`ITEM_TOUCH`

[use wav]
	`ITEM_USE`

[stack limit]
	20

[cool time]
	10000

[cool time group]
	5

[action type]
	2

[casting time]
	2000

[move speed]
	20	600000

[int data]
	1001
	600000

[string data]
	`Character/goblin_transform.img`
	`TRANSFORM_GOBLIN`

[usable place]
	`[all]`
```

### 瞬移卷轴
```stk
[name]
	`城镇瞬移卷轴`

[explain]
	`能够瞬间传送到最近城镇的魔法卷轴
	在危险时刻的救命道具
	使用后立即传送，无法取消`

[grade]
	15

[rarity]
	2

[attach type]
	`[trade]`

[creation rate]
	6

[weight]
	1

[usable job]
	`[all]`

[minimum level]
	10

[stackable type]
	`[consumable]`	0

[sub type]
	5

[icon]
	`ItemIcon.img`	45

[field image]
	`FieldIcon.img`	22

[price]
	1000

[value]
	500

[move wav]
	`ITEM_TOUCH`

[use wav]
	`TELEPORT_USE`

[stack limit]
	50

[cool time]
	5000

[cool time group]
	6

[action type]
	3

[casting time]
	3000

[int data]
	1

[string data]
	`TELEPORT_TOWN`

[usable place]
	`[dungeon]`
```

## 💡 示例说明

### 文件结构说明
1. **基本信息**: 每个示例都包含完整的基本信息标签
2. **数值平衡**: 所有数值都经过平衡性考虑
3. **功能完整**: 每个示例都是功能完整的STK文件
4. **注释详细**: 说明文本详细描述了物品的用途和效果

### 使用建议
1. **直接使用**: 这些示例可以直接复制使用
2. **参考修改**: 可以基于这些示例进行修改
3. **学习结构**: 通过示例学习STK文件的正确结构
4. **测试验证**: 建议在使用前进行游戏内测试

### 注意事项
1. **ID冲突**: 使用前请确保物品ID不冲突
2. **资源文件**: 确保引用的图标和音效文件存在
3. **数值调整**: 根据游戏需要调整数值
4. **职业限制**: 注意职业使用限制的设置

## 🔗 相关链接

- [STK文件模板](../04-实用工具/STK文件模板.md)
- [基础STK类型](../01-基础STK类型/)
- [高级STK类型](../02-高级STK类型/)
- [标签索引](../03-标签索引/)
- [常见问题](../06-常见问题/)