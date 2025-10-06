# SHO文件完整示例

## 概述

本文档提供了多种类型的完整SHO文件示例，涵盖了从基础商店到高级特殊商店的各种配置场景。

## 示例1：基础武器商店

### 文件名：`weaponshop.sho`

```
#PVF_File

[npc index]	50001	// 武器商人NPC索引

[message]	`欢迎来到武器商店！这里有各种优质武器供您选择。`	// 商店欢迎消息

[shop type]	0	// 普通商店类型

[buy only]	0	// 允许买卖

// 商店配置
[refresh type]	0	// 不刷新商品
[access level]	1	// 1级以上可访问
[currency type]	0	// 接受金币
[discount rate]	100	// 原价销售

// 销售商品列表开始
[sell list]

	// 新手剑
	[item]	2001	// 新手剑ID
	[price]	1000	// 价格1000金币
	[stock]	-1	// 无限库存
	[max buy]	1	// 单次购买1把
	[level required]	1	// 1级可购买
	[class required]	0	// 鬼剑士专用

	// 铁剑
	[item]	2010	// 铁剑ID
	[price]	5000	// 价格5000金币
	[stock]	-1	// 无限库存
	[max buy]	1	// 单次购买1把
	[level required]	10	// 10级可购买
	[class required]	0	// 鬼剑士专用

	// 钢剑
	[item]	2020	// 钢剑ID
	[price]	15000	// 价格15000金币
	[stock]	-1	// 无限库存
	[max buy]	1	// 单次购买1把
	[level required]	20	// 20级可购买
	[class required]	0	// 鬼剑士专用

	// 精钢剑
	[item]	2030	// 精钢剑ID
	[price]	35000	// 价格35000金币
	[stock]	-1	// 无限库存
	[max buy]	1	// 单次购买1把
	[level required]	30	// 30级可购买
	[class required]	0	// 鬼剑士专用

[sell list end]	// 商品列表结束
```

## 示例2：VIP限时商店

### 文件名：`vipshop.sho`

```
#PVF_File

[npc index]	50002	// VIP商人NPC索引

[message]	`尊贵的VIP会员，欢迎来到专属商店！`	// VIP欢迎消息

[shop type]	1	// 特殊商店类型

[buy only]	1	// 只能购买，不能出售

// VIP商店配置
[refresh type]	1	// 定时刷新
[refresh time]	86400	// 每天刷新一次
[access level]	30	// 30级以上可访问
[currency type]	1	// 接受点券
[discount rate]	80	// 8折优惠
[vip only]	1	// 仅VIP可访问
[max purchase]	10	// 每人每天最多购买10件

// 销售商品列表开始
[sell list]

	// VIP专属武器
	[item]	9001	// VIP武器ID
	[price]	500	// 价格500点券
	[stock]	50	// 限量50把
	[max buy]	1	// 单次购买1把
	[purchase limit]	1	// 每人只能买1次
	[level required]	40	// 40级可购买
	[rare item]	1	// 稀有物品
	[time limited]	1640995200	// 限时销售

	// VIP强化石
	[item]	9010	// VIP强化石ID
	[price]	100	// 价格100点券
	[stock]	200	// 限量200个
	[max buy]	5	// 单次购买5个
	[purchase limit]	20	// 每人最多买20个
	[level required]	20	// 20级可购买

	// VIP经验药水
	[item]	9020	// VIP经验药水ID
	[price]	50	// 价格50点券
	[stock]	-1	// 无限库存
	[max buy]	10	// 单次购买10个
	[level required]	1	// 1级可购买

[sell list end]	// 商品列表结束
```

## 示例3：公会声望商店

### 文件名：`guildshop.sho`

```
#PVF_File

[npc index]	50003	// 公会商人NPC索引

[message]	`公会成员专享商店，用声望兑换珍贵物品！`	// 公会商店消息

[shop type]	2	// 限时商店类型

[buy only]	1	// 只能购买

// 公会商店配置
[refresh type]	2	// 条件刷新
[access level]	25	// 25级以上可访问
[currency type]	2	// 特殊货币（声望）
[discount rate]	100	// 原价
[guild only]	1	// 仅公会成员可访问
[reputation required]	1000	// 需要1000声望
[purchase cooldown]	3600	// 购买后1小时冷却

// 销售商品列表开始
[sell list]

	// 公会徽章
	[item]	7001	// 公会徽章ID
	[price]	5000	// 价格5000声望
	[stock]	10	// 限量10个
	[max buy]	1	// 单次购买1个
	[purchase limit]	1	// 每人只能买1次
	[level required]	30	// 30级可购买
	[rare item]	1	// 稀有物品

	// 公会技能书
	[item]	7010	// 公会技能书ID
	[price]	10000	// 价格10000声望
	[stock]	5	// 限量5本
	[max buy]	1	// 单次购买1本
	[purchase limit]	3	// 每人最多买3本
	[level required]	40	// 40级可购买
	[rare item]	1	// 稀有物品

	// 公会药水
	[item]	7020	// 公会药水ID
	[price]	500	// 价格500声望
	[stock]	-1	// 无限库存
	[max buy]	5	// 单次购买5个
	[level required]	20	// 20级可购买

[sell list end]	// 商品列表结束
```

## 示例4：活动限时商店

### 文件名：`eventshop.sho`

