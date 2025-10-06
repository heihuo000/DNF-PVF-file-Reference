# 完整STK文件示例

## 📋 概述

本文档提供各种类型STK文件的完整实际示例，这些示例都是经过测试的完整文件，可以直接在游戏中使用。

## 🧪 消耗品示例

### 高级恢复药水
```
[name] `高级恢复药水`
[explain]
`恢复大量HP的高级药水
在危险的地下城中必不可少的道具
使用后立即恢复800点HP`
[/explain]
[grade] 35
[rarity] 2
[attach type] `[trade]`
[creation rate] 5
[weight] 3
[usable job]
`[all]`
[/usable job]
[minimum level] 30
[stackable type] `[consumable]` 0
[sub type] 0
[icon] `ItemIcon.img` 25
[field image] `FieldIcon.img` 12
[price] 2000
[value] 1000
[move wav] `ITEM_TOUCH`
[use wav] `ITEM_USE`
[stack limit] 100
[cool time] 3000
[cool time group] 1
[action type] 1
[casting time] 1000
[HP] 800 0
[usable place]
`[all]`
[/usable place]
```

### 力量增强药水
```
[name] `巨人之力药水`
[explain]
`蕴含巨人力量的神奇药水
使用后在5分钟内大幅提升力量
适合在困难战斗前使用`
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

### 万能解毒剂
```
[name] `万能解毒剂`
[explain]
`能够解除所有毒素的特效药剂
瞬间清除中毒、出血等负面状态
冒险者的救命良药`
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
[stackable type] `[consumable]` 0
[sub type] 3
[icon] `ItemIcon.img` 35
[field image] `FieldIcon.img` 18
[price] 3000
[value] 1500
[move wav] `ITEM_TOUCH`
[use wav] `ITEM_USE`
[stack limit] 30
[cool time] 2000
[cool time group] 4
[action type] 1
[casting time] 800
[poison resistance] 100 0
[bleeding resistance] 100 0
[usable place]
`[all]`
[/usable place]
```

## 🔧 材料示例

### 精炼铁矿石
```
[name] `精炼铁矿石`
[explain]
`经过精炼处理的高品质铁矿石
制作高级武器和防具的重要材料
工匠们的首选原料`
[/explain]
[grade] 30
[rarity] 2
[attach type] `[trade]`
[creation rate] 6
[weight] 15
[usable job]
`[all]`
[/usable job]
[minimum level] 1
[stackable type] `[material]` 0
[sub type] 0
[icon] `MaterialIcon.img` 20
[field image] `MaterialField.img` 10
[price] 800
[value] 400
[move wav] `MATERIAL_TOUCH`
[stack limit] 999
```

### 哥布林王卡片
```
[name] `哥布林王卡片`
[explain]
`哥布林王的怪物卡片
蕴含强大的力量增幅效果
可以附魔到武器上增加攻击力`
[/explain]
[grade] 25
[rarity] 3
[attach type] `[trade]`
[creation rate] 2
[weight] 1
[usable job]
`[all]`
[/usable job]
[minimum level] 20
[stackable type] `[material]` 1
[sub type] 1
[icon] `CardIcon.img` 15
[field image] `CardField.img` 8
[price] 5000
[value] 2500
[move wav] `CARD_TOUCH`
[stack limit] 100
[int data]
1001
101
[/int data]
[string data]
`MonsterCard/goblin_king.img`
`weapon`
`normal`
`none`
[/string data]
[enchant]
[physical attack] 15
[strength] 8
[critical hit] 3
[/enchant]
```

### 强化石
```
[name] `+7强化石`
[explain]
`蕴含神秘力量的强化石
使用后可以将装备强化到+7
成功率较高，是强化的理想选择`
[/explain]
[grade] 45
[rarity] 4
[attach type] `[account]`
[creation rate] 1
[weight] 5
[usable job]
`[all]`
[/usable job]
[minimum level] 40
[stackable type] `[material]` 2
[sub type] 2
[icon] `EnhanceIcon.img` 25
[field image] `EnhanceField.img` 12
[price] 50000
[value] 25000
[move wav] `ENHANCE_TOUCH`
[stack limit] 50
[int data]
7
85
15
[/int data]
```

## 🎁 增强剂示例

### 新手福利盒
```
[name] `新手冒险者福利盒`
[explain]
`为新手冒险者特别准备的福利盒
包含各种有用的装备和道具
帮助新手快速成长`
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
[stackable] 20003 60 2
[equipment] 10001 50 1 0 0
[equipment] 10002 40 1 0 0
[cera] 1000 30
[other] 30001 20 1
[/booster info]
```

### 传说宝箱
```
[name] `远古传说宝箱`
[explain]
`来自远古时代的神秘宝箱
蕴含传说级装备的强大力量
只有真正的勇者才能获得其中的宝物`
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
[equipment] 11003 12 1 0 9
[stackable] 21001 200 10
[stackable] 21002 150 8
[cera] 5000 50
[avatar] 30001 20 1 0
[creature] 40001 5 1 0
[/booster info]
```

## 🔧 配方示例

### 钢剑制作配方
```
[name] `精钢长剑制作配方`
[explain]
`制作精钢长剑的详细配方
需要工艺制作技能等级3
制作出的武器攻击力强劲`
[/explain]
[grade] 30
[rarity] 2
[attach type] `[trade]`
[creation rate] 4
[weight] 2
[usable job]
`[all]`
[/usable job]
[minimum level] 25
[stackable type] `[recipe]` 0
[sub type] 1
[icon] `RecipeIcon.img` 20
[field image] `RecipeField.img` 10
[price] 8000
[value] 4000
[move wav] `RECIPE_TOUCH`
[use wav] `RECIPE_USE`
[stack limit] 1
[int data]
3
25001 8
25002 5
25003 2

