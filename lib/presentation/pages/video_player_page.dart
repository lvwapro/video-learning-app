import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/video_providers.dart';
import '../providers/note_providers.dart';
import '../widgets/smart_video_player.dart';
import '../widgets/note_editor_dialog.dart';
import '../../core/utils/logger.dart';

/// 视频播放器页面
class VideoPlayerPage extends ConsumerStatefulWidget {
  final int videoId;

  const VideoPlayerPage({
    super.key,
    required this.videoId,
  });

  @override
  ConsumerState<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends ConsumerState<VideoPlayerPage> {
  Duration? _currentPosition;

  @override
  void initState() {
    super.initState();
    // 增加播放次数
    Future.microtask(() {
      final repository = ref.read(videoRepositoryProvider);
      repository.incrementPlayCount(widget.videoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoAsync = ref.watch(videoProvider(widget.videoId));
    final notesAsync = ref.watch(videoNotesProvider(widget.videoId));

    return Scaffold(
      appBar: AppBar(
        title: videoAsync.when(
          data: (video) => Text(video?.title ?? '视频播放'),
          loading: () => const Text('加载中...'),
          error: (_, __) => const Text('视频播放'),
        ),
        actions: [
          IconButton(
            icon: videoAsync.valueOrNull?.isFavorite == true
                ? const Icon(Icons.star)
                : const Icon(Icons.star_outline),
            onPressed: () async {
              final repository = ref.read(videoRepositoryProvider);
              await repository.toggleFavorite(widget.videoId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
      body: videoAsync.when(
        data: (video) {
          if (video == null) {
            return const Center(
              child: Text('视频不存在'),
            );
          }

          return Column(
            children: [
              // 视频播放器（使用 Flexible 避免溢出）
              Flexible(
                flex: 0,
                child: SmartVideoPlayer(
                  videoPath: video.path,
                  videoId: video.id,
                  notes: notesAsync.valueOrNull ?? [],
                  initialPosition: Duration(seconds: video.playbackPosition),
                  onPositionChanged: (position) {
                    _currentPosition = position;
                    // 每5秒保存一次播放进度
                    if (position.inSeconds % 5 == 0) {
                      _savePlaybackPosition(position);
                    }
                  },
                  onNoteTimestampTap: (timestamp) {
                    AppLogger.info('跳转到笔记时间: ${timestamp.inSeconds}s');
                  },
                  onAddNote: () => _showAddNoteDialog(context),
                ),
              ),

              // 笔记列表
              Expanded(
                child: _buildNotesSection(notesAsync),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('加载失败: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesSection(AsyncValue notesAsync) {
    return notesAsync.when(
      data: (notes) {
        if (notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.note_add_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  '还没有笔记',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  '点击右下角按钮添加笔记',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
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
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(
                  note.userNote ?? note.originalText ?? '空笔记',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${note.formattedTimestamp} • ${note.typeDisplayName}',
                ),
                trailing: PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('编辑'),
                        ],
                      ),
                      onTap: () {
                        Future.delayed(Duration.zero, () {
                          _editNote(context, note);
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('删除', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      onTap: () {
                        Future.delayed(Duration.zero, () {
                          _deleteNote(context, note.id);
                        });
                      },
                    ),
                  ],
                ),
                onTap: () => _editNote(context, note),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('加载笔记失败: $error')),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('视频信息'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 显示视频信息
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('编辑标题'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 编辑视频标题
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('删除视频', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteVideo(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) async {
    final video = await ref.read(videoProvider(widget.videoId).future);
    if (video == null) return;

    final currentPosition = _currentPosition ?? Duration.zero;
    
    if (!mounted) return;
    
    final result = await showNoteEditor(
      context: context,
      videoId: widget.videoId,
      timestamp: currentPosition,
    );

    if (result == true && mounted) {
      // 笔记已保存，刷新笔记列表
      ref.invalidate(videoNotesProvider(widget.videoId));
    }
  }

  void _confirmDeleteVideo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除视频'),
        content: const Text('确定要删除这个视频吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final repository = ref.read(videoRepositoryProvider);
              await repository.deleteVideo(widget.videoId);
              if (context.mounted) {
                Navigator.pop(context); // 关闭对话框
                Navigator.pop(context); // 返回上一页
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  Future<void> _savePlaybackPosition(Duration position) async {
    final repository = ref.read(videoRepositoryProvider);
    await repository.updatePlaybackPosition(
      widget.videoId,
      position.inSeconds,
    );
  }

  Future<void> _editNote(BuildContext context, note) async {
    final result = await showNoteEditor(
      context: context,
      videoId: widget.videoId,
      timestamp: note.timestamp,
      existingNote: note,
    );

    if (result == true && mounted) {
      ref.invalidate(videoNotesProvider(widget.videoId));
    }
  }

  Future<void> _deleteNote(BuildContext context, int noteId) async {
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
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('笔记已删除'),
              backgroundColor: Colors.orange,
            ),
          );
          ref.invalidate(videoNotesProvider(widget.videoId));
        }
      } catch (e) {
        if (mounted) {
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

  @override
  void dispose() {
    // 保存最终播放进度
    if (_currentPosition != null) {
      final repository = ref.read(videoRepositoryProvider);
      repository.updatePlaybackPosition(
        widget.videoId,
        _currentPosition!.inSeconds,
      );
    }
    super.dispose();
  }
}

