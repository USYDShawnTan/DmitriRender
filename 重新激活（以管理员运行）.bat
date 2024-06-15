@echo off
chcp 65001 >nul

echo 整体原理：
echo 1、删除注册表中 HKEY_CURRENT_USER\SOFTWARE\DmitriRender
echo 2、删除 %UserProfile%\Documents\desktop.ini 文件中 IconIndex=-235 下面的部分
echo 3、检查 PotPlayer 根目录下是否存在 version.dll 文件，如果有则删除
echo 4、打开启用程序重新试用
echo 5、播放 success_video.mp4
echo 6、将 bat 文件根目录下的 version.dll 复制到 PotPlayer 根目录
echo 按任意键继续！不需要可以直接关闭。

pause

rem 步骤1：删除注册表
reg delete HKEY_CURRENT_USER\SOFTWARE\DmitriRender /f
echo 已执行完步骤1（删除注册表）。

rem 步骤2：自动删除 desktop.ini 中 [IconIndex=-235] 下面的所有内容
set "file=%UserProfile%\Documents\desktop.ini"
set "tempfile=%UserProfile%\Documents\desktop_temp.ini"

if exist "%file%" (
    for /f "tokens=1* delims=:" %%a in ('findstr /n "^" "%file%"') do (
        if "%%b"=="IconIndex=-235" (
            break
        ) else (
            echo.%%b>>"%tempfile%"
        )
    )
    move /y "%tempfile%" "%file%"
    echo 已执行完步骤2（自动删除 desktop.ini 中的部分内容）。
) else (
    echo 文件 %file% 不存在。
)

rem 步骤3：检查 PotPlayer 根目录下是否存在 version.dll 文件，如果有则删除
if exist "C:\Program Files\DAUM\PotPlayer\version.dll" (
    del "C:\Program Files\DAUM\PotPlayer\version.dll"
    echo 已删除 PotPlayer 根目录下的 version.dll 文件。
)

rem 步骤4：打开启用程序重新试用
start /w /d "%AppData%\DmitriRender\x64\" pcnsl.exe

rem 步骤5：播放 success_video.mp4
if exist "%~dp0success_video.mp4" (
    start "" "%~dp0success_video.mp4"
    echo 正在播放 success_video.mp4。
)

rem 等待两秒
timeout /t 3 >nul

rem 步骤6：将 bat 文件根目录下的 version.dll 复制到 PotPlayer 根目录
if exist "%~dp0version.dll" (
    copy /y "%~dp0version.dll" "C:\Program Files\DAUM\PotPlayer\"
    echo 已将 version.dll 复制到 PotPlayer 根目录。
)

echo 如果以上操作顺利，已经重新试用成功，批处理程序将自动关闭。potplayer你自己手动关一下谢谢
timeout /t 5 >nul
exit
