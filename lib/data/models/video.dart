import 'package:isar/isar.dart';

part 'video.g.dart';

/// 视频模型
@collection
class Video {
  Id id = Isar.autoIncrement;

  /// 视频标题
  @Index()
  late String title;

  /// 视频文件路径
  late String path;

  /// 视频时长（秒）
  late int durationInSeconds;

  /// 视频大小（字节）
  late int sizeInBytes;

  /// 视频格式
  late String format;

  /// 缩略图路径
  String? thumbnailPath;

  /// 视频描述
  String? description;

  /// 字幕路径
  String? subtitlePath;

  /// 创建时间
  late DateTime createdAt;

  /// 最后播放时间
  DateTime? lastPlayedAt;

  /// 播放进度（秒）
  int playbackPosition = 0;

  /// 播放次数
  int playCount = 0;

  /// 是否收藏
  bool isFavorite = false;

  /// 标签
  late List<String> tags;

  /// 类别
  String? category;

  /// 视频来源URL（如果是在线视频）
  String? sourceUrl;

  /// 笔记数量
  int noteCount = 0;

  /// 是否已完成
  bool isCompleted = false;

  /// 完成百分比
  double completionPercent = 0.0;

  // 计算属性
  
  /// 获取Duration对象
  @ignore
  Duration get duration => Duration(seconds: durationInSeconds);

  /// 获取格式化的文件大小
  @ignore
  String get formattedSize {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else if (sizeInBytes < 1024 * 1024 * 1024) {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(sizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// 获取格式化的时长
  @ignore
  String get formattedDuration {
    final duration = Duration(seconds: durationInSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }
}

