import 'package:isar/isar.dart';
import '../models/video.dart';
import '../datasources/database_service.dart';
import '../../core/utils/logger.dart';

/// 视频数据仓库
class VideoRepository {
  final DatabaseService _db = DatabaseService.instance;

  /// 获取所有视频
  Future<List<Video>> getAllVideos() async {
    try {
      return await _db.isar.videos.where().findAll();
    } catch (e, stackTrace) {
      AppLogger.error('获取视频列表失败', e, stackTrace);
      rethrow;
    }
  }

  /// 根据ID获取视频
  Future<Video?> getVideoById(int id) async {
    try {
      return await _db.isar.videos.get(id);
    } catch (e, stackTrace) {
      AppLogger.error('获取视频失败: $id', e, stackTrace);
      rethrow;
    }
  }

  /// 搜索视频
  Future<List<Video>> searchVideos(String query) async {
    try {
      return await _db.isar.videos
          .filter()
          .titleContains(query, caseSensitive: false)
          .or()
          .descriptionContains(query, caseSensitive: false)
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('搜索视频失败: $query', e, stackTrace);
      rethrow;
    }
  }

  /// 根据标签获取视频
  Future<List<Video>> getVideosByTag(String tag) async {
    try {
      return await _db.isar.videos
          .filter()
          .tagsElementContains(tag, caseSensitive: false)
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('根据标签获取视频失败: $tag', e, stackTrace);
      rethrow;
    }
  }

  /// 获取收藏的视频
  Future<List<Video>> getFavoriteVideos() async {
    try {
      return await _db.isar.videos
          .filter()
          .isFavoriteEqualTo(true)
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('获取收藏视频失败', e, stackTrace);
      rethrow;
    }
  }

  /// 创建视频
  Future<int> createVideo(Video video) async {
    try {
      return await _db.isar.writeTxn(() async {
        return await _db.isar.videos.put(video);
      });
    } catch (e, stackTrace) {
      AppLogger.error('创建视频失败', e, stackTrace);
      rethrow;
    }
  }

  /// 更新视频
  Future<void> updateVideo(Video video) async {
    try {
      await _db.isar.writeTxn(() async {
        await _db.isar.videos.put(video);
      });
    } catch (e, stackTrace) {
      AppLogger.error('更新视频失败: ${video.id}', e, stackTrace);
      rethrow;
    }
  }

  /// 删除视频
  Future<void> deleteVideo(int id) async {
    try {
      await _db.isar.writeTxn(() async {
        await _db.isar.videos.delete(id);
      });
    } catch (e, stackTrace) {
      AppLogger.error('删除视频失败: $id', e, stackTrace);
      rethrow;
    }
  }

  /// 更新播放进度
  Future<void> updatePlaybackPosition(int videoId, int position) async {
    try {
      final video = await getVideoById(videoId);
      if (video != null) {
        video.playbackPosition = position;
        video.lastPlayedAt = DateTime.now();
        await updateVideo(video);
      }
    } catch (e, stackTrace) {
      AppLogger.error('更新播放进度失败: $videoId', e, stackTrace);
      rethrow;
    }
  }

  /// 切换收藏状态
  Future<void> toggleFavorite(int videoId) async {
    try {
      final video = await getVideoById(videoId);
      if (video != null) {
        video.isFavorite = !video.isFavorite;
        await updateVideo(video);
      }
    } catch (e, stackTrace) {
      AppLogger.error('切换收藏状态失败: $videoId', e, stackTrace);
      rethrow;
    }
  }

  /// 增加播放次数
  Future<void> incrementPlayCount(int videoId) async {
    try {
      final video = await getVideoById(videoId);
      if (video != null) {
        video.playCount++;
        video.lastPlayedAt = DateTime.now();
        await updateVideo(video);
      }
    } catch (e, stackTrace) {
      AppLogger.error('增加播放次数失败: $videoId', e, stackTrace);
      rethrow;
    }
  }

  /// 监听视频变化
  Stream<List<Video>> watchAllVideos() {
    return _db.isar.videos.where().watch(fireImmediately: true);
  }

  /// 监听单个视频变化
  Stream<Video?> watchVideo(int id) {
    return _db.isar.videos.watchObject(id, fireImmediately: true);
  }
}

