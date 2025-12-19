import 'package:flutter/material.dart';
import '../../data/models/mind_map.dart';
import '../../core/constants/app_colors.dart';
import 'dart:math' as math;

/// 思维导图画布组件
class MindMapCanvas extends StatefulWidget {
  final List<MindMapNode> nodes;
  final String? selectedNodeId;
  final ValueChanged<String>? onNodeTap;
  final ValueChanged<String>? onNodeLongPress;
  final ValueChanged<MindMapNode>? onNodeMoved;

  const MindMapCanvas({
    super.key,
    required this.nodes,
    this.selectedNodeId,
    this.onNodeTap,
    this.onNodeLongPress,
    this.onNodeMoved,
  });

  @override
  State<MindMapCanvas> createState() => _MindMapCanvasState();
}

class _MindMapCanvasState extends State<MindMapCanvas> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset _lastFocalPoint = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _lastFocalPoint = details.focalPoint;
      },
      onScaleUpdate: (details) {
        setState(() {
          // 缩放
          _scale = (_scale * details.scale).clamp(0.5, 3.0);
          
          // 平移
          final delta = details.focalPoint - _lastFocalPoint;
          _offset += delta;
          _lastFocalPoint = details.focalPoint;
        });
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomPaint(
          painter: MindMapPainter(
            nodes: widget.nodes,
            selectedNodeId: widget.selectedNodeId,
            scale: _scale,
            offset: _offset,
          ),
          child: Stack(
            children: widget.nodes.map((node) {
              return _buildNode(node);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNode(MindMapNode node) {
    final isSelected = node.id == widget.selectedNodeId;
    final position = Offset(node.positionX, node.positionY);
    final transformedPosition = (position * _scale) + _offset;

    return Positioned(
      left: transformedPosition.dx - (node.width * _scale / 2),
      top: transformedPosition.dy - (node.height * _scale / 2),
      child: GestureDetector(
        onTap: () => widget.onNodeTap?.call(node.id),
        onLongPress: () => widget.onNodeLongPress?.call(node.id),
        child: Transform.scale(
          scale: _scale,
          child: Container(
            width: node.width,
            height: node.height,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(int.parse('0x${node.colorHex}')).withOpacity(0.9),
              borderRadius: BorderRadius.circular(
                node.nodeType == 'topic' ? 20 : 12,
              ),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                node.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: node.nodeType == 'topic'
                      ? 16
                      : node.nodeType == 'mainTopic'
                          ? 14
                          : 12,
                  fontWeight: node.nodeType == 'topic'
                      ? FontWeight.w700
                      : FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 思维导图绘制器
class MindMapPainter extends CustomPainter {
  final List<MindMapNode> nodes;
  final String? selectedNodeId;
  final double scale;
  final Offset offset;

  MindMapPainter({
    required this.nodes,
    this.selectedNodeId,
    required this.scale,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 绘制连接线
    for (final node in nodes) {
      if (node.parentId != null) {
        final parent = nodes.firstWhere(
          (n) => n.id == node.parentId,
          orElse: () => node,
        );

        final startPos = Offset(parent.positionX, parent.positionY);
        final endPos = Offset(node.positionX, node.positionY);

        final transformedStart = (startPos * scale) + offset;
        final transformedEnd = (endPos * scale) + offset;

        // 绘制贝塞尔曲线
        final path = Path();
        path.moveTo(transformedStart.dx, transformedStart.dy);

        final controlPoint1 = Offset(
          transformedStart.dx + (transformedEnd.dx - transformedStart.dx) / 2,
          transformedStart.dy,
        );
        final controlPoint2 = Offset(
          transformedStart.dx + (transformedEnd.dx - transformedStart.dx) / 2,
          transformedEnd.dy,
        );

        path.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          transformedEnd.dx,
          transformedEnd.dy,
        );

        canvas.drawPath(path, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(MindMapPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.selectedNodeId != selectedNodeId ||
        oldDelegate.scale != scale ||
        oldDelegate.offset != offset;
  }
}

