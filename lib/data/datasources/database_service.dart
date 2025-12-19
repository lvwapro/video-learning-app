import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/video.dart';
import '../models/video_note.dart';
import '../models/subtitle.dart';
import '../models/mind_map.dart';
import '../models/chapter.dart';
import '../../core/utils/logger.dart';

/// 数据库服务
class DatabaseService {
  static DatabaseService? _instance;
  static Isar? _isar;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  /// 初始化数据库
  Future<void> initialize() async {
    if (_isar != null) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      
      _isar = await Isar.open(
        [
          VideoSchema,
          VideoNoteSchema,
          SubtitleSchema,
          MindMapSchema,
          ChapterSchema,
        ],
        directory: dir.path,
        name: 'vidnotes_db',
      );

      AppLogger.info('数据库初始化成功');
    } catch (e, stackTrace) {
      AppLogger.error('数据库初始化失败', e, stackTrace);
      rethrow;
    }
  }

  /// 获取Isar实例
  Isar get isar {
    if (_isar == null) {
      throw Exception('数据库未初始化，请先调用initialize()');
    }
    return _isar!;
  }

  /// 关闭数据库
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

  /// 清空所有数据
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
    AppLogger.info('已清空所有数据');
  }

  /// 导出数据库
  Future<void> exportDatabase(String path) async {
    // TODO: 实现数据库导出功能
  }

  /// 导入数据库
  Future<void> importDatabase(String path) async {
    // TODO: 实现数据库导入功能
  }
}

