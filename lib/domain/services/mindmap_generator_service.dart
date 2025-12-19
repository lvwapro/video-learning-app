import 'dart:convert';
import 'dart:math';
import '../../data/models/video_note.dart';
import '../../data/models/mind_map.dart';
import '../../core/utils/logger.dart';
import 'package:uuid/uuid.dart';

/// 思维导图生成服务
class MindMapGeneratorService {
  final _uuid = const Uuid();

  /// 从笔记生成思维导图
  Future<MindMap> generateFromNotes({
    required List<VideoNote> notes,
    required String title,
    int? videoId,
  }) async {
    try {
      AppLogger.info('开始从${notes.length}条笔记生成思维导图');

      // 按标签分组笔记
      final notesByTag = _groupNotesByTags(notes);
      
      // 创建根节点
      final rootNode = MindMapNode(
        id: _uuid.v4(),
        title: title,
        colorHex: 'FF4361EE',
        positionX: 400,
        positionY: 300,
        width: 160,
        height: 80,
        nodeType: 'topic',
      );

      final nodes = [rootNode];
      final random = Random();

      // 为每个标签创建主题节点
      int mainTopicIndex = 0;
      for (final entry in notesByTag.entries) {
        final tag = entry.key;
        final tagNotes = entry.value;

        // 计算主题节点位置（环绕根节点）
        final angle = (mainTopicIndex * 2 * pi) / notesByTag.length;
        final radius = 250.0;
        final x = rootNode.positionX + radius * cos(angle);
        final y = rootNode.positionY + radius * sin(angle);

        final mainTopicNode = MindMapNode(
          id: _uuid.v4(),
          title: tag,
          content: '${tagNotes.length}条笔记',
          colorHex: _getColorForIndex(mainTopicIndex),
          positionX: x,
          positionY: y,
          width: 140,
          height: 70,
          parentId: rootNode.id,
          nodeType: 'mainTopic',
        );

        rootNode.childrenIds.add(mainTopicNode.id);
        nodes.add(mainTopicNode);

        // 为每条笔记创建子节点
        for (int i = 0; i < min(tagNotes.length, 5); i++) {
          final note = tagNotes[i];
          final subAngle = angle + (i - 2) * 0.3;
          final subRadius = 180.0;
          final subX = mainTopicNode.positionX + subRadius * cos(subAngle);
          final subY = mainTopicNode.positionY + subRadius * sin(subAngle);

          final subNode = MindMapNode(
            id: _uuid.v4(),
            title: _truncateText(note.userNote ?? note.originalText ?? '笔记', 20),
            content: note.userNote,
            colorHex: mainTopicNode.colorHex,
            positionX: subX,
            positionY: subY,
            width: 120,
            height: 60,
            parentId: mainTopicNode.id,
            videoId: note.videoId,
            timestampInSeconds: note.timestampInSeconds,
            noteId: note.id,
            nodeType: 'subtopic',
          );

          mainTopicNode.childrenIds.add(subNode.id);
          nodes.add(subNode);
        }

        mainTopicIndex++;
      }

      // 创建思维导图对象
      final mindMap = MindMap()
        ..title = title
        ..videoId = videoId
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now()
        ..layoutType = MindMapLayoutType.radial
        ..rootNodeId = rootNode.id
        ..nodesJson = jsonEncode(nodes.map((n) => n.toJson()).toList())
        ..tags = notesByTag.keys.toList()
        ..description = '从${notes.length}条笔记生成';

      AppLogger.info('思维导图生成成功，共${nodes.length}个节点');
      return mindMap;
    } catch (e, stackTrace) {
      AppLogger.error('生成思维导图失败', e, stackTrace);
      rethrow;
    }
  }

  /// 按标签分组笔记
  Map<String, List<VideoNote>> _groupNotesByTags(List<VideoNote> notes) {
    final Map<String, List<VideoNote>> result = {};
    
    for (final note in notes) {
      if (note.tags.isEmpty) {
        result.putIfAbsent('未分类', () => []).add(note);
      } else {
        for (final tag in note.tags) {
          result.putIfAbsent(tag, () => []).add(note);
        }
      }
    }

    return result;
  }

  /// 截断文本
  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// 获取颜色
  String _getColorForIndex(int index) {
    final colors = [
      'FF4361EE',
      'FF3A0CA3',
      'FFF72585',
      'FF06D6A0',
      'FFFFC107',
      'FF4CC9F0',
      'FFFF6B9D',
      'FF9D4EDD',
    ];
    return colors[index % colors.length];
  }

  /// 从文本生成思维导图
  Future<MindMap> generateFromText({
    required String text,
    required String title,
  }) async {
    try {
      // 简单的文本分析：按段落分割
      final paragraphs = text.split('\n\n').where((p) => p.trim().isNotEmpty).toList();
      
      final rootNode = MindMapNode(
        id: _uuid.v4(),
        title: title,
        colorHex: 'FF4361EE',
        positionX: 400,
        positionY: 300,
        width: 160,
        height: 80,
        nodeType: 'topic',
      );

      final nodes = [rootNode];

      for (int i = 0; i < min(paragraphs.length, 6); i++) {
        final angle = (i * 2 * pi) / min(paragraphs.length, 6);
        final radius = 250.0;
        final x = rootNode.positionX + radius * cos(angle);
        final y = rootNode.positionY + radius * sin(angle);

        final node = MindMapNode(
          id: _uuid.v4(),
          title: _truncateText(paragraphs[i], 30),
          content: paragraphs[i],
          colorHex: _getColorForIndex(i),
          positionX: x,
          positionY: y,
          width: 140,
          height: 70,
          parentId: rootNode.id,
          nodeType: 'mainTopic',
        );

        rootNode.childrenIds.add(node.id);
        nodes.add(node);
      }

      final mindMap = MindMap()
        ..title = title
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now()
        ..layoutType = MindMapLayoutType.radial
        ..rootNodeId = rootNode.id
        ..nodesJson = jsonEncode(nodes.map((n) => n.toJson()).toList())
        ..tags = []
        ..description = '从文本生成';

      return mindMap;
    } catch (e, stackTrace) {
      AppLogger.error('从文本生成思维导图失败', e, stackTrace);
      rethrow;
    }
  }

  /// 优化布局
  Future<List<MindMapNode>> optimizeLayout(
    List<MindMapNode> nodes,
    MindMapLayoutType layoutType,
  ) async {
    // TODO: 实现不同的布局算法
    return nodes;
  }
}

