import 'package:isar/isar.dart';

part 'mind_map.g.dart';

/// 思维导图布局类型
enum MindMapLayoutType {
  tree,      // 树状
  radial,    // 放射状
  horizontal, // 水平
  vertical,  // 垂直
}

/// 思维导图模型
@collection
class MindMap {
  Id id = Isar.autoIncrement;

  /// 导图标题
  @Index()
  late String title;

  /// 关联的视频ID
  int? videoId;

  /// 创建时间
  late DateTime createdAt;

  /// 更新时间
  late DateTime updatedAt;

  /// 布局类型
  @Enumerated(EnumType.name)
  MindMapLayoutType layoutType = MindMapLayoutType.tree;

  /// 根节点ID
  String? rootNodeId;

  /// 节点数据（JSON格式存储）
  late String nodesJson;

  /// 导图描述
  String? description;

  /// 标签
  late List<String> tags;

  /// 是否公开分享
  bool isPublic = false;

  /// 是否收藏
  bool isFavorite = false;

  /// 主题配色（颜色十六进制列表，JSON格式）
  String? themeColorsJson;

  /// 缩略图路径
  String? thumbnailPath;

  /// 导出次数
  int exportCount = 0;

  /// 最后导出时间
  DateTime? lastExportedAt;
}

/// 思维导图节点（用于内存操作，不存储到数据库）
class MindMapNode {
  String id;
  String title;
  String? content;
  String colorHex;
  double positionX;
  double positionY;
  double width;
  double height;
  List<String> childrenIds;
  String? parentId;
  
  // 关联数据
  int? videoId;
  int? timestampInSeconds;
  int? noteId;
  
  // 样式
  String nodeType; // topic, mainTopic, subtopic
  bool isCollapsed;

  MindMapNode({
    required this.id,
    required this.title,
    this.content,
    this.colorHex = 'FF4361EE',
    this.positionX = 0,
    this.positionY = 0,
    this.width = 120,
    this.height = 60,
    List<String>? childrenIds,
    this.parentId,
    this.videoId,
    this.timestampInSeconds,
    this.noteId,
    this.nodeType = 'subtopic',
    this.isCollapsed = false,
  }) : childrenIds = childrenIds ?? [];

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'colorHex': colorHex,
      'positionX': positionX,
      'positionY': positionY,
      'width': width,
      'height': height,
      'childrenIds': childrenIds,
      'parentId': parentId,
      'videoId': videoId,
      'timestampInSeconds': timestampInSeconds,
      'noteId': noteId,
      'nodeType': nodeType,
      'isCollapsed': isCollapsed,
    };
  }

  /// 从JSON创建
  factory MindMapNode.fromJson(Map<String, dynamic> json) {
    return MindMapNode(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String?,
      colorHex: json['colorHex'] as String? ?? 'FF4361EE',
      positionX: (json['positionX'] as num?)?.toDouble() ?? 0,
      positionY: (json['positionY'] as num?)?.toDouble() ?? 0,
      width: (json['width'] as num?)?.toDouble() ?? 120,
      height: (json['height'] as num?)?.toDouble() ?? 60,
      childrenIds: (json['childrenIds'] as List?)?.cast<String>() ?? [],
      parentId: json['parentId'] as String?,
      videoId: json['videoId'] as int?,
      timestampInSeconds: json['timestampInSeconds'] as int?,
      noteId: json['noteId'] as int?,
      nodeType: json['nodeType'] as String? ?? 'subtopic',
      isCollapsed: json['isCollapsed'] as bool? ?? false,
    );
  }

  /// 复制节点
  MindMapNode copyWith({
    String? id,
    String? title,
    String? content,
    String? colorHex,
    double? positionX,
    double? positionY,
    double? width,
    double? height,
    List<String>? childrenIds,
    String? parentId,
    int? videoId,
    int? timestampInSeconds,
    int? noteId,
    String? nodeType,
    bool? isCollapsed,
  }) {
    return MindMapNode(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      colorHex: colorHex ?? this.colorHex,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      width: width ?? this.width,
      height: height ?? this.height,
      childrenIds: childrenIds ?? this.childrenIds,
      parentId: parentId ?? this.parentId,
      videoId: videoId ?? this.videoId,
      timestampInSeconds: timestampInSeconds ?? this.timestampInSeconds,
      noteId: noteId ?? this.noteId,
      nodeType: nodeType ?? this.nodeType,
      isCollapsed: isCollapsed ?? this.isCollapsed,
    );
  }
}

