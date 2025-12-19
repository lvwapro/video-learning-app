import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/mind_map.dart';
import '../../data/repositories/mindmap_repository.dart';

/// 思维导图仓库Provider
final mindMapRepositoryProvider = Provider<MindMapRepository>((ref) {
  return MindMapRepository();
});

/// 所有思维导图列表Provider
final allMindMapsProvider = StreamProvider<List<MindMap>>((ref) {
  final repository = ref.watch(mindMapRepositoryProvider);
  return repository.watchAllMindMaps();
});

/// 收藏思维导图列表Provider
final favoriteMindMapsProvider = FutureProvider<List<MindMap>>((ref) {
  final repository = ref.watch(mindMapRepositoryProvider);
  return repository.getFavoriteMindMaps();
});

/// 单个思维导图Provider
final mindMapProvider = StreamProvider.family<MindMap?, int>((ref, id) {
  final repository = ref.watch(mindMapRepositoryProvider);
  return repository.watchMindMap(id);
});

/// 视频关联的思维导图Provider
final videoMindMapsProvider = FutureProvider.family<List<MindMap>, int>((ref, videoId) {
  final repository = ref.watch(mindMapRepositoryProvider);
  return repository.getMindMapsByVideoId(videoId);
});

/// 当前编辑的思维导图节点Provider
final currentMindMapNodesProvider = StateProvider<List<MindMapNode>>((ref) => []);

/// 当前选中的节点IDProvider
final selectedNodeIdProvider = StateProvider<String?>((ref) => null);

/// 思维导图缩放级别Provider
final mindMapZoomProvider = StateProvider<double>((ref) => 1.0);

/// 思维导图偏移量Provider
final mindMapOffsetProvider = StateProvider<Offset>((ref) => Offset.zero);

class Offset {
  final double dx;
  final double dy;
  
  const Offset(this.dx, this.dy);
  
  static const zero = Offset(0, 0);
  
  Offset operator +(Offset other) => Offset(dx + other.dx, dy + other.dy);
  Offset operator -(Offset other) => Offset(dx - other.dx, dy - other.dy);
  Offset operator *(double operand) => Offset(dx * operand, dy * operand);
}

