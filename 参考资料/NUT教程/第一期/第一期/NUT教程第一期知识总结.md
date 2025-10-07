# NUT教程第一期知识总结

## 概述
本教程以盗贼职业为例，详细介绍了DNF中NUT脚本的基础开发流程，包括技能创建、状态管理、动画控制和攻击系统的实现。

## 核心文件结构

### 1. PVF文件组织架构
```
PVF文件/
├── character/thief/attackinfo/uppercut.atk    # 攻击信息文件
├── skill/thief/zskill00.skl                   # 技能定义文件
└── sqr/                                       # 脚本文件目录
    ├── character/
    │   ├── thief/
    │   │   ├── thief_header.nut               # 头文件定义
    │   │   └── zskill00/                      # 技能脚本目录
    │   └── thief_load_state.nut               # 状态加载文件
    └── loadstate.nut                          # 主加载文件
```

### 2. 关键文件说明

#### loadstate.nut - 主加载文件
- 负责加载各职业的状态脚本
- 使用 `sq_RunScript()` 函数加载其他脚本文件
- 包含所有职业的加载入口

#### thief_header.nut - 头文件定义
定义了技能开发所需的常量：
```nut
// 状态编号 - 必须唯一，避免与现有状态冲突
STATE_ZSKILL00 <- 95    // 技能状态编号，建议使用90以上不会与现有状态冲突

// 技能编号 - 对应技能列表中的技能ID
SKILL_ZSKILL00 <- 220   // 技能编号，对应技能列表

// 动画文件索引 - 指向CHR文件中的动画定义
CUSTOM_ANI_01 <- 0      // 指向character/thief/thief.chr中的[etc motion]第0个动画

// 攻击信息索引 - 指向CHR文件中的攻击信息定义
CUSTOM_ATK_01 <- 0      // 指向character/thief/thief.chr中的[etc attack info]第0个攻击信息

// 向量标志常量 - 用于数据传递和状态控制
VECTOR_FLAG_0 <- 0      // 向量标志0，用于substate控制
VECTOR_FLAG_1 <- 1      // 向量标志1，用于技能阶段控制
VECTOR_FLAG_2 <- 2      // 向量标志2，用于特殊状态标记

// 静态整数索引 - 用于技能数据获取
SKL_STATIC_INT_IDX_0 <- 0    // 静态整数索引0
SKL_STATIC_INT_IDX_1 <- 1    // 静态整数索引1

// 技能等级列索引 - 用于获取技能等级数据
SKL_LVL_COLUMN_IDX_0 <- 0    // 技能等级列索引0
SKL_LVL_COLUMN_IDX_1 <- 1    // 技能等级列索引1
```

#### thief_load_state.nut - 状态加载
```nut
// 加载头文件
IRDSQRCharacter.pushScriptFiles("Character/thief/thief_header.nut");

// 注册技能状态
IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_THIEF, 
                         "Character/Thief/Zskill00/Zskill00.nut", 
                         "Zskill00", 
                         STATE_ZSKILL00, 
                         SKILL_ZSKILL00);
```

## NUT脚本核心函数详解

### 1. 基础函数框架

#### checkExecutableSkill_技能名(obj)
**功能**: 检查技能是否可以执行
```nut
function checkExecutableSkill_Zskill00(obj)
{
    if (!obj) return false;
    local isUse = obj.sq_IsUseSkill(SKILL_ZSKILL00);  // 检查技能可用性
    
    if (isUse) {
        obj.sq_AddSetStatePacket(STATE_ZSKILL00, STATE_PRIORITY_USER, false);
        return true;
    }
    
    return false;
}
```

#### checkCommandEnable_技能名(obj)
**功能**: 检查按键输入条件
```nut
function checkCommandEnable_Zskill00(obj)
{
    if (!obj) return false;
    local state = obj.sq_GetState();  // 获取当前角色状态
    
    if (state == STATE_STAND)         // 仅在站立状态可使用
        return true;
    
    return false;
}
```

