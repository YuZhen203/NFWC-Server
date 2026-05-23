@echo off
chcp 65001 >nul
title NFWC 服务器自动配置
setlocal enabledelayedexpansion

echo ============================================
echo   NFWC 服务器 - 自动配置脚本
echo ============================================
echo.

:: 获取当前脚本所在目录
set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"

:: 找整合包 ZIP
set "ZIP="
for %%f in ("%ROOT%\*.zip") do (
    echo %%f | find /i "No Flesh Within Chest" >nul
    if not errorlevel 1 set "ZIP=%%f"
)

if not defined ZIP (
    echo [!] 未找到 No Flesh Within Chest-*.zip 文件
    echo     请把整合包 .zip 放到 %ROOT% 目录下
    pause
    exit /b 1
)

echo [1/6] 解压整合包...
set "TEMP_DIR=%ROOT%\_temp_extract"
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"
tar -xf "%ZIP%" -C "%TEMP_DIR%" 2>nul
if not errorlevel 1 goto extracted
:: tar 不行用 PowerShell 的 Expand-Archive
powershell -Command "Expand-Archive -Path '%ZIP%' -DestinationPath '%TEMP_DIR%' -Force" 2>nul
:extracted

:: 找到解压后的 overrides 目录
set "OVERRIDES=%TEMP_DIR%\overrides"
if not exist "%OVERRIDES%" (
    :: 有的 ZIP 解压后会多一层目录
    for /d %%d in ("%TEMP_DIR%\*") do (
        if exist "%%d\overrides" set "OVERRIDES=%%d\overrides"
    )
)

echo [2/6] 复制模组...

:: 从本地 PCL 安装复制完整模组（所有朋友都运行过整合包，都有这些文件）
set "PCL_DIR=%ROOT%\..\.minecraft\versions\No Flesh Within Chest"
if exist "F:\MC\.minecraft\versions\No Flesh Within Chest\mods" (
    set "MODS_SRC=F:\MC\.minecraft\versions\No Flesh Within Chest\mods"
) else if exist "%PCL_DIR%\mods" (
    set "MODS_SRC=%PCL_DIR%\mods"
) else (
    echo [!] 未找到 PCL 模组目录！
    echo     请将 .minecraft 下整合包的 mods 文件夹复制到 %ROOT%\
    pause
    exit /b 1
)

if exist "%ROOT%\mods" rmdir /s /q "%ROOT%\mods"
xcopy /e /i /q /y "!MODS_SRC!" "%ROOT%\mods" >nul
echo 模组已复制

:: 复制配置文件
if exist "%ROOT%\config" rmdir /s /q "%ROOT%\config"
xcopy /e /i /q /y "%OVERRIDES%\config" "%ROOT%\config" >nul

if exist "%ROOT%\kubejs" rmdir /s /q "%ROOT%\kubejs"
xcopy /e /i /q /y "%OVERRIDES%\kubejs" "%ROOT%\kubejs" >nul

if exist "%ROOT%\defaultconfigs" rmdir /s /q "%ROOT%\defaultconfigs"
xcopy /e /i /q /y "%OVERRIDES%\defaultconfigs" "%ROOT%\defaultconfigs" >nul

    echo [!] Forge 安装失败，请检查 Java 17 是否正确配置
    pause
    exit /b 1
)

echo [6/6] 应用游戏存档数据...
if exist "%ROOT%\repack" (
    xcopy /e /i /q /y "%ROOT%\repack\world" "%ROOT%\world" >nul
    if exist "%ROOT%\repack\server.properties" copy /y "%ROOT%\repack\server.properties" "%ROOT%\server.properties" >nul
    if exist "%ROOT%\repack\ops.json" copy /y "%ROOT%\repack\ops.json" "%ROOT%\ops.json" >nul
    if exist "%ROOT%\repack\whitelist.json" copy /y "%ROOT%\repack\whitelist.json" "%ROOT%\whitelist.json" >nul
)

:: 清理
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
if exist "%FORGE_JAR%" del "%FORGE_JAR%"

echo.
echo ============================================
echo   配置完成！现在你可以：
echo     1. 双击 run.bat 启动服务器
echo     2. 或用 Sea Lantern 导入本目录
echo ============================================
echo.
pause
