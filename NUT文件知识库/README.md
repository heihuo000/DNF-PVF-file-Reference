# NUT脚本知识库 - 快速入门指南

## 🎯 欢迎来到NUT脚本世界

NUT脚本是DNF游戏中用于实现自定义技能、装备效果和游戏逻辑的强大脚本语言。本知识库将帮助您从零开始掌握NUT脚本开发。

## 📚 知识库结构

```
NUT文件知识库/
├── README.md              # 📖 快速入门指南（当前文件）
├── 标签参考.md             # 🏷️ 核心函数和语法详解
├── 依赖文件简介.md         # 🔗 文件间关联关系
├── 问题解答.md             # ❓ 常见问题和解决方案
├── 示例文件/               # 💡 实用代码模板
│   ├── 01-基础技能模板.nut
│   ├── 02-多动作技能模板.nut
│   ├── 03-BUFF技能模板.nut
│   ├── 04-被动技能模板.nut
│   └── 05-函数合并示例.nut
└── 高级示例/               # 🚀 高级开发指南和实战案例
    ├── NUT脚本开发完整指南.md
    ├── DNF引擎Squirrel脚本调用机制详解.md
    ├── DAF学院NUT脚本知识总结.md
    └── 常用技能模板集合.md
```

## 🚀 快速开始

### 第一步：了解基础概念

NUT脚本的核心概念包括：

- **State（状态）**: 技能或角色的当前状态
- **Skill（技能）**: 可释放的技能定义
- **Object（对象）**: 游戏中的实体（角色、怪物等）
- **Damager（伤害器）**: 处理伤害计算的对象

### 第二步：环境准备

1. **工具准备**:
   - 文本编辑器（推荐Notepad++）
   - PVF编辑器
   - 游戏测试环境

2. **文件结构**:
   ```
   script/
   ├── [职业]_header.nut    # 常量定义
   ├── [职业].nut           # 主要逻辑
   └── test.nut             # 调试文件
   ```

### 第三步：创建第一个技能

让我们创建一个简单的攻击技能：

```nut
// 1. 在header文件中定义常量
STATE_MY_FIRST_SKILL <- 100;
SKILL_MY_FIRST_SKILL <- 200;

// 2. 检查技能是否可以释放
function checkExecutableSkill_MyFirstSkill(obj)
{
    if(!obj) return false;
    
    // 检查冷却时间
    if(obj.sq_IsUseSkill(SKILL_MY_FIRST_SKILL)) return false;
    
    // 检查MP消耗
    local needMp = 50;
    if(obj.sq_GetMp() < needMp) return false;
    
    return true;
}

// 3. 设置技能状态
function onSetState_MyFirstSkill(obj, state, datas, isResetTimer)
{
    if(!obj) return;
    
    if(isResetTimer)
    {
        // 播放动画
        obj.sq_SetCurrentAnimation(CUSTOM_ANI_ATTACK);
        
        // 停止移动
        obj.sq_StopMove();
        
        // 设置攻击判定时机
        obj.sq_AddSetStatePacket(STATE_MY_FIRST_SKILL, STATE_PRIORITY_USER, false);
        obj.sq_SetCurrentAttackInfo(0);
    }
}

// 4. 处理时间事件
function onTimeEvent_MyFirstSkill(obj, timeEventIndex, timeEventCount)
{
    if(!obj) return;
    
    if(timeEventIndex == 0)
    {
        // 创建攻击区域
        obj.sq_StartWrite();
        obj.sq_WriteDword(obj.sq_GetSkillLevel(SKILL_MY_FIRST_SKILL));
        obj.sq_SendCreatePassiveObjectPacket(24211, 0, 100, 0, 0);
        
        // 返回站立状态
        obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, true);
    }
}

// 5. 处理攻击判定
function onAttack_MyFirstSkill(obj, damager, boundingBox, isStuck)
{
    if(!obj || !damager) return;
    
    // 设置伤害倍率
    local skillLevel = obj.sq_GetSkillLevel(SKILL_MY_FIRST_SKILL);
    local damageRate = 100 + (skillLevel * 10);  // 基础100%，每级+10%
    
    damager.sq_SetDamageRate(damageRate);
    damager.sq_SetAttackInfo(SAI_IS_MAGIC, false);  // 物理攻击
}
```