```
#PVF_File

[npc index]	50004	// 活动商人NPC索引

[message]	`限时活动商店！错过就要等下次了！`	// 活动商店消息

[shop type]	1	// 特殊商店类型

[buy only]	1	// 只能购买

// 活动商店配置
[refresh type]	1	// 定时刷新
[refresh time]	21600	// 每6小时刷新
[access level]	15	// 15级以上可访问
[currency type]	0	// 接受金币
[discount rate]	70	// 7折优惠
[event shop]	1	// 活动商店标记
[max purchase]	20	// 每人每次刷新最多购买20件

// 销售商品列表开始
[sell list]

	// 活动武器
	[item]	8001	// 活动武器ID
	[price]	50000	// 价格50000金币
	[stock]	20	// 限量20把
	[max buy]	1	// 单次购买1把
	[purchase limit]	2	// 每人最多买2把
	[level required]	35	// 35级可购买
	[event item]	1	// 活动物品
	[time limited]	1640995200	// 限时销售

	// 活动防具
	[item]	8010	// 活动防具ID
	[price]	30000	// 价格30000金币
	[stock]	30	// 限量30件
	[max buy]	1	// 单次购买1件
	[purchase limit]	5	// 每人最多买5件
	[level required]	25	// 25级可购买
	[event item]	1	// 活动物品

	// 活动消耗品
	[item]	8020	// 活动消耗品ID
	[price]	1000	// 价格1000金币
	[stock]	100	// 限量100个
	[max buy]	10	// 单次购买10个
	[purchase limit]	50	// 每人最多买50个
	[level required]	10	// 10级可购买
	[event item]	1	// 活动物品

[sell list end]	// 商品列表结束
```

## 示例5：多职业通用商店

### 文件名：`generalshop.sho`

```
#PVF_File

[npc index]	50005	// 通用商人NPC索引

[message]	`各职业通用装备商店，总有适合您的！`	// 通用商店消息

[shop type]	0	// 普通商店类型

[buy only]	0	// 允许买卖

// 通用商店配置
[refresh type]	0	// 不刷新
[access level]	1	// 1级以上可访问
[currency type]	0	// 接受金币
[discount rate]	95	// 95折优惠

// 销售商品列表开始
[sell list]

	// 鬼剑士武器
	[item]	3001	// 鬼剑士武器ID
	[price]	25000	// 价格25000金币
	[stock]	-1	// 无限库存
	[max buy]	1	// 单次购买1把
	[level required]	25	// 25级可购买
	[class required]	0	// 鬼剑士专用
	[gender required]	0	// 男性专用

	// 格斗家武器
	[item]	3002	// 格斗家武器ID
	[price]	25000	// 价格25000金币
	[stock]	-1	// 无限库存
	[max buy]	1	// 单次购买1把
	[level required]	25	// 25级可购买
	[class required]	1	// 格斗家专用
	[gender required]	0	// 男性专用

	// 神枪手武器
	[item]	3003	// 神枪手武器ID
	[price]	25000	// 价格25000金币
	[stock]	-1	// 无限库存
	[max buy]	1	// 单次购买1把
	[level required]	25	// 25级可购买
	[class required]	2	// 神枪手专用
	[gender required]	0	// 男性专用

	// 魔法师武器
	[item]	3004	// 魔法师武器ID
	[price]	25000	// 价格25000金币
	[stock]	-1	// 无限库存
	[max buy]	1	// 单次购买1把
	[level required]	25	// 25级可购买
	[class required]	3	// 魔法师专用
	[gender required]	0	// 男性专用

	// 圣职者武器
	[item]	3005	// 圣职者武器ID
	[price]	25000	// 价格25000金币
	[stock]	-1	// 无限库存
	[max buy]	1	// 单次购买1把
	[level required]	25	// 25级可购买
	[class required]	4	// 圣职者专用
	[gender required]	0	// 男性专用

	// 通用防具（所有职业可用）
	[item]	4001	// 通用防具ID
	[price]	15000	// 价格15000金币
	[stock]	-1	// 无限库存
	[max buy]	1	// 单次购买1件
	[level required]	20	// 20级可购买
	[class required]	-1	// 所有职业可用
	[gender required]	-1	// 不限性别

[sell list end]	// 商品列表结束
```

## 格式要点总结

### 1. 文件头部
- 必须以 `#PVF_File` 开头
- 基础信息标签在前

### 2. 标签格式
- 使用Tab字符分隔标签和数值
- 字符串使用反引号包围
- 注释使用 `//` 格式

### 3. 商品配置
- 每个商品必须有 `[item]` 和 `[price]`
- 其他标签根据需要添加
- 保持逻辑一致性

### 4. 列表结构
- `[sell list]` 开始商品列表
- `[sell list end]` 结束商品列表
- 所有商品配置在两者之间

## 使用建议

1. **选择合适模板**: 根据商店类型选择对应示例作为基础
2. **修改关键参数**: 调整NPC索引、物品ID、价格等
3. **测试验证**: 确保所有物品ID和配置都有效
4. **保持一致性**: 同类型商店使用相似的配置规范

## 相关文档

- [基础信息标签详解](../01-基础信息标签/基础信息标签详解.md)
- [商店配置标签详解](../02-商店配置标签/商店配置标签详解.md)
- [商品配置标签详解](../03-商品配置标签/商品配置标签详解.md)
- [常见问题](../05-常见问题/)
- [PVF文件格式规范](../../PVF文件格式规范.md)