1
10501 1

2
140 5
141 3

3
[/int data]
[string data]
`[craftmanship]`
[/string data]
```

### 高级恢复药水配方
```
[name] `高级恢复药水配方`
[explain]
`制作高级恢复药水的秘方
需要化学制作技能等级2
制作的药水恢复效果显著`
[/explain]
[grade] 25
[rarity] 2
[attach type] `[trade]`
[creation rate] 5
[weight] 1
[usable job]
`[all]`
[/usable job]
[minimum level] 20
[stackable type] `[recipe]` 0
[sub type] 0
[icon] `RecipeIcon.img` 15
[field image] `RecipeField.img` 8
[price] 3000
[value] 1500
[move wav] `RECIPE_TOUCH`
[use wav] `RECIPE_USE`
[stack limit] 1
[int data]
3
26001 5
26002 3
26003 1

1
21001 10

1
170 2

2
[/int data]
[string data]
`[chemistry]`
[/string data]
```

## 🎯 投掷物品示例

### 钢制回旋镖
```
[name] `精钢回旋镖`
[explain]
`由精钢打造的回旋镖
投掷后会自动返回使用者手中
对敌人造成持续伤害`
[/explain]
[grade] 35
[rarity] 3
[attach type] `[trade]`
[creation rate] 3
[weight] 8
[usable job]
`[all]`
[/usable job]
[minimum level] 30
[stackable type] `[throw item]` 0
[sub type] 2
[icon] `ThrowIcon.img` 15
[field image] `ThrowField.img` 8
[price] 6000
[value] 3000
[move wav] `THROW_TOUCH`
[use wav] `THROW_USE`
[stack limit] 50
[applying range] 250
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
[/int data]
[string data]
`PassiveObject/ThrowItem/steel_boomerang.ptl`
`THROW_BOOMERANG`
[/string data]
```

### 爆裂手雷
```
[name] `爆裂手雷`
[explain]
`威力强大的军用手雷
投掷后延迟3秒爆炸
对范围内所有敌人造成巨大伤害`
[/explain]
[grade] 30
[rarity] 3
[attach type] `[trade]`
[creation rate] 4
[weight] 12
[usable job]
`[gunner]`
[/usable job]
[minimum level] 25
[stackable type] `[throw item]` 0
[sub type] 1
[icon] `ThrowIcon.img` 20
[field image] `ThrowField.img` 10
[price] 5000
[value] 2500
[move wav] `THROW_TOUCH`
[use wav] `THROW_USE`
[stack limit] 30
[applying range] 300
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
[/int data]
[string data]
`PassiveObject/ThrowItem/explosive_grenade.ptl`
`THROW_GRENADE`
[/string data]
```

## 📦 潘多拉魔盒示例

### 神秘宝盒
```
[name] `神秘的古代宝盒`
[explain]
`来自古代文明的神秘宝盒
打开后可以随机获得各种珍贵物品
每次开启都是一次惊喜的冒险`
[/explain]
[grade] 40
[rarity] 4
[attach type] `[account]`
[creation rate] 0
[weight] 8
[usable job]
`[all]`
[/usable job]
[minimum level] 35
[stackable type] `[pandora box]` 0
[sub type] 2
[icon] `PandoraIcon.img` 30
[field image] `PandoraField.img` 15
[price] 0
[value] 10000
[move wav] `PANDORA_TOUCH`
[use wav] `PANDORA_OPEN`
[stack limit] 20
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
[/int data]
```

### 幸运宝盒
```
[name] `四叶草幸运宝盒`
[explain]
`带有四叶草标记的幸运宝盒
据说能带来好运气
开启时有更高概率获得稀有物品`
[/explain]
[grade] 50
[rarity] 4
[attach type] `[account]`
[creation rate] 0
[weight] 6
[usable job]
`[all]`
[/usable job]
[minimum level] 45
[stackable type] `[pandora box]` 0
[sub type] 3
[icon] `PandoraIcon.img` 35
[field image] `PandoraField.img` 18
[price] 0
[value] 15000
[move wav] `PANDORA_TOUCH`
[use wav] `PANDORA_OPEN`
[stack limit] 15
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
[/int data]
```

## 🏺 传承装备示例

### 传说剑传承
```
[name] `传说之剑传承精华`
[explain]
`从传说级剑类武器中提取的精华
蕴含着无数英雄的意志
使用后可以随机获得一把传说级剑`
[/explain]
[grade] 65
[rarity] 5
[attach type] `[account]`
[creation rate] 0
[weight] 10
[usable job]
`[swordman]`
[/usable job]
[minimum level] 60
[stackable type] `[legacy]` 0
[sub type] 0
[icon] `LegacyIcon.img` 40
[field image] `LegacyField.img` 20
[price] 0
[value] 80000
[move wav] `LEGACY_TOUCH`
[use wav] `LEGACY_EXTRACT`
[stack limit] 1
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
[/int data]
```

### 史诗护甲传承
```
[name] `史诗护甲传承精华`
[explain]
`从史诗级护甲中提取的传承精华
凝聚了无数战士的防御意志
使用后可以随机获得一件史诗级护甲`
[/explain]
[grade] 55
[rarity] 4
[attach type] `[account]`
[creation rate] 0
[weight] 12
[usable job]
`[all]`
[/usable job]
[minimum level] 50
[stackable type] `[legacy]` 0
[sub type] 1
[icon] `LegacyIcon.img` 30
[field image] `LegacyField.img` 15
[price] 0
[value] 50000
[move wav] `LEGACY_TOUCH`
[use wav] `LEGACY_EXTRACT`
[stack limit] 1
[int data]
55001
6
56001 20000
56002 20000
56003 18000
56004 18000
56005 12000
56006 12000
[/int data]
```

## 📝 任务道具示例

### 神秘信件
```
[name] `封印的神秘信件`
[explain]
`一封被神秘力量封印的信件
似乎与某个重要的任务有关
只有特定的人才能打开`
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
[icon] `QuestIcon.img` 10
[field image] `QuestField.img` 5
[price] 0
[value] 0
[move wav] `QUEST_TOUCH`
[stack limit] 1
[impossible to delete] 1
[int data]
12345
[/int data]
```

### 活动纪念币
```
[name] `春节庆典纪念币`
[explain]
`春节庆典活动的纪念币
可以在活动商店兑换各种奖励
活动结束后将自动消失`
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
[icon] `EventIcon.img` 15
[field image] `EventField.img` 8
[price] 0
[value] 100
[move wav] `EVENT_TOUCH`
[stack limit] 999
[event start date] 20240201
[event end date] 20240229
```

## 🎨 特殊效果示例

### 变身药水
```
[name] `哥布林变身药水`
[explain]
`神奇的变身药水
使用后会变成哥布林的外观
持续10分钟，期间移动速度提升`
[/explain]
[grade] 20
[rarity] 3
[attach type] `[trade]`
[creation rate] 2
[weight] 3
[usable job]
`[all]`
[/usable job]
[minimum level] 15
[stackable type] `[consumable]` 0
[sub type] 4
[icon] `ItemIcon.img` 40
[field image] `FieldIcon.img` 20
[price] 8000
[value] 4000
[move wav] `ITEM_TOUCH`
[use wav] `ITEM_USE`
[stack limit] 20
[cool time] 10000
[cool time group] 5
[action type] 2
[casting time] 2000
[move speed] 20 600000
[int data]
1001
600000
[/int data]
[string data]
`Character/goblin_transform.img`
`TRANSFORM_GOBLIN`
[/string data]
[usable place]
`[all]`
[/usable place]
```

### 瞬移卷轴
```
[name] `城镇瞬移卷轴`
[explain]
`能够瞬间传送到最近城镇的魔法卷轴
在危险时刻的救命道具
使用后立即传送，无法取消`
[/explain]
[grade] 15
[rarity] 2
[attach type] `[trade]`
[creation rate] 6
[weight] 1
[usable job]
`[all]`
[/usable job]
[minimum level] 10
[stackable type] `[consumable]` 0
[sub type] 5
[icon] `ItemIcon.img` 45
[field image] `FieldIcon.img` 22
[price] 1000
[value] 500
[move wav] `ITEM_TOUCH`
[use wav] `TELEPORT_USE`
[stack limit] 50
[cool time] 5000
[cool time group] 6
[action type] 3
[casting time] 3000
[int data]
1
[/int data]
[string data]
`TELEPORT_TOWN`
[/string data]
[usable place]
`[dungeon]`
[/usable place]
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