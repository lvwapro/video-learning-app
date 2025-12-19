# iOS 真机调试指南

## 当前状态
✅ Xcode 工作区已打开  
✅ iOS 平台文件已创建  
✅ 权限配置已添加到 Info.plist  
✅ 依赖已安装（暂时移除了 FFmpeg 以避免下载问题）

## 真机调试步骤

### 1. 在 Xcode 中配置签名

Xcode 已经自动识别了您的开发者身份：
- **Developer ID**: "iPhone Developer: 瓦 绿 (5JAX9C6TDC)"

在 Xcode 中：
1. 选择左侧项目导航器中的 **Runner** 项目
2. 选择 **TARGETS** > **Runner**
3. 点击 **Signing & Capabilities** 标签
4. 确保 **Team** 选择了您的开发团队
5. 检查 **Bundle Identifier** 是否唯一（默认：`com.example.vidnotes`）
   - 建议修改为：`com.yourname.vidnotes`

### 2. 连接 iPhone 设备

1. 使用 USB 线缆连接 iPhone 到电脑
2. 在 iPhone 上信任此电脑（首次连接时会弹出提示）
3. 在 Xcode 顶部工具栏的设备选择器中选择你的 iPhone

### 3. 运行应用

#### 方式一：在 Xcode 中运行
1. 在 Xcode 中按 `⌘ + R` 或点击左上角的 ▶️ 按钮
2. 首次运行时，需要在 iPhone 上信任开发者证书：
   - 打开 iPhone **设置** > **通用** > **VPN 与设备管理**
   - 找到您的开发者应用并点击信任

#### 方式二：使用 Flutter 命令（推荐）
```bash
# 列出可用设备
flutter devices

# 运行到指定设备
flutter run -d <device-id>

# 或直接运行（如果只有一个设备会自动选择）
flutter run
```

### 4. 已配置的权限

以下权限已添加到 `ios/Runner/Info.plist`：
- ✅ 相册访问权限（NSPhotoLibraryUsageDescription）
- ✅ 保存到相册权限（NSPhotoLibraryAddUsageDescription）
- ✅ 相机权限（NSCameraUsageDescription）
- ✅ 麦克风权限（NSMicrophoneUsageDescription）
- ✅ 文件共享（UIFileSharingEnabled）

### 5. 常见问题

#### 签名错误
**问题**：Failed to code sign  
**解决**：
1. 确保在 Signing & Capabilities 中选择了正确的 Team
2. 修改 Bundle Identifier 为唯一标识符
3. 清理构建：Xcode 菜单 > Product > Clean Build Folder

#### 信任问题
**问题**：App 无法启动，提示未受信任的开发者  
**解决**：
1. iPhone 设置 > 通用 > VPN 与设备管理
2. 找到你的开发者证书
3. 点击"信任"

#### FFmpeg 相关错误
**状态**：已暂时注释 FFmpeg 依赖  
**原因**：FFmpeg 包下载可能失败（404错误）  
**影响**：字幕提取功能暂不可用，其他功能正常  
**恢复**：如需使用，取消 `pubspec.yaml` 中的注释并重新安装

### 6. 快速命令

```bash
# 清理并重新构建
cd /Users/huangct/Documents/learn/myGithub/my-app/video-learning-app
flutter clean
flutter pub get

# 列出设备
flutter devices

# 运行应用
flutter run

# 构建 iOS（无签名）
flutter build ios --no-codesign

# 查看日志
flutter logs
```

### 7. 性能优化建议

对于真机调试：
1. 使用 **Profile 模式** 测试性能：
   ```bash
   flutter run --profile
   ```

2. 使用 **Release 模式** 测试最终体验：
   ```bash
   flutter run --release
   ```

3. Debug 模式下性能较慢是正常的

### 8. 下一步

真机调试成功后，您可以：
1. ✅ 测试视频播放功能
2. ✅ 测试笔记系统（富文本编辑、时间戳）
3. ✅ 测试思维导图（手势缩放、拖拽）
4. ⏸️ AI 功能需要额外配置 OpenAI API（已暂缓）
5. 📦 准备 App Store 发布

---

## 当前项目状态

### 已完成 ✅
- 基础框架（Riverpod + GoRouter + Isar）
- 视频管理（导入、播放器、字幕）
- 笔记系统（富文本、时间戳、截图）
- 思维导图（自动生成、手动编辑、手势交互）
- Material 3 设计系统（亮色/暗色主题）

### 暂缓 ⏸️
- AI 功能（需要 OpenAI API Key）
- FFmpeg 集成（真机调试时可能有问题）

### 注意事项
- 确保 iPhone 系统版本 >= iOS 13.0
- 首次运行需要信任开发者证书
- 建议使用真机测试性能和手势操作
- 视频文件较大时注意内存占用

---

**提示**：如遇到其他问题，可以查看：
- Flutter 官方文档：https://docs.flutter.dev/deployment/ios
- Xcode 控制台日志
- 终端运行 `flutter doctor` 检查环境


