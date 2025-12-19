import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/video_note.dart';
import '../../data/repositories/note_repository.dart';

/// 笔记仓库Provider
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});

/// 所有笔记列表Provider
final allNotesProvider = StreamProvider<List<VideoNote>>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.watchAllNotes();
});

/// 视频笔记列表Provider
final videoNotesProvider = StreamProvider.family<List<VideoNote>, int>((ref, videoId) {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.watchNotesByVideoId(videoId);
});

/// 需要复习的笔记Provider
final reviewNotesProvider = FutureProvider<List<VideoNote>>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getNotesForReview();
});

/// 笔记搜索Provider
final noteSearchProvider = FutureProvider.family<List<VideoNote>, String>((ref, query) {
  final repository = ref.watch(noteRepositoryProvider);
  if (query.isEmpty) {
    return repository.getAllNotes();
  }
  return repository.searchNotes(query);
});

/// 按类型筛选笔记Provider
final notesByTypeProvider = FutureProvider.family<List<VideoNote>, NoteType>((ref, type) {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getNotesByType(type);
});

/// 当前选中的笔记ID Provider
final selectedNoteIdProvider = StateProvider<int?>((ref) => null);

/// 笔记排序方式
enum NoteSortOrder {
  createdDesc,     // 创建时间降序
  createdAsc,      // 创建时间升序
  timestampDesc,   // 时间戳降序
  timestampAsc,    // 时间戳升序
  importanceDesc,  // 重要程度降序
}

/// 笔记排序Provider
final noteSortOrderProvider = StateProvider<NoteSortOrder>(
  (ref) => NoteSortOrder.createdDesc,
);
