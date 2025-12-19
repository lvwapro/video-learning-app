# 学迹VidNotes - 视频学习笔记应用

<div align="center">
  <h3>📚 从视频中提取知识，创建笔记和思维导图</h3>
  <p>专为考研/考公/语言学习等场景设计的智能视频学习工具</p>
</div>

---

## 📋 项目概述

学迹VidNotes 是一款功能强大的视频学习笔记应用，帮助用户从视频内容中提取知识、做笔记、生成思维导图。支持iOS、Android、Web和桌面端。

### ✨ 核心功能

- 📹 **视频管理** - 导入本地视频，支持多种格式
- 🎬 **智能播放器** - 自定义播放控制、AB循环、速度调节
- 📝 **时间戳笔记** - 在播放时添加笔记，支持截图标注
- 🧠 **思维导图** - 自动或手动创建知识结构图
- 🤖 **AI辅助** - 智能总结、关键点提取、问题生成
- 🔍 **全文搜索** - 快速查找笔记和视频内容
- 📊 **学习统计** - 追踪学习进度和时间
- 🌓 **深色模式** - 支持亮色/暗色主题切换

## 🛠 技术栈

### 前端
- **Flutter 3.0+** - 跨平台UI框架
- **Riverpod 2.0** - 状态管理
- **GoRouter** - 路由导航
- **Material 3** - 现代化UI设计

### 数据层
- **Isar** - 高性能本地数据库
- **Path Provider** - 文件路径管理
- **File Picker** - 文件选择

### 视频处理
- **video_player** - 视频播放
- **FFmpeg** - 视频处理和字幕提取
- **chewie** - 增强的视频播放器UI

### AI集成
- **OpenAI API** - GPT模型集成
- **本地模型** - 离线AI处理（可选）

## 📁 项目结构

```
lib/
├── core/                  # 核心模块
│   ├── constants/        # 常量定义
│   │   ├── app_constants.dart
│   │   └── app_colors.dart
│   ├── theme/            # 主题配置
│   │   └── app_theme.dart
│   ├── router/           # 路由配置
│   │   └── app_router.dart
│   ├── extensions/       # 扩展方法
│   │   ├── duration_extensions.dart
│   │   ├── datetime_extensions.dart
│   │   └── string_extensions.dart
│   └── utils/            # 工具类
│       └── logger.dart
│
├── data/                  # 数据层
│   ├── models/           # 数据模型
│   │   ├── video.dart
│   │   ├── video_note.dart
│   │   ├── subtitle.dart
│   │   ├── mind_map.dart
│   │   └── chapter.dart
│   ├── repositories/     # 数据仓库
│   │   ├── video_repository.dart
│   │   └── note_repository.dart
│   └── datasources/      # 数据源
│       └── database_service.dart
│
├── presentation/         # 表现层
│   ├── pages/           # 页面
│   │   ├── splash_page.dart
│   │   ├── home_page.dart
│   │   ├── video_list_page.dart
│   │   ├── video_player_page.dart
│   │   ├── notes_page.dart
│   │   ├── mindmap_page.dart
│   │   └── settings_page.dart
│   ├── widgets/         # 通用组件
│   └── providers/       # 状态管理
│       ├── theme_provider.dart
│       ├── video_providers.dart
│       └── note_providers.dart
│
└── main.dart            # 应用入口
```

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- iOS 12.0+ / Android 5.0+

### 安装步骤

1. **克隆项目**
```bash
git clone <repository-url>
cd video-learning-app
```

2. **安装依赖**
```bash
flutter pub get
```

3. **生成代码**
```bash
# 生成Isar数据库模型代码
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **下载字体文件**

将以下字体文件放置到 `assets/fonts/` 目录：
- `NotoSansSC-Regular.ttf`
- `NotoSansSC-Bold.ttf`
- `Inter-Regular.ttf`
- `Inter-Bold.ttf`

字体下载：
- [Noto Sans SC](https://fonts.google.com/noto/specimen/Noto+Sans+SC)
- [Inter](https://fonts.google.com/specimen/Inter)

5. **运行应用**
```bash
# 开发模式
flutter run

# 构建Release版本
flutter build apk --release  # Android
flutter build ios --release  # iOS
flutter build web --release  # Web
```

## 📱 平台配置

### iOS配置

编辑 `ios/Runner/Info.plist`，添加必要权限：

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册以保存截图</string>
<key>NSCameraUsageDescription</key>
<string>需要使用相机拍摄笔记</string>
<key>NSMicrophoneUsageDescription</key>
<string>需要使用麦克风录制音频笔记</string>
```

### Android配置

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

## 🎯 开发路线图

### ✅ 第一阶段：基础框架（已完成）
- [x] 项目初始化
- [x] 主题系统（亮色/暗色）
- [x] 路由配置
- [x] 状态管理
- [x] 数据库设计

### ✅ 第二阶段：视频管理（已完成）
- [x] 视频导入功能
- [x] 视频播放器组件
- [x] 播放控制（播放/暂停/进度/速度）
- [x] 播放进度保存
- [x] 视频元数据管理

### ✅ 第三阶段：笔记系统（已完成）
- [x] 时间戳笔记功能
- [x] 笔记CRUD操作
- [x] 笔记卡片组件
- [x] 笔记搜索和筛选（预留）
- [x] 标签管理

### ⏸️ 第四阶段：AI功能（暂缓）
- [ ] OpenAI API集成
- [ ] 视频内容智能总结
- [ ] 关键点自动提取
- [ ] 问题生成
- [ ] 智能标签推荐

### ✅ 第五阶段：思维导图（已完成）⭐ NEW!
- [x] 思维导图渲染引擎（CustomPaint）
- [x] 节点编辑功能（增删改）
- [x] 从笔记生成导图
- [x] 放射状布局算法
- [x] 缩放和平移交互
- [x] 智能配色系统
- [ ] 导出为图片/PDF（预留）

### 🎨 第六阶段：增强功能
- [ ] 数据同步（云端）
- [ ] 社区功能
- [ ] 浏览器插件
- [ ] 团队协作
- [ ] 机构版功能

## 🧪 测试

```bash
# 运行单元测试
flutter test

# 运行集成测试
flutter test integration_test

# 代码覆盖率
flutter test --coverage
```

## 📝 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📖 详细文档

- [README.md](README.md) - 项目概述（本文档）
- [SETUP.md](SETUP.md) - 详细环境配置指南
- [QUICK_START.md](QUICK_START.md) - 5分钟快速开始
- [PROGRESS.md](PROGRESS.md) - 开发进度追踪
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - 项目总结报告
- [MINDMAP_GUIDE.md](MINDMAP_GUIDE.md) - 思维导图使用指南 ⭐ NEW!
- [FINAL_REPORT.md](FINAL_REPORT.md) - 最终完成报告 ⭐ NEW!

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 👥 联系方式

- 项目主页: [GitHub Repository]
- 问题反馈: [GitHub Issues]
- 邮箱: your-email@example.com

## 🙏 致谢

- Flutter团队提供的优秀框架
- 所有开源依赖包的作者
- 社区贡献者

---

<div align="center">
  <p>用 ❤️ 构建 | © 2025 学迹VidNotes</p>
</div>