#### onSetState_技能名(obj, state, datas, isResetTimer)
**功能**: 技能状态设置时的处理逻辑
```nut
function onSetState_Zskill00(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    obj.sq_StopMove();                              // 停止角色移动
    obj.sq_SetCurrentAnimation(CUSTOM_ANI_01);      // 设置动画
    obj.sq_SetCurrentAttackInfo(CUSTOM_ATK_01);     // 设置攻击信息
    
    // 设置攻击速度影响
    obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                             SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
    
    // 计算伤害倍率
    local damage = obj.sq_GetBonusRateWithPassive(SKILL_ZSKILL00, STATE_ZSKILL00, 0, 1.0);
    obj.sq_SetCurrentAttackBonusRate(damage);
}
```

#### onEndCurrentAni_技能名(obj)
**功能**: 动画结束时的处理
```nut
function onEndCurrentAni_Zskill00(obj)
{
    // 动画结束后恢复站立状态
    obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}
```

### 2. 进阶功能函数

#### onAttack_技能名(obj, damager, boundingBox, isStuck)
**功能**: 攻击命中时的处理
```nut
function onAttack_Zskill00(obj, damager, boundingBox, isStuck)
{
    if (!obj || !damager) return;
    
    // 对命中目标添加颜色光谱效果
    sq_EffectLayerAppendage(damager, sq_RGB(46, 204, 113), 150, 0, 0, 240);
}
```

## 技能文件配置 (zskill00.skl)

### 基本信息配置
```
[name]
`教學技能`                    # 技能显示名称

[name2]
`Shuriken`                   # 技能英文名

[basic explain]
`教學技能`                    # 基础说明

[explain]
`教學技能`                    # 详细说明
```

### 技能属性配置
```
[executable states]
8	0	14                   # 可执行状态列表

[required level]
1                            # 需求等级

[type]
`[active]`                   # 技能类型：主动技能

[skill class]
1                            # 技能分类

[maximum level]
70                           # 最大等级

[weapon effect type]
`[physical]`                 # 武器效果类型：物理
```

## 特效系统

### 视觉效果函数
```nut
// 命中效果
obj.sq_setCustomHitEffectFileName("Character/Mage/Effect/Animation/ATIceSword/05_2_smoke_dodge.ani");

// 屏幕震动
obj.sq_SetShake(obj, 2, 150);

// 闪屏效果
sq_flashScreen(obj, 30, 30, 30, 200, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);

// 颜色光谱
sq_EffectLayerAppendage(damager, sq_RGB(46, 204, 113), 150, 0, 0, 240);
```

## 开发流程总结

### 第一阶段：基础动画技能
1. 创建技能文件 (.skl)
2. 定义头文件常量
3. 实现基础函数框架
4. 配置状态加载

### 第二阶段：添加攻击系统
1. 添加攻击信息设置
2. 配置伤害计算
3. 设置攻击速度影响

### 第三阶段：特效增强
1. 添加视觉特效
2. 实现命中反馈
3. 配置屏幕效果

## 重要注意事项

### 1. 编号管理与文件指向关系

#### 状态编号 (STATE_*)
- **作用**: 定义技能的唯一状态标识符
- **命名规范**: `STATE_技能名` (如: STATE_ZSKILL00)
- **数值范围**: 建议使用90-200之间的未使用编号
- **冲突避免**: 必须确保与现有状态编号不冲突
- **使用场景**: 在`onSetState`、`checkExecutableSkill`等函数中使用

#### 技能编号 (SKILL_*)
- **作用**: 对应游戏中技能列表的技能ID
- **命名规范**: `SKILL_技能名` (如: SKILL_ZSKILL00)
- **数值范围**: 建议使用200-300之间的未使用编号
- **文件关联**: 必须与.skl技能文件中的技能ID保持一致
- **使用场景**: 技能检查、伤害计算、状态注册等

#### 动画编号 (CUSTOM_ANI_*)
- **作用**: 指向CHR文件中[etc motion]部分的动画索引
- **命名规范**: `CUSTOM_ANI_描述` (如: CUSTOM_ANI_01, CUSTOM_ANI_ATTACK)
- **数值含义**: 对应CHR文件中动画的排列顺序(从0开始)
- **文件指向**: character/职业/职业.chr → [etc motion] → 第N个动画
- **使用场景**: `obj.sq_SetCurrentAnimation()`函数中使用

