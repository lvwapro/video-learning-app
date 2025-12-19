import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 主题模式状态管理
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  /// 切换到亮色主题
  void setLightMode() {
    state = ThemeMode.light;
  }

  /// 切换到暗色主题
  void setDarkMode() {
    state = ThemeMode.dark;
  }

  /// 切换到系统主题
  void setSystemMode() {
    state = ThemeMode.system;
  }

  /// 切换主题
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

/// 主题模式Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

