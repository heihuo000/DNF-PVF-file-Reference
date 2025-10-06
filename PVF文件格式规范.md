# PVF文件格式规范（基于真实PVF文件分析）

## 概述

PVF（Player Versus Fighter）文件是DNF游戏中用于定义装备、道具、技能、地图等游戏内容的配置文件。本文档基于对真实PVF文件的深入分析，详细说明了PVF文件的实际格式规范和编写要求。

**本规范适用于所有PVF文件类型，包括但不限于：**
- **EQU文件** - 装备文件（武器、防具、首饰等）
- **STK文件** - 堆叠物品文件（消耗品、材料等）
- **MAP文件** - 地图文件
- **SKL文件** - 技能文件
- **ANI文件** - 动画文件
- **其他PVF格式文件**

## 真实格式分析来源

本规范基于以下真实PVF文件的分析：
- `equipment/brac_2choro994.equ` - 装备文件
- `equipment/tonfa_2213101.equ` - 武器文件  
- `stackable/material/material_3291.stk` - 材料文件
- `map/hendonmyre/hendon_auction.map` - 地图文件

## 基本格式要求

### 1. 文件编码
- **必须使用UTF-8编码**
- 支持中文、韩文、日文等多种字符
- 避免使用GBK或其他编码格式

### 2. 行尾符
- **使用CRLF（\r\n）作为行尾符**
- 这是真实PVF文件中使用的标准格式
- 与之前认为的LF格式不同

### 3. 缩进格式
- **使用制表符（Tab）进行缩进**
- 每个缩进层级使用一个制表符
- 嵌套结构使用多个制表符表示层级

### 4. 参数分隔
- **参数之间使用制表符（Tab）分隔**
- 这是真实PVF文件中的标准做法
- 不要使用空格分隔参数

### 5. 标签格式
- 标签使用方括号包围：`[tag name]`
- 标签名称使用小写字母和空格
- 标签可以从行首开始，也可以有缩进

### 6. 参数值格式
**基于真实PVF文件的参数格式规则：**
- **数字值**：直接写数字，**不加任何引号**
	- 示例：`[level]	50`、`[price]	1000`
- **字符串值**：使用**反引号**包围 `` `string` ``
	- 示例：`[name]	`测试装备``、`[usable job]	`[all]``
- **特殊字符串**：某些特殊值可能使用双引号，但反引号是主流
- **布尔值**：通常用数字表示（0/1）或特定字符串

## 详细格式说明

### 1. 文件头格式
所有PVF文件都以 `#PVF_File` 开头：
```
#PVF_File

[name]	`装备名称`
```

### 2. 字符串值格式
**重要发现：真实PVF文件中字符串值使用反引号包围**

✅ 正确格式：
```
[name]	`精 · 加持的禁锢之限手镯 : [湮灭黑洞]`
[description]	`这是装备描述`
[type]	`[normal]`
```

❌ 错误格式：
```
[name]	"装备名称"     // 不要使用双引号
[name]	'装备名称'     // 不要使用单引号
```

### 3. 数值格式
**数值直接写，不使用任何引号**

✅ 正确格式：
```
[level]	50
[price]	1000
[weight]	1.5
[offset x]	-10
```

❌ 错误格式：
```
[level]	`50`         // 数值不要用反引号
[price]	"1000"       // 数值不要用双引号
```

### 4. 参数分隔格式
**参数之间使用制表符（Tab）分隔**

✅ 正确格式：
```
[player number]	2	8
[pvp start area]	650	230	474	213
[icon mark]	`item/equipment.img`	14
[equipment type]	`[weapon]`	21
```

❌ 错误格式：
```
[player number] 2 8                    // 不要用空格分隔
[icon mark] `item.img`  14             // 不要用多个空格
```

### 5. 缩进格式
**使用制表符进行缩进，每层一个Tab**

