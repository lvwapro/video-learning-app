import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_provider.dart';
import '../../core/constants/app_constants.dart';

/// 设置页面
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          // 外观设置
          _buildSectionHeader(context, '外观'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('主题模式'),
            subtitle: Text(_getThemeModeText(themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeModeDialog(context, ref),
          ),

          const Divider(height: 32),

          // 视频设置
          _buildSectionHeader(context, '视频'),
          ListTile(
            leading: const Icon(Icons.video_settings),
            title: const Text('默认播放速度'),
            subtitle: const Text('1.0x'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 设置默认播放速度
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.autorenew),
            title: const Text('自动播放下一个'),
            subtitle: const Text('视频结束后自动播放列表中的下一个'),
            value: false,
            onChanged: (value) {
              // TODO: 实现自动播放设置
            },
          ),

          const Divider(height: 32),

          // 笔记设置
          _buildSectionHeader(context, '笔记'),
          SwitchListTile(
            secondary: const Icon(Icons.sync),
            title: const Text('自动保存'),
            subtitle: const Text('笔记修改后自动保存'),
            value: true,
            onChanged: (value) {
              // TODO: 实现自动保存设置
            },
          ),

          const Divider(height: 32),

          // 数据管理
          _buildSectionHeader(context, '数据'),
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: const Text('导出数据'),
            subtitle: const Text('导出所有笔记和思维导图'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 实现数据导出
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('导入数据'),
            subtitle: const Text('从备份文件导入数据'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 实现数据导入
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text(
              '清空所有数据',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text('删除所有视频、笔记和思维导图'),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () => _showClearDataDialog(context),
          ),

          const Divider(height: 32),

          // 关于
          _buildSectionHeader(context, '关于'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('版本'),
            subtitle: Text(AppConstants.appVersion),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('使用帮助'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 显示帮助文档
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('隐私政策'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 显示隐私政策
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return '浅色';
      case ThemeMode.dark:
        return '深色';
      case ThemeMode.system:
        return '跟随系统';
    }
  }

  void _showThemeModeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('主题模式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('浅色'),
              value: ThemeMode.light,
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setLightMode();
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('深色'),
              value: ThemeMode.dark,
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setDarkMode();
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('跟随系统'),
              value: ThemeMode.system,
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setSystemMode();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空所有数据'),
        content: const Text('此操作将删除所有视频、笔记和思维导图，且无法恢复。确定要继续吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 实现清空数据
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

