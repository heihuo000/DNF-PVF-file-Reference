# PVF工具使用最佳实践

## 一、PVF文件路径机制深度解析

### 1.1 核心理解
**关键认知**：PVF文件系统采用相对路径机制，这是理解和操作PVF文件的基础。

### 1.2 路径机制详解

#### A. LST文件中的路径规则
```
passiveobject.lst 中的路径格式：
记录格式：[ID]\t[相对路径]
例如：990000	ActionObject/HQEQU/1.obj
```

#### B. 实际文件路径转换
```
LST中记录的路径：ActionObject/HQEQU/1.obj
实际完整路径：passiveobject/actionobject/hqequ/1.obj
转换规则：passiveobject/ + [LST中的路径（小写）]
```

#### C. 路径转换示例
| LST记录路径 | 实际PVF路径 | 说明 |
|------------|-------------|------|
| `ActionObject/HQEQU/1.obj` | `passiveobject/actionobject/hqequ/1.obj` | 被动对象文件 |
| `Character/Swordman/skill.obj` | `passiveobject/character/swordman/skill.obj` | 角色技能对象 |
| `Equipment/Weapon/sword.obj` | `passiveobject/equipment/weapon/sword.obj` | 装备对象 |

### 1.3 常见错误和避免方法

#### 错误示例1：直接使用LST路径
```
❌ 错误：mcp_PvfTool_get_file_content("ActionObject/HQEQU/1.obj")
✅ 正确：mcp_PvfTool_get_file_content("passiveobject/actionobject/hqequ/1.obj")
```

#### 错误示例2：大小写混淆
```
❌ 错误：passiveobject/ActionObject/HQEQU/1.obj
✅ 正确：passiveobject/actionobject/hqequ/1.obj
```

## 二、PVF搜索工具使用指南

### 2.1 mcp_PvfTool_search_pvf 参数详解

#### A. search_type 参数的正确使用
```
search_type搜索方式有很多种你要了解每种的搜索类型是不同的
search_type=0: 返回null（无结果）
search_type=1: 返回空数组（无结果）
search_type=2: 正确返回搜索结果 ✅
```



#### B. 搜索范围控制
```javascript
// 全局搜索
mcp_PvfTool_search_pvf({
    keyword: "243445",
    search_type: 2
})

// 指定目录搜索
mcp_PvfTool_search_pvf({
    keyword: "243445", 
    search_folder: "passiveobject",
    search_type: 2
})
```

### 2.2 搜索策略最佳实践

#### A. ID冲突检查流程
```
1. 搜索LST文件中的ID注册
   → mcp_PvfTool_search_pvf(keyword: "ID", search_type: 2)

2. 搜索代码文件中的ID使用
   → mcp_PvfTool_search_pvf(keyword: "ID", search_folder: "sqr", search_type: 2)

3. 验证文件是否存在
   → mcp_PvfTool_file_exists(file_path)

4. 获取文件内容确认
   → mcp_PvfTool_get_file_content(file_path)
```

#### B. 分层搜索策略
```
第一层：LST文件搜索（注册检查）
第二层：目录搜索（使用检查）
第三层：内容搜索（详细验证）
```

## 三、文件操作最佳实践

### 3.1 文件存在性验证

#### A. 标准验证流程
```javascript
// 1. 检查文件是否存在
mcp_PvfTool_file_exists("passiveobject/actionobject/hqequ/1.obj")

// 2. 获取文件内容
mcp_PvfTool_get_file_content("passiveobject/actionobject/hqequ/1.obj")

// 3. 解析JSON格式（如需要）
mcp_PvfTool_get_file_data_json("passiveobject/actionobject/hqequ/1.obj")
```

#### B. 批量操作优化
```javascript
// 批量检查文件内容
mcp_PvfTool_get_file_contents_batch({
    file_list: [
        "passiveobject/file1.obj",
        "passiveobject/file2.obj",
        "passiveobject/file3.obj"
    ]
})
```

### 3.2 编码处理

#### A. 编码类型选择
```
UTF8: 现代PVF文件（推荐）
CN: 中文简体
TW: 中文繁体
KR: 韩文
JP: 日文
Unicode: 通用Unicode
```

#### B. 编码使用示例
```javascript
mcp_PvfTool_get_file_content({
    file_path: "passiveobject/file.obj",
    encoding_type: "UTF8"
})
```

## 四、常见问题解决方案

### 4.1 文件不存在错误

#### 问题诊断
```
错误信息：文件不存在
可能原因：
1. 路径格式错误（未添加目录前缀）
2. 大小写错误
3. 文件确实不存在
```

#### 解决步骤
```
1. 检查路径格式：确保包含正确的目录前缀
2. 验证大小写：PVF路径通常为小写
3. 搜索确认：使用search_pvf确认文件位置
4. LST验证：检查相关LST文件中的注册信息
```

### 4.2 搜索无结果问题

