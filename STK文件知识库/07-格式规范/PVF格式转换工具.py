#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
PVF格式转换工具 - 基于真实PVF格式规范

根据从真实PVF文件中观察到的格式规范：
1. 字符串值使用反引号包围：`字符串内容`
2. 数值不使用任何引号，直接写数字
3. 参数之间使用制表符（Tab）分隔
4. 使用制表符（Tab）进行缩进
5. 使用CRLF（\r\n）作为行尾符
6. 标签格式：[标签名] 和 [/标签名]
7. 文件以 #PVF_File 开头

作者: Assistant
版本: 2.0 (基于真实PVF格式)
"""

import os
import re
import argparse
import shutil
from typing import List, Tuple


class PVFFormatConverter:
    """PVF格式转换器 - 基于真实PVF格式规范"""
    
    def __init__(self):
        self.changes_made = []
    
    def convert_file(self, input_path: str, output_path: str = None, backup: bool = False) -> bool:
        """
        转换PVF文件格式
        
        Args:
            input_path: 输入文件路径
            output_path: 输出文件路径，如果为None则覆盖原文件
            backup: 是否创建备份文件
            
        Returns:
            bool: 是否进行了转换
        """
        self.changes_made = []
        
        if not os.path.exists(input_path):
            print(f"❌ 文件不存在: {input_path}")
            return False
        
        if backup and output_path is None:
            backup_path = input_path + '.backup'
            shutil.copy2(input_path, backup_path)
            print(f"📁 已创建备份: {backup_path}")
        
        if output_path is None:
            output_path = input_path
        
        try:
            # 尝试UTF-8编码读取
            with open(input_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except UnicodeDecodeError:
            try:
                # 尝试GBK编码读取
                with open(input_path, 'r', encoding='gbk') as f:
                    content = f.read()
                self.changes_made.append("文件编码从GBK转换为UTF-8")
            except Exception as e:
                print(f"❌ 无法读取文件 {input_path}: {e}")
                return False
        except Exception as e:
            print(f"❌ 无法读取文件 {input_path}: {e}")
            return False
        
        # 转换内容
        converted_content = self._convert_content(content)
        
        try:
            # 保存为UTF-8编码，保持CRLF行尾符
            with open(output_path, 'w', encoding='utf-8', newline='') as f:
                f.write(converted_content)
            
            if self.changes_made:
                print(f"✅ 文件转换完成: {input_path}")
                for change in self.changes_made:
                    print(f"  - {change}")
                return True
            else:
                print(f"ℹ️  文件格式已正确: {input_path}")
                return False
                
        except Exception as e:
            print(f"❌ 无法保存文件 {output_path}: {e}")
            return False
    
    def _convert_content(self, content: str) -> str:
        """转换文件内容"""
        lines = content.splitlines(keepends=True)
        converted_lines = []
        
        for line_num, line in enumerate(lines, 1):
            converted_line = self._convert_line(line, line_num)
            converted_lines.append(converted_line)
        
        return ''.join(converted_lines)
    
    def _convert_line(self, line: str, line_num: int) -> str:
        """转换单行格式"""
        original_line = line
        
        # 移除行尾符进行处理
        line_content = line.rstrip('\r\n')
        
        # 跳过空行和注释行
        if not line_content.strip() or line_content.strip().startswith('#'):
            return line_content + '\r\n'
        
        # 转换1: 修复错误的引号（双引号和单引号改为反引号）
        if '"' in line_content or "'" in line_content:
            new_line = line_content
            # 替换成对的双引号为反引号
            new_line = re.sub(r'"([^"]*)"', r'`\1`', new_line)
            # 替换成对的单引号为反引号
            new_line = re.sub(r"'([^']*)'", r'`\1`', new_line)
            
            if new_line != line_content:
                self.changes_made.append(f"第 {line_num} 行: 修复引号格式（改为反引号）")
                line_content = new_line
        
        # 转换2: 确保参数之间使用制表符分隔（将多个空格转换为制表符）
        if not line_content.strip().startswith('#'):
            # 检测并转换参数间的空格分隔
            # 匹配标签后的多个空格
            new_line = re.sub(r'(\]) {2,}', r'\1\t', line_content)
            # 匹配参数之间的多个空格（但不影响字符串内容）
            new_line = re.sub(r'(\S) {2,}(\S)', r'\1\t\2', new_line)
            
            if new_line != line_content:
                self.changes_made.append(f"第 {line_num} 行: 参数分隔改为制表符")
                line_content = new_line
        
        # 转换3: 确保缩进使用制表符（将行首空格转换为制表符）
        leading_spaces = len(line_content) - len(line_content.lstrip(' '))
        if leading_spaces > 0:
            # 将行首的空格转换为制表符（假设4个空格等于1个制表符）
            tabs = '\t' * (leading_spaces // 4)
            remaining_spaces = ' ' * (leading_spaces % 4)
            new_line = tabs + remaining_spaces + line_content.lstrip(' ')
            
            if new_line != line_content:
                self.changes_made.append(f"第 {line_num} 行: 缩进改为制表符")
                line_content = new_line
        
        # 转换4: 移除数值的引号
        # 匹配被引号包围的数字（整数、小数、负数）
        number_pattern = r'[`"\'](-?\d+(?:\.\d+)?)[`"\']'
        if re.search(number_pattern, line_content):
            new_line = re.sub(number_pattern, r'\1', line_content)
            if new_line != line_content:
                self.changes_made.append(f"第 {line_num} 行: 移除数值的引号")
                line_content = new_line
        
        # 转换5: 修复标签格式（去除标签内的多余空白）
        if '[' in line_content and ']' in line_content:
            new_line = re.sub(r'\[\s*([^\]]+?)\s*\]', r'[\1]', line_content)
            if new_line != line_content:
                self.changes_made.append(f"第 {line_num} 行: 修复标签格式")
                line_content = new_line
        
        # 转换6: 统一行尾符为CRLF（符合真实PVF格式）
        if not original_line.endswith('\r\n'):
            self.changes_made.append(f"第 {line_num} 行: 统一行尾符为CRLF")
        
        return line_content + '\r\n'
    
    def convert_directory(self, dir_path: str, recursive: bool = False, backup: bool = False) -> int:
        """转换目录中的所有PVF文件"""
        converted_count = 0
        
        if not os.path.exists(dir_path):
            print(f"❌ 目录不存在: {dir_path}")
            return 0
        
        if recursive:
            for root, dirs, files in os.walk(dir_path):
                for file in files:
                    if file.endswith(('.stk', '.equ', '.pvf', '.map')):
                        file_path = os.path.join(root, file)
                        if self.convert_file(file_path, backup=backup):
                            converted_count += 1
        else:
            for file in os.listdir(dir_path):
                if file.endswith(('.stk', '.equ', '.pvf', '.map')):
                    file_path = os.path.join(dir_path, file)
                    if os.path.isfile(file_path):
                        if self.convert_file(file_path, backup=backup):
                            converted_count += 1
        
        return converted_count
    
    def preview_changes(self, input_path: str) -> List[str]:
        """预览文件转换后的变化（不实际修改文件）"""
        self.changes_made = []
        
        if not os.path.exists(input_path):
            return [f"❌ 文件不存在: {input_path}"]
        
        try:
            # 尝试UTF-8编码读取
            with open(input_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except UnicodeDecodeError:
            try:
                # 尝试GBK编码读取
                with open(input_path, 'r', encoding='gbk') as f:
                    content = f.read()
                self.changes_made.append("文件编码从GBK转换为UTF-8")
            except Exception as e:
                return [f"❌ 无法读取文件 {input_path}: {e}"]
        except Exception as e:
            return [f"❌ 无法读取文件 {input_path}: {e}"]
        
        # 模拟转换过程
        self._convert_content(content)
        
        if self.changes_made:
            return [f"📋 预览文件变化: {input_path}"] + [f"  - {change}" for change in self.changes_made]
        else:
            return [f"ℹ️  文件格式已正确: {input_path}"]


def main():
    """主函数 - 命令行接口"""
    parser = argparse.ArgumentParser(
        description='PVF格式转换工具 - 基于真实PVF格式规范',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
使用示例:
  python PVF格式转换工具.py file.stk                    # 转换单个文件
  python PVF格式转换工具.py file.stk --backup           # 转换并备份
  python PVF格式转换工具.py ./files/                    # 转换目录
  python PVF格式转换工具.py ./files/ --recursive        # 递归转换
  python PVF格式转换工具.py file.stk --dry-run          # 预览变化
        """
    )
    
    parser.add_argument('path', help='要转换的文件或目录路径')
    parser.add_argument('--recursive', '-r', action='store_true', help='递归处理子目录')
    parser.add_argument('--backup', '-b', action='store_true', help='创建备份文件')
    parser.add_argument('--dry-run', '-d', action='store_true', help='预览变化，不实际修改文件')
    
    args = parser.parse_args()
    
    converter = PVFFormatConverter()
    
    if os.path.isfile(args.path):
        # 处理单个文件
        if args.dry_run:
            changes = converter.preview_changes(args.path)
            for change in changes:
                print(change)
        else:
            converter.convert_file(args.path, backup=args.backup)
    
    elif os.path.isdir(args.path):
        # 处理目录
        if args.dry_run:
            print("❌ 目录模式不支持预览功能")
        else:
            converted_count = converter.convert_directory(args.path, args.recursive, args.backup)
            print(f"\n📊 转换完成，共处理 {converted_count} 个文件")
    
    else:
        print(f"❌ 路径不存在: {args.path}")


if __name__ == '__main__':
    main()