✅ 正确格式：
```
[equipment option]
	[physical attack]	100	200
	[magical attack]	50	100
[/equipment option]

[background animation]
	[ani info]
		[filename]	`Animation/far00.ani`
		[layer]	`[distantback]`
	[/ani info]
[/background animation]
```

❌ 错误格式：
```
[equipment option]
    [physical attack] 100 200          // 不要用空格缩进
[/equipment option]
```

### 6. 标签格式
```
[标签名]                               // 单独标签
[标签名]	参数1	参数2	参数3           // 带参数的标签
[/标签名]                              // 结束标签
```

### 7. 注释格式
- 使用双斜杠 `//` 开始注释
- 注释可以在行末或单独一行
- 注释前通常有空格或Tab
- 注释可以出现在任何位置

### 8. 空行规则
- 相关标签组之间可以有空行
- 文件末尾应该有一个空行
- 空行用于提高可读性

## 真实文件示例分析

### 装备文件示例（brac_2choro994.equ）
```
#PVF_File

[name]	`精 · 加持的禁锢之限手镯 : [湮灭黑洞]`
[grade]	2
[rarity]	5
[icon mark]	`item/new_equipment/05_acc/bracelet/br_a_2choro994.img`	0
[field image]	`item/new_equipment/05_acc/bracelet/br_a_2choro994.img`	1
[equipment type]	`[bracelet]`	23
[move wav]	`BONE_TOUCH`
[durability]	45
[weight]	250
[price]	632000
```

### 地图文件示例（hendon_auction.map）
```
#PVF_File

[background pos]	80
[player number]	2	8
[pvp start area]	650	230	474	213
[type]	`[normal]`
[tile]
	`Tile/hm01.til`
	`Tile/hm01.til`
[/tile]
[animation]
	`Animation/gate01.ani`	`[normal]`	1342	415	0
	`Animation/hmlight01.ani`	`[normal]`	1340	415	0
[/animation]
```

## 格式验证要点

### 必须检查的项目：
1. **文件编码**：UTF-8
2. **行尾符**：CRLF（\r\n）
3. **字符串引号**：使用反引号 `` ` ``
4. **数值格式**：无引号
5. **参数分隔**：制表符（Tab）
6. **缩进**：制表符（Tab）

### 常见错误修正：

❌ **引号错误**：
```
[name]	"装备名称"
[type]	'类型'
```
✅ **修正后**：
```
[name]	`装备名称`
[type]	`类型`
```

❌ **数值引号错误**：
```
[level]	`50`
[price]	"1000"
```
✅ **修正后**：
```
[level]	50
[price]	1000
```

❌ **分隔符错误**：
```
[icon mark] `item.img` 14              // 空格分隔
[equipment type] `[weapon]`  21        // 多空格分隔
```
✅ **修正后**：
```
[icon mark]	`item.img`	14             // Tab分隔
[equipment type]	`[weapon]`	21       // Tab分隔
```

❌ **缩进错误**：
```
[equipment option]
    [physical attack] 100 200          // 空格缩进
[/equipment option]
```
✅ **修正后**：
```
[equipment option]
	[physical attack]	100	200        // Tab缩进和Tab分隔
[/equipment option]
```

## 编辑器配置建议

### VS Code 设置：
```json
{
	"editor.insertSpaces": false,
	"editor.detectIndentation": false,
	"files.eol": "\r\n",
	"editor.renderWhitespace": "all"
}
```

### Notepad++ 设置：
- 编码：UTF-8
- 行尾符：Windows (CRLF)
- 显示：显示所有字符
- 缩进：使用制表符

## 验证工具

使用提供的格式检查工具验证文件格式：
```powershell
.\Check-PVFFormat.ps1 -FilePath "your_file.equ" -ShowDetails
```

## 不同文件类型的应用说明

### EQU文件（装备文件）
EQU文件严格遵循本规范的所有要求：
- 所有字符串值必须使用反引号 `` ` `` 包围
- 数值参数不使用任何引号
- 参数间使用制表符分隔
- 缩进使用制表符
- 特别注意装备属性、技能等级、套装信息等复杂结构的格式

