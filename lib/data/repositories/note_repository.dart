import 'package:isar/isar.dart';
import '../models/video_note.dart';
import '../datasources/database_service.dart';
import '../../core/utils/logger.dart';

/// 笔记数据仓库
class NoteRepository {
  final DatabaseService _db = DatabaseService.instance;

  /// 获取视频的所有笔记
  Future<List<VideoNote>> getNotesByVideoId(int videoId) async {
    try {
      return await _db.isar.videoNotes
          .filter()
          .videoIdEqualTo(videoId)
          .sortByTimestampInSeconds()
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('获取视频笔记失败: $videoId', e, stackTrace);
      rethrow;
    }
  }

  /// 获取所有笔记
  Future<List<VideoNote>> getAllNotes() async {
    try {
      return await _db.isar.videoNotes
          .where()
          .sortByCreatedAtDesc()
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('获取所有笔记失败', e, stackTrace);
      rethrow;
    }
  }

  /// 根据ID获取笔记
  Future<VideoNote?> getNoteById(int id) async {
    try {
      return await _db.isar.videoNotes.get(id);
    } catch (e, stackTrace) {
      AppLogger.error('获取笔记失败: $id', e, stackTrace);
      rethrow;
    }
  }

  /// 搜索笔记
  Future<List<VideoNote>> searchNotes(String query) async {
    try {
      return await _db.isar.videoNotes
          .filter()
          .userNoteContains(query, caseSensitive: false)
          .or()
          .originalTextContains(query, caseSensitive: false)
          .sortByCreatedAtDesc()
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('搜索笔记失败: $query', e, stackTrace);
      rethrow;
    }
  }

  /// 根据标签获取笔记
  Future<List<VideoNote>> getNotesByTag(String tag) async {
    try {
      return await _db.isar.videoNotes
          .filter()
          .tagsElementContains(tag, caseSensitive: false)
          .sortByCreatedAtDesc()
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('根据标签获取笔记失败: $tag', e, stackTrace);
      rethrow;
    }
  }

  /// 根据类型获取笔记
  Future<List<VideoNote>> getNotesByType(NoteType type) async {
    try {
      return await _db.isar.videoNotes
          .filter()
          .typeEqualTo(type)
          .sortByCreatedAtDesc()
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('根据类型获取笔记失败: $type', e, stackTrace);
      rethrow;
    }
  }

  /// 获取需要复习的笔记
  Future<List<VideoNote>> getNotesForReview() async {
    try {
      final now = DateTime.now();
      return await _db.isar.videoNotes
          .filter()
          .needReviewEqualTo(true)
          .and()
          .nextReviewDateIsNotNull()
          .and()
          .nextReviewDateLessThan(now)
          .sortByNextReviewDate()
          .findAll();
    } catch (e, stackTrace) {
      AppLogger.error('获取复习笔记失败', e, stackTrace);
      rethrow;
    }
  }

  /// 创建笔记
  Future<int> createNote(VideoNote note) async {
    try {
      return await _db.isar.writeTxn(() async {
        return await _db.isar.videoNotes.put(note);
      });
    } catch (e, stackTrace) {
      AppLogger.error('创建笔记失败', e, stackTrace);
      rethrow;
    }
  }

  /// 更新笔记
  Future<void> updateNote(VideoNote note) async {
    try {
      note.updatedAt = DateTime.now();
      await _db.isar.writeTxn(() async {
        await _db.isar.videoNotes.put(note);
      });
    } catch (e, stackTrace) {
      AppLogger.error('更新笔记失败: ${note.id}', e, stackTrace);
      rethrow;
    }
  }

  /// 删除笔记
  Future<void> deleteNote(int id) async {
    try {
      await _db.isar.writeTxn(() async {
        await _db.isar.videoNotes.delete(id);
      });
    } catch (e, stackTrace) {
      AppLogger.error('删除笔记失败: $id', e, stackTrace);
      rethrow;
    }
  }

  /// 批量删除笔记
  Future<void> deleteNotes(List<int> ids) async {
    try {
      await _db.isar.writeTxn(() async {
        await _db.isar.videoNotes.deleteAll(ids);
      });
    } catch (e, stackTrace) {
      AppLogger.error('批量删除笔记失败', e, stackTrace);
      rethrow;
    }
  }

  /// 删除指定视频的所有笔记
  Future<void> deleteNotesByVideoId(int videoId) async {
    try {
      await _db.isar.writeTxn(() async {
        await _db.isar.videoNotes.filter().videoIdEqualTo(videoId).deleteAll();
      });
    } catch (e, stackTrace) {
      AppLogger.error('删除视频笔记失败: $videoId', e, stackTrace);
      rethrow;
    }
  }

  /// 更新复习信息
  Future<void> markAsReviewed(int noteId) async {
    try {
      final note = await getNoteById(noteId);
      if (note != null) {
        note.reviewCount++;
        note.nextReviewDate = _calculateNextReviewDate(note.reviewCount);
        note.updatedAt = DateTime.now();
        await updateNote(note);
      }
    } catch (e, stackTrace) {
      AppLogger.error('标记为已复习失败: $noteId', e, stackTrace);
      rethrow;
    }
  }

  /// 计算下次复习时间（基于间隔重复算法）
  DateTime _calculateNextReviewDate(int reviewCount) {
    final now = DateTime.now();
    final intervals = [1, 3, 7, 14, 30, 60]; // 天数
    final index = reviewCount < intervals.length ? reviewCount : intervals.length - 1;
    return now.add(Duration(days: intervals[index]));
  }

  /// 监听视频笔记变化
  Stream<List<VideoNote>> watchNotesByVideoId(int videoId) {
    return _db.isar.videoNotes
        .filter()
        .videoIdEqualTo(videoId)
        .watch(fireImmediately: true);
  }

  /// 监听所有笔记变化
  Stream<List<VideoNote>> watchAllNotes() {
    return _db.isar.videoNotes.where().watch(fireImmediately: true);
  }
}

