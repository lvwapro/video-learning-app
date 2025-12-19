/// String扩展方法
extension StringExtensions on String {
  /// 检查字符串是否为空或null
  bool get isNullOrEmpty {
    return isEmpty;
  }

  /// 检查字符串是否不为空
  bool get isNotNullOrEmpty {
    return isNotEmpty;
  }

  /// 首字母大写
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// 截断字符串并添加省略号
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// 解析为Duration (格式: HH:MM:SS 或 MM:SS)
  Duration? toDuration() {
    try {
      final parts = split(':').map(int.parse).toList();
      if (parts.length == 3) {
        // HH:MM:SS
        return Duration(
          hours: parts[0],
          minutes: parts[1],
          seconds: parts[2],
        );
      } else if (parts.length == 2) {
        // MM:SS
        return Duration(
          minutes: parts[0],
          seconds: parts[1],
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 移除所有空格
  String removeAllSpaces() {
    return replaceAll(' ', '');
  }

  /// 检查是否是有效的视频文件扩展名
  bool isVideoExtension() {
    final extension = toLowerCase();
    return extension.endsWith('.mp4') ||
        extension.endsWith('.mov') ||
        extension.endsWith('.avi') ||
        extension.endsWith('.mkv') ||
        extension.endsWith('.flv') ||
        extension.endsWith('.wmv');
  }

  /// 获取文件扩展名
  String get fileExtension {
    final lastDot = lastIndexOf('.');
    if (lastDot == -1) return '';
    return substring(lastDot + 1).toLowerCase();
  }

  /// 获取文件名（不含扩展名）
  String get fileNameWithoutExtension {
    final lastSlash = lastIndexOf('/');
    final lastDot = lastIndexOf('.');
    if (lastSlash == -1 && lastDot == -1) return this;
    if (lastDot == -1) {
      return lastSlash == -1 ? this : substring(lastSlash + 1);
    }
    final start = lastSlash == -1 ? 0 : lastSlash + 1;
    return substring(start, lastDot);
  }
}