### STK文件（堆叠物品文件）
STK文件同样遵循本规范：
- 物品名称、描述等字符串使用反引号
- 价格、重量、等级等数值直接写
- 嵌套结构（如booster info）严格按缩进规则
- 特别注意消耗品效果、材料属性等的格式

### 其他文件类型
MAP、SKL、ANI等文件类型也必须遵循相同的基础格式规范，只是具体的标签内容不同。

## 总结

基于真实PVF文件分析，标准格式为：
- 字符串：`` `内容` ``（反引号）
- 数值：直接写数字
- 分隔：制表符（Tab）
- 缩进：制表符（Tab）
- 行尾：CRLF（\r\n）

**这个规范适用于所有PVF文件类型，包括EQU、STK、MAP等所有格式。**

这与之前基于传言的格式规范有显著差异，请以此真实分析为准。

## 注意事项

- 本规范基于官方示例文件 `equipmentsamplebytool.equ.md` 等文件的实际格式分析
- 官方文件中存在一定的格式灵活性，但建议遵循一致的规范
- 在实际使用中，建议优先参考官方示例文件的格式

## 缩进规则详解

### ✅ 正确格式
```
[usable job]
	`[swordman]`
	`[fighter]`
[/usable job]

[avatar select ability]
	`[MAGICAL_ATTACK]`	`+`	45
	`[MAGICAL_DEFENSE]`	`+`	45
[/avatar select ability]
```

### ❌ 错误格式
```
[usable job]
    `[swordman]`        # 错误：使用空格缩进
    `[fighter]`
[/usable job]

[avatar select ability]
  `[MAGICAL_ATTACK]`	`+`	45    # 错误：使用空格缩进
  `[MAGICAL_DEFENSE]`	`+`	45
[/avatar select ability]
```

**规则**: 所有缩进必须使用TAB键，不能使用空格

## 标签格式规则

### ✅ 正确格式
```
[name]
	`物品名称`

[grade]
	2

[stackable type]
	`[consumable]`	0

[price]
	1000

[value]
	500
```

### ❌ 错误格式
```
[ name ]            # 错误：标签名前后有空格
	`物品名称`

[grade ]            # 错误：标签名后有空格
	2

[ stackable type]   # 错误：标签名前有空格
	`[consumable]`	0
```

**规则**: 标签名前后不能有空格，必须紧贴方括号

## 🔧 编辑器设置建议

### Visual Studio Code
```json
{
	"editor.insertSpaces": false,
	"editor.detectIndentation": false,
	"editor.tabSize": 4,
	"files.encoding": "utf8"
}
```

### Notepad++
1. 设置 → 首选项 → 语言
2. 取消勾选 "用空格替代制表符"
3. 设置制表符大小为4

### Sublime Text
```json
{
	"translate_tabs_to_spaces": false,
	"tab_size": 4,
	"detect_indentation": false
}
```

## 📝 格式检查清单

