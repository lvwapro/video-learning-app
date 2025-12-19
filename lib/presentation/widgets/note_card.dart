import 'package:flutter/material.dart';
import '../../data/models/video_note.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/datetime_extensions.dart';

/// 笔记卡片组件
class NoteCard extends StatelessWidget {
  final VideoNote note;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool showVideoThumbnail;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isSelected = false,
    this.showVideoThumbnail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 0,
      color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 笔记类型和时间戳
              Row(
                children: [
                  _buildTypeIcon(),
                  const SizedBox(width: 8),
                  Text(
                    note.formattedTimestamp,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  // 重要程度星标
                  if (note.importance > 3)
                    Row(
                      children: List.generate(
                        note.importance - 3,
                        (index) => Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  // 操作菜单
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, size: 18),
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        PopupMenuItem(
                          onTap: onEdit,
                          child: const Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('编辑'),
                            ],
                          ),
                        ),
                      if (onDelete != null)
                        PopupMenuItem(
                          onTap: onDelete,
                          child: const Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('删除', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 笔记内容
              if (note.userNote != null && note.userNote!.isNotEmpty) ...[
                Text(
                  note.userNote!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // 原始字幕文本
              if (note.originalText != null && note.originalText!.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    note.originalText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // 截图预览
              if (note.screenshotPath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    note.screenshotPath!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // 标签
              if (note.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: note.tags.take(3).map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 11),
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),

              // 创建时间
              const SizedBox(height: 4),
              Text(
                note.createdAt.toFriendlyFormat(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData icon;
    Color color;

    switch (note.type) {
      case NoteType.highlight:
        icon = Icons.highlight;
        color = AppColors.noteHighlight;
        break;
      case NoteType.comment:
        icon = Icons.comment;
        color = AppColors.noteComment;
        break;
      case NoteType.question:
        icon = Icons.help_outline;
        color = AppColors.noteQuestion;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}