## 📖 学习路径推荐

### 🌱 初学者路径（1-2周）

1. **基础语法学习**
   - 阅读 [标签参考.md](标签参考.md) 中的基础语法部分
   - 理解变量、函数、条件语句的使用

2. **核心概念理解**
   - 学习State、Skill、Object的概念
   - 理解技能释放的完整流程

3. **第一个技能**
   - 使用 [01-基础技能模板.nut](示例文件/01-基础技能模板.nut)
   - 修改参数，创建自己的技能

### 🌿 进阶路径（2-4周）

1. **复杂技能开发**
   - 学习 [02-多动作技能模板.nut](示例文件/02-多动作技能模板.nut)
   - 掌握多阶段技能的设计

2. **BUFF系统**
   - 研究 [03-BUFF技能模板.nut](示例文件/03-BUFF技能模板.nut)
   - 实现状态增益效果

3. **被动技能**
   - 学习 [04-被动技能模板.nut](示例文件/04-被动技能模板.nut)
   - 理解事件触发机制

### 🌳 高级路径（1-2个月）

1. **函数合并**
   - 掌握 [05-函数合并示例.nut](示例文件/05-函数合并示例.nut)
   - 学习模块化设计

2. **深入理解引擎机制**
   - 阅读 [DNF引擎Squirrel脚本调用机制详解.md](高级示例/DNF引擎Squirrel脚本调用机制详解.md)
   - 理解脚本加载和执行流程

3. **完整开发指南**
   - 学习 [NUT脚本开发完整指南.md](高级示例/NUT脚本开发完整指南.md)
   - 掌握从理论到实践的完整开发流程

4. **实战技能模板**
   - 使用 [常用技能模板集合.md](高级示例/常用技能模板集合.md)
   - 快速开发各种类型的技能

5. **DAF学院进阶**
   - 参考 [DAF学院NUT脚本知识总结.md](高级示例/DAF学院NUT脚本知识总结.md)
   - 学习高级开发技巧和最佳实践

6. **性能优化**
   - 学习缓存机制
   - 掌握内存管理

7. **复杂系统设计**
   - 状态机设计
   - 事件系统架构

## 🛠️ 开发工具和技巧

### 调试技巧

1. **使用print输出**:
```nut
function debugInfo(obj)
{
    print("=== Debug Info ===");
    print("State: " + obj.sq_GetState());
    print("HP: " + obj.sq_GetHp());
    print("MP: " + obj.sq_GetMp());
    print("================");
}
```

2. **动态调试**:
```nut
// 在test.nut中定义测试函数
function testSkill(obj)
{
    // 测试逻辑
    obj.sq_AddSetStatePacket(STATE_MY_SKILL, STATE_PRIORITY_USER, true);
}

// 在主文件中引用
dofile("test.nut");
```

3. **分段测试**:
```nut
// 注释掉可能有问题的部分
function problematicFunction(obj)
{
    // obj.sq_SetCurrentAnimation(CUSTOM_ANI);  // 暂时注释
    obj.sq_StopMove();  // 保留这部分测试
    // obj.sq_AddSetStatePacket(...);  // 暂时注释
}
```

### 常用代码片段

1. **安全的对象检查**:
```nut
function safeFunction(obj)
{
    if(!obj) return;  // 必须的安全检查
    // 使用obj的代码
}
```

2. **技能冷却检查**:
```nut
if(obj.sq_IsUseSkill(SKILL_ID)) return false;
```

3. **MP消耗检查**:
```nut
local needMp = obj.sq_GetIntData(SKILL_ID, SKL_MP_CONSUMPTION);
if(obj.sq_GetMp() < needMp) return false;
```

## ⚠️ 重要注意事项

### 语法规范

1. **字符串必须使用反引号**:
```nut
// ✅ 正确
[name] `技能名称`

// ❌ 错误
[name] "技能名称"
```

2. **使用Tab缩进**:
```nut
// ✅ 正确（使用Tab）
function example()
{
	local value = 100;
	return value;
}
```

