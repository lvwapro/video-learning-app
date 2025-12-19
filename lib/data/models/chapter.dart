import 'package:isar/isar.dart';

part 'chapter.g.dart';

/// 视频章节模型
@collection
class Chapter {
  Id id = Isar.autoIncrement;

  /// 关联的视频ID
  @Index()
  late int videoId;

  /// 章节标题
  late String title;

  /// 章节描述
  String? description;

  /// 开始时间（秒）
  late int startTimeInSeconds;

  /// 结束时间（秒）
  late int endTimeInSeconds;

  /// 章节序号
  late int order;

  /// 是否由AI生成
  bool isAIGenerated = false;

  /// 章节标签
  late List<String> tags;

  /// 缩略图路径
  String? thumbnailPath;

  /// 创建时间
  late DateTime createdAt;

  // 计算属性
  
  /// 获取开始时间Duration
  @ignore
  Duration get startTime => Duration(seconds: startTimeInSeconds);

  /// 获取结束时间Duration
  @ignore
  Duration get endTime => Duration(seconds: endTimeInSeconds);

  /// 获取章节时长
  @ignore
  Duration get duration => Duration(seconds: endTimeInSeconds - startTimeInSeconds);

  /// 格式化开始时间
  @ignore
  String get formattedStartTime {
    final duration = startTime;
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

  /// 格式化时长
  @ignore
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '$hours小时${minutes}分钟';
    } else {
      return '$minutes分钟';
    }
  }
}

