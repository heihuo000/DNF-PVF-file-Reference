# PVF路径机制快速参考

## 🚀 快速查阅指南

### 核心原理
```
LST文件路径 = 相对路径
实际PVF路径 = 目录前缀 + 相对路径（小写）
```

### 路径转换公式
```
passiveobject.lst中: ActionObject/HQEQU/1.obj
实际PVF路径: passiveobject/actionobject/hqequ/1.obj
```

## 🔧 常用工具参数

### 搜索工具
```javascript
// ✅ 正确用法
mcp_PvfTool_search_pvf({
    keyword: "243445",
    search_type: 2  // 搜索方式有多种,如果搜索不到内容可以尝试更换一下参数
})
```

### 文件读取
```javascript
// ✅ 正确路径格式
mcp_PvfTool_get_file_content("passiveobject/actionobject/hqequ/1.obj")

// ❌ 错误路径格式  
mcp_PvfTool_get_file_content("ActionObject/HQEQU/1.obj")
```

## 📋 检查清单

### ID冲突检查
- [ ] LST文件搜索 (`search_type=2`)
- [ ] 代码文件搜索 (`search_folder="sqr"`)
- [ ] 文件存在验证 (`file_exists`)
- [ ] 内容确认 (`get_file_content`)

### 路径验证
- [ ] 包含目录前缀 (`passiveobject/`, `skill/`, `sqr/`)
- [ ] 全部小写
- [ ] 正确的分隔符 (`/`)

## ⚠️ 常见错误

| 错误类型 | 错误示例 | 正确示例 |
|---------|---------|---------|
| 缺少前缀 | `ActionObject/file.obj` | `passiveobject/actionobject/file.obj` |
| 大小写错误 | `PassiveObject/File.obj` | `passiveobject/file.obj` |
| 搜索参数错误 | `search_type=0` | `search_type=2` |

## 🎯 快速解决方案

### 文件不存在
1. 检查路径前缀
2. 验证大小写
3. 使用搜索确认位置

### 搜索无结果
1. 确保 `search_type=2`
2. 尝试不同关键词
3. 扩大搜索范围

### ID冲突检查
1. 搜索LST注册: `search_pvf(id, search_type=2)`
2. 搜索代码使用: `search_pvf(id, search_folder="sqr", search_type=2)`
3. 最终确认: `file_exists` + `get_file_content`

---
**提示**: 遇到问题时，先检查路径格式和搜索参数！