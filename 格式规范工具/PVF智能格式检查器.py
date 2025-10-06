#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
PVF智能格式检查器
================

专门用于检查PVF文件格式规范的智能工具，能够：
1. 智能识别缩进符和空格的正确使用场景
2. 检查字符串引号使用规范
3. 验证参数分隔符格式
4. 提供详细的修复建议

作者: AI Assistant
版本: 1.0.0
"""

import re
import os
import sys
from typing import List, Dict, Tuple, Optional
from dataclasses import dataclass
from enum import Enum


class IssueType(Enum):
    """问题类型枚举"""
    INDENT_ERROR = "缩进错误"
    STRING_QUOTE_ERROR = "字符串引号错误"
    PARAMETER_SEPARATOR_ERROR = "参数分隔符错误"
    NUMERIC_QUOTE_ERROR = "数值引号错误"
    ENCODING_ERROR = "编码错误"
    LINE_ENDING_ERROR = "行尾符错误"


@dataclass
class FormatIssue:
    """格式问题数据类"""
    line_number: int
    issue_type: IssueType
    description: str
    current_content: str
    suggested_fix: str
    severity: str  # "error", "warning", "info"


class PVFFormatChecker:
    """PVF格式检查器主类"""
    
    def __init__(self):
        self.issues: List[FormatIssue] = []
        self.file_content: str = ""
        self.lines: List[str] = []
        
        # PVF标签模式
        self.tag_pattern = re.compile(r'^\s*\[([^\]]+)\]')
        self.closing_tag_pattern = re.compile(r'^\s*\[/([^\]]+)\]')
        
        # 字符串值模式 (应该使用反引号)
        self.string_value_pattern = re.compile(r'`([^`]*)`')
        self.wrong_quote_pattern = re.compile(r'"([^"]*)"')
        self.wrong_single_quote_pattern = re.compile(r"'([^']*)'")
        
        # 数值模式
        self.numeric_pattern = re.compile(r'^-?\d+\.?\d*$')
        
        # 常见的字符串标签（这些标签的值应该使用反引号）
        self.string_tags = {
            'name', 'description', 'flavor text', 'type', 'usable job',
            'icon mark', 'field image', 'move wav', 'filename', 'layer',
            'sound', 'effect', 'animation', 'texture', 'material'
        }
        
        # 常见的数值标签（这些标签的值不应该使用引号）
        self.numeric_tags = {
            'level', 'price', 'weight', 'durability', 'grade', 'rarity',
            'physical attack', 'magical attack', 'strength', 'intelligence',
            'vitality', 'spirit', 'x', 'y', 'width', 'height', 'offset x',
            'offset y', 'delay', 'frame', 'loop'
        }

    def check_file(self, file_path: str) -> List[FormatIssue]:
        """检查文件格式"""
        self.issues.clear()
        
        try:
            # 检查文件编码
            self._check_encoding(file_path)
            
            # 读取文件内容
            with open(file_path, 'r', encoding='utf-8') as f:
                self.file_content = f.read()
                self.lines = self.file_content.splitlines()
            
            # 检查行尾符
            self._check_line_endings(file_path)
            
            # 逐行检查格式
            for line_num, line in enumerate(self.lines, 1):
                self._check_line_format(line_num, line)
            
        except Exception as e:
            self.issues.append(FormatIssue(
                line_number=0,
                issue_type=IssueType.ENCODING_ERROR,
                description=f"文件读取错误: {str(e)}",
                current_content="",
                suggested_fix="检查文件是否存在且可读",
                severity="error"
            ))
        
        return self.issues

    def _check_encoding(self, file_path: str):
        """检查文件编码"""
        try:
            with open(file_path, 'rb') as f:
                raw_data = f.read()
            
            # 检查BOM
            if raw_data.startswith(b'\xef\xbb\xbf'):
                # UTF-8 with BOM
                pass
            elif raw_data.startswith(b'\xff\xfe') or raw_data.startswith(b'\xfe\xff'):
                # UTF-16
                self.issues.append(FormatIssue(
                    line_number=0,
                    issue_type=IssueType.ENCODING_ERROR,
                    description="文件使用UTF-16编码，应该使用UTF-8",
                    current_content="UTF-16编码",
                    suggested_fix="转换为UTF-8编码",
                    severity="error"
                ))
            
            # 尝试用UTF-8解码
            try:
                raw_data.decode('utf-8')
            except UnicodeDecodeError:
                self.issues.append(FormatIssue(
                    line_number=0,
                    issue_type=IssueType.ENCODING_ERROR,
                    description="文件不是有效的UTF-8编码",
                    current_content="非UTF-8编码",
                    suggested_fix="转换为UTF-8编码",
                    severity="error"
                ))
                
        except Exception as e:
            self.issues.append(FormatIssue(
                line_number=0,
                issue_type=IssueType.ENCODING_ERROR,
                description=f"编码检查失败: {str(e)}",
                current_content="",
                suggested_fix="检查文件完整性",
                severity="error"
            ))

    def _check_line_endings(self, file_path: str):
        """检查行尾符"""
        try:
            with open(file_path, 'rb') as f:
                content = f.read()
            
            # 检查行尾符类型
            has_crlf = b'\r\n' in content
            has_lf_only = b'\n' in content and not has_crlf
            has_cr_only = b'\r' in content and not has_crlf
            
            if has_lf_only:
                self.issues.append(FormatIssue(
                    line_number=0,
                    issue_type=IssueType.LINE_ENDING_ERROR,
                    description="文件使用LF行尾符，PVF文件应该使用CRLF",
                    current_content="LF (\\n)",
                    suggested_fix="转换为CRLF (\\r\\n)",
                    severity="warning"
                ))
            elif has_cr_only:
                self.issues.append(FormatIssue(
                    line_number=0,
                    issue_type=IssueType.LINE_ENDING_ERROR,
                    description="文件使用CR行尾符，PVF文件应该使用CRLF",
                    current_content="CR (\\r)",
                    suggested_fix="转换为CRLF (\\r\\n)",
                    severity="error"
                ))
                
        except Exception:
            pass  # 如果检查失败，跳过行尾符检查

    def _check_line_format(self, line_num: int, line: str):
        """检查单行格式"""
        # 跳过空行和注释行
        if not line.strip() or line.strip().startswith('//') or line.strip().startswith('#'):
            return
        
        # 检查缩进格式
        self._check_indentation(line_num, line)
        
        # 检查标签行格式
        if self.tag_pattern.match(line) or self.closing_tag_pattern.match(line):
            self._check_tag_line(line_num, line)
        else:
            # 检查普通内容行
            self._check_content_line(line_num, line)

    def _check_indentation(self, line_num: int, line: str):
        """检查缩进格式"""
        if not line or line[0] not in [' ', '\t']:
            return  # 没有缩进的行
        
        # 分析缩进字符
        indent_chars = []
        for char in line:
            if char == ' ':
                indent_chars.append('space')
            elif char == '\t':
                indent_chars.append('tab')
            else:
                break
        
        # 检查是否混用空格和制表符
        if 'space' in indent_chars and 'tab' in indent_chars:
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.INDENT_ERROR,
                description="缩进混用了空格和制表符",
                current_content=line,
                suggested_fix=self._suggest_indent_fix(line),
                severity="error"
            ))
        
        # 检查是否使用空格缩进（应该使用制表符）
        elif 'space' in indent_chars and 'tab' not in indent_chars:
            # 判断这是否是真正的缩进还是参数分隔
            if self._is_indentation_context(line):
                self.issues.append(FormatIssue(
                    line_number=line_num,
                    issue_type=IssueType.INDENT_ERROR,
                    description="使用空格进行缩进，应该使用制表符(Tab)",
                    current_content=line,
                    suggested_fix=self._suggest_indent_fix(line),
                    severity="error"
                ))

    def _is_indentation_context(self, line: str) -> bool:
        """判断是否是缩进上下文（而不是参数分隔）"""
        stripped = line.strip()
        
        # 如果是标签行，通常是缩进
        if self.tag_pattern.match(stripped) or self.closing_tag_pattern.match(stripped):
            return True
        
        # 如果行首有多个连续空格，很可能是缩进
        leading_spaces = len(line) - len(line.lstrip(' '))
        if leading_spaces >= 4:  # 4个或更多空格通常是缩进
            return True
        
        return False

    def _suggest_indent_fix(self, line: str) -> str:
        """建议缩进修复"""
        # 计算空格数量并转换为制表符
        leading_spaces = len(line) - len(line.lstrip(' '))
        tab_count = leading_spaces // 4  # 假设4个空格等于1个制表符
        remaining_spaces = leading_spaces % 4
        
        content = line.lstrip(' \t')
        suggested = '\t' * tab_count
        if remaining_spaces > 0:
            suggested += ' ' * remaining_spaces
        suggested += content
        
        return suggested

    def _check_tag_line(self, line_num: int, line: str):
        """检查标签行格式"""
        # 分割标签和参数
        parts = line.split('\t')
        if len(parts) == 1:
            # 没有参数的标签，检查是否错误使用空格分隔
            space_parts = line.split(' ')
            if len(space_parts) > 1 and not line.strip().endswith(']'):
                # 可能是用空格分隔的参数
                self.issues.append(FormatIssue(
                    line_number=line_num,
                    issue_type=IssueType.PARAMETER_SEPARATOR_ERROR,
                    description="标签参数使用空格分隔，应该使用制表符(Tab)",
                    current_content=line,
                    suggested_fix=self._suggest_tab_separation_fix(line),
                    severity="error"
                ))
        else:
            # 有参数的标签，检查参数格式
            tag_match = self.tag_pattern.match(parts[0].strip())
            if tag_match:
                tag_name = tag_match.group(1).lower()
                self._check_tag_parameters(line_num, line, tag_name, parts[1:])

    def _check_tag_parameters(self, line_num: int, line: str, tag_name: str, parameters: List[str]):
        """检查标签参数格式"""
        for i, param in enumerate(parameters):
            param = param.strip()
            if not param:
                continue
            
            # 检查字符串参数
            if tag_name in self.string_tags:
                self._check_string_parameter(line_num, line, param, tag_name)
            
            # 检查数值参数
            elif tag_name in self.numeric_tags:
                self._check_numeric_parameter(line_num, line, param, tag_name)
            
            # 检查通用参数格式
            else:
                self._check_generic_parameter(line_num, line, param)

    def _check_string_parameter(self, line_num: int, line: str, param: str, tag_name: str):
        """检查字符串参数格式"""
        # 检查是否使用了错误的引号
        if self.wrong_quote_pattern.search(param):
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.STRING_QUOTE_ERROR,
                description=f"标签 [{tag_name}] 的字符串值使用了双引号，应该使用反引号",
                current_content=line,
                suggested_fix=self._suggest_quote_fix(line, '"', '`'),
                severity="error"
            ))
        
        if self.wrong_single_quote_pattern.search(param):
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.STRING_QUOTE_ERROR,
                description=f"标签 [{tag_name}] 的字符串值使用了单引号，应该使用反引号",
                current_content=line,
                suggested_fix=self._suggest_quote_fix(line, "'", '`'),
                severity="error"
            ))
        
        # 检查是否缺少引号
        if not (param.startswith('`') and param.endswith('`')) and not param.startswith('['):
            # 特殊值如 [all], [normal] 等不需要额外引号
            if not (param.startswith('[') and param.endswith(']')):
                self.issues.append(FormatIssue(
                    line_number=line_num,
                    issue_type=IssueType.STRING_QUOTE_ERROR,
                    description=f"标签 [{tag_name}] 的字符串值缺少反引号",
                    current_content=line,
                    suggested_fix=self._suggest_add_backticks(line, param),
                    severity="error"
                ))

    def _check_numeric_parameter(self, line_num: int, line: str, param: str, tag_name: str):
        """检查数值参数格式"""
        # 检查数值是否被错误地加了引号
        if param.startswith('`') and param.endswith('`'):
            inner_value = param[1:-1]
            if self.numeric_pattern.match(inner_value):
                self.issues.append(FormatIssue(
                    line_number=line_num,
                    issue_type=IssueType.NUMERIC_QUOTE_ERROR,
                    description=f"标签 [{tag_name}] 的数值参数不应该使用引号",
                    current_content=line,
                    suggested_fix=line.replace(param, inner_value),
                    severity="error"
                ))
        
        elif param.startswith('"') and param.endswith('"'):
            inner_value = param[1:-1]
            if self.numeric_pattern.match(inner_value):
                self.issues.append(FormatIssue(
                    line_number=line_num,
                    issue_type=IssueType.NUMERIC_QUOTE_ERROR,
                    description=f"标签 [{tag_name}] 的数值参数不应该使用双引号",
                    current_content=line,
                    suggested_fix=line.replace(param, inner_value),
                    severity="error"
                ))

    def _check_generic_parameter(self, line_num: int, line: str, param: str):
        """检查通用参数格式"""
        # 检查是否使用了错误的引号类型
        if self.wrong_quote_pattern.search(param):
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.STRING_QUOTE_ERROR,
                description="参数使用了双引号，建议使用反引号",
                current_content=line,
                suggested_fix=self._suggest_quote_fix(line, '"', '`'),
                severity="warning"
            ))

    def _check_content_line(self, line_num: int, line: str):
        """检查内容行格式"""
        # 检查是否使用空格分隔多个参数
        if '\t' not in line and ' ' in line.strip():
            parts = line.strip().split()
            if len(parts) > 1:
                # 可能是用空格分隔的多个参数
                self.issues.append(FormatIssue(
                    line_number=line_num,
                    issue_type=IssueType.PARAMETER_SEPARATOR_ERROR,
                    description="多个参数使用空格分隔，应该使用制表符(Tab)",
                    current_content=line,
                    suggested_fix=self._suggest_tab_separation_fix(line),
                    severity="warning"
                ))

    def _suggest_tab_separation_fix(self, line: str) -> str:
        """建议制表符分隔修复"""
        # 保留行首的缩进
        leading_whitespace = line[:len(line) - len(line.lstrip())]
        content = line.lstrip()
        
        # 将多个空格替换为制表符
        parts = content.split()
        if len(parts) > 1:
            return leading_whitespace + '\t'.join(parts)
        
        return line

    def _suggest_quote_fix(self, line: str, old_quote: str, new_quote: str) -> str:
        """建议引号修复"""
        return line.replace(old_quote, new_quote)

    def _suggest_add_backticks(self, line: str, param: str) -> str:
        """建议添加反引号"""
        return line.replace(param, f'`{param}`')

    def generate_report(self, file_path: str) -> str:
        """生成检查报告"""
        if not self.issues:
            return f"✅ 文件 {file_path} 格式检查通过，未发现问题。"
        
        report = [f"📋 PVF格式检查报告 - {file_path}"]
        report.append("=" * 60)
        report.append(f"发现 {len(self.issues)} 个问题：")
        report.append("")
        
        # 按严重程度分组
        errors = [issue for issue in self.issues if issue.severity == "error"]
        warnings = [issue for issue in self.issues if issue.severity == "warning"]
        infos = [issue for issue in self.issues if issue.severity == "info"]
        
        if errors:
            report.append("🔴 错误 (必须修复):")
            for issue in errors:
                report.append(f"  行 {issue.line_number}: {issue.description}")
                report.append(f"    当前: {issue.current_content.strip()}")
                report.append(f"    建议: {issue.suggested_fix.strip()}")
                report.append("")
        
        if warnings:
            report.append("🟡 警告 (建议修复):")
            for issue in warnings:
                report.append(f"  行 {issue.line_number}: {issue.description}")
                report.append(f"    当前: {issue.current_content.strip()}")
                report.append(f"    建议: {issue.suggested_fix.strip()}")
                report.append("")
        
        if infos:
            report.append("ℹ️ 信息:")
            for issue in infos:
                report.append(f"  行 {issue.line_number}: {issue.description}")
                report.append("")
        
        # 添加统计信息
        report.append("📊 问题统计:")
        report.append(f"  错误: {len(errors)} 个")
        report.append(f"  警告: {len(warnings)} 个")
        report.append(f"  信息: {len(infos)} 个")
        
        return "\n".join(report)

    def auto_fix_file(self, file_path: str, backup: bool = True) -> bool:
        """自动修复文件格式问题"""
        if backup:
            backup_path = file_path + ".backup"
            try:
                import shutil
                shutil.copy2(file_path, backup_path)
                print(f"已创建备份文件: {backup_path}")
            except Exception as e:
                print(f"创建备份失败: {e}")
                return False
        
        try:
            # 重新检查文件
            self.check_file(file_path)
            
            # 应用修复
            fixed_lines = self.lines.copy()
            
            # 按行号倒序处理，避免行号偏移
            for issue in sorted(self.issues, key=lambda x: x.line_number, reverse=True):
                if issue.line_number > 0 and issue.suggested_fix:
                    fixed_lines[issue.line_number - 1] = issue.suggested_fix
            
            # 写回文件
            with open(file_path, 'w', encoding='utf-8', newline='\r\n') as f:
                f.write('\n'.join(fixed_lines))
            
            print(f"✅ 文件已自动修复: {file_path}")
            return True
            
        except Exception as e:
            print(f"❌ 自动修复失败: {e}")
            return False


def main():
    """主函数"""
    if len(sys.argv) < 2:
        print("用法: python PVF智能格式检查器.py <文件路径> [选项]")
        print("选项:")
        print("  --auto-fix    自动修复问题")
        print("  --no-backup   自动修复时不创建备份")
        print("  --quiet       只显示错误")
        sys.exit(1)
    
    file_path = sys.argv[1]
    auto_fix = "--auto-fix" in sys.argv
    no_backup = "--no-backup" in sys.argv
    quiet = "--quiet" in sys.argv
    
    if not os.path.exists(file_path):
        print(f"❌ 文件不存在: {file_path}")
        sys.exit(1)
    
    checker = PVFFormatChecker()
    
    # 检查文件
    issues = checker.check_file(file_path)
    
    # 生成报告
    if not quiet:
        report = checker.generate_report(file_path)
        print(report)
    
    # 自动修复
    if auto_fix and issues:
        success = checker.auto_fix_file(file_path, backup=not no_backup)
        if success:
            # 重新检查修复后的文件
            new_issues = checker.check_file(file_path)
            if len(new_issues) < len(issues):
                print(f"✅ 修复了 {len(issues) - len(new_issues)} 个问题")
            if new_issues:
                print("⚠️ 仍有以下问题需要手动修复:")
                for issue in new_issues:
                    print(f"  行 {issue.line_number}: {issue.description}")
    
    # 返回退出码
    error_count = len([i for i in issues if i.severity == "error"])
    sys.exit(error_count)


if __name__ == "__main__":
    main()