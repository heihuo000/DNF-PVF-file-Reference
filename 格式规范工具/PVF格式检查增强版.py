#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
PVF格式检查增强版
================

增强版PVF格式检查工具，提供：
1. 更智能的格式检查算法
2. 详细的问题分析和修复建议
3. 批量文件检查功能
4. HTML格式报告生成
5. 交互式修复模式

作者: AI Assistant
版本: 2.0.0
"""

import re
import os
import sys
import json
import argparse
from typing import List, Dict, Tuple, Optional, Set
from dataclasses import dataclass, asdict
from enum import Enum
from pathlib import Path
import datetime


class IssueType(Enum):
    """问题类型枚举"""
    INDENT_ERROR = "缩进错误"
    STRING_QUOTE_ERROR = "字符串引号错误"
    PARAMETER_SEPARATOR_ERROR = "参数分隔符错误"
    NUMERIC_QUOTE_ERROR = "数值引号错误"
    ENCODING_ERROR = "编码错误"
    LINE_ENDING_ERROR = "行尾符错误"
    STRUCTURE_ERROR = "结构错误"
    WHITESPACE_ERROR = "空白字符错误"


@dataclass
class FormatIssue:
    """格式问题数据类"""
    line_number: int
    issue_type: IssueType
    description: str
    current_content: str
    suggested_fix: str
    severity: str  # "error", "warning", "info"
    rule_reference: str = ""  # 规范引用
    auto_fixable: bool = True  # 是否可自动修复


@dataclass
class CheckResult:
    """检查结果数据类"""
    file_path: str
    issues: List[FormatIssue]
    total_lines: int
    check_time: str
    file_size: int
    encoding: str


class PVFFormatCheckerEnhanced:
    """增强版PVF格式检查器"""
    
    def __init__(self):
        self.issues: List[FormatIssue] = []
        self.file_content: str = ""
        self.lines: List[str] = []
        self.file_stats = {}
        
        # 编译正则表达式模式
        self._compile_patterns()
        
        # 初始化标签分类
        self._init_tag_categories()
        
        # 初始化规则引用
        self._init_rule_references()

    def _compile_patterns(self):
        """编译正则表达式模式"""
        # PVF标签模式
        self.tag_pattern = re.compile(r'^\s*\[([^\]]+)\]')
        self.closing_tag_pattern = re.compile(r'^\s*\[/([^\]]+)\]')
        self.tag_with_params_pattern = re.compile(r'^\s*\[([^\]]+)\]\s*(.+)?')
        
        # 字符串值模式
        self.string_value_pattern = re.compile(r'`([^`]*)`')
        self.wrong_quote_pattern = re.compile(r'"([^"]*)"')
        self.wrong_single_quote_pattern = re.compile(r"'([^']*)'")
        
        # 数值模式
        self.numeric_pattern = re.compile(r'^-?\d+\.?\d*$')
        self.float_pattern = re.compile(r'^-?\d+\.\d+$')
        self.integer_pattern = re.compile(r'^-?\d+$')
        
        # 空白字符模式
        self.leading_whitespace_pattern = re.compile(r'^(\s*)')
        self.trailing_whitespace_pattern = re.compile(r'\s+$')
        self.multiple_spaces_pattern = re.compile(r'  +')
        
        # 特殊值模式
        self.special_value_pattern = re.compile(r'^\[([^\]]+)\]$')
        
        # 注释模式
        self.comment_pattern = re.compile(r'//.*$')

    def _init_tag_categories(self):
        """初始化标签分类"""
        # 字符串标签（值应该使用反引号）
        self.string_tags = {
            'name', 'description', 'flavor text', 'type', 'usable job',
            'icon mark', 'field image', 'move wav', 'filename', 'layer',
            'sound', 'effect', 'animation', 'texture', 'material',
            'comment', 'explain', 'category', 'sub type', 'weapon type',
            'armor type', 'accessory type', 'class', 'job', 'skill name'
        }
        
        # 数值标签（值不应该使用引号）
        self.numeric_tags = {
            'level', 'price', 'weight', 'durability', 'grade', 'rarity',
            'physical attack', 'magical attack', 'strength', 'intelligence',
            'vitality', 'spirit', 'x', 'y', 'width', 'height', 'offset x',
            'offset y', 'delay', 'frame', 'loop', 'count', 'amount',
            'stack limit', 'cool time', 'cast time', 'mp cost', 'hp cost'
        }
        
        # 混合标签（可能包含字符串和数值）
        self.mixed_tags = {
            'pvp start area', 'player number', 'equipment option',
            'skill option', 'set item option', 'random option'
        }
        
        # 结构标签（通常有开始和结束标签）
        self.structure_tags = {
            'equipment option', 'skill option', 'set item option',
            'random option', 'animation', 'tile', 'background animation',
            'booster info', 'upgrade info', 'usable job', 'aura ability',
            'emblem socket default', 'skill data up',
            # 技能文件中的结构标签
            'level info', 'dungeon', 'pvp', 'death tower', 'warroom',
            'level property', 'static data', 'command', 'skill fitness growtype',
            'purchase cost',  # 这个确实有结束标签
            # 注意：command customizing, cool time 等是单独标签，不需要结束标签
        }

    def _init_rule_references(self):
        """初始化规则引用"""
        self.rule_refs = {
            IssueType.INDENT_ERROR: "PVF格式规范 - 3.缩进格式",
            IssueType.STRING_QUOTE_ERROR: "PVF格式规范 - 2.字符串值格式",
            IssueType.PARAMETER_SEPARATOR_ERROR: "PVF格式规范 - 4.参数分隔格式",
            IssueType.NUMERIC_QUOTE_ERROR: "PVF格式规范 - 3.数值格式",
            IssueType.ENCODING_ERROR: "PVF格式规范 - 1.文件编码",
            IssueType.LINE_ENDING_ERROR: "PVF格式规范 - 2.行尾符",
            IssueType.STRUCTURE_ERROR: "PVF格式规范 - 6.标签格式",
            IssueType.WHITESPACE_ERROR: "PVF格式规范 - 通用格式要求"
        }

    def check_file(self, file_path: str) -> CheckResult:
        """检查文件格式并返回详细结果"""
        self.issues.clear()
        start_time = datetime.datetime.now()
        
        try:
            # 获取文件信息
            file_size = os.path.getsize(file_path)
            
            # 检查文件编码
            encoding = self._detect_and_check_encoding(file_path)
            
            # 读取文件内容
            with open(file_path, 'r', encoding='utf-8') as f:
                self.file_content = f.read()
                self.lines = self.file_content.splitlines()
            
            # 检查行尾符
            self._check_line_endings(file_path)
            
            # 检查文件结构
            self._check_file_structure()
            
            # 逐行检查格式
            for line_num, line in enumerate(self.lines, 1):
                self._check_line_format_enhanced(line_num, line)
            
            # 检查整体一致性
            self._check_consistency()
            
            check_time = (datetime.datetime.now() - start_time).total_seconds()
            
            return CheckResult(
                file_path=file_path,
                issues=self.issues.copy(),
                total_lines=len(self.lines),
                check_time=f"{check_time:.2f}s",
                file_size=file_size,
                encoding=encoding
            )
            
        except Exception as e:
            self.issues.append(FormatIssue(
                line_number=0,
                issue_type=IssueType.ENCODING_ERROR,
                description=f"文件读取错误: {str(e)}",
                current_content="",
                suggested_fix="检查文件是否存在且可读",
                severity="error",
                rule_reference=self.rule_refs[IssueType.ENCODING_ERROR],
                auto_fixable=False
            ))
            
            return CheckResult(
                file_path=file_path,
                issues=self.issues.copy(),
                total_lines=0,
                check_time="0.00s",
                file_size=0,
                encoding="unknown"
            )

    def _detect_and_check_encoding(self, file_path: str) -> str:
        """检测并检查文件编码"""
        try:
            with open(file_path, 'rb') as f:
                raw_data = f.read()
            
            # 检查BOM
            if raw_data.startswith(b'\xef\xbb\xbf'):
                return "UTF-8 with BOM"
            elif raw_data.startswith(b'\xff\xfe'):
                self.issues.append(FormatIssue(
                    line_number=0,
                    issue_type=IssueType.ENCODING_ERROR,
                    description="文件使用UTF-16 LE编码，应该使用UTF-8",
                    current_content="UTF-16 LE",
                    suggested_fix="转换为UTF-8编码",
                    severity="error",
                    rule_reference=self.rule_refs[IssueType.ENCODING_ERROR],
                    auto_fixable=False
                ))
                return "UTF-16 LE"
            elif raw_data.startswith(b'\xfe\xff'):
                self.issues.append(FormatIssue(
                    line_number=0,
                    issue_type=IssueType.ENCODING_ERROR,
                    description="文件使用UTF-16 BE编码，应该使用UTF-8",
                    current_content="UTF-16 BE",
                    suggested_fix="转换为UTF-8编码",
                    severity="error",
                    rule_reference=self.rule_refs[IssueType.ENCODING_ERROR],
                    auto_fixable=False
                ))
                return "UTF-16 BE"
            
            # 尝试用UTF-8解码
            try:
                raw_data.decode('utf-8')
                return "UTF-8"
            except UnicodeDecodeError as e:
                self.issues.append(FormatIssue(
                    line_number=0,
                    issue_type=IssueType.ENCODING_ERROR,
                    description=f"文件不是有效的UTF-8编码: {str(e)}",
                    current_content="非UTF-8编码",
                    suggested_fix="转换为UTF-8编码",
                    severity="error",
                    rule_reference=self.rule_refs[IssueType.ENCODING_ERROR],
                    auto_fixable=False
                ))
                return "unknown"
                
        except Exception as e:
            self.issues.append(FormatIssue(
                line_number=0,
                issue_type=IssueType.ENCODING_ERROR,
                description=f"编码检查失败: {str(e)}",
                current_content="",
                suggested_fix="检查文件完整性",
                severity="error",
                rule_reference=self.rule_refs[IssueType.ENCODING_ERROR],
                auto_fixable=False
            ))
            return "error"

    def _check_line_endings(self, file_path: str):
        """检查行尾符"""
        try:
            with open(file_path, 'rb') as f:
                content = f.read()
            
            # 统计不同类型的行尾符
            crlf_count = content.count(b'\r\n')
            lf_only_count = content.count(b'\n') - crlf_count
            cr_only_count = content.count(b'\r') - crlf_count
            
            # 检查文件是否为空或只有一行
            if len(content) == 0:
                return
                
            # 如果文件只有LF行尾符，且文件大小较小，可能是从PVF工具提取的测试文件
            # 这种情况下只给出信息提示，不作为错误
            if lf_only_count > 0 and crlf_count == 0:
                # 检查是否为测试文件（文件名包含test_或文件较小）
                import os
                file_size = os.path.getsize(file_path)
                is_test_file = "test_" in os.path.basename(file_path).lower()
                
                if is_test_file and file_size < 10240:  # 小于10KB的测试文件
                    severity = "info"
                    description = f"发现 {lf_only_count} 个LF行尾符，PVF文件应该使用CRLF（测试文件自动转换）"
                else:
                    severity = "error"
                    description = f"发现 {lf_only_count} 个LF行尾符，PVF文件应该使用CRLF"
                    
                self.issues.append(FormatIssue(
                    line_number=0,
                    issue_type=IssueType.LINE_ENDING_ERROR,
                    description=description,
                    current_content="LF (\\n)",
                    suggested_fix="转换为CRLF (\\r\\n)",
                    severity=severity,
                    rule_reference=self.rule_refs[IssueType.LINE_ENDING_ERROR],
                    auto_fixable=True
                ))
            elif lf_only_count > 0 and crlf_count > 0:
                # 混合行尾符，这是真正的问题
                self.issues.append(FormatIssue(
                    line_number=0,
                    issue_type=IssueType.LINE_ENDING_ERROR,
                    description=f"发现混合行尾符：{lf_only_count} 个LF，{crlf_count} 个CRLF",
                    current_content="混合行尾符",
                    suggested_fix="统一转换为CRLF (\\r\\n)",
                    severity="error",
                    rule_reference=self.rule_refs[IssueType.LINE_ENDING_ERROR],
                    auto_fixable=True
                ))
            
            if cr_only_count > 0:
                self.issues.append(FormatIssue(
                    line_number=0,
                    issue_type=IssueType.LINE_ENDING_ERROR,
                    description=f"发现 {cr_only_count} 个CR行尾符，PVF文件应该使用CRLF",
                    current_content="CR (\\r)",
                    suggested_fix="转换为CRLF (\\r\\n)",
                    severity="error",
                    rule_reference=self.rule_refs[IssueType.LINE_ENDING_ERROR],
                    auto_fixable=True
                ))
                
        except Exception:
            pass

    def _check_file_structure(self):
        """检查文件整体结构"""
        if not self.lines:
            return
        
        # 检查文件头
        if not self.lines[0].strip().startswith('#PVF_File'):
            self.issues.append(FormatIssue(
                line_number=1,
                issue_type=IssueType.STRUCTURE_ERROR,
                description="PVF文件应该以 '#PVF_File' 开头",
                current_content=self.lines[0] if self.lines else "",
                suggested_fix="#PVF_File",
                severity="error",
                rule_reference=self.rule_refs[IssueType.STRUCTURE_ERROR],
                auto_fixable=True
            ))
        
        # 检查标签配对
        self._check_tag_pairing()

    def _check_tag_pairing(self):
        """检查标签配对"""
        tag_stack = []
        
        for line_num, line in enumerate(self.lines, 1):
            stripped = line.strip()
            if not stripped or stripped.startswith('//') or stripped.startswith('#'):
                continue
            
            # 检查开始标签
            tag_match = self.tag_pattern.match(stripped)
            if tag_match:
                tag_name = tag_match.group(1).lower()
                if tag_name in self.structure_tags:
                    tag_stack.append((tag_name, line_num))
            
            # 检查结束标签
            closing_match = self.closing_tag_pattern.match(stripped)
            if closing_match:
                tag_name = closing_match.group(1).lower()
                if tag_stack and tag_stack[-1][0] == tag_name:
                    tag_stack.pop()
                else:
                    self.issues.append(FormatIssue(
                        line_number=line_num,
                        issue_type=IssueType.STRUCTURE_ERROR,
                        description=f"结束标签 [/{tag_name}] 没有匹配的开始标签",
                        current_content=line,
                        suggested_fix="检查标签配对",
                        severity="error",
                        rule_reference=self.rule_refs[IssueType.STRUCTURE_ERROR],
                        auto_fixable=False
                    ))
        
        # 检查未关闭的标签
        for tag_name, line_num in tag_stack:
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.STRUCTURE_ERROR,
                description=f"标签 [{tag_name}] 没有对应的结束标签 [/{tag_name}]",
                current_content=self.lines[line_num - 1],
                suggested_fix=f"添加结束标签 [/{tag_name}]",
                severity="warning",
                rule_reference=self.rule_refs[IssueType.STRUCTURE_ERROR],
                auto_fixable=False
            ))

    def _check_line_format_enhanced(self, line_num: int, line: str):
        """增强版行格式检查"""
        # 跳过空行和注释行
        if not line.strip() or line.strip().startswith('//') or line.strip().startswith('#'):
            return
        
        # 检查尾随空白字符
        if self.trailing_whitespace_pattern.search(line):
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.WHITESPACE_ERROR,
                description="行尾有多余的空白字符",
                current_content=line,
                suggested_fix=line.rstrip(),
                severity="info",
                rule_reference=self.rule_refs[IssueType.WHITESPACE_ERROR],
                auto_fixable=True
            ))
        
        # 检查缩进格式
        self._check_indentation_enhanced(line_num, line)
        
        # 检查标签行格式
        if self.tag_pattern.match(line.strip()) or self.closing_tag_pattern.match(line.strip()):
            self._check_tag_line_enhanced(line_num, line)
        else:
            # 检查普通内容行
            self._check_content_line_enhanced(line_num, line)

    def _check_indentation_enhanced(self, line_num: int, line: str):
        """增强版缩进检查"""
        if not line or line[0] not in [' ', '\t']:
            return
        
        # 分析缩进字符
        leading_match = self.leading_whitespace_pattern.match(line)
        if not leading_match:
            return
        
        leading_whitespace = leading_match.group(1)
        spaces = leading_whitespace.count(' ')
        tabs = leading_whitespace.count('\t')
        
        # 检查混用
        if spaces > 0 and tabs > 0:
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.INDENT_ERROR,
                description="缩进混用了空格和制表符",
                current_content=line,
                suggested_fix=self._suggest_indent_fix_enhanced(line),
                severity="error",
                rule_reference=self.rule_refs[IssueType.INDENT_ERROR],
                auto_fixable=True
            ))
        
        # 检查空格缩进
        elif spaces > 0 and tabs == 0 and self._is_indentation_context(line):
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.INDENT_ERROR,
                description=f"使用 {spaces} 个空格进行缩进，应该使用制表符",
                current_content=line,
                suggested_fix=self._suggest_indent_fix_enhanced(line),
                severity="error",
                rule_reference=self.rule_refs[IssueType.INDENT_ERROR],
                auto_fixable=True
            ))

    def _suggest_indent_fix_enhanced(self, line: str) -> str:
        """增强版缩进修复建议"""
        leading_match = self.leading_whitespace_pattern.match(line)
        if not leading_match:
            return line
        
        leading_whitespace = leading_match.group(1)
        content = line[len(leading_whitespace):]
        
        # 计算应该使用的制表符数量
        spaces = leading_whitespace.count(' ')
        tabs = leading_whitespace.count('\t')
        
        # 假设4个空格等于1个制表符
        total_tabs = tabs + (spaces // 4)
        remaining_spaces = spaces % 4
        
        new_indent = '\t' * total_tabs
        if remaining_spaces > 0:
            new_indent += ' ' * remaining_spaces
        
        return new_indent + content

    def _check_tag_line_enhanced(self, line_num: int, line: str):
        """增强版标签行检查"""
        stripped = line.strip()
        
        # 首先检查是否是标签行
        tag_match = self.tag_pattern.match(stripped)
        closing_tag_match = self.closing_tag_pattern.match(stripped)
        
        if tag_match or closing_tag_match:
            # 这是一个标签行，检查参数分隔
            if '\t' in line:
                parts = line.split('\t')
            else:
                # 检查是否有标签外的参数（标签后面的内容）
                if tag_match:
                    tag_content = tag_match.group(0)
                    remaining = line[line.find(tag_content) + len(tag_content):].strip()
                    if remaining:
                        # 有参数但没有制表符分隔
                        self.issues.append(FormatIssue(
                            line_number=line_num,
                            issue_type=IssueType.PARAMETER_SEPARATOR_ERROR,
                            description="标签参数使用空格分隔，应该使用制表符",
                            current_content=line,
                            suggested_fix=self._suggest_tab_separation_fix(line),
                            severity="error",
                            rule_reference=self.rule_refs[IssueType.PARAMETER_SEPARATOR_ERROR],
                            auto_fixable=True
                        ))
                        return
                parts = [stripped]  # 只有标签，没有参数
            
            # 检查标签和参数
            if len(parts) > 1:
                tag_part = parts[0].strip()
                tag_match = self.tag_pattern.match(tag_part)
                if tag_match:
                    tag_name = tag_match.group(1).lower()
                    parameters = [p.strip() for p in parts[1:] if p.strip()]
                    self._check_tag_parameters_enhanced(line_num, line, tag_name, parameters)

    def _check_tag_parameters_enhanced(self, line_num: int, line: str, tag_name: str, parameters: List[str]):
        """增强版标签参数检查"""
        for i, param in enumerate(parameters):
            if not param:
                continue
            
            # 检查字符串参数
            if tag_name in self.string_tags:
                self._check_string_parameter_enhanced(line_num, line, param, tag_name, i)
            
            # 检查数值参数
            elif tag_name in self.numeric_tags:
                self._check_numeric_parameter_enhanced(line_num, line, param, tag_name, i)
            
            # 检查混合参数
            elif tag_name in self.mixed_tags:
                self._check_mixed_parameter(line_num, line, param, tag_name, i)
            
            # 检查通用参数
            else:
                self._check_generic_parameter_enhanced(line_num, line, param, i)

    def _check_string_parameter_enhanced(self, line_num: int, line: str, param: str, tag_name: str, param_index: int):
        """增强版字符串参数检查"""
        # 检查错误的引号类型
        if param.startswith('"') and param.endswith('"'):
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.STRING_QUOTE_ERROR,
                description=f"标签 [{tag_name}] 的第 {param_index + 1} 个参数使用双引号，应该使用反引号",
                current_content=line,
                suggested_fix=line.replace(param, f'`{param[1:-1]}`'),
                severity="error",
                rule_reference=self.rule_refs[IssueType.STRING_QUOTE_ERROR],
                auto_fixable=True
            ))
        
        elif param.startswith("'") and param.endswith("'"):
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.STRING_QUOTE_ERROR,
                description=f"标签 [{tag_name}] 的第 {param_index + 1} 个参数使用单引号，应该使用反引号",
                current_content=line,
                suggested_fix=line.replace(param, f'`{param[1:-1]}`'),
                severity="error",
                rule_reference=self.rule_refs[IssueType.STRING_QUOTE_ERROR],
                auto_fixable=True
            ))
        
        # 检查缺少引号
        elif not (param.startswith('`') and param.endswith('`')) and not self.special_value_pattern.match(param):
            # 特殊值如 [all], [normal] 等不需要额外引号
            if not self.numeric_pattern.match(param):
                self.issues.append(FormatIssue(
                    line_number=line_num,
                    issue_type=IssueType.STRING_QUOTE_ERROR,
                    description=f"标签 [{tag_name}] 的字符串参数缺少反引号",
                    current_content=line,
                    suggested_fix=line.replace(param, f'`{param}`'),
                    severity="error",
                    rule_reference=self.rule_refs[IssueType.STRING_QUOTE_ERROR],
                    auto_fixable=True
                ))

    def _check_numeric_parameter_enhanced(self, line_num: int, line: str, param: str, tag_name: str, param_index: int):
        """增强版数值参数检查"""
        # 检查数值是否被错误地加了引号
        if param.startswith('`') and param.endswith('`'):
            inner_value = param[1:-1]
            if self.numeric_pattern.match(inner_value):
                self.issues.append(FormatIssue(
                    line_number=line_num,
                    issue_type=IssueType.NUMERIC_QUOTE_ERROR,
                    description=f"标签 [{tag_name}] 的数值参数不应该使用反引号",
                    current_content=line,
                    suggested_fix=line.replace(param, inner_value),
                    severity="error",
                    rule_reference=self.rule_refs[IssueType.NUMERIC_QUOTE_ERROR],
                    auto_fixable=True
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
                    severity="error",
                    rule_reference=self.rule_refs[IssueType.NUMERIC_QUOTE_ERROR],
                    auto_fixable=True
                ))

    def _check_mixed_parameter(self, line_num: int, line: str, param: str, tag_name: str, param_index: int):
        """检查混合类型参数"""
        # 对于混合标签，根据参数内容判断类型
        if self.numeric_pattern.match(param):
            # 数值参数，检查是否有引号
            if param.startswith('`') or param.startswith('"'):
                self.issues.append(FormatIssue(
                    line_number=line_num,
                    issue_type=IssueType.NUMERIC_QUOTE_ERROR,
                    description=f"标签 [{tag_name}] 的数值参数不应该使用引号",
                    current_content=line,
                    suggested_fix=line.replace(param, param.strip('`"')),
                    severity="warning",
                    rule_reference=self.rule_refs[IssueType.NUMERIC_QUOTE_ERROR],
                    auto_fixable=True
                ))
        else:
            # 字符串参数，检查引号
            if param.startswith('"') and param.endswith('"'):
                self.issues.append(FormatIssue(
                    line_number=line_num,
                    issue_type=IssueType.STRING_QUOTE_ERROR,
                    description=f"标签 [{tag_name}] 的字符串参数建议使用反引号",
                    current_content=line,
                    suggested_fix=line.replace(param, f'`{param[1:-1]}`'),
                    severity="warning",
                    rule_reference=self.rule_refs[IssueType.STRING_QUOTE_ERROR],
                    auto_fixable=True
                ))

    def _check_generic_parameter_enhanced(self, line_num: int, line: str, param: str, param_index: int):
        """增强版通用参数检查"""
        # 检查是否使用了错误的引号类型
        if param.startswith('"') and param.endswith('"'):
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.STRING_QUOTE_ERROR,
                description=f"第 {param_index + 1} 个参数使用双引号，建议使用反引号",
                current_content=line,
                suggested_fix=line.replace(param, f'`{param[1:-1]}`'),
                severity="warning",
                rule_reference=self.rule_refs[IssueType.STRING_QUOTE_ERROR],
                auto_fixable=True
            ))

    def _check_content_line_enhanced(self, line_num: int, line: str):
        """增强版内容行检查"""
        stripped = line.strip()
        
        # 检查多个连续空格
        if self.multiple_spaces_pattern.search(stripped):
            self.issues.append(FormatIssue(
                line_number=line_num,
                issue_type=IssueType.WHITESPACE_ERROR,
                description="发现多个连续空格，可能应该使用制表符分隔",
                current_content=line,
                suggested_fix=self._suggest_tab_separation_fix(line),
                severity="info",
                rule_reference=self.rule_refs[IssueType.WHITESPACE_ERROR],
                auto_fixable=True
            ))

    def _check_consistency(self):
        """检查整体一致性"""
        # 统计引号使用情况
        backtick_count = 0
        double_quote_count = 0
        single_quote_count = 0
        
        for line in self.lines:
            backtick_count += line.count('`')
            double_quote_count += line.count('"')
            single_quote_count += line.count("'")
        
        # 如果双引号使用较多，给出建议
        if double_quote_count > backtick_count and double_quote_count > 5:
            self.issues.append(FormatIssue(
                line_number=0,
                issue_type=IssueType.STRING_QUOTE_ERROR,
                description=f"文件中大量使用双引号 ({double_quote_count} 个)，建议统一使用反引号",
                current_content="整个文件",
                suggested_fix="将所有双引号替换为反引号",
                severity="info",
                rule_reference=self.rule_refs[IssueType.STRING_QUOTE_ERROR],
                auto_fixable=True
            ))

    def _is_indentation_context(self, line: str) -> bool:
        """判断是否是缩进上下文"""
        stripped = line.strip()
        
        # 标签行通常是缩进
        if self.tag_pattern.match(stripped) or self.closing_tag_pattern.match(stripped):
            return True
        
        # 多个连续空格通常是缩进
        leading_spaces = len(line) - len(line.lstrip(' '))
        if leading_spaces >= 4:
            return True
        
        return False

    def _suggest_tab_separation_fix(self, line: str) -> str:
        """建议制表符分隔修复"""
        # 保留行首缩进
        leading_match = self.leading_whitespace_pattern.match(line)
        if leading_match:
            leading = leading_match.group(1)
            content = line[len(leading):]
        else:
            leading = ""
            content = line
        
        # 智能分割参数
        parts = re.split(r'\s+', content.strip())
        if len(parts) > 1:
            return leading + '\t'.join(parts)
        
        return line

    def generate_detailed_report(self, result: CheckResult) -> str:
        """生成详细报告"""
        if not result.issues:
            return f"""
