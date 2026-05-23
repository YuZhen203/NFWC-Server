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

echo [2/6] 复制模组、配置等...
if exist "%ROOT%\mods" rmdir /s /q "%ROOT%\mods"
xcopy /e /i /q "%OVERRIDES%\mods" "%ROOT%\mods" >nul

if exist "%ROOT%\config" rmdir /s /q "%ROOT%\config"
xcopy /e /i /q "%OVERRIDES%\config" "%ROOT%\config" >nul

if exist "%ROOT%\kubejs" rmdir /s /q "%ROOT%\kubejs"
xcopy /e /i /q "%OVERRIDES%\kubejs" "%ROOT%\kubejs" >nul

if exist "%ROOT%\defaultconfigs" rmdir /s /q "%ROOT%\defaultconfigs"
xcopy /e /i /q "%OVERRIDES%\defaultconfigs" "%ROOT%\defaultconfigs" >nul

echo [3/6] 删除客户端模组...
del "%ROOT%\mods\RuOK-*.jar" 2>nul
del "%ROOT%\mods\oculus-mc*.jar" 2>nul
del "%ROOT%\mods\oculus-flywheel-compat*.jar" 2>nul
del "%ROOT%\mods\embeddium-*.jar" 2>nul
del "%ROOT%\mods\entityculling-*.jar" 2>nul
del "%ROOT%\mods\inventoryhud*.jar" 2>nul
del "%ROOT%\mods\skinlayers3d*.jar" 2>nul
del "%ROOT%\mods\dynamiclightsreforged*.jar" 2>nul
del "%ROOT%\mods\drippyloadingscreen*.jar" 2>nul
del "%ROOT%\mods\fancymenu_*.jar" 2>nul
del "%ROOT%\mods\Controlling-*.jar" 2>nul
del "%ROOT%\mods\BetterAdvancements-*.jar" 2>nul
del "%ROOT%\mods\InventoryProfilesNext-*.jar" 2>nul
del "%ROOT%\mods\ItemBorders-*.jar" 2>nul
del "%ROOT%\mods\OverflowingBars-*.jar" 2>nul
del "%ROOT%\mods\TravelersTitles-*.jar" 2>nul
del "%ROOT%\mods\EnchantmentDescriptions-*.jar" 2>nul
del "%ROOT%\mods\appleskin-*.jar" 2>nul
del "%ROOT%\mods\LegendaryTooltips-*.jar" 2>nul
del "%ROOT%\mods\jei-*.jar" 2>nul
del "%ROOT%\mods\emi-*.jar" 2>nul
del "%ROOT%\mods\emi_loot*.jar" 2>nul
del "%ROOT%\mods\Jade-*.jar" 2>nul
del "%ROOT%\mods\Iceberg-*.jar" 2>nul
del "%ROOT%\mods\CosmeticArmorReworked*.jar" 2>nul
del "%ROOT%\mods\lazydfu*.jar" 2>nul
del "%ROOT%\mods\jecharacters*.jar" 2>nul
del "%ROOT%\mods\konkrete_*.jar" 2>nul
del "%ROOT%\mods\melody_*.jar" 2>nul
del "%ROOT%\mods\lightspeed-*.jar" 2>nul
del "%ROOT%\mods\MyServerIsCompatible*.jar" 2>nul

echo [4/6] 删除客户端 KubeJS 脚本...
del /s /q "%ROOT%\kubejs\client_scripts\*.js" 2>nul
del "%ROOT%\kubejs\startup_scripts\client_init.js" 2>nul
del "%ROOT%\kubejs\startup_scripts\key_bind_register.js" 2>nul

echo [5/6] 下载安装 Forge 43.3.5...
set "FORGE_URL=https://maven.minecraftforge.net/net/minecraftforge/forge/1.19.2-43.3.5/forge-1.19.2-43.3.5-installer.jar"
set "FORGE_JAR=%ROOT%\forge-installer.jar"

if not exist "%FORGE_JAR%" (
    echo 正在下载 Forge 安装器...
    powershell -Command "Invoke-WebRequest -Uri '%FORGE_URL%' -OutFile '%FORGE_JAR%'" 2>nul
)

if not exist "%ROOT%\server.jar" (
    echo 正在下载 Minecraft 服务端...
    powershell -Command "Invoke-WebRequest -Uri 'https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar' -OutFile '%ROOT%\server.jar'" 2>nul
)

echo 正在安装 Forge...
java -jar "%FORGE_JAR%" --installServer
if errorlevel 1 (
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
