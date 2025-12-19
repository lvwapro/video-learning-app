import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/constants/app_colors.dart';
import '../providers/video_providers.dart';
import '../providers/note_providers.dart';
import '../providers/video_import_provider.dart';

/// 主页
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  void _onNavigationChanged(int index) {
    if (_selectedIndex == index) return;
    
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.videoList);
        break;
      case 2:
        context.go(AppRoutes.notes);
        break;
      case 3:
        context.go(AppRoutes.mindmap);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(allVideosProvider);
    final notesAsync = ref.watch(allNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('学迹VidNotes'),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 实现搜索功能
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎卡片
            _buildWelcomeCard(),
            const SizedBox(height: 24),

            // 统计卡片
            _buildStatsCards(videosAsync, notesAsync),
            const SizedBox(height: 24),

            // 快速操作
            _buildQuickActions(),
            const SizedBox(height: 24),

            // 最近视频
            _buildRecentVideos(videosAsync),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => _importVideo(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('导入视频'),
              elevation: 4,
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavigationChanged,
        elevation: 8,
        animationDuration: const Duration(milliseconds: 300),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: '视频库',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_outlined),
            selectedIcon: Icon(Icons.note),
            label: '笔记',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_tree_outlined),
            selectedIcon: Icon(Icons.account_tree),
            label: '思维导图',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '开始学习',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '从视频中提取知识，创建笔记和思维导图',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRoutes.videoList),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.video_library, size: 20),
            label: const Text(
              '浏览视频库',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(
    AsyncValue<List<dynamic>> videosAsync,
    AsyncValue<List<dynamic>> notesAsync,
  ) {
    final videoCount = videosAsync.valueOrNull?.length ?? 0;
    final noteCount = notesAsync.valueOrNull?.length ?? 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.video_library,
            title: '视频',
            value: videoCount.toString(),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.note,
            title: '笔记',
            value: noteCount.toString(),
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.account_tree,
            title: '导图',
            value: '0',
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '快速操作',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildQuickActionChip(
              icon: Icons.add_circle_outline,
              label: '导入视频',
              onTap: () => _importVideo(context, ref),
            ),
            _buildQuickActionChip(
              icon: Icons.note_add,
              label: '新建笔记',
              onTap: () => context.go(AppRoutes.notes),
            ),
            _buildQuickActionChip(
              icon: Icons.account_tree,
              label: '新建导图',
              onTap: () => context.go(AppRoutes.mindmap),
            ),
            _buildQuickActionChip(
              icon: Icons.star_outline,
              label: '收藏',
              onTap: () {
                // TODO: 查看收藏
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildRecentVideos(AsyncValue<List<dynamic>> videosAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '最近视频',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.videoList),
              child: const Text('查看全部'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        videosAsync.when(
          data: (videos) {
            if (videos.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.video_library_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '还没有视频',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '点击下方按钮导入第一个视频',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final recentVideos = videos.take(3).toList();
            return Column(
              children: recentVideos.map((video) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.play_circle_outline),
                    ),
                    title: Text(video.title),
                    subtitle: Text(video.formattedDuration),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.push('/video/${video.id}');
                    },
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('加载失败: $error'),
          ),
        ),
      ],
    );
  }

  /// 导入视频
  Future<void> _importVideo(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(videoImportControllerProvider.notifier);
    
    // 显示加载对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('导入视频中...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final video = await controller.importVideo();
      
      if (context.mounted) {
        Navigator.of(context).pop(); // 关闭加载对话框
        
        if (video != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('视频导入成功: ${video.title}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // 关闭加载对话框
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导入失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

