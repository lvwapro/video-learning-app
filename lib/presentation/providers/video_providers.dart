import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/video.dart';
import '../../data/repositories/video_repository.dart';

/// 视频仓库Provider
final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepository();
});

/// 所有视频列表Provider
final allVideosProvider = StreamProvider<List<Video>>((ref) {
  final repository = ref.watch(videoRepositoryProvider);
  return repository.watchAllVideos();
});

/// 收藏视频列表Provider
final favoriteVideosProvider = FutureProvider<List<Video>>((ref) {
  final repository = ref.watch(videoRepositoryProvider);
  return repository.getFavoriteVideos();
});

/// 单个视频Provider
final videoProvider = StreamProvider.family<Video?, int>((ref, id) {
  final repository = ref.watch(videoRepositoryProvider);
  return repository.watchVideo(id);
});

/// 视频搜索Provider
final videoSearchProvider = FutureProvider.family<List<Video>, String>((ref, query) {
  final repository = ref.watch(videoRepositoryProvider);
  if (query.isEmpty) {
    return repository.getAllVideos();
  }
  return repository.searchVideos(query);
});

/// 当前播放视频ID Provider
final currentPlayingVideoIdProvider = StateProvider<int?>((ref) => null);

