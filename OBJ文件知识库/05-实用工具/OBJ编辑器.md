# OBJ编辑器工具

## 📝 编辑器选择

### 推荐编辑器

#### Visual Studio Code
**优势**：
- 免费开源，功能强大
- 丰富的插件生态
- 优秀的语法高亮支持
- 内置终端和调试功能

**配置方法**：
```json
// settings.json 配置
{
    "files.associations": {
        "*.obj": "plaintext"
    },
    "editor.insertSpaces": false,
    "editor.detectIndentation": false,
    "editor.tabSize": 4,
    "editor.renderWhitespace": "all"
}
```

**推荐插件**：
- **Bracket Pair Colorizer**：标签配对高亮
- **Whitespace**：显示空白字符
- **Find and Replace**：批量查找替换

#### Notepad++
**优势**：
- 轻量级，启动快速
- 支持多种编码格式
- 强大的查找替换功能
- 插件支持

**配置方法**：
1. 设置 → 首选项 → 语言
2. 添加自定义语言定义
3. 配置语法高亮规则

```xml
<!-- PVF语法高亮配置 -->
<Language name="PVF" ext="obj equ skl" commentLine="#" commentStart="/*" commentEnd="*/">
    <Keywords name="Keywords1">[name] [width] [layer] [pass type] [basic action]</Keywords>
    <Keywords name="Keywords2">[object destroy condition] [destroy condition]</Keywords>
</Language>
```

#### Sublime Text
**优势**：
- 高性能文本编辑
- 强大的多选功能
- 丰富的快捷键
- 插件扩展性强

**配置文件**：
```json
// PVF.sublime-syntax
%YAML 1.2
---
name: PVF
file_extensions:
  - obj
  - equ
  - skl
scope: source.pvf

contexts:
  main:
    - match: '#.*$'
      scope: comment.line.pvf
    - match: '\[.*\]'
      scope: keyword.control.pvf
    - match: '`.*`'
      scope: string.quoted.pvf
```

## 🛠️ 专用工具

### PVF Studio
**功能特点**：
- 专为DNF PVF文件设计
- 可视化编辑界面
- 实时语法检查
- 文件依赖关系显示

**使用方法**：
1. 下载并安装PVF Studio
2. 打开OBJ文件
3. 使用可视化界面编辑属性
4. 实时预览效果

**界面说明**：
```
┌─────────────────────────────────────┐
│ 文件 编辑 视图 工具 帮助            │
├─────────────────────────────────────┤
│ 文件树    │ 属性编辑器    │ 预览   │
│ ├─obj/    │ [name]        │        │
│ │ ├─test  │ `测试对象`    │ [图像] │
│ │ └─...   │ [width]       │        │
│ └─...     │ 50            │        │
└─────────────────────────────────────┘
```

### DNF Editor
**功能特点**：
- 集成开发环境
- 多文件类型支持
- 项目管理功能
- 版本控制集成

**项目结构**：
```
DNF_Project/
├── passiveobject/
│   ├── skill/
│   ├── monster/
│   └── common/
├── Action/
├── AttackInfo/
└── Animation/
```

## 🔧 自定义工具

### 格式检查脚本

#### Python版本
```python
#!/usr/bin/env python3
# obj_checker.py - OBJ文件格式检查工具

import os
import re
import sys

def check_obj_file(filepath):
    """检查OBJ文件格式"""
    errors = []
    
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    # 检查文件头
    if not lines[0].strip().startswith('#PVF_File'):
        errors.append("缺少文件头 #PVF_File")
    
    # 检查字符串格式
    for i, line in enumerate(lines, 1):
        if '"' in line and not line.strip().startswith('#'):
            errors.append(f"第{i}行: 发现双引号，应使用反引号")
    
    # 检查必需标签
    content = ''.join(lines)
    if '[name]' not in content:
        errors.append("缺少必需标签 [name]")
    
    return errors

def main():
    if len(sys.argv) != 2:
        print("用法: python obj_checker.py <obj文件路径>")
        return
    
    filepath = sys.argv[1]
    if not os.path.exists(filepath):
        print(f"文件不存在: {filepath}")
        return
    
    errors = check_obj_file(filepath)
    
    if errors:
        print(f"发现 {len(errors)} 个错误:")
        for error in errors:
            print(f"  - {error}")
    else:
        print("文件格式正确!")

if __name__ == "__main__":
    main()
```

#### 批处理版本
```batch
@echo off
REM obj_checker.bat - OBJ文件批量检查工具

setlocal enabledelayedexpansion

echo OBJ文件格式检查工具
echo ==================

set error_count=0

for %%f in (*.obj) do (
    echo 检查文件: %%f
    
    REM 检查文件头
    findstr /b "#PVF_File" "%%f" >nul
    if !errorlevel! neq 0 (
        echo   错误: 缺少文件头 #PVF_File
        set /a error_count+=1
    )
    
    REM 检查双引号
    findstr /n "\"" "%%f" >nul
    if !errorlevel! equ 0 (
        echo   警告: 发现双引号，建议使用反引号
        set /a error_count+=1
    )
    
    REM 检查必需标签
    findstr "\[name\]" "%%f" >nul
    if !errorlevel! neq 0 (
        echo   错误: 缺少必需标签 [name]
        set /a error_count+=1
    )
    
    echo.
)

echo 检查完成，发现 !error_count! 个问题
pause
```

