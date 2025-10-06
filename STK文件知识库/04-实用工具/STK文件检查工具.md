# STK文件检查工具

## 📋 概述

本文档提供STK文件的检查工具和验证方法，帮助开发者确保STK文件的正确性和完整性。

## 🔍 基础检查清单

### 必需标签检查
```
✅ 基础信息检查
□ [name] - 物品名称
□ [explain] - 物品说明
□ [grade] - 物品等级
□ [rarity] - 稀有度
□ [stackable type] - 堆叠类型
□ [icon] - 图标设置
□ [price] - 价格设置

✅ 类型特定检查
□ [sub type] - 子类型（根据物品类型）
□ [usable job] - 职业限制（如需要）
□ [minimum level] - 最低等级（如需要）
□ [attach type] - 绑定类型
```

### 数值合理性检查
```
✅ 等级相关
□ grade值是否在合理范围（1-85）
□ minimum level是否与grade匹配
□ 属性数值是否符合等级要求

✅ 经济平衡
□ price和value的比例是否合理
□ creation rate是否适当
□ 稀有度与价格是否匹配

✅ 功能逻辑
□ 冷却时间是否合理
□ 持续时间是否适当
□ 堆叠数量是否合理
```

## 🛠️ 自动检查脚本

### Python检查脚本
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
STK文件检查工具
用于验证STK文件的格式和内容正确性
"""

import re
import os
import sys
from typing import List, Dict, Tuple, Optional

class STKChecker:
    def __init__(self):
        # 必需标签定义
        self.required_tags = {
            'all': ['name', 'explain', 'grade', 'rarity', 'stackable type', 'icon', 'price'],
            'consumable': ['sub type', 'usable job', 'action type'],
            'material': ['sub type'],
            'booster': ['booster info'],
            'recipe': ['int data', 'string data'],
            'throw item': ['applying range', 'int data', 'string data'],
            'pandora box': ['int data'],
            'legacy': ['int data'],
            'quest': []
        }
        
        # 数值范围定义
        self.value_ranges = {
            'grade': (1, 85),
            'rarity': (1, 6),
            'minimum level': (1, 85),
            'creation rate': (0, 10),
            'weight': (1, 999),
            'stack limit': (1, 9999),
            'cool time': (0, 3600000),  # 最大1小时
            'price': (0, 999999999),
            'value': (0, 999999999)
        }
        
        # 职业列表
        self.valid_jobs = [
            'swordman', 'fighter', 'gunner', 'mage', 'priest',
            'thief', 'knight', 'demonic swordman', 'creator', 'all'
        ]
        
        # 绑定类型
        self.valid_attach_types = [
            'trade', 'character', 'account', 'untradable'
        ]
        
        # 堆叠类型
        self.valid_stackable_types = [
            'consumable', 'material', 'booster', 'recipe',
            'throw item', 'pandora box', 'legacy', 'quest'
        ]

    def check_file(self, file_path: str) -> Dict:
        """检查单个STK文件"""
        result = {
            'file': file_path,
            'valid': True,
            'errors': [],
            'warnings': [],
            'info': {}
        }
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            result['valid'] = False
            result['errors'].append(f"文件读取失败: {e}")
            return result
        
        # 解析STK内容
        parsed_data = self.parse_stk_content(content)
        result['info'] = parsed_data
        
        # 执行各项检查
        self.check_required_tags(parsed_data, result)
        self.check_value_ranges(parsed_data, result)
        self.check_job_restrictions(parsed_data, result)
        self.check_type_consistency(parsed_data, result)
        self.check_economic_balance(parsed_data, result)
        
        return result

    def parse_stk_content(self, content: str) -> Dict:
        """解析STK文件内容"""
        data = {}
        
        # 解析单行标签
        single_patterns = [
            r'\[name\]\s*`([^`]+)`',
            r'\[grade\]\s*(\d+)',
            r'\[rarity\]\s*(\d+)',
            r'\[price\]\s*(\d+)',
            r'\[value\]\s*(\d+)',
            r'\[minimum level\]\s*(\d+)',
            r'\[weight\]\s*(\d+)',
            r'\[creation rate\]\s*(\d+)',
            r'\[stack limit\]\s*(\d+)',
            r'\[cool time\]\s*(\d+)',
            r'\[attach type\]\s*`\[([^\]]+)\]`',
            r'\[stackable type\]\s*`\[([^\]]+)\]`\s*(\d+)',
            r'\[sub type\]\s*(\d+)',
            r'\[action type\]\s*(\d+)'
        ]
        
        for pattern in single_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                tag_name = pattern.split('\\')[1].replace('[', '').replace(']', '')
                data[tag_name] = match.groups()
        
        # 解析说明文本
        explain_match = re.search(r'\[explain\]\s*`([^`]+)`', content, re.DOTALL)
        if explain_match:
            data['explain'] = explain_match.group(1)
        
        # 解析职业限制
        job_match = re.search(r'\[usable job\]\s*(.*?)\[/usable job\]', content, re.DOTALL)
        if job_match:
            jobs = re.findall(r'`\[([^\]]+)\]`', job_match.group(1))
            data['usable job'] = jobs
        
        # 解析使用场所
        place_match = re.search(r'\[usable place\]\s*(.*?)\[/usable place\]', content, re.DOTALL)
        if place_match:
            places = re.findall(r'`\[([^\]]+)\]`', place_match.group(1))
            data['usable place'] = places
        
        return data

    def check_required_tags(self, data: Dict, result: Dict):
        """检查必需标签"""
        stackable_type = data.get('stackable type', [''])[0]
        
        # 检查通用必需标签
        for tag in self.required_tags['all']:
            if tag not in data:
                result['errors'].append(f"缺少必需标签: [{tag}]")
                result['valid'] = False
        
        # 检查类型特定标签
        if stackable_type in self.required_tags:
            for tag in self.required_tags[stackable_type]:
                if tag not in data:
                    result['errors'].append(f"缺少{stackable_type}类型必需标签: [{tag}]")
                    result['valid'] = False

    def check_value_ranges(self, data: Dict, result: Dict):
        """检查数值范围"""
        for tag, (min_val, max_val) in self.value_ranges.items():
            if tag in data:
                try:
                    value = int(data[tag][0])
                    if not (min_val <= value <= max_val):
                        result['warnings'].append(
                            f"[{tag}] 数值 {value} 超出推荐范围 {min_val}-{max_val}"
                        )
                except (ValueError, IndexError):
                    result['errors'].append(f"[{tag}] 数值格式错误")
                    result['valid'] = False

    def check_job_restrictions(self, data: Dict, result: Dict):
        """检查职业限制"""
        if 'usable job' in data:
            for job in data['usable job']:
                if job not in self.valid_jobs:
                    result['warnings'].append(f"未知职业类型: {job}")

    def check_type_consistency(self, data: Dict, result: Dict):
        """检查类型一致性"""
        # 检查绑定类型
        if 'attach type' in data:
            attach_type = data['attach type'][0]
            if attach_type not in self.valid_attach_types:
                result['warnings'].append(f"未知绑定类型: {attach_type}")
        
        # 检查堆叠类型
        if 'stackable type' in data:
            stackable_type = data['stackable type'][0]
            if stackable_type not in self.valid_stackable_types:
                result['errors'].append(f"未知堆叠类型: {stackable_type}")
                result['valid'] = False

    def check_economic_balance(self, data: Dict, result: Dict):
        """检查经济平衡"""
        if 'price' in data and 'value' in data:
            try:
                price = int(data['price'][0])
                value = int(data['value'][0])
                
                # 通常value应该是price的40-60%
                if value > price:
                    result['warnings'].append("回收价格高于购买价格，可能影响经济平衡")
                elif value < price * 0.3:
                    result['warnings'].append("回收价格过低，可能影响玩家体验")
                elif value > price * 0.7:
                    result['warnings'].append("回收价格过高，可能影响经济平衡")
            except (ValueError, IndexError):
                pass

    def check_directory(self, directory: str) -> List[Dict]:
        """检查目录下所有STK文件"""
        results = []
        
        for root, dirs, files in os.walk(directory):
            for file in files:
                if file.lower().endswith('.stk'):
                    file_path = os.path.join(root, file)
                    result = self.check_file(file_path)
                    results.append(result)
        
        return results

    def generate_report(self, results: List[Dict]) -> str:
        """生成检查报告"""
        total_files = len(results)
        valid_files = sum(1 for r in results if r['valid'])
        
        report = f"""