3. **函数命名规范**:
```nut
// 状态处理函数
function onSetState_SkillName(obj, state, datas, isResetTimer)

// 攻击处理函数
function onAttack_SkillName(obj, damager, boundingBox, isStuck)

// 时间事件函数
function onTimeEvent_SkillName(obj, timeEventIndex, timeEventCount)
```

### 性能考虑

1. **避免无限循环**
2. **及时清理资源**
3. **缓存重复计算**
4. **限制递归深度**

### 安全实践

1. **始终检查对象是否为空**
2. **验证数组边界**
3. **处理异常情况**
4. **备份重要文件**

## 🔗 相关资源

### 知识库文档

- [标签参考.md](标签参考.md) - 详细的函数和语法说明
- [依赖文件简介.md](依赖文件简介.md) - 文件间关系和引用规则
- [问题解答.md](问题解答.md) - 常见问题的解决方案

### 示例代码

#### 基础示例
- [基础技能模板](示例文件/01-基础技能模板.nut) - 简单攻击技能
- [多动作技能模板](示例文件/02-多动作技能模板.nut) - 复杂多阶段技能
- [BUFF技能模板](示例文件/03-BUFF技能模板.nut) - 状态增益技能
- [被动技能模板](示例文件/04-被动技能模板.nut) - 被动触发技能
- [函数合并示例](示例文件/05-函数合并示例.nut) - 代码整合技巧

#### 高级示例
- [NUT脚本开发完整指南](高级示例/NUT脚本开发完整指南.md) - 从理论到实践的完整开发流程
- [DNF引擎Squirrel脚本调用机制详解](高级示例/DNF引擎Squirrel脚本调用机制详解.md) - 深入理解引擎机制
- [DAF学院NUT脚本知识总结](高级示例/DAF学院NUT脚本知识总结.md) - 高级开发技巧和最佳实践
- [常用技能模板集合](高级示例/常用技能模板集合.md) - 10种常见技能类型的完整实现模板

### 外部资源

- DAF学院官方教程
- 社区论坛和讨论组
- 相关工具和编辑器

## 🎓 学习建议

1. **循序渐进**: 从简单的技能开始，逐步增加复杂度
2. **多练习**: 理论结合实践，多写多测试
3. **参考示例**: 充分利用示例代码，理解设计思路
4. **社区交流**: 积极参与社区讨论，学习他人经验
5. **文档先行**: 遇到问题先查阅文档，再寻求帮助

## 🆘 获取帮助

当您遇到问题时，建议按以下顺序寻求帮助：

1. **查阅 [问题解答.md](问题解答.md)** - 查看是否有相似问题
2. **检查示例代码** - 参考相关模板的实现
3. **社区求助** - 在相关论坛或群组提问
4. **调试技巧** - 使用调试方法定位问题

## 📝 贡献指南

欢迎为知识库贡献内容：

1. **报告问题**: 发现错误或不准确的信息
2. **提供示例**: 分享有用的代码片段
3. **完善文档**: 补充缺失的说明或教程
4. **优化结构**: 建议更好的组织方式

---

## 🎉 开始您的NUT脚本之旅

现在您已经了解了基础知识，可以开始实践了！建议从 [01-基础技能模板.nut](示例文件/01-基础技能模板.nut) 开始，创建您的第一个自定义技能。

记住：**实践是最好的老师**。不要害怕犯错，每个错误都是学习的机会。

祝您在NUT脚本开发的道路上取得成功！🚀

---

## 📈 版本更新记录

### v2.0 (2024年12月) - 高级示例扩展版
- ✅ 新增高级示例目录，包含4个专业指南文档
- ✅ 添加完整的NUT脚本开发指南，涵盖理论到实践
- ✅ 深入解析DNF引擎Squirrel脚本调用机制
- ✅ 整合DAF学院高级开发技巧和最佳实践
- ✅ 提供10种常见技能类型的完整实现模板
- ✅ 优化学习路径，增加高级开发阶段指导

### v1.0 (2024年) - 基础版本
- ✅ 建立基础知识库结构
- ✅ 提供5个基础示例模板
- ✅ 完善核心概念和语法说明
- ✅ 建立快速入门指南

---

*最后更新：2024年12月*  
*知识库版本：2.0*  
*贡献者：NUT脚本开发团队*