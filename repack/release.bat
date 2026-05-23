@echo off
chcp 65001 >nul
title NFWC 存档打包工具

set "ROOT=%~dp0.."
set "REPACK=%~dp0"

echo ============================================
echo   NFWC 存档打包
echo ============================================
echo.

:: 检查当前有没有正在运行的服务器
tasklist /fi "IMAGENAME eq java.exe" 2>nul | find /i "java.exe" >nul
if not errorlevel 1 (
    echo [!] Java 进程正在运行，请先关闭服务器！
    pause
    exit /b 1
)

:: 复制世界存档
echo [1/3] 打包世界存档...
if exist "%REPACK%world" rmdir /s /q "%REPACK%world"
xcopy /e /i /q "%ROOT%\world" "%REPACK%world" >nul

:: 复制配置文件
echo [2/3] 打包服务器配置...
copy /y "%ROOT%\server.properties" "%REPACK%server.properties" >nul
copy /y "%ROOT%\ops.json" "%REPACK%ops.json" >nul
copy /y "%ROOT%\whitelist.json" "%REPACK%whitelist.json" >nul
copy /y "%ROOT%\usercache.json" "%REPACK%usercache.json" >nul

:: 提交并推送
echo [3/3] 推送到 Git...
cd /d "%ROOT%"
git add repack/
git commit -m "更新存档 %date%"
git push
if errorlevel 1 (
    echo [!] Git 推送失败，请检查网络或 GitHub 认证
    pause
    exit /b 1
)

echo.
echo ============================================
echo   存档已推送到 GitHub！
echo ============================================
echo.
pause