STK文件检查报告
================

总文件数: {total_files}
有效文件: {valid_files}
错误文件: {total_files - valid_files}

详细结果:
--------
"""
        
        for result in results:
            status = "✅" if result['valid'] else "❌"
            report += f"\n{status} {result['file']}\n"
            
            if result['errors']:
                report += "  错误:\n"
                for error in result['errors']:
                    report += f"    - {error}\n"
            
            if result['warnings']:
                report += "  警告:\n"
                for warning in result['warnings']:
                    report += f"    - {warning}\n"
        
        return report

def main():
    """主函数"""
    if len(sys.argv) != 2:
        print("用法: python stk_checker.py <STK文件或目录路径>")
        sys.exit(1)
    
    path = sys.argv[1]
    checker = STKChecker()
    
    if os.path.isfile(path):
        # 检查单个文件
        result = checker.check_file(path)
        report = checker.generate_report([result])
    elif os.path.isdir(path):
        # 检查目录
        results = checker.check_directory(path)
        report = checker.generate_report(results)
    else:
        print(f"错误: 路径 {path} 不存在")
        sys.exit(1)
    
    print(report)

if __name__ == "__main__":
    main()
```

### 批处理检查脚本
```batch
@echo off
chcp 65001 > nul
echo STK文件批量检查工具
echo ==================

if "%~1"=="" (
    echo 用法: check_stk.bat [STK文件目录]
    echo 示例: check_stk.bat "C:\DNF\stackable"
    pause
    exit /b 1
)

set "STK_DIR=%~1"
if not exist "%STK_DIR%" (
    echo 错误: 目录 "%STK_DIR%" 不存在
    pause
    exit /b 1
)

echo 正在检查目录: %STK_DIR%
echo.

set /a total_files=0
set /a error_files=0

for /r "%STK_DIR%" %%f in (*.stk) do (
    set /a total_files+=1
    echo 检查文件: %%~nxf
    
    REM 检查文件大小
    if %%~zf LSS 100 (
        echo   警告: 文件过小 ^(%%~zf 字节^)
    )
    
    REM 检查基本标签
    findstr /i "\[name\]" "%%f" >nul || (
        echo   错误: 缺少 [name] 标签
        set /a error_files+=1
    )
    
    findstr /i "\[grade\]" "%%f" >nul || (
        echo   错误: 缺少 [grade] 标签
        set /a error_files+=1
    )
    
    findstr /i "\[stackable type\]" "%%f" >nul || (
        echo   错误: 缺少 [stackable type] 标签
        set /a error_files+=1
    )
    
    echo.
)

echo 检查完成
echo ==========
echo 总文件数: %total_files%
echo 错误文件: %error_files%

if %error_files% GTR 0 (
    echo.
    echo 发现错误，请检查上述文件！
) else (
    echo.
    echo 所有文件检查通过！
)

pause
```

## 📊 检查项目详解

### 格式检查
1. **文件编码**: 确保使用UTF-8编码
2. **标签格式**: 检查标签的开闭是否正确
3. **数值格式**: 验证数字字段的格式
4. **字符串格式**: 检查字符串是否正确使用反引号

### 内容检查
1. **必需标签**: 验证所有必需标签是否存在
2. **数值范围**: 检查数值是否在合理范围内
3. **类型匹配**: 验证不同类型标签的一致性
4. **逻辑关系**: 检查标签间的逻辑关系

### 平衡性检查
1. **等级平衡**: 属性与等级的匹配度
2. **经济平衡**: 价格与价值的合理性
3. **功能平衡**: 冷却时间、持续时间等

## 🔧 常用检查命令

### 快速语法检查
```bash
# 检查基本标签
grep -n "\[name\]" *.stk
grep -n "\[grade\]" *.stk
grep -n "\[stackable type\]" *.stk

# 检查数值范围
grep -n "\[grade\] [0-9]\{3,\}" *.stk  # 查找等级超过99的物品
grep -n "\[price\] 0" *.stk            # 查找价格为0的物品

# 检查编码问题
file -bi *.stk | grep -v "utf-8"       # 查找非UTF-8编码文件
```

### 批量验证脚本
```powershell
# PowerShell批量检查脚本
Get-ChildItem -Path "." -Filter "*.stk" | ForEach-Object {
    $content = Get-Content $_.FullName -Encoding UTF8
    $hasName = $content | Select-String "\[name\]"
    $hasGrade = $content | Select-String "\[grade\]"
    $hasType = $content | Select-String "\[stackable type\]"
    
    if (-not $hasName) {
        Write-Host "$($_.Name): 缺少 [name] 标签" -ForegroundColor Red
    }
    if (-not $hasGrade) {
        Write-Host "$($_.Name): 缺少 [grade] 标签" -ForegroundColor Red
    }
    if (-not $hasType) {
        Write-Host "$($_.Name): 缺少 [stackable type] 标签" -ForegroundColor Red
    }
}
```

## 📝 检查清单模板

### 发布前检查清单
```
□ 文件格式检查
  □ UTF-8编码
  □ 标签格式正确
  □ 无语法错误

□ 必需内容检查
  □ 所有必需标签存在
  □ 名称和说明完整
  □ 图标路径正确

□ 数值平衡检查
  □ 等级设置合理
  □ 属性数值平衡
  □ 价格设置合理

□ 功能测试
  □ 游戏内正常显示
  □ 功能正常工作
  □ 无冲突问题

□ 兼容性检查
  □ 与现有内容兼容
  □ ID无冲突
  □ 资源文件存在
```

## 🔗 相关工具

- [STK文件模板](./STK文件模板.md)
- [数值计算器](./数值计算器.md)
- [标签索引](../03-标签索引/)
- [常见问题](../06-常见问题/)

## 💡 使用建议

1. **定期检查**: 建议在每次修改后都进行检查
2. **自动化**: 使用脚本自动化检查流程
3. **版本控制**: 结合版本控制系统使用
4. **团队协作**: 建立团队检查标准
5. **持续改进**: 根据发现的问题不断完善检查工具