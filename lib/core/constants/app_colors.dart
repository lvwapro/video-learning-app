import 'package:flutter/material.dart';

/// 应用颜色系统
class AppColors {
  AppColors._();

  // 主色调
  static const Color primary = Color(0xFF4361EE);
  static const Color primaryLight = Color(0xFF6C8EFF);
  static const Color primaryDark = Color(0xFF2A4BC7);
  
  // 辅助色
  static const Color secondary = Color(0xFF3A0CA3);
  static const Color secondaryLight = Color(0xFF5B29D1);
  static const Color secondaryDark = Color(0xFF240572);
  
  // 强调色
  static const Color accent = Color(0xFFF72585);
  static const Color accentLight = Color(0xFFFF4DA6);
  static const Color accentDark = Color(0xFFD1005F);
  
  // 成功/错误/警告
  static const Color success = Color(0xFF06D6A0);
  static const Color error = Color(0xFFEF476F);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF4CC9F0);
  
  // 笔记类型颜色
  static const Color noteHighlight = Color(0xFFFFD60A);
  static const Color noteComment = Color(0xFF06D6A0);
  static const Color noteQuestion = Color(0xFFFF6B9D);
  
  // 思维导图节点颜色
  static const List<Color> mindMapColors = [
    Color(0xFF4361EE),
    Color(0xFF3A0CA3),
    Color(0xFFF72585),
    Color(0xFF06D6A0),
    Color(0xFFFFC107),
    Color(0xFF4CC9F0),
    Color(0xFFFF6B9D),
    Color(0xFF9D4EDD),
  ];
  
  // 中性色 - Light Theme
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color dividerLight = Color(0xFFE0E0E0);
  
  // 中性色 - Dark Theme
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color dividerDark = Color(0xFF2C2C2C);
  
  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