### 模板生成器

#### OBJ模板生成脚本
```python
#!/usr/bin/env python3
# obj_template.py - OBJ文件模板生成器

import os
import sys

TEMPLATES = {
    'basic_effect': '''#PVF_File

[name]
`{name}`

[width]
{width}

[layer]
`[normal]`

[pass type]
`[pass all]`

[basic action]
`Action/{action_file}.act`

[object destroy condition]
\t`[destroy condition]`
\t`[on end of animation]`
\t`[/destroy condition]`
[/object destroy condition]
''',
    
    'attack_object': '''#PVF_File

[name]
`{name}`

[width]
{width}

[layer]
`[normal]`

[pass type]
`[pass enemy]`

[piercing power]
{piercing_power}

[team]
`[friend]`

[basic action]
`Action/{action_file}.act`

[attack info]
`AttackInfo/{attack_file}.atk`

[vanish]
`[on collision]`

[object destroy condition]
\t`[destroy condition]`
\t`[on collision]`
\t`[/destroy condition]`
[/object destroy condition]
''',
    
    'trap_object': '''#PVF_File

[name]
`{name}`

[width]
{width}

[layer]
`[bottom]`

[pass type]
`[do not pass]`

[hp]
{hp}

[basic action]
`Action/{action_file}.act`

[attack info]
`AttackInfo/{attack_file}.atk`

[object destroy condition]
\t`[destroy condition]`
\t`[on hp]`
\t`[/destroy condition]`
[/object destroy condition]
'''
}

def generate_template(template_type, **kwargs):
    """生成OBJ模板"""
    if template_type not in TEMPLATES:
        print(f"未知模板类型: {template_type}")
        print(f"可用模板: {', '.join(TEMPLATES.keys())}")
        return None
    
    return TEMPLATES[template_type].format(**kwargs)

def main():
    print("OBJ文件模板生成器")
    print("================")
    
    # 获取用户输入
    template_type = input("选择模板类型 (basic_effect/attack_object/trap_object): ")
    name = input("对象名称: ")
    width = input("对象宽度 (默认50): ") or "50"
    action_file = input("ACT文件名 (不含扩展名): ")
    
    kwargs = {
        'name': name,
        'width': width,
        'action_file': action_file
    }
    
    # 根据模板类型添加额外参数
    if template_type == 'attack_object':
        kwargs['piercing_power'] = input("穿刺力 (默认500): ") or "500"
        kwargs['attack_file'] = input("ATK文件名 (不含扩展名): ")
    elif template_type == 'trap_object':
        kwargs['hp'] = input("生命值 (默认1): ") or "1"
        kwargs['attack_file'] = input("ATK文件名 (不含扩展名): ")
    
    # 生成模板
    template_content = generate_template(template_type, **kwargs)
    if template_content:
        filename = f"{name.replace(' ', '_')}.obj"
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(template_content)
        print(f"模板已生成: {filename}")

if __name__ == "__main__":
    main()
```

## 📋 工具配置指南

### 编辑器通用配置

#### 基础设置
```ini
# 通用编辑器配置
[editor]
tab_size = 4
use_tabs = true
show_whitespace = true
word_wrap = false
encoding = utf-8

[syntax]
highlight_brackets = true
highlight_keywords = true
case_sensitive = false
```

#### 快捷键配置
```
Ctrl+D          # 复制当前行
Ctrl+Shift+D    # 删除当前行
Ctrl+/          # 切换注释
Ctrl+F          # 查找
Ctrl+H          # 替换
F3              # 查找下一个
Shift+F3        # 查找上一个
```

### 项目管理

#### 目录结构建议
```
OBJ_Project/
├── src/                    # 源文件
│   ├── passiveobject/
│   ├── Action/
│   └── AttackInfo/
├── tools/                  # 工具脚本
│   ├── checker.py
│   ├── template.py
│   └── converter.py
├── docs/                   # 文档
├── backup/                 # 备份
└── build/                  # 构建输出
```

#### 版本控制
```bash
# Git配置示例
git init
git add .gitignore

# .gitignore 内容
*.bak
*.tmp
build/
*.log
```

## 🔍 调试功能

### 实时预览
- **功能**：编辑时实时显示效果
- **实现**：集成游戏引擎预览
- **优势**：快速验证修改效果

### 语法检查
- **功能**：实时检查语法错误
- **实现**：基于规则的验证引擎
- **优势**：及时发现问题

### 依赖分析
- **功能**：分析文件依赖关系
- **实现**：解析文件引用链
- **优势**：避免依赖问题

---

*下一步：查看 [格式检查工具](格式检查工具.md)*