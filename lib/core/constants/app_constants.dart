/// 应用常量定义
class AppConstants {
  AppConstants._();

  // 应用信息
  static const String appName = '学迹VidNotes';
  static const String appVersion = '1.0.0';
  
  // 数据库
  static const String databaseName = 'vidnotes_db';
  
  // 文件路径
  static const String videosPath = 'videos';
  static const String screenshotsPath = 'screenshots';
  static const String exportsPath = 'exports';
  
  // 视频配置
  static const int maxVideoSizeMB = 500;
  static const List<String> supportedVideoFormats = [
    'mp4',
    'mov',
    'avi',
    'mkv',
    'flv',
    'wmv',
  ];
  
  // 播放速度选项
  static const List<double> playbackSpeeds = [
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0,
  ];
  
  // 笔记类型
  static const String noteTypeHighlight = 'highlight';
  static const String noteTypeComment = 'comment';
  static const String noteTypeQuestion = 'question';
  
  // 思维导图
  static const int maxMindMapNodes = 100;
  static const double mindMapDefaultZoom = 1.0;
  static const double mindMapMinZoom = 0.5;
  static const double mindMapMaxZoom = 3.0;
  
  // AI配置
  static const int aiMaxTokens = 4000;
  static const double aiTemperature = 0.7;
  
  // 缓存
  static const int imageCacheMaxAge = 7; // days
  static const int videoCacheMaxSize = 1024; // MB
  
  // 分页
  static const int defaultPageSize = 20;
  static const int notesPageSize = 50;
}

