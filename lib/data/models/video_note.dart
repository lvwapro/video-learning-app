import 'package:isar/isar.dart';

part 'video_note.g.dart';

/// 笔记类型枚举
enum NoteType {
  highlight, // 高亮/重点
  comment,   // 评论/笔记
  question,  // 问题
}

/// 视频笔记模型
@collection
class VideoNote {
  Id id = Isar.autoIncrement;

  /// 关联的视频ID
  @Index()
  late int videoId;

  /// 时间戳（秒）
  late int timestampInSeconds;

  /// 原始字幕文本
  String? originalText;

  /// 用户笔记内容
  String? userNote;

  /// 笔记类型
  @Enumerated(EnumType.name)
  late NoteType type;

  /// 标签列表
  late List<String> tags;

  /// 截图路径
  String? screenshotPath;

  /// 创建时间
  late DateTime createdAt;

  /// 更新时间
  late DateTime updatedAt;

  /// 是否需要复习
  bool needReview = false;

  /// 下次复习时间
  DateTime? nextReviewDate;

  /// 复习次数
  int reviewCount = 0;

  /// 是否已归档
  bool isArchived = false;

  /// 笔记颜色（十六进制字符串，如 "FF4361EE"）
  String? colorHex;

  /// 重要程度（1-5星）
  int importance = 3;

  // 计算属性
  
  /// 获取Duration对象
  @ignore
  Duration get timestamp => Duration(seconds: timestampInSeconds);

  /// 获取格式化的时间戳
  @ignore
  String get formattedTimestamp {
    final duration = Duration(seconds: timestampInSeconds);
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

  /// 获取笔记类型的显示名称
  @ignore
  String get typeDisplayName {
    switch (type) {
      case NoteType.highlight:
        return '重点';
      case NoteType.comment:
        return '笔记';
      case NoteType.question:
        return '问题';
    }
  }
}

