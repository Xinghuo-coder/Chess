# Android APK 打包指南

## 环境准备

### 1. 安装 Node.js 和 npm
```bash
# 下载并安装 Node.js LTS 版本
# https://nodejs.org/

# 验证安装
node --version  # 应该 >= 14.0.0
npm --version   # 应该 >= 6.0.0
```

### 2. 安装 Java JDK
```bash
# 安装 JDK 11 或更高版本
# Windows: https://adoptium.net/
# macOS: brew install openjdk@11
# Linux: sudo apt install openjdk-11-jdk

# 验证安装
java -version   # 应该显示 >= 11

# 设置 JAVA_HOME 环境变量
# Windows: 
# set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.x
# macOS/Linux:
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.jdk/Contents/Home
```

### 3. 安装 Android SDK
```bash
# 方法1: 安装 Android Studio（推荐）
# https://developer.android.com/studio
# 安装后在 SDK Manager 中安装必要组件

# 方法2: 使用命令行工具
# https://developer.android.com/studio#command-tools

# 设置 ANDROID_HOME 环境变量
# Windows:
# set ANDROID_HOME=C:\Users\YourName\AppData\Local\Android\Sdk
# macOS:
# export ANDROID_HOME=~/Library/Android/sdk
# Linux:
# export ANDROID_HOME=~/Android/Sdk

# 将以下目录添加到 PATH
# $ANDROID_HOME/tools
# $ANDROID_HOME/platform-tools
# $ANDROID_HOME/cmdline-tools/latest/bin
```

### 4. 安装 Gradle
```bash
# Android Studio 已包含 Gradle，无需单独安装
# 或手动安装: https://gradle.org/install/

# 验证安装
gradle --version  # 应该 >= 7.0
```

### 5. 安装 Cordova CLI
```bash
npm install -g cordova

# 验证安装
cordova --version  # 应该 >= 12.0.0
```

## 项目初始化

### 1. 安装项目依赖
```bash
cd /path/to/Chess
npm install
```

### 2. 添加 Android 平台
```bash
cordova platform add android

# 查看已安装的平台
cordova platform list
```

### 3. 检查环境
```bash
cordova requirements

# 应该看到类似输出：
# Requirements check results for android:
# Java JDK: installed 11.0.x
# Android SDK: installed true
# Android target: installed android-33
# Gradle: installed /path/to/gradle
```

## 准备图标和启动画面

### 1. 创建图标目录结构
```bash
mkdir -p res/icon/android
mkdir -p res/screen/android
```

### 2. 准备图标（必需）
在 `res/icon/android/` 目录下放置以下尺寸的图标：
- `ldpi.png` - 36x36
- `mdpi.png` - 48x48
- `hdpi.png` - 72x72
- `xhdpi.png` - 96x96
- `xxhdpi.png` - 144x144
- `xxxhdpi.png` - 192x192

### 3. 准备启动画面（可选）
在 `res/screen/android/` 目录下放置启动画面：
- `splash-port-ldpi.png` - 200x320
- `splash-port-mdpi.png` - 320x480
- `splash-port-hdpi.png` - 480x800
- `splash-port-xhdpi.png` - 720x1280
- `splash-port-xxhdpi.png` - 960x1600
- `splash-port-xxxhdpi.png` - 1280x1920

**图标生成工具推荐**:
- https://icon.kitchen/
- https://www.appicon.co/
- https://romannurik.github.io/AndroidAssetStudio/

## 构建 APK

### 1. 调试版本（用于测试）
```bash
# 构建调试版 APK
cordova build android --debug

# 或使用 npm script
npm run build:android:debug

# 输出位置：
# platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

### 2. 发布版本（用于发布）

#### 步骤 1: 生成签名密钥
```bash
# 创建密钥库目录
mkdir -p build

# 生成签名密钥
keytool -genkey -v -keystore build/chess-release.keystore \
  -alias chess -keyalg RSA -keysize 2048 -validity 10000

# 会提示输入：
# - 密钥库密码（请记住）
# - 密钥密码（请记住）
# - 姓名、组织等信息
```

#### 步骤 2: 创建签名配置文件
创建 `build.json` 文件：
```json
{
  "android": {
    "release": {
      "keystore": "build/chess-release.keystore",
      "storePassword": "你的密钥库密码",
      "alias": "chess",
      "password": "你的密钥密码",
      "keystoreType": ""
    }
  }
}
```

**重要**: 将 `build.json` 添加到 `.gitignore`，不要提交到版本控制！

#### 步骤 3: 构建签名的发布版 APK
```bash
cordova build android --release

# 或使用 npm script
npm run build:android

# 输出位置：
# platforms/android/app/build/outputs/apk/release/app-release.apk
```

## 安装和测试

### 1. 在设备上安装
```bash
# 连接 Android 设备并启用 USB 调试

# 直接运行（会自动构建并安装）
cordova run android

