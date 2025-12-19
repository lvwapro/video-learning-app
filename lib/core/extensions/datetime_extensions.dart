import 'package:intl/intl.dart';

/// DateTime扩展方法
extension DateTimeExtensions on DateTime {
  /// 格式化为标准日期时间 (如: 2024-01-15 14:30)
  String toStandardFormat() {
    return DateFormat('yyyy-MM-dd HH:mm').format(this);
  }

  /// 格式化为友好的日期时间 (如: 今天 14:30, 昨天 14:30, 01月15日)
  String toFriendlyFormat() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisDate = DateTime(year, month, day);
    
    if (thisDate == today) {
      return '今天 ${DateFormat('HH:mm').format(this)}';
    } else if (thisDate == yesterday) {
      return '昨天 ${DateFormat('HH:mm').format(this)}';
    } else if (year == now.year) {
      return DateFormat('MM月dd日').format(this);
    } else {
      return DateFormat('yyyy年MM月dd日').format(this);
    }
  }

  /// 相对时间 (如: 刚刚, 5分钟前, 2小时前)
  String toRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}周前';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}个月前';
    } else {
      return '${(difference.inDays / 365).floor()}年前';
    }
  }

  /// 是否是今天
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// 是否是昨天
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && 
        month == yesterday.month && 
        day == yesterday.day;
  }
}

