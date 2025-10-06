#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
PVF格式检查工具启动器
提供友好的交互界面来使用PVF格式检查工具
"""

import os
import sys
import glob
import subprocess
from pathlib import Path

def clear_screen():
    """清屏"""
    os.system('cls' if os.name == 'nt' else 'clear')

def show_menu():
    """显示主菜单"""
    clear_screen()
    print("=" * 50)
    print("           PVF格式检查工具")
    print("=" * 50)
    print()
    print("1. 检查单个文件")
    print("2. 检查所有EQU文件")
    print("3. 检查所有STK文件")
    print("4. 检查所有SHO文件")
    print("5. 检查所有PVF文件")
    print("6. 自动修复单个文件")
    print("7. 自动修复所有EQU文件")
    print("8. 显示帮助信息")
    print("9. 退出")
    print()

def run_checker(files, auto_fix=False):
    """运行格式检查器"""
    script_path = "PVF格式检查增强版.py"
    
    if isinstance(files, str):
        files = [files]
    
    for file in files:
        if not os.path.exists(file):
            print(f"文件不存在: {file}")
            continue
            
        print(f"{'修复' if auto_fix else '检查'}文件: {file}")
        print("-" * 40)
        
        cmd = ["python", script_path, file]
        if auto_fix:
            cmd.append("--auto-fix")
            
        try:
            result = subprocess.run(cmd, capture_output=False, text=True)
            if auto_fix and result.returncode == 0:
                print(f"✅ 修复完成！备份文件已保存为 {file}.backup")
        except Exception as e:
            print(f"❌ 运行出错: {e}")
        
        print()

def get_files_by_pattern(pattern):
    """根据模式获取文件列表"""
    files = glob.glob(pattern)
    if not files:
        print(f"未找到匹配的文件: {pattern}")
        return []
    return files

def show_help():
    """显示帮助信息"""
    clear_screen()
    print("=" * 50)
    print("         PVF格式检查工具帮助")
    print("=" * 50)
    print()
    print("本工具用于检查PVF文件格式规范，包括：")
    print()
    print("1. 缩进格式检查")
    print("   - 检查是否使用制表符进行缩进")
    print("   - 识别错误的空格缩进")
    print()
    print("2. 字符串格式检查")
    print("   - 检查字符串是否使用反引号 ``")
    print("   - 识别错误的双引号 \"\"")
    print()
    print("3. 参数分隔检查")
    print("   - 检查标签参数是否使用制表符分隔")
    print("   - 识别错误的空格分隔")
    print()
    print("4. 数值格式检查")
    print("   - 检查数值是否正确（不加引号）")
    print()
    print("5. 行尾符检查")
    print("   - 检查是否使用CRLF行尾符")
    print()
    print("自动修复功能会创建备份文件（.backup扩展名）")
    print()
    input("按回车键返回主菜单...")

def main():
    """主函数"""
    while True:
        show_menu()
        
        try:
            choice = input("请选择操作 (1-9): ").strip()
        except KeyboardInterrupt:
            print("\n\n感谢使用PVF格式检查工具！")
            sys.exit(0)
        
        if choice == "1":
            filename = input("\n请输入文件名: ").strip()
            if filename:
                run_checker(filename)
                input("\n按回车键继续...")
                
        elif choice == "2":
            files = get_files_by_pattern("*.equ")
            if files:
                run_checker(files)
                input("\n按回车键继续...")
                
        elif choice == "3":
            files = get_files_by_pattern("*.stk")
            if files:
                run_checker(files)
                input("\n按回车键继续...")
                
        elif choice == "4":
            files = get_files_by_pattern("*.sho")
            if files:
                run_checker(files)
                input("\n按回车键继续...")
                
        elif choice == "5":
            patterns = ["*.equ", "*.stk", "*.sho", "*.map", "*.ani"]
            all_files = []
            for pattern in patterns:
                all_files.extend(get_files_by_pattern(pattern))
            
            if all_files:
                run_checker(all_files)
                input("\n按回车键继续...")
            else:
                print("未找到任何PVF文件")
                input("\n按回车键继续...")
                
        elif choice == "6":
            filename = input("\n请输入要修复的文件名: ").strip()
            if filename:
                run_checker(filename, auto_fix=True)
                input("\n按回车键继续...")
                
        elif choice == "7":
            files = get_files_by_pattern("*.equ")
            if files:
                print(f"\n将修复 {len(files)} 个EQU文件")
                confirm = input("确认继续吗？(y/N): ").strip().lower()
                if confirm == 'y':
                    run_checker(files, auto_fix=True)
                    print("所有EQU文件修复完成！")
                else:
                    print("操作已取消")
                input("\n按回车键继续...")
                
        elif choice == "8":
            show_help()
            
        elif choice == "9":
            print("\n感谢使用PVF格式检查工具！")
            break
            
        else:
            print("\n无效选择，请重新输入...")
            input("按回车键继续...")

if __name__ == "__main__":
    main()