# 或手动安装
adb install platforms/android/app/build/outputs/apk/debug/app-debug.apk

# 卸载
adb uninstall com.yiyeguzou.chess
```

### 2. 在模拟器上测试
```bash
# 列出可用的模拟器
emulator -list-avds

# 启动模拟器
emulator -avd <avd_name>

# 运行应用
cordova run android --emulator
```

## APK 优化

### 1. 启用代码混淆和压缩
编辑 `platforms/android/app/build.gradle`：
```gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 2. 生成分包 APK（减小体积）
在 `config.xml` 中添加：
```xml
<preference name="android-build-tool" value="gradle" />
```

### 3. WebView 优化
已在 `config.xml` 中配置：
- 硬件加速
- 本地存储
- 禁用过度滚动

## 发布到 Google Play

### 1. 准备发布材料
- 应用图标（512x512 PNG）
- 功能图片（1024x500 PNG）
- 屏幕截图（至少2张，最多8张）
- 应用描述（简短和完整）
- 隐私政策链接

### 2. 创建应用包 (AAB - 推荐)
```bash
# 构建 Android App Bundle
cordova build android --release -- --packageType=bundle

# 输出位置：
# platforms/android/app/build/outputs/bundle/release/app-release.aab
```

### 3. 上传到 Play Console
1. 访问 https://play.google.com/console
2. 创建应用
3. 上传 AAB 文件
4. 填写商店信息
5. 提交审核

## 常见问题

### Q1: cordova requirements 显示错误
**解决**: 确保所有环境变量正确设置，重启终端/IDE

### Q2: 构建失败 - Gradle 错误
**解决**: 
```bash
cd platforms/android
./gradlew clean
cd ../..
cordova build android
```

### Q3: APK 安装失败
**解决**: 
- 检查设备是否启用"未知来源"
- 卸载旧版本后重新安装
- 检查签名是否正确

### Q4: 应用启动白屏
**解决**:
- 检查 `index.html` 中的资源路径
- 确保所有资源文件都已包含
- 查看 Chrome Remote Debugging 控制台错误

### Q5: 触摸事件不响应
**解决**: 已在代码中实现，确保：
- `config.xml` 中 `DisallowOverscroll` 为 true
- Canvas 设置了 `touch-action: none`

### Q6: 性能优化
**建议**:
- 使用 WebView 硬件加速（已配置）
- 优化图片大小和格式
- 减少 DOM 操作
- 使用 Canvas 离屏渲染

## 自动化构建脚本

创建 `build.sh` (macOS/Linux):
```bash
#!/bin/bash

echo "=== 中国象棋 APK 构建脚本 ==="

# 清理
echo "清理旧构建..."
cordova clean

# 准备
echo "准备环境..."
cordova prepare android

# 构建
echo "构建 APK..."
if [ "$1" == "release" ]; then
    cordova build android --release
    echo "✓ 发布版 APK 构建完成"
    echo "位置: platforms/android/app/build/outputs/apk/release/app-release.apk"
else
    cordova build android --debug
    echo "✓ 调试版 APK 构建完成"
    echo "位置: platforms/android/app/build/outputs/apk/debug/app-debug.apk"
fi

echo "=== 构建完成 ==="
```

使用方法：
```bash
chmod +x build.sh
./build.sh          # 构建调试版
./build.sh release  # 构建发布版
```

Windows 版本 `build.bat`:
```batch
@echo off
echo === 中国象棋 APK 构建脚本 ===

echo 清理旧构建...
call cordova clean

echo 准备环境...
call cordova prepare android

echo 构建 APK...
if "%1"=="release" (
    call cordova build android --release
    echo ✓ 发布版 APK 构建完成
    echo 位置: platforms\android\app\build\outputs\apk\release\app-release.apk
) else (
    call cordova build android --debug
    echo ✓ 调试版 APK 构建完成
    echo 位置: platforms\android\app\build\outputs\apk\debug\app-debug.apk
)

echo === 构建完成 ===
pause
```

## 持续集成（CI/CD）

### GitHub Actions 示例
创建 `.github/workflows/android.yml`:
```yaml
name: Android APK Build

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        
    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'temurin'
        java-version: '11'
        
    - name: Install Cordova
      run: npm install -g cordova
      
    - name: Install dependencies
      run: npm install
      
    - name: Add Android platform
      run: cordova platform add android
      
    - name: Build APK
      run: cordova build android --debug
      
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: app-debug
        path: platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

## 技术支持

- **Cordova 官方文档**: https://cordova.apache.org/docs/
- **Android 开发文档**: https://developer.android.com/
- **问题反馈**: 项目 Issues 页面

## 版本历史

- **v1.6.0** (2026-01-24) - 添加 Cordova APK 打包支持
- **v1.5.1** - 修复BUG
- **v1.5.0** - 大幅度修改UI，增加风格选择

---
**作者**: 一叶孤舟  
**邮箱**: itlwei@163.com  
**QQ**: 28701884
