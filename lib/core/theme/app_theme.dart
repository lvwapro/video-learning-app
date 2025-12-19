import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

/// 应用主题配置
class AppTheme {
  AppTheme._();

  // 圆角半径
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  // 间距
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // 阴影
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x24000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  /// 亮色主题
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        error: AppColors.error,
        surface: AppColors.surfaceLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      
      // AppBar主题
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false, // 左对齐
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          // fontFamily: 'NotoSansSC', // 使用系统默认字体
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
      ),
      
      // Card主题
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        color: AppColors.surfaceLight,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      
      // 文本主题
      textTheme: _buildTextTheme(AppColors.textPrimaryLight),
      
      // 按钮主题
      elevatedButtonTheme: _buildElevatedButtonTheme(true),
      outlinedButtonTheme: _buildOutlinedButtonTheme(true),
      textButtonTheme: _buildTextButtonTheme(true),
      
      // 输入框主题
      inputDecorationTheme: _buildInputDecorationTheme(true),
      
      // 浮动按钮主题
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      // 底部导航栏
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Divider主题
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
        space: 1,
      ),
      
      // IconTheme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryLight,
        size: 24,
      ),
    );
  }

  /// 暗色主题
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        tertiary: AppColors.accentLight,
        error: AppColors.error,
        surface: AppColors.surfaceDark,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF000000), // 纯黑背景，类似Deja
      
      // AppBar主题
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false, // 左对齐，类似Deja
        backgroundColor: Color(0xFF000000),
        foregroundColor: AppColors.textPrimaryDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          // fontFamily: 'NotoSansSC', // 使用系统默认字体
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
      ),
      
      // Card主题
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        color: const Color(0xFF1C1C1E), // 更深的卡片颜色，类似Deja
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      
      // 文本主题
      textTheme: _buildTextTheme(AppColors.textPrimaryDark),
      
      // 按钮主题
      elevatedButtonTheme: _buildElevatedButtonTheme(false),
      outlinedButtonTheme: _buildOutlinedButtonTheme(false),
      textButtonTheme: _buildTextButtonTheme(false),
      
      // 输入框主题
      inputDecorationTheme: _buildInputDecorationTheme(false),
      
      // 浮动按钮主题
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.black,
        elevation: 4,
      ),
      
      // 底部导航栏
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF000000),
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // Divider主题
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),
      
      // IconTheme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
        size: 24,
      ),
    );
  }

  /// 构建文本主题
  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.2,
      ),
      
      // Headline styles
      headlineLarge: TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      
      // Title styles
      titleLarge: TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      
      // Body styles
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      
      // Label styles
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
    );
  }

  /// 构建ElevatedButton主题
  static ElevatedButtonThemeData _buildElevatedButtonTheme(bool isLight) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 构建OutlinedButton主题
  static OutlinedButtonThemeData _buildOutlinedButtonTheme(bool isLight) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 构建TextButton主题
  static TextButtonThemeData _buildTextButtonTheme(bool isLight) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 构建InputDecoration主题
  static InputDecorationTheme _buildInputDecorationTheme(bool isLight) {
    final borderColor = isLight ? AppColors.dividerLight : AppColors.dividerDark;
    final fillColor = isLight ? AppColors.surfaceLight : AppColors.surfaceDark;
    
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark,
      ),
    );
  }
}

