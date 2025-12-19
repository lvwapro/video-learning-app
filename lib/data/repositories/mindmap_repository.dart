import 'package:isar/isar.dart';
import '../models/mind_map.dart';
import '../datasources/database_service.dart';
import '../../core/utils/logger.dart';

/// 思维导图数据仓库
class MindMapRepository {
  final DatabaseService _db = DatabaseService.instance;

  /// 获取所有思维导图
  Future<List<MindMap>> getAllMindMaps() async {
    try {
      return await _db.isar.mindMaps.where().findAll();
    } catch (e, stackTrace) {
      AppLogger.error('获取思维导图列表失败', e, stackTrace);
      rethrow;
    }
  }

  /// 根据ID获取思维导图
  Future<MindMap?> getMindMapById(int id) async {
    try {
      return await _db.isar.mindMaps.get(id);
    } catch (e, stackTrace) {
      AppLogger.error('获取思维导图失败: $id', e, stackTrace);
      rethrow;
    }
  }

  /// 根据视频ID获取思维导图
  Future<List<MindMap>> getMindMapsByVideoId(int videoId) async {
    try {
      return await _db.isar.mindMaps
          .filter()
          .videoIdEqualTo(videoId)
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('根据视频获取思维导图失败: $videoId', e, stackTrace);
      rethrow;
    }
  }

  /// 搜索思维导图
  Future<List<MindMap>> searchMindMaps(String query) async {
    try {
      return await _db.isar.mindMaps
          .filter()
          .titleContains(query, caseSensitive: false)
          .or()
          .descriptionContains(query, caseSensitive: false)
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('搜索思维导图失败: $query', e, stackTrace);
      rethrow;
    }
  }

  /// 获取收藏的思维导图
  Future<List<MindMap>> getFavoriteMindMaps() async {
    try {
      return await _db.isar.mindMaps
          .filter()
          .isFavoriteEqualTo(true)
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('获取收藏思维导图失败', e, stackTrace);
      rethrow;
    }
  }

  /// 创建思维导图
  Future<int> createMindMap(MindMap mindMap) async {
    try {
      return await _db.isar.writeTxn(() async {
        return await _db.isar.mindMaps.put(mindMap);
      });
    } catch (e, stackTrace) {
      AppLogger.error('创建思维导图失败', e, stackTrace);
      rethrow;
    }
  }

  /// 更新思维导图
  Future<void> updateMindMap(MindMap mindMap) async {
    try {
      mindMap.updatedAt = DateTime.now();
      await _db.isar.writeTxn(() async {
        await _db.isar.mindMaps.put(mindMap);
      });
    } catch (e, stackTrace) {
      AppLogger.error('更新思维导图失败: ${mindMap.id}', e, stackTrace);
      rethrow;
    }
  }

  /// 删除思维导图
  Future<void> deleteMindMap(int id) async {
    try {
      await _db.isar.writeTxn(() async {
        await _db.isar.mindMaps.delete(id);
      });
    } catch (e, stackTrace) {
      AppLogger.error('删除思维导图失败: $id', e, stackTrace);
      rethrow;
    }
  }

  /// 切换收藏状态
  Future<void> toggleFavorite(int mindMapId) async {
    try {
      final mindMap = await getMindMapById(mindMapId);
      if (mindMap != null) {
        mindMap.isFavorite = !mindMap.isFavorite;
        await updateMindMap(mindMap);
      }
    } catch (e, stackTrace) {
      AppLogger.error('切换收藏状态失败: $mindMapId', e, stackTrace);
      rethrow;
    }
  }

  /// 监听思维导图变化
  Stream<List<MindMap>> watchAllMindMaps() {
    return _db.isar.mindMaps.where().watch(fireImmediately: true);
  }

  /// 监听单个思维导图变化
  Stream<MindMap?> watchMindMap(int id) {
    return _db.isar.mindMaps.watchObject(id, fireImmediately: true);
  }
}

