#!/bin/bash
# 图标和启动画面准备脚本

echo "=== 中国象棋 图标资源准备 ==="

# 创建目录
mkdir -p res/icon/android
mkdir -p res/screen/android
mkdir -p res/icon/ios

# 检查是否有源图标
if [ ! -f "icon-source.png" ]; then
    echo "警告: 未找到 icon-source.png (建议尺寸: 1024x1024)"
    echo "请将源图标文件命名为 icon-source.png 放在项目根目录"
    echo ""
    echo "可以使用在线工具生成图标："
    echo "- https://icon.kitchen/"
    echo "- https://www.appicon.co/"
    echo ""
    exit 1
fi

# 检查 ImageMagick 是否安装
if ! command -v convert &> /dev/null; then
    echo "ImageMagick 未安装，需要手动生成图标"
    echo ""
    echo "安装方法："
    echo "  macOS:   brew install imagemagick"
    echo "  Ubuntu:  sudo apt-get install imagemagick"
    echo "  Windows: 从 https://imagemagick.org/ 下载安装"
    echo ""
    echo "或使用在线工具手动生成以下尺寸的图标："
    echo "Android Icons:"
    echo "  - ldpi.png (36x36)"
    echo "  - mdpi.png (48x48)"
    echo "  - hdpi.png (72x72)"
    echo "  - xhdpi.png (96x96)"
    echo "  - xxhdpi.png (144x144)"
    echo "  - xxxhdpi.png (192x192)"
    exit 1
fi

echo "开始生成 Android 图标..."

# 生成 Android 图标
convert icon-source.png -resize 36x36 res/icon/android/ldpi.png
convert icon-source.png -resize 48x48 res/icon/android/mdpi.png
convert icon-source.png -resize 72x72 res/icon/android/hdpi.png
convert icon-source.png -resize 96x96 res/icon/android/xhdpi.png
convert icon-source.png -resize 144x144 res/icon/android/xxhdpi.png
convert icon-source.png -resize 192x192 res/icon/android/xxxhdpi.png

echo "✓ Android 图标生成完成"

# 生成启动画面（如果有源文件）
if [ -f "splash-source.png" ]; then
    echo "开始生成 Android 启动画面..."
    
    convert splash-source.png -resize 200x320! res/screen/android/splash-port-ldpi.png
    convert splash-source.png -resize 320x480! res/screen/android/splash-port-mdpi.png
    convert splash-source.png -resize 480x800! res/screen/android/splash-port-hdpi.png
    convert splash-source.png -resize 720x1280! res/screen/android/splash-port-xhdpi.png
    convert splash-source.png -resize 960x1600! res/screen/android/splash-port-xxhdpi.png
    convert splash-source.png -resize 1280x1920! res/screen/android/splash-port-xxxhdpi.png
    
    echo "✓ Android 启动画面生成完成"
else
    echo "提示: 未找到 splash-source.png (建议尺寸: 1280x1920)"
    echo "如需启动画面，请将源文件命名为 splash-source.png 放在项目根目录后重新运行"
fi

# 生成 iOS 图标（可选）
if [ "$1" == "ios" ]; then
    echo "开始生成 iOS 图标..."
    convert icon-source.png -resize 57x57 res/icon/ios/icon-57.png
    convert icon-source.png -resize 114x114 res/icon/ios/icon-57-2x.png
    convert icon-source.png -resize 72x72 res/icon/ios/icon-72.png
    convert icon-source.png -resize 144x144 res/icon/ios/icon-72-2x.png
    echo "✓ iOS 图标生成完成"
fi

echo ""
echo "=== 资源生成完成 ==="
echo "图标位置: res/icon/android/"
echo "启动画面位置: res/screen/android/"
echo ""
echo "下一步: 运行 cordova build android"
