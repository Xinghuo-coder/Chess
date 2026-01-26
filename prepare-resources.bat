@echo off
REM 图标和启动画面准备脚本 (Windows)

echo === 中国象棋 图标资源准备 ===

REM 创建目录
if not exist "res\icon\android" mkdir res\icon\android
if not exist "res\screen\android" mkdir res\screen\android
if not exist "res\icon\ios" mkdir res\icon\ios

REM 检查是否有源图标
if not exist "icon-source.png" (
    echo 警告: 未找到 icon-source.png ^(建议尺寸: 1024x1024^)
    echo 请将源图标文件命名为 icon-source.png 放在项目根目录
    echo.
    echo 可以使用在线工具生成图标：
    echo - https://icon.kitchen/
    echo - https://www.appicon.co/
    echo.
    pause
    exit /b 1
)

echo.
echo 请手动使用以下工具生成图标：
echo.
echo 在线工具推荐：
echo 1. https://icon.kitchen/
echo 2. https://www.appicon.co/
echo 3. https://romannurik.github.io/AndroidAssetStudio/
echo.
echo 需要生成以下尺寸的图标：
echo Android Icons:
echo   - ldpi.png ^(36x36^)
echo   - mdpi.png ^(48x48^)
echo   - hdpi.png ^(72x72^)
echo   - xhdpi.png ^(96x96^)
echo   - xxhdpi.png ^(144x144^)
echo   - xxxhdpi.png ^(192x192^)
echo.
echo 将生成的图标放入 res\icon\android\ 目录
echo.
pause