### 基础检查
- [ ] 所有字符串都使用反引号 `` ` `` 包围
- [ ] 参数之间使用TAB键分隔
- [ ] 缩进使用TAB键，不使用空格
- [ ] 标签名前后没有多余空格
- [ ] 文件编码为UTF-8

### 高级检查
- [ ] 数值参数没有使用引号
- [ ] 布尔值使用正确格式（0/1）
- [ ] 路径分隔符使用正斜杠 `/`
- [ ] 标签配对正确（开始/结束标签）

## 🛠️ 格式验证工具

### PowerShell检查脚本
```powershell
# 检查文件中的空格缩进
function Check-PVFFormat {
	param([string]$FilePath)
	
	$lines = Get-Content $FilePath -Encoding UTF8
	$lineNumber = 0
	
	foreach ($line in $lines) {
		$lineNumber++
		
		# 检查是否使用空格缩进
		if ($line -match "^[ ]+[^[ ]") {
			Write-Warning "第 $lineNumber 行使用了空格缩进: $line"
		}
		
		# 检查字符串是否使用正确的引号
		if ($line -match '"[^"]*"' -or $line -match "'[^']*'") {
			Write-Warning "第 $lineNumber 行使用了错误的引号: $line"
		}
		
		# 检查参数分隔是否使用空格
		if ($line -match "`t.*[ ]+.*`t" -or $line -match "^[^`t]*[ ]+[^`t]*$") {
			if (-not ($line -match "^\[.*\]$")) {  # 排除标签行
				Write-Warning "第 $lineNumber 行可能使用了空格分隔参数: $line"
			}
		}
	}
}

# 使用方法
Check-PVFFormat "path/to/your/file.stk"
```

### Python检查脚本
```python
import re

def check_pvf_format(file_path):
	"""检查PVF文件格式"""
	with open(file_path, 'r', encoding='utf-8') as f:
		lines = f.readlines()
	
	errors = []
	
	for i, line in enumerate(lines, 1):
		# 检查空格缩进
		if re.match(r'^[ ]+[^[ ]', line):
			errors.append(f"第 {i} 行使用了空格缩进")
		
		# 检查错误的引号
		if re.search(r'"[^"]*"', line) or re.search(r"'[^']*'", line):
			errors.append(f"第 {i} 行使用了错误的引号")
		
		# 检查字符串格式
		if '`' in line:
			if not re.search(r'`[^`]*`', line):
				errors.append(f"第 {i} 行字符串格式错误")
	
	return errors

# 使用方法
errors = check_pvf_format("path/to/your/file.stk")
for error in errors:
	print(error)
```

## 📋 常见格式错误

### 错误1: 使用空格代替TAB
```
# 错误
[icon]
    `item/stackable/consume.img` 25

# 正确
[icon]
	`item/stackable/consume.img`	25
```

### 错误2: 字符串使用错误引号
```
# 错误
[name]
	"HP恢复药水"
	'HP恢复药水'

# 正确
[name]
	`HP恢复药水`
```

### 错误3: 参数使用空格分隔
```
# 错误
[strength] 25 300000

# 正确
[strength]	25	300000
```

### 错误4: 标签名包含空格
```
# 错误
[ name ]
	`物品名称`

# 正确
[name]
	`物品名称`
```

### 错误5: 数值使用引号
```
# 错误
[grade]
	`2`

# 正确
[grade]
	2
```

## 🎯 最佳实践

### 1. 编辑器配置
- 设置显示制表符和空格
- 禁用自动空格替换
- 使用UTF-8编码
- 设置制表符大小为4

### 2. 编写习惯
- 复制现有正确格式的文件作为模板
- 使用TAB键进行缩进和分隔
- 所有字符串使用反引号
- 定期使用检查工具验证

### 3. 测试流程
1. 编写完成后运行格式检查
2. 在游戏中测试文件是否正常加载
3. 检查功能是否按预期工作
4. 记录任何格式相关的问题

## ⚠️ 特别注意事项

1. **绝对不要混用空格和TAB**
2. **字符串内容可以包含空格，但分隔符必须是TAB**
3. **复制粘贴时要特别注意格式保持**
4. **不同编辑器可能会自动转换格式，需要检查**
5. **文件保存时确保使用UTF-8编码**

## 🔗 相关链接

- [格式规范工具](格式规范工具/) - 使用正确格式的模板和检查工具
- [PVF格式检查工具](格式规范工具/PVF格式检查工具.py) - 自动化格式检查
- [快速使用指南](格式规范工具/快速使用指南.md) - 格式规范快速入门

---

**记住：PVF文件格式容不得半点马虎，一个字符的错误都可能导致整个文件失效！**