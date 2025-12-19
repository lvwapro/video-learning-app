import 'package:isar/isar.dart';

part 'subtitle.g.dart';

/// 字幕条目模型
@collection
class Subtitle {
  Id id = Isar.autoIncrement;

  /// 关联的视频ID
  @Index()
  late int videoId;

  /// 字幕序号
  late int index;

  /// 开始时间（秒）
  late int startTimeInSeconds;

  /// 结束时间（秒）
  late int endTimeInSeconds;

  /// 字幕文本
  late String text;

  /// 字幕语言代码 (如: zh-CN, en-US)
  String language = 'zh-CN';

  /// 是否由AI生成
  bool isAIGenerated = false;

  /// 置信度（0-1，AI生成时有效）
  double confidence = 1.0;

  // 计算属性
  
  /// 获取开始时间Duration
  @ignore
  Duration get startTime => Duration(seconds: startTimeInSeconds);

  /// 获取结束时间Duration
  @ignore
  Duration get endTime => Duration(seconds: endTimeInSeconds);

  /// 获取时长
  @ignore
  Duration get duration => Duration(seconds: endTimeInSeconds - startTimeInSeconds);

  /// 格式化开始时间
  @ignore
  String get formattedStartTime {
    final duration = startTime;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final milliseconds = duration.inMilliseconds.remainder(1000);
    
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')},'
        '${milliseconds.toString().padLeft(3, '0')}';
  }

  /// 格式化结束时间
  @ignore
  String get formattedEndTime {
    final duration = endTime;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final milliseconds = duration.inMilliseconds.remainder(1000);
    
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')},'
        '${milliseconds.toString().padLeft(3, '0')}';
  }

  /// 检查给定时间是否在字幕时间范围内
  @ignore
  bool isInRange(Duration time) {
    final seconds = time.inSeconds;
    return seconds >= startTimeInSeconds && seconds <= endTimeInSeconds;
  }
}

