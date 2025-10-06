#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
PVF文件格式检查工具
用于检查PVF文件是否符合严格的格式要求

使用方法:
    python PVF格式检查工具.py <文件路径>
    python PVF格式检查工具.py <目录路径> --recursive
"""

import os
import re
import sys
import argparse
from typing import List, Tuple, Dict

class PVFFormatChecker:
    """PVF文件格式检查器"""
    
    def __init__(self):
        self.errors = []
        self.warnings = []
        
    def check_file(self, file_path: str) -> Dict[str, List[str]]:
        """检查单个文件的格式"""
        self.errors = []
        self.warnings = []
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
        except UnicodeDecodeError:
            try:
                with open(file_path, 'r', encoding='gbk') as f:
                    lines = f.readlines()
                self.warnings.append("文件使用GBK编码，建议使用UTF-8")
            except Exception as e:
                self.errors.append(f"无法读取文件: {e}")
                return {"errors": self.errors, "warnings": self.warnings}
        except Exception as e:
            self.errors.append(f"无法读取文件: {e}")
            return {"errors": self.errors, "warnings": self.warnings}
        
        self._check_format(lines)
        
        return {
            "errors": self.errors,
            "warnings": self.warnings
        }
    
    def _check_format(self, lines: List[str]) -> None:
        """检查文件格式"""
        for line_num, line in enumerate(lines, 1):
            self._check_line_format(line, line_num)
    
    def _check_line_format(self, line: str, line_num: int) -> None:
        """检查单行格式"""
        original_line = line
        line = line.rstrip('\n\r')
        
        # 跳过空行和注释行
        if not line.strip() or line.strip().startswith('#'):
            return
        
        # 检查1: 空格缩进
        if re.match(r'^[ ]+[^[ ]', line):
            self.errors.append(f"第 {line_num} 行: 使用了空格缩进，应该使用TAB键")
            self.errors.append(f"  内容: {repr(line)}")
        
        # 检查2: 错误的引号
        if re.search(r'"[^"]*"', line) or re.search(r"'[^']*'", line):
            self.errors.append(f"第 {line_num} 行: 使用了错误的引号，应该使用反引号 `")
            self.errors.append(f"  内容: {repr(line)}")
        
        # 检查3: 字符串格式
        if '`' in line:
            # 检查反引号是否成对出现
            backtick_count = line.count('`')
            if backtick_count % 2 != 0:
                self.errors.append(f"第 {line_num} 行: 反引号不成对")
                self.errors.append(f"  内容: {repr(line)}")
            
            # 检查字符串格式是否正确
            strings = re.findall(r'`[^`]*`', line)
            for string in strings:
                if not string.startswith('`') or not string.endswith('`'):
                    self.errors.append(f"第 {line_num} 行: 字符串格式错误")
                    self.errors.append(f"  内容: {repr(line)}")
        
        # 检查4: 标签格式
        if line.strip().startswith('[') and line.strip().endswith(']'):
            tag_content = line.strip()[1:-1]
            if tag_content.startswith(' ') or tag_content.endswith(' '):
                self.errors.append(f"第 {line_num} 行: 标签名前后有多余空格")
                self.errors.append(f"  内容: {repr(line)}")
        
        # 检查5: 参数分隔
        if '\t' in line and not line.strip().startswith('['):
            # 检查是否混用了空格和TAB
            if re.search(r'\t.*[ ]+.*\t', line) or re.search(r'[ ]+.*\t', line):
                self.warnings.append(f"第 {line_num} 行: 可能混用了空格和TAB分隔符")
                self.warnings.append(f"  内容: {repr(line)}")
        
        # 检查6: 数值格式
        # 检查数值是否被错误地用引号包围
        if re.search(r'`\d+`', line):
            self.warnings.append(f"第 {line_num} 行: 数值被引号包围，可能不正确")
            self.warnings.append(f"  内容: {repr(line)}")
        
        # 检查7: 行尾字符
        if original_line.endswith('\r\n'):
            self.warnings.append(f"第 {line_num} 行: 使用了Windows行尾符(CRLF)")
        elif original_line.endswith('\r'):
            self.warnings.append(f"第 {line_num} 行: 使用了Mac行尾符(CR)")
    
    def check_directory(self, dir_path: str, recursive: bool = False) -> Dict[str, Dict[str, List[str]]]:
        """检查目录中的所有PVF文件"""
        results = {}
        
        if recursive:
            for root, dirs, files in os.walk(dir_path):
                for file in files:
                    if file.endswith(('.stk', '.equ', '.pvf')):
                        file_path = os.path.join(root, file)
                        results[file_path] = self.check_file(file_path)
        else:
            for file in os.listdir(dir_path):
                if file.endswith(('.stk', '.equ', '.pvf')):
                    file_path = os.path.join(dir_path, file)
                    if os.path.isfile(file_path):
                        results[file_path] = self.check_file(file_path)
        
        return results

def print_results(results: Dict[str, Dict[str, List[str]]]) -> None:
    """打印检查结果"""
    total_files = len(results)
    files_with_errors = 0
    files_with_warnings = 0
    total_errors = 0
    total_warnings = 0
    
    for file_path, result in results.items():
        errors = result.get('errors', [])
        warnings = result.get('warnings', [])
        
        if errors:
            files_with_errors += 1
            total_errors += len(errors)
        
        if warnings:
            files_with_warnings += 1
            total_warnings += len(warnings)
        
        if errors or warnings:
            print(f"\n📁 文件: {file_path}")
            print("=" * 80)
            
            if errors:
                print("❌ 错误:")
                for error in errors:
                    print(f"  {error}")
            
            if warnings:
                print("⚠️  警告:")
                for warning in warnings:
                    print(f"  {warning}")
    
    # 打印总结
    print("\n" + "=" * 80)
    print("📊 检查总结")
    print("=" * 80)
    print(f"总文件数: {total_files}")
    print(f"有错误的文件: {files_with_errors}")
    print(f"有警告的文件: {files_with_warnings}")
    print(f"总错误数: {total_errors}")
    print(f"总警告数: {total_warnings}")
    
    if total_errors == 0:
        print("✅ 所有文件格式检查通过！")
    else:
        print("❌ 发现格式错误，请修复后重新检查")

def main():
    """主函数"""
    parser = argparse.ArgumentParser(description='PVF文件格式检查工具')
    parser.add_argument('path', help='要检查的文件或目录路径')
    parser.add_argument('-r', '--recursive', action='store_true', 
                       help='递归检查子目录')
    parser.add_argument('-v', '--verbose', action='store_true',
                       help='显示详细信息')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.path):
        print(f"❌ 路径不存在: {args.path}")
        sys.exit(1)
    
    checker = PVFFormatChecker()
    
    if os.path.isfile(args.path):
        # 检查单个文件
        result = checker.check_file(args.path)
        results = {args.path: result}
    elif os.path.isdir(args.path):
        # 检查目录
        results = checker.check_directory(args.path, args.recursive)
    else:
        print(f"❌ 无效的路径: {args.path}")
        sys.exit(1)
    
    if not results:
        print("❌ 没有找到PVF文件 (.stk, .equ, .pvf)")
        sys.exit(1)
    
    print("🔍 PVF文件格式检查工具")
    print("=" * 80)
    
    print_results(results)

if __name__ == '__main__':
    main()