import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/note_providers.dart';
import '../widgets/note_card.dart';
import '../widgets/note_editor_dialog.dart';

/// 笔记页面
class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(allNotesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('我的笔记'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 实现搜索
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: 实现筛选
            },
          ),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '还没有笔记',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '在视频播放时添加笔记',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NoteCard(
                  note: note,
                  onTap: () {
                    // 跳转到对应的视频位置
                    context.push('/video/${note.videoId}');
                  },
                  onEdit: () => _editNote(context, ref, note),
                  onDelete: () => _deleteNote(context, ref, note.id),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('加载失败: $error'),
        ),
      ),
    );
  }

  static Future<void> _editNote(
    BuildContext context,
    WidgetRef ref,
    note,
  ) async {
    final result = await showNoteEditor(
      context: context,
      videoId: note.videoId,
      timestamp: note.timestamp,
      existingNote: note,
    );

    if (result == true) {
      ref.invalidate(allNotesProvider);
    }
  }

  static Future<void> _deleteNote(
    BuildContext context,
    WidgetRef ref,
    int noteId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除笔记'),
        content: const Text('确定要删除这条笔记吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repository = ref.read(noteRepositoryProvider);
        await repository.deleteNote(noteId);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('笔记已删除'),
              backgroundColor: Colors.orange,
            ),
          );
          ref.invalidate(allNotesProvider);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('删除失败: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

