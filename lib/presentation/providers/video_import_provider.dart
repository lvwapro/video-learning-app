import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/video_repository.dart';
import '../../domain/services/video_import_service.dart';
import '../../data/models/video.dart';
import '../../core/utils/logger.dart';
import 'video_providers.dart'; // 导入 videoRepositoryProvider

/// 视频导入服务Provider
final videoImportServiceProvider = Provider<VideoImportService>((ref) {
  final repository = ref.watch(videoRepositoryProvider);
  return VideoImportService(repository);
});

/// 视频导入状态
class VideoImportState {
  final bool isImporting;
  final Video? importedVideo;
  final String? error;

  const VideoImportState({
    this.isImporting = false,
    this.importedVideo,
    this.error,
  });

  VideoImportState copyWith({
    bool? isImporting,
    Video? importedVideo,
    String? error,
  }) {
    return VideoImportState(
      isImporting: isImporting ?? this.isImporting,
      importedVideo: importedVideo ?? this.importedVideo,
      error: error,
    );
  }
}

/// 视频导入控制器
class VideoImportController extends StateNotifier<VideoImportState> {
  final VideoImportService _importService;

  VideoImportController(this._importService)
      : super(const VideoImportState());

  /// 导入单个视频
  Future<Video?> importVideo() async {
    state = state.copyWith(isImporting: true, error: null);
    
    try {
      final video = await _importService.importVideo();
      
      if (video != null) {
        state = state.copyWith(
          isImporting: false,
          importedVideo: video,
        );
        AppLogger.info('视频导入成功: ${video.title}');
        return video;
      } else {
        state = state.copyWith(isImporting: false);
        return null;
      }
    } catch (e, stackTrace) {
      AppLogger.error('导入视频失败', e, stackTrace);
      state = state.copyWith(
        isImporting: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// 导入多个视频
  Future<List<Video>> importMultipleVideos() async {
    state = state.copyWith(isImporting: true, error: null);
    
    try {
      final videos = await _importService.importMultipleVideos();
      state = state.copyWith(isImporting: false);
      return videos;
    } catch (e, stackTrace) {
      AppLogger.error('批量导入视频失败', e, stackTrace);
      state = state.copyWith(
        isImporting: false,
        error: e.toString(),
      );
      return [];
    }
  }

  /// 重置状态
  void reset() {
    state = const VideoImportState();
  }
}

/// 视频导入控制器Provider
final videoImportControllerProvider =
    StateNotifierProvider<VideoImportController, VideoImportState>((ref) {
  final importService = ref.watch(videoImportServiceProvider);
  return VideoImportController(importService);
});