#### 攻击信息编号 (CUSTOM_ATK_*)
- **作用**: 指向CHR文件中[etc attack info]部分的攻击信息索引
- **命名规范**: `CUSTOM_ATK_描述` (如: CUSTOM_ATK_01, CUSTOM_ATK_UPPERCUT)
- **数值含义**: 对应CHR文件中攻击信息的排列顺序(从0开始)
- **文件指向**: character/职业/职业.chr → [etc attack info] → 第N个攻击信息
- **关联文件**: 通常关联character/职业/attackinfo/具体攻击.atk文件
- **使用场景**: `obj.sq_SetCurrentAttackInfo()`函数中使用

#### 向量标志编号 (VECTOR_FLAG_*)
- **作用**: 用于技能内部状态控制和数据传递
- **命名规范**: `VECTOR_FLAG_N` (如: VECTOR_FLAG_0, VECTOR_FLAG_1)
- **数值范围**: 通常使用0-10之间的连续编号
- **使用场景**: substate控制、技能阶段切换、特殊状态标记

#### 静态数据索引 (SKL_STATIC_INT_IDX_*)
- **作用**: 指向技能文件中[static data]部分的数据索引
- **命名规范**: `SKL_STATIC_INT_IDX_N` (如: SKL_STATIC_INT_IDX_0)
- **数值含义**: 对应.skl文件中静态数据的位置索引
- **使用场景**: 获取技能的固定数值参数

#### 技能等级列索引 (SKL_LVL_COLUMN_IDX_*)
- **作用**: 指向技能文件中[level info]部分的列索引
- **命名规范**: `SKL_LVL_COLUMN_IDX_N` (如: SKL_LVL_COLUMN_IDX_0)
- **数值含义**: 对应.skl文件中等级数据的列位置
- **使用场景**: 获取技能的等级相关数值

### 2. 文件依赖关系与指向详解

#### 核心文件依赖图
```
thief_header.nut (头文件定义)
    ↓ (提供常量)
thief_zskill00.nut (技能逻辑)
    ↓ (引用动画/攻击)
character/thief/thief.chr (角色定义)
    ↓ (指向具体文件)
character/thief/animation/*.ani (动画文件)
character/thief/attackinfo/*.atk (攻击文件)
    ↓ (技能数据)
skill/thief/zskill00.skl (技能属性)
```

#### 详细文件指向关系

**1. NUT → CHR 文件指向**
- `CUSTOM_ANI_01 <- 0` → `character/thief/thief.chr` → `[etc motion]` → 第0个动画路径
- `CUSTOM_ATK_01 <- 0` → `character/thief/thief.chr` → `[etc attack info]` → 第0个攻击信息路径

**2. CHR → 具体资源文件指向**
```
[etc motion]
    `character/thief/animation/zskill00.ani`    // 对应CUSTOM_ANI_01 = 0

[etc attack info]  
    `character/thief/attackinfo/zskill00.atk`   // 对应CUSTOM_ATK_01 = 0
```

**3. NUT → SKL 文件数据指向**
- `SKILL_ZSKILL00 <- 220` → `skill/thief/zskill00.skl` → `[skill index]` → 220
- `SKL_STATIC_INT_IDX_0` → `skill/thief/zskill00.skl` → `[static data]` → 第0列数据
- `SKL_LVL_COLUMN_IDX_0` → `skill/thief/zskill00.skl` → `[level info]` → 第0列等级数据

**4. 状态注册依赖**
- `STATE_ZSKILL00 <- 95` → 游戏状态系统注册
- 必须在`character/thief/thief.nut`中的状态列表注册
- 状态编号必须全局唯一，避免与现有状态冲突

#### 文件修改连锁反应
当修改某个文件时，需要同步更新的相关文件：

**修改头文件常量时**:
- 更新所有引用该常量的NUT文件
- 检查CHR文件中对应索引是否存在
- 验证SKL文件中对应数据是否匹配

