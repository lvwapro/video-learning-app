import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/video_note.dart';
import '../../data/repositories/note_repository.dart';
import '../../core/constants/app_colors.dart';
import '../providers/note_providers.dart'; // 导入 noteRepositoryProvider

/// 笔记编辑器对话框
class NoteEditorDialog extends ConsumerStatefulWidget {
  final int videoId;
  final Duration timestamp;
  final String? initialText;
  final VideoNote? existingNote;

  const NoteEditorDialog({
    super.key,
    required this.videoId,
    required this.timestamp,
    this.initialText,
    this.existingNote,
  });

  @override
  ConsumerState<NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends ConsumerState<NoteEditorDialog> {
  late TextEditingController _noteController;
  late NoteType _selectedType;
  late int _importance;
  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();
  bool _needReview = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(
      text: widget.existingNote?.userNote ?? '',
    );
    _selectedType = widget.existingNote?.type ?? NoteType.comment;
    _importance = widget.existingNote?.importance ?? 3;
    if (widget.existingNote != null) {
      _tags.addAll(widget.existingNote!.tags);
      _needReview = widget.existingNote!.needReview;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Row(
                children: [
                  Text(
                    widget.existingNote == null ? '添加笔记' : '编辑笔记',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 时间戳显示
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '时间: ${_formatDuration(widget.timestamp)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 原始字幕文本（如果有）
              if (widget.initialText != null && widget.initialText!.isNotEmpty) ...[
                Text(
                  '字幕内容',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.initialText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 笔记类型选择
              Text(
                '笔记类型',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<NoteType>(
                segments: const [
                  ButtonSegment(
                    value: NoteType.highlight,
                    icon: Icon(Icons.highlight, size: 18),
                    label: Text('重点'),
                  ),
                  ButtonSegment(
                    value: NoteType.comment,
                    icon: Icon(Icons.comment, size: 18),
                    label: Text('笔记'),
                  ),
                  ButtonSegment(
                    value: NoteType.question,
                    icon: Icon(Icons.help_outline, size: 18),
                    label: Text('问题'),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (Set<NoteType> newSelection) {
                  setState(() => _selectedType = newSelection.first);
                },
              ),
              const SizedBox(height: 16),

              // 笔记内容输入
              Text(
                '笔记内容',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: '输入你的笔记...',
                ),
              ),
              const SizedBox(height: 16),

              // 重要程度
              Row(
                children: [
                  Text(
                    '重要程度',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Slider(
                      value: _importance.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _importance.toString(),
                      onChanged: (value) {
                        setState(() => _importance = value.toInt());
                      },
                    ),
                  ),
                  Row(
                    children: List.generate(
                      _importance,
                      (index) => const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 标签
              Text(
                '标签',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._tags.map((tag) => Chip(
                        label: Text(tag),
                        onDeleted: () {
                          setState(() => _tags.remove(tag));
                        },
                      )),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16),
                    label: const Text('添加标签'),
                    onPressed: _showAddTagDialog,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 需要复习开关
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('需要复习'),
                subtitle: const Text('将此笔记加入复习计划'),
                value: _needReview,
                onChanged: (value) {
                  setState(() => _needReview = value);
                },
              ),
              const SizedBox(height: 20),

              // 保存按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveNote,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTagDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加标签'),
        content: TextField(
          controller: _tagController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '输入标签名称',
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty && !_tags.contains(value)) {
              setState(() => _tags.add(value));
              _tagController.clear();
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _tagController.clear();
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (_tagController.text.isNotEmpty &&
                  !_tags.contains(_tagController.text)) {
                setState(() => _tags.add(_tagController.text));
                _tagController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveNote() async {
    if (_noteController.text.isEmpty && widget.initialText == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入笔记内容')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(noteRepositoryProvider);

      if (widget.existingNote != null) {
        // 更新现有笔记
        final note = widget.existingNote!
          ..userNote = _noteController.text
          ..type = _selectedType
          ..importance = _importance
          ..tags = _tags
          ..needReview = _needReview;

        await repository.updateNote(note);
      } else {
        // 创建新笔记
        final note = VideoNote()
          ..videoId = widget.videoId
          ..timestampInSeconds = widget.timestamp.inSeconds
          ..originalText = widget.initialText
          ..userNote = _noteController.text
          ..type = _selectedType
          ..importance = _importance
          ..tags = _tags
          ..needReview = _needReview
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        await repository.createNote(note);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('笔记已保存'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }
}

/// 显示笔记编辑器的辅助方法
Future<bool?> showNoteEditor({
  required BuildContext context,
  required int videoId,
  required Duration timestamp,
  String? initialText,
  VideoNote? existingNote,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => NoteEditorDialog(
      videoId: videoId,
      timestamp: timestamp,
      initialText: initialText,
      existingNote: existingNote,
    ),
  );
}