#### 问题诊断
```
搜索返回空结果
可能原因：
1. search_type参数错误
2. 关键词不准确
3. 搜索范围过窄
4. 文件确实不存在
```

#### 解决步骤
```
1. 确保使用search_type=2
2. 尝试不同的关键词变体
3. 扩大搜索范围（去掉search_folder限制）
4. 使用正则表达式搜索
```

### 4.3 ID冲突检查

#### 完整检查流程
```
1. LST文件检查
   → 搜索所有相关LST文件
   → 确认ID是否已注册

2. 代码文件检查
   → 搜索sqr目录下的使用情况
   → 检查函数和变量引用

3. 配置文件检查
   → 检查技能树配置
   → 检查装备配置

4. 最终确认
   → 综合所有检查结果
   → 确定ID的安全性
```

## 五、工具使用技巧

### 5.1 高效搜索技巧

#### A. 渐进式搜索
```
1. 从宽泛关键词开始
2. 逐步缩小搜索范围
3. 使用精确匹配确认
```

#### B. 组合搜索策略
```
1. ID搜索 + 文件名搜索
2. 目录搜索 + 内容搜索
3. 正则表达式 + 精确匹配
```

### 5.2 批量操作优化

#### A. 批量文件处理
```javascript
// 获取文件列表
mcp_PvfTool_get_file_list({
    dir_name: "passiveobject",
    file_type: ".obj"
})

// 批量获取内容
mcp_PvfTool_get_file_contents_batch({
    file_list: file_paths
})
```

#### B. 批量ID检查
```javascript
// 批量获取物品信息
mcp_PvfTool_get_item_infos_batch({
    file_paths: item_file_paths
})

// 批量ID转文件信息
mcp_PvfTool_item_codes_to_file_infos_batch({
    lst_names: ["equipment", "stackable"],
    item_codes: [243445, 243446, 243447]
})
```

## 六、最佳实践总结

### 6.1 操作前检查清单
```
□ 确认路径格式正确（包含目录前缀）
□ 验证大小写格式
□ 使用正确的search_type参数
□ 选择合适的编码类型
□ 准备备用搜索策略
```

### 6.2 错误预防措施
```
1. 路径验证：始终验证文件路径的完整性
2. 参数检查：确认所有工具参数的正确性
3. 结果验证：对搜索结果进行二次确认
4. 备份策略：重要操作前进行备份
```

### 6.3 调试技巧
```
1. 分步验证：将复杂操作分解为简单步骤
2. 日志记录：记录每次操作的结果
3. 对比分析：与已知正确的案例对比
4. 渐进测试：从简单到复杂逐步测试
```

## 七、实际案例分析

### 7.1 被动对象ID检查案例

#### 问题场景
检查被动对象ID 243445是否在当前PVF中被使用

#### 解决过程
```
1. 初始错误：
   mcp_PvfTool_get_file_content("ActionObject/HQEQU/1.obj")
   结果：文件不存在

2. 路径机制学习：
   理解LST中的路径是相对路径

3. 正确操作：
   mcp_PvfTool_get_file_content("passiveobject/actionobject/hqequ/1.obj")
   结果：成功获取文件内容

4. 最终确认：
   ID 243445在当前PVF中未被使用，安全可用
```

#### 经验总结
```
1. 路径机制理解是基础
2. 错误信息要仔细分析
3. 多种方法交叉验证
4. 记录正确的操作流程
```

### 7.2 搜索参数优化案例

#### 问题场景
使用search_pvf搜索时返回空结果

#### 解决过程
```
1. 初始问题：
   search_type=0 或 search_type=1 返回空结果

2. 参数调整：
   改为 search_type=2

3. 成功获取：
   返回正确的搜索结果

4. 最佳实践：
   始终使用 search_type=2 进行搜索
```

## 八、工具功能对照表

| 功能需求 | 推荐工具 | 关键参数 | 注意事项 |
|---------|---------|---------|---------|
| 文件存在检查 | `mcp_PvfTool_file_exists` | file_path | 使用完整路径 |
| 文件内容获取 | `mcp_PvfTool_get_file_content` | file_path, encoding_type | 注意编码选择 |
| 关键词搜索 | `mcp_PvfTool_search_pvf` | keyword, search_type=2 | 必须使用search_type=2 |
| 目录文件列表 | `mcp_PvfTool_get_file_list` | dir_name, file_type | 可指定文件类型 |
| 批量文件处理 | `mcp_PvfTool_get_file_contents_batch` | file_list | 提高效率 |
| ID转文件信息 | `mcp_PvfTool_item_code_to_file_info` | item_code, lst_names | 需要指定LST类型 |

---

**文档版本**: 1.0  
**创建时间**: 2024年12月  
**最后更新**: 基于墓碑脱手功能开发过程中的实际经验总结  
**适用范围**: DNF PVF文件操作和MCP工具使用