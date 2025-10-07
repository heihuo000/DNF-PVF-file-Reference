# DNF STK文件功能详解

## 📋 目录
1. [STK文件概述](#stk文件概述)
2. [基础消耗品 (stackablesample.stk)](#基础消耗品)
3. [增强剂/抽奖盒 (booster)](#增强剂抽奖盒)
4. [配方 (recipe)](#配方)
5. [投掷物品 (throwitem)](#投掷物品)
6. [怪物卡片 (monster_card)](#怪物卡片)
7. [潘多拉盒子 (pandora)](#潘多拉盒子)
8. [传承装备抽取 (legacy)](#传承装备抽取)
9. [通用标签说明](#通用标签说明)
10. [实用技巧](#实用技巧)

---

## STK文件概述

STK文件是DNF中定义**可堆叠物品**的脚本文件，包括：
- 消耗品 (药水、食物等)
- 材料 (制作材料、怪物卡片等)
- 配方 (制作配方)
- 投掷物品 (手雷、飞镖等)
- 抽奖盒子 (各种抽奖道具)
- 特殊功能物品

---

## 基础消耗品

### 📦 基本信息标签
```
[name] `物品名称`                    // 物品显示名称
[name2] `英文名称`                   // 英文名称(可选)
[explain] `物品说明`                 // 物品描述，支持换行
[flavor text] `风味文本`             // 物品背景故事
[grade] 6                           // 物品等级 (1-85)
[rarity] 0                          // 稀有度: 0普通 1高级 2稀有 3传说 4史诗
[weight] 5                          // 重量 (单位: 10g)
[minimum level] 0                   // 使用最低等级
```

### 🎯 职业限制
```
[usable job]                        // 可使用职业开始
`[all]`                            // 全职业可用
// 或指定职业: `[swordman]` `[fighter]` `[gunner]` `[mage]` `[priest]`
[/usable job]                      // 职业限制结束
```

### 💰 经济属性
```
[attach type] `[free]`              // 归属类型
// `[free]` 自由交易
// `[trade]` 可交易
// `[trade delete]` 交易后删除
// `[sealing]` 封印状态

[price] 100                         // 购买价格
[cash] 1200                        // 点券价格
[medal] 5                          // 勋章价格
[value] 50                         // 出售价格
[finish point price] 10            // FP价格
[creation rate] 2                  // 生成概率 (建议≤10)
```

### 🖼️ 视觉效果
```
[icon] `StackableIcon.img` 2        // 图标文件和帧索引
[field image] `StackableField.img` 1 // 掉落时显示图像
[move wav] `MOVE_SOUND`             // 移动音效
[use wav] `USE_SOUND`               // 使用音效
```

### ⏱️ 冷却系统
```
[cool time] 1000                    // 使用冷却时间 (毫秒)
[쿨타입 그룹] 0                      // 冷却组 (-1为独立冷却)
[party cooltime] 1                  // 1=队伍共享冷却
```

### 📊 物品类型
```
[stackable type] `[waste]` 14       // 物品类型和价格表索引
```

**可用类型**:
- `[waste]` - 消耗品
- `[material]` - 材料
- `[recipe]` - 配方
- `[throw]` - 投掷物品
- `[set]` - 套装道具
- `[legacy]` - 传承抽取
- `[quest]` - 任务道具
- `[etc]` - 其他
- `[creature]` - 宠物相关
- `[feed]` - 宠物食物
- `[cera package]` - 点券礼包
- `[package]` - 普通礼包
- `[pandora box]` - 潘多拉盒子
- `[booster]` - 增强剂
- `[cera booster]` - 点券增强剂

### 🎲 属性变化效果
```
[stat change]                       // 属性变化开始
`+` 1000 `rigidity`                // 增加1000点硬直度
`+` 100 `fire attack`              // 增加100点火属性攻击
`+` 101 `water attack`             // 增加101点水属性攻击
`+` 102 `dark attack`              // 增加102点暗属性攻击
`+` 103 `light attack`             // 增加103点光属性攻击
[/stat change]
[stat change duration] 60000 `myself` // 持续60秒，作用于自身
```

### 🔧 数据存储
```
[int data]                          // 整数数据
3                                   // 数据1
4                                   // 数据2
[/int data]

[string data]                       // 字符串数据
`ASDF.ptl`                         // 字符串1
`ASDF2.ptl`                        // 字符串2
[/string data]
```

### 🎯 特殊功能
```
[action type]                       // 功能类型
`[megaphone]`                      // 喇叭功能
100                                // 功能参数1
100                                // 功能参数2
[/action type]

[action usable place]               // 可使用场所
`[village]`                        // 城镇
`[dungeon]`                        // 地下城
`[pvp]`                           // PVP场所
[/action usable place]
```

---

## 增强剂/抽奖盒

### 🎁 增强剂信息
```
[stackable type] `[booster]` 0      // 增强剂类型

[booster info]                      // 增强剂信息开始
[avatar]                           // 时装抽取
2                                  // 抽取数量
39000 1000 1 0 0                  // 物品ID 概率 数量 期限 能力值
[/avatar]

[cera]                             // 点券道具
1                                  // 抽取数量
8 1000 10                         // 物品ID 概率 数量
[/cera]

[creature]                         // 宠物
1
8 1000 10
[/creature]

[equipment]                        // 装备
1
8 1000 10
[/equipment]

[stackable]                        // 消耗品
1
8 1000 10
[/stackable]

[etc]                             // 其他物品
1
8 1000 10
[/etc]
[/booster info]                    // 增强剂信息结束
```

---

## 配方

### 📜 配方制作
```
[stackable type] `[recipe]` 0       // 配方类型

[int data]
3                                  // 需要材料种类数
27 1                              // 材料ID 数量
28 4                              // 材料ID 数量
29 2                              // 材料ID 数量

2                                  // 产出物品种类数
10001 1                           // 产出ID 数量
77 3                              // 产出ID 数量

2                                  // 需要技能种类数
140 1                             // 技能ID 最低等级
142 7                             // 技能ID 最低等级

1                                  // 需要等级 (0:全部 1:高级 2:专家)
[/int data]

[string data]
`[craftmanship]`                   // 制作类型
// `[craftmanship]` - 工艺
// `[weaving]` - 纺织
// `[machinary]` - 机械
// `[chemistry]` - 化学
// `[enchant]` - 附魔
[/string data]
```

---

## 投掷物品

### 🎯 投掷武器
```
[stackable type] `[throw]` 0        // 投掷物品类型
[applying range] 200               // 作用范围 (像素)

[int data]
50001                             // 生成的被动对象ID
0                                 // 被动对象参数
0                                 // 发射前延迟
450                               // 发射后延迟
0                                 // 速度类型 (0:攻击速度 1:施法速度)
100                               // 速度倍率 (%)
[/int data]

[string data]
`PassiveObject/ThrowItem/Particle/Boomerang.ptl` // 轨迹粒子效果
`THROW`                           // 投掷音效
[/string data]
```

---

## 怪物卡片

### 🃏 卡片属性
```
[stackable type] `[material]` 4     // 材料类型
[sub type] 1                       // 子类型1=怪物卡片

[string data]
`Interface/MonsterCard/cut_cardimage.img` // 卡片图像包
`[weapon]`                         // 附魔目标部位
`[foil]`                          // 闪卡标识
`[unlimited challenge]`            // 活动名称
[/string data]

[int data]
1                                 // 卡片图像索引
3000                              // 怪物ID
[/int data]

[enchant]                         // 附魔属性
[HP MAX] +10                      // 最大HP
[MP MAX] +27                      // 最大MP
[physical attack] +100            // 物理攻击力
[magical attack] -10              // 魔法攻击力
[fire resistance] +17             // 火抗性
[slow resistance] 18              // 减速抗性
[inventory limit] +30             // 负重上限
[move speed] +1                   // 移动速度
[attack speed] +2                 // 攻击速度
[cast speed] +3                   // 施法速度
[/enchant]
```

---

## 潘多拉盒子

### 🎁 随机奖励
```
[stackable type] `[pandora box]` 0  // 潘多拉盒子类型

[int data]
1001                              // 默认奖励物品ID

10001 288 20                      // 物品ID 概率(十万分率) 数量
2342 301 10                       // 0.301%概率获得10个2342号物品
3222 1 25                         // 0.001%概率获得25个3222号物品
4222 5000 30                      // 5%概率获得30个4222号物品
2222 243 20                       // 0.243%概率获得20个2222号物品
[/int data]
```

---

## 传承装备抽取

### ⚔️ 装备抽取
```
[stackable type] `[legacy]` 0       // 传承类型

[int data]
1001                              // 默认物品ID

10001 288                         // 物品ID 概率(十万分率)
2342 301                          // 0.301%概率
3222 1                            // 0.001%概率
4222 5000                         // 5%概率
2222 243                          // 0.243%概率
[/int data]
```

---

## 通用标签说明

### 📦 包裹系统
```
[packagable] 0                     // 0=不可邮寄 1=可邮寄
[stack limit] 1000                 // 堆叠上限 (0=无限制)
[need material] 3043 2             // 需要材料ID和数量
```

### 🎨 染色系统
```
[dye type] 0                       // 0:随机染色 1:单色 2:多色
[dye info]
1 1000                            // 颜色索引 概率(千分率)
10 2000                           // 仅随机染色使用
[/dye info]
```

### 🔗 任务系统
```
[linking quest index] 1000         // 关联任务ID
// 当[stackable type]为`[quest receive]`时使用
```

---

## 实用技巧

### 💡 设计建议

1. **概率设计**
   - 十万分率: 1 = 0.001%
   - 千分率: 1 = 0.1%
   - 合理设置稀有物品概率

2. **数值平衡**
   - 消耗品效果不宜过强
   - 冷却时间要合理
   - 价格要符合游戏经济

3. **功能组合**
   - 可组合多种效果
   - 注意效果叠加规则
   - 测试各种使用场景

### 🔧 常见问题

1. **物品不显示**: 检查图标路径和索引
2. **无法使用**: 检查职业限制和等级要求
3. **效果异常**: 检查数据格式和标签闭合
4. **概率问题**: 确认概率单位和总和

### 📚 学习路径

1. **初学者**: 从基础消耗品开始
2. **进阶**: 学习配方和投掷物品
3. **高级**: 掌握增强剂和复杂功能
4. **专家**: 自定义特殊效果和系统

---

## 总结

STK文件是DNF中功能最丰富的物品定义文件，通过合理组合各种标签，可以创造出功能强大、效果丰富的游戏道具。掌握STK文件的编写技巧，是成为DNF内容创作者的重要技能。

记住：**实践是最好的老师**，多尝试、多测试，才能真正掌握STK文件的精髓！