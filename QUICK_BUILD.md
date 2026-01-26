# 中国象棋 - 快速打包指南

## 最快速打包方法（已有环境）

### 1. 一键安装依赖
```bash
# 安装 Node.js 依赖
npm install

# 全局安装 Cordova
npm install -g cordova
```

### 2. 添加 Android 平台
```bash
cordova platform add android
```

### 3. 准备图标（简易方法）

**在线生成工具**（推荐，最简单）：
1. 访问 https://icon.kitchen/
2. 上传你的图标（建议 1024x1024 PNG）
3. 选择 "Cordova/PhoneGap"
4. 下载并解压到项目根目录
5. 或手动将图标放入 `res/icon/android/` 目录

**必需的图标文件**（如果手动准备）：
```
res/icon/android/
  ├── ldpi.png (36x36)
  ├── mdpi.png (48x48)
  ├── hdpi.png (72x72)
  ├── xhdpi.png (96x96)
  ├── xxhdpi.png (144x144)
  └── xxxhdpi.png (192x192)
```

### 4. 构建 APK

**调试版（用于测试）**：
```bash
cordova build android --debug
```
输出: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`

**发布版（用于发布）**：

先创建签名密钥：
```bash
keytool -genkey -v -keystore chess-release.keystore \
  -alias chess -keyalg RSA -keysize 2048 -validity 10000
```

创建 `build.json`:
```json
{
  "android": {
    "release": {
      "keystore": "chess-release.keystore",
      "storePassword": "你的密码",
      "alias": "chess",
      "password": "你的密码"
    }
  }
}
```

构建发布版：
```bash
cordova build android --release
```
输出: `platforms/android/app/build/outputs/apk/release/app-release.apk`

### 5. 安装到设备
```bash
# USB 连接设备并启用调试模式
adb install platforms/android/app/build/outputs/apk/debug/app-debug.apk

# 或直接运行
cordova run android
```

## 环境要求（必须）

| 工具 | 版本 | 检查命令 |
|------|------|---------|
| Node.js | >= 14.x | `node --version` |
| npm | >= 6.x | `npm --version` |
| Java JDK | >= 11 | `java -version` |
| Android SDK | API 22+ | `sdkmanager --list` |
| Cordova | >= 12.x | `cordova --version` |

### 环境变量设置

**必须设置的环境变量**：
```bash
# Java
export JAVA_HOME=/path/to/jdk

# Android SDK
export ANDROID_HOME=/path/to/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

## 常见问题快速解决

### ❌ "cordova: command not found"
```bash
npm install -g cordova
```

### ❌ "Requirements check failed"
```bash
# 检查环境
cordova requirements

# 按提示安装缺失组件
```

### ❌ 构建失败 - Gradle 错误
```bash
cd platforms/android
./gradlew clean
cd ../..
cordova clean
cordova build android
```

### ❌ 图标未生成
手动创建 `res/icon/android/` 目录并放入图标，或使用在线工具

### ❌ APK 无法安装
- 卸载设备上的旧版本
- 检查是否启用"未知来源"安装
- 检查签名是否正确

## NPM 脚本快捷命令

```bash
npm run build:android:debug   # 构建调试版
npm run build:android          # 构建发布版
npm run dev                    # 运行到设备
npm run clean                  # 清理
```

## 项目结构
```
Chess/
├── config.xml          # Cordova 配置
├── package.json        # Node.js 配置
├── index.html          # 主入口
├── js/                 # 游戏逻辑
├── css/                # 样式
├── img/                # 图片资源
├── audio/              # 音频文件
├── res/                # 应用资源
│   ├── icon/          # 图标
│   └── screen/        # 启动画面
└── platforms/          # 平台代码（自动生成）
    └── android/
```

## 完整文档

详细说明请查看：
- **[BUILD_APK.md](BUILD_APK.md)** - 完整打包指南
- **[MOBILE_ADAPTATION.md](MOBILE_ADAPTATION.md)** - 移动端适配说明

## 技术支持

- 作者：一叶孤舟
- 邮箱：itlwei@163.com
- QQ：28701884
- 文档：https://cordova.apache.org/docs/

---

**提示**: 首次构建可能需要下载依赖，请耐心等待。
