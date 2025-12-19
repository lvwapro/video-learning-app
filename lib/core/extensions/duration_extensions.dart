/// Duration扩展方法
extension DurationExtensions on Duration {
  /// 格式化为 HH:MM:SS
  String toHHMMSS() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// 格式化为 MM:SS
  String toMMSS() {
    final minutes = inMinutes;
    final seconds = inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// 格式化为人类可读形式 (如: "1小时30分钟")
  String toHumanReadable() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    
    final parts = <String>[];
    if (hours > 0) parts.add('$hours小时');
    if (minutes > 0) parts.add('$minutes分钟');
    if (seconds > 0 && hours == 0) parts.add('$seconds秒');
    
    return parts.isEmpty ? '0秒' : parts.join('');
  }
}

