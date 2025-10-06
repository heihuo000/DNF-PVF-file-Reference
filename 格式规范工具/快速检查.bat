@echo off
chcp 936 >nul
title PVF格式检查工具

:menu
cls
echo ========================================
echo         PVF格式检查工具
echo ========================================
echo.
echo 1. 检查单个文件
echo 2. 检查所有EQU文件
echo 3. 检查所有STK文件  
echo 4. 检查所有SHO文件
echo 5. 检查所有PVF文件
echo 6. 自动修复单个文件
echo 7. 自动修复所有EQU文件
echo 8. 显示帮助信息
echo 9. 退出
echo.
set /p choice=请选择操作 (1-9): 

if "%choice%"=="1" goto check_single
if "%choice%"=="2" goto check_equ
if "%choice%"=="3" goto check_stk
if "%choice%"=="4" goto check_sho
if "%choice%"=="5" goto check_all
if "%choice%"=="6" goto fix_single
if "%choice%"=="7" goto fix_equ
if "%choice%"=="8" goto help
if "%choice%"=="9" goto exit

echo 无效选择，请重新输入...
pause
goto menu

:check_single
echo.
set /p filename=请输入文件名: 
if not exist "%filename%" (
    echo 文件不存在: %filename%
    pause
    goto menu
)
python "PVF格式检查增强版.py" "%filename%"
pause
goto menu

:check_equ
echo.
echo 正在检查所有EQU文件...
for %%f in (*.equ) do (
    echo 检查文件: %%f
    python "PVF格式检查增强版.py" "%%f"
    echo.
)
pause
goto menu

:check_stk
echo.
echo 正在检查所有STK文件...
for %%f in (*.stk) do (
    echo 检查文件: %%f
    python "PVF格式检查增强版.py" "%%f"
    echo.
)
pause
goto menu

:check_sho
echo.
echo 正在检查所有SHO文件...
for %%f in (*.sho) do (
    echo 检查文件: %%f
    python "PVF格式检查增强版.py" "%%f"
    echo.
)
pause
goto menu

:check_all
echo.
echo 正在检查所有PVF文件...
for %%f in (*.equ *.stk *.sho *.map *.ani) do (
    echo 检查文件: %%f
    python "PVF格式检查增强版.py" "%%f"
    echo.
)
pause
goto menu

:fix_single
echo.
set /p filename=请输入要修复的文件名: 
if not exist "%filename%" (
    echo 文件不存在: %filename%
    pause
    goto menu
)
echo 正在自动修复文件: %filename%
python "PVF格式检查增强版.py" "%filename%" --auto-fix
echo.
echo 修复完成！备份文件已保存为 %filename%.backup
pause
goto menu

:fix_equ
echo.
echo 正在自动修复所有EQU文件...
for %%f in (*.equ) do (
    echo 修复文件: %%f
    python "PVF格式检查增强版.py" "%%f" --auto-fix
)
echo.
echo 所有EQU文件修复完成！
pause
goto menu

:help
cls
echo ========================================
echo         PVF格式检查工具帮助
echo ========================================
echo.
echo 本工具用于检查PVF文件格式规范，包括：
echo.
echo 1. 缩进格式检查
echo    - 检查是否使用制表符进行缩进
echo    - 识别错误的空格缩进
echo.
echo 2. 字符串格式检查  
echo    - 检查字符串是否使用反引号 ``
echo    - 识别错误的双引号 ""
echo.
echo 3. 参数分隔检查
echo    - 检查标签参数是否使用制表符分隔
echo    - 识别错误的空格分隔
echo.
echo 4. 数值格式检查
echo    - 检查数值是否正确（不加引号）
echo.
echo 5. 行尾符检查
echo    - 检查是否使用CRLF行尾符
echo.
echo 自动修复功能会创建备份文件（.backup扩展名）
echo.
pause
goto menu

:exit
echo.
echo 感谢使用PVF格式检查工具！
pause
exit