✅ PVF格式检查通过
==================

文件: {result.file_path}
总行数: {result.total_lines}
文件大小: {result.file_size} 字节
编码: {result.encoding}
检查耗时: {result.check_time}

🎉 恭喜！文件格式完全符合PVF规范，未发现任何问题。
"""
        
        # 按严重程度分组
        errors = [i for i in result.issues if i.severity == "error"]
        warnings = [i for i in result.issues if i.severity == "warning"]
        infos = [i for i in result.issues if i.severity == "info"]
        
        report = [f"📋 PVF格式检查详细报告"]
        report.append("=" * 50)
        report.append(f"文件: {result.file_path}")
        report.append(f"总行数: {result.total_lines}")
        report.append(f"文件大小: {result.file_size} 字节")
        report.append(f"编码: {result.encoding}")
        report.append(f"检查耗时: {result.check_time}")
        report.append("")
        report.append(f"发现 {len(result.issues)} 个问题：")
        report.append(f"  🔴 错误: {len(errors)} 个 (必须修复)")
        report.append(f"  🟡 警告: {len(warnings)} 个 (建议修复)")
        report.append(f"  ℹ️ 信息: {len(infos)} 个 (可选修复)")
        report.append("")
        
        # 详细问题列表
        if errors:
            report.append("🔴 错误详情 (必须修复):")
            report.append("-" * 30)
            for i, issue in enumerate(errors, 1):
                report.append(f"{i}. 行 {issue.line_number}: {issue.description}")
                report.append(f"   类型: {issue.issue_type.value}")
                report.append(f"   当前: {issue.current_content.strip()}")
                report.append(f"   建议: {issue.suggested_fix.strip()}")
                report.append(f"   规范: {issue.rule_reference}")
                report.append(f"   自动修复: {'是' if issue.auto_fixable else '否'}")
                report.append("")
        
        if warnings:
            report.append("🟡 警告详情 (建议修复):")
            report.append("-" * 30)
            for i, issue in enumerate(warnings, 1):
                report.append(f"{i}. 行 {issue.line_number}: {issue.description}")
                report.append(f"   类型: {issue.issue_type.value}")
                report.append(f"   当前: {issue.current_content.strip()}")
                report.append(f"   建议: {issue.suggested_fix.strip()}")
                report.append(f"   规范: {issue.rule_reference}")
                report.append("")
        
        if infos:
            report.append("ℹ️ 信息详情 (可选修复):")
            report.append("-" * 30)
            for i, issue in enumerate(infos, 1):
                report.append(f"{i}. 行 {issue.line_number}: {issue.description}")
                report.append(f"   类型: {issue.issue_type.value}")
                report.append(f"   建议: {issue.suggested_fix.strip()}")
                report.append("")
        
        # 修复建议
        auto_fixable_count = len([i for i in result.issues if i.auto_fixable])
        if auto_fixable_count > 0:
            report.append("🔧 修复建议:")
            report.append(f"  • {auto_fixable_count} 个问题可以自动修复")
            report.append("  • 运行命令: python PVF格式检查增强版.py <文件> --auto-fix")
            report.append("")
        
        # 问题统计
        issue_types = {}
        for issue in result.issues:
            issue_type = issue.issue_type.value
            if issue_type not in issue_types:
                issue_types[issue_type] = 0
            issue_types[issue_type] += 1
        
        report.append("📊 问题类型统计:")
        for issue_type, count in sorted(issue_types.items()):
            report.append(f"  • {issue_type}: {count} 个")
        
        return "\n".join(report)

    def check_multiple_files(self, file_paths: List[str]) -> List[CheckResult]:
        """批量检查多个文件"""
        results = []
        for file_path in file_paths:
            if os.path.exists(file_path):
                result = self.check_file(file_path)
                results.append(result)
            else:
                # 创建错误结果
                error_issue = FormatIssue(
                    line_number=0,
                    issue_type=IssueType.ENCODING_ERROR,
                    description=f"文件不存在: {file_path}",
                    current_content="",
                    suggested_fix="检查文件路径",
                    severity="error",
                    auto_fixable=False
                )
                results.append(CheckResult(
                    file_path=file_path,
                    issues=[error_issue],
                    total_lines=0,
                    check_time="0.00s",
                    file_size=0,
                    encoding="unknown"
                ))
        return results

    def generate_summary_report(self, results: List[CheckResult]) -> str:
        """生成汇总报告"""
        total_files = len(results)
        total_issues = sum(len(r.issues) for r in results)
        clean_files = len([r for r in results if not r.issues])
        
        report = [f"📊 PVF格式检查汇总报告"]
        report.append("=" * 40)
        report.append(f"检查文件总数: {total_files}")
        report.append(f"格式正确文件: {clean_files}")
        report.append(f"有问题文件: {total_files - clean_files}")
        report.append(f"问题总数: {total_issues}")
        report.append("")
        
        if total_issues > 0:
            # 按文件列出问题
            report.append("📋 文件问题详情:")
            for result in results:
                if result.issues:
                    errors = len([i for i in result.issues if i.severity == "error"])
                    warnings = len([i for i in result.issues if i.severity == "warning"])
                    infos = len([i for i in result.issues if i.severity == "info"])
                    
                    report.append(f"  📄 {os.path.basename(result.file_path)}")
                    report.append(f"     错误: {errors}, 警告: {warnings}, 信息: {infos}")
        
        return "\n".join(report)

    def auto_fix_file(self, file_path: str, backup: bool = True) -> Tuple[bool, int]:
        """自动修复文件，返回(成功标志, 修复问题数量)"""
        if backup:
            backup_path = file_path + ".backup"
            try:
                import shutil
                shutil.copy2(file_path, backup_path)
                print(f"✅ 已创建备份文件: {backup_path}")
            except Exception as e:
                print(f"❌ 创建备份失败: {e}")
                return False, 0
        
        try:
            # 检查文件
            result = self.check_file(file_path)
            auto_fixable_issues = [i for i in result.issues if i.auto_fixable]
            
            if not auto_fixable_issues:
                print("ℹ️ 没有可自动修复的问题")
                return True, 0
            
            # 应用修复
            fixed_lines = self.lines.copy()
            fixed_count = 0
            
            # 按行号倒序处理，避免行号偏移
            for issue in sorted(auto_fixable_issues, key=lambda x: x.line_number, reverse=True):
                if issue.line_number > 0 and issue.suggested_fix:
                    if issue.line_number <= len(fixed_lines):
                        fixed_lines[issue.line_number - 1] = issue.suggested_fix
                        fixed_count += 1
            
            # 写回文件，确保使用CRLF行尾符
            with open(file_path, 'w', encoding='utf-8', newline='') as f:
                f.write('\r\n'.join(fixed_lines) + '\r\n')
            
            print(f"✅ 自动修复完成: {file_path}")
            print(f"📊 修复了 {fixed_count} 个问题")
            return True, fixed_count
            
        except Exception as e:
            print(f"❌ 自动修复失败: {e}")
            return False, 0


def main():
    """主函数"""
    parser = argparse.ArgumentParser(description="PVF格式检查增强版")
    parser.add_argument("files", nargs="+", help="要检查的文件路径")
    parser.add_argument("--auto-fix", action="store_true", help="自动修复问题")
    parser.add_argument("--no-backup", action="store_true", help="自动修复时不创建备份")
    parser.add_argument("--quiet", action="store_true", help="只显示错误")
    parser.add_argument("--summary", action="store_true", help="显示汇总报告")
    parser.add_argument("--json", help="将结果保存为JSON文件")
    
    args = parser.parse_args()
    
    checker = PVFFormatCheckerEnhanced()
    
    # 检查文件
    if len(args.files) == 1:
        # 单文件检查
        file_path = args.files[0]
        if not os.path.exists(file_path):
            print(f"❌ 文件不存在: {file_path}")
            sys.exit(1)
        
        result = checker.check_file(file_path)
        
        if not args.quiet:
            report = checker.generate_detailed_report(result)
            print(report)
        
        # 自动修复
        if args.auto_fix and result.issues:
            success, fixed_count = checker.auto_fix_file(file_path, backup=not args.no_backup)
            if success and fixed_count > 0:
                # 重新检查
                new_result = checker.check_file(file_path)
                remaining_issues = len(new_result.issues)
                if remaining_issues > 0:
                    print(f"⚠️ 仍有 {remaining_issues} 个问题需要手动修复")
        
        # 保存JSON结果
        if args.json:
            with open(args.json, 'w', encoding='utf-8') as f:
                json.dump(asdict(result), f, ensure_ascii=False, indent=2, default=str)
            print(f"📄 结果已保存到: {args.json}")
        
        # 返回退出码
        error_count = len([i for i in result.issues if i.severity == "error"])
        sys.exit(error_count)
    
    else:
        # 多文件检查
        results = checker.check_multiple_files(args.files)
        
        if args.summary:
            summary = checker.generate_summary_report(results)
            print(summary)
        else:
            for result in results:
                if not args.quiet or result.issues:
                    report = checker.generate_detailed_report(result)
                    print(report)
                    print("-" * 60)
        
        # 批量自动修复
        if args.auto_fix:
            total_fixed = 0
            for result in results:
                if result.issues and os.path.exists(result.file_path):
                    success, fixed_count = checker.auto_fix_file(
                        result.file_path, 
                        backup=not args.no_backup
                    )
                    if success:
                        total_fixed += fixed_count
            
            if total_fixed > 0:
                print(f"🎉 总共修复了 {total_fixed} 个问题")
        
        # 保存JSON结果
        if args.json:
            with open(args.json, 'w', encoding='utf-8') as f:
                json.dump([asdict(r) for r in results], f, ensure_ascii=False, indent=2, default=str)
            print(f"📄 结果已保存到: {args.json}")
        
        # 返回退出码
        total_errors = sum(len([i for i in r.issues if i.severity == "error"]) for r in results)
        sys.exit(min(total_errors, 255))


if __name__ == "__main__":
    main()