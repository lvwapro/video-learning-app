# 项目设置指南

## 🔧 详细设置步骤

### 1. 生成Isar数据库代码

Isar需要代码生成来创建数据库schema。运行以下命令：

```bash
# 首次运行或模型变更后
flutter pub run build_runner build --delete-conflicting-outputs

# 监听模式（开发时推荐）
flutter pub run build_runner watch --delete-conflicting-outputs
```

这将生成以下文件：
- `lib/data/models/video.g.dart`
- `lib/data/models/video_note.g.dart`
- `lib/data/models/subtitle.g.dart`
- `lib/data/models/mind_map.g.dart`
- `lib/data/models/chapter.g.dart`

### 2. 字体文件配置

#### 下载字体

**Noto Sans SC（中文字体）**
1. 访问 https://fonts.google.com/noto/specimen/Noto+Sans+SC
2. 点击 "Download family"
3. 解压下载的zip文件
4. 复制以下文件到 `assets/fonts/`：
   - `NotoSansSC-Regular.ttf`
   - `NotoSansSC-Bold.ttf`

**Inter（英文字体）**
1. 访问 https://fonts.google.com/specimen/Inter
2. 点击 "Download family"
3. 解压下载的zip文件
4. 从 `static/` 文件夹复制以下文件到 `assets/fonts/`：
   - `Inter-Regular.ttf`
   - `Inter-Bold.ttf`

#### 验证字体文件

确保 `assets/fonts/` 目录结构如下：

```
assets/fonts/
├── NotoSansSC-Regular.ttf
├── NotoSansSC-Bold.ttf
├── Inter-Regular.ttf
└── Inter-Bold.ttf
```

### 3. 平台特定配置

#### iOS配置

**Info.plist 权限**

编辑 `ios/Runner/Info.plist`：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- 现有配置... -->
    
    <!-- 相册访问权限 -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>需要访问相册以保存视频截图和笔记图片</string>
    
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>需要保存截图到相册</string>
    
    <!-- 相机权限（可选） -->
    <key>NSCameraUsageDescription</key>
    <string>需要使用相机拍摄笔记图片</string>
    
    <!-- 麦克风权限（可选） -->
    <key>NSMicrophoneUsageDescription</key>
    <string>需要使用麦克风录制音频笔记</string>
    
    <!-- 文件访问 -->
    <key>UIFileSharingEnabled</key>
    <true/>
    <key>LSSupportsOpeningDocumentsInPlace</key>
    <true/>
</dict>
</plist>
```

**Podfile 配置**

编辑 `ios/Podfile`，确保最低版本：

```ruby
platform :ios, '12.0'
```

#### Android配置

**AndroidManifest.xml 权限**

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- 网络权限 -->
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <!-- 存储权限 -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="28" />
    
    <!-- Android 13+ 媒体权限 -->
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    
    <!-- 相机权限（可选） -->
    <uses-permission android:name="android.permission.CAMERA"/>
    
    <!-- 录音权限（可选） -->
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>

    <application
        android:label="学迹VidNotes"
        android:icon="@mipmap/ic_launcher"
        android:requestLegacyExternalStorage="true">
        <!-- 现有配置... -->
    </application>
</manifest>
```

**build.gradle 配置**

编辑 `android/app/build.gradle`：

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        // ...
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

### 4. 依赖安装验证

运行以下命令验证所有依赖正确安装：

```bash
# 清理
flutter clean

# 重新获取依赖
flutter pub get

# 验证
flutter doctor -v
```

检查输出，确保没有错误。

### 5. 运行项目

```bash
# 检查可用设备
flutter devices

# 运行到特定设备
flutter run -d <device-id>

# 运行到iOS模拟器
flutter run -d iPhone

# 运行到Android模拟器
flutter run -d emulator-5554

# 调试模式
flutter run --debug

# Profile模式（性能分析）
flutter run --profile

# Release模式
flutter run --release
```

### 6. 常见问题

#### 问题1：Build runner失败

```bash
# 删除生成的文件
find . -name "*.g.dart" -delete

# 清理
flutter clean
flutter pub get

# 重新生成
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 问题2：字体未显示

1. 确保字体文件在 `assets/fonts/` 目录
2. 确保 `pubspec.yaml` 中正确声明了字体
3. 运行 `flutter clean && flutter pub get`
4. 重启应用

#### 问题3：iOS权限错误

- 确保 `Info.plist` 中添加了所有必要的权限描述
- 在iOS设备/模拟器的设置中手动授予权限

#### 问题4：Android编译错误

- 确保 `minSdkVersion >= 21`
- 确保 `compileSdkVersion >= 34`
- 更新 Android SDK 和工具

### 7. 开发工具推荐

- **VS Code** + Flutter插件
- **Android Studio** + Flutter插件
- **Xcode**（iOS开发必需）

### 8. 代码格式化

```bash
# 格式化所有代码
flutter format .

# 分析代码质量
flutter analyze

# 运行测试
flutter test
```

### 9. 下一步

完成设置后，你可以：
1. 运行应用查看基础框架
2. 阅读代码了解项目结构
3. 开始开发第二阶段功能（视频管理）
4. 查看 README.md 了解项目详情

## 📞 需要帮助？

如遇到问题，请：
1. 检查 Flutter 版本 (`flutter --version`)
2. 运行 `flutter doctor` 诊断
3. 查看项目 Issues
4. 提交新的 Issue

---

祝开发顺利！🚀