**修改CHR文件时**:
- 确保动画/攻击文件路径正确
- 更新头文件中的索引编号
- 检查NUT文件中的引用是否需要调整

**修改SKL文件时**:
- 确保技能编号与头文件一致
- 检查等级数据列数是否匹配索引
- 验证静态数据索引的有效性

### 3. 函数命名规范
- 所有函数名必须以技能名结尾
- 函数名格式：`function名_技能名(参数)`
- 保持命名一致性避免调用错误

### 4. 状态管理
- 技能开始时设置对应状态
- 动画结束时恢复站立状态
- 正确处理状态优先级

## 编号管理最佳实践

### 编号分配建议表
| 编号类型 | 推荐范围 | 示例 | 注意事项 |
|---------|---------|------|----------|
| 状态编号 | 90-199 | STATE_ZSKILL00 <- 95 | 避免与现有状态冲突 |
| 技能编号 | 200-299 | SKILL_ZSKILL00 <- 220 | 必须与SKL文件一致 |
| 动画索引 | 0-50 | CUSTOM_ANI_01 <- 0 | 对应CHR文件中的顺序 |
| 攻击索引 | 0-50 | CUSTOM_ATK_01 <- 0 | 对应CHR文件中的顺序 |
| 向量标志 | 0-10 | VECTOR_FLAG_0 <- 0 | 技能内部使用 |

### 常见问题与解决方案

#### 1. 状态编号冲突
**问题**: 技能无法正常触发或与其他技能冲突
**解决**: 
- 检查`character/职业/职业.nut`中的状态注册
- 使用更高的未使用编号
- 搜索现有文件确认编号未被占用

#### 2. 动画/攻击索引错误
**问题**: 技能播放错误的动画或攻击效果
**解决**:
- 检查CHR文件中`[etc motion]`和`[etc attack info]`的顺序
- 确认对应的.ani和.atk文件存在
- 验证索引编号从0开始计数

#### 3. 技能数据获取失败
**问题**: 无法正确获取技能等级数据或静态数据
**解决**:
- 检查SKL文件中的数据结构
- 确认列索引与实际数据列数匹配
- 验证技能编号与SKL文件中的skill index一致

#### 4. 文件路径指向错误
**问题**: 游戏无法找到对应的资源文件
**解决**:
- 检查CHR文件中的路径是否正确
- 确认文件名大小写匹配
- 验证文件确实存在于指定位置

### 调试技巧
1. **使用日志输出**: 在关键位置添加`print()`语句输出变量值
2. **分步测试**: 先测试基础功能，再逐步添加复杂逻辑
3. **对比参考**: 参考现有技能的实现方式
4. **版本控制**: 每次修改前备份文件，便于回滚

## 扩展学习方向

1. **被动技能开发**: 学习被动技能的实现方式
2. **多段攻击技能**: 实现连续攻击的技能逻辑
3. **召唤系统**: 学习召唤物的创建和管理
4. **Buff系统**: 实现状态增益效果
5. **技能连携**: 学习技能之间的组合机制

## 总结
通过本教程，我们深入学习了DNF技能开发的核心知识，特别是编号管理和文件指向关系。这些知识点是技能开发的基础，必须熟练掌握：

### 核心要点回顾：
1. **编号管理**: 状态编号、技能编号、动画索引、攻击索引的规范使用
2. **文件指向**: NUT→CHR→具体资源文件的完整指向链
3. **依赖关系**: 头文件、技能文件、角色文件、资源文件的相互依赖
4. **最佳实践**: 编号分配建议、常见问题解决、调试技巧

### 开发流程建议：
1. 先规划编号分配，确保无冲突
2. 创建头文件定义所有常量
3. 准备CHR文件中的动画和攻击信息
4. 实现NUT技能逻辑文件
5. 创建对应的SKL技能数据文件
6. 全面测试各种情况

记住：严格遵循编号规范和文件指向关系是技能开发成功的关键！

这个教程为DNF技能开发提供了完整的入门指导，通过三个递进的示例展示了从基础到进阶的开发过程。