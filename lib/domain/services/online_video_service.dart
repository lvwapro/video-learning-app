import 'package:dio/dio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../core/utils/logger.dart';

/// 视频平台类型
enum VideoPlatform {
  bilibili, // 哔哩哔哩
  youtube, // YouTube
  direct, // 直接视频链接
  unknown, // 未知平台
}

/// 在线视频信息
class OnlineVideoInfo {
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String videoUrl;
  final String? subtitleUrl;
  final VideoPlatform platform;
  final int? duration;
  final String originalUrl;

  OnlineVideoInfo({
    required this.title,
    this.description,
    this.thumbnailUrl,
    required this.videoUrl,
    this.subtitleUrl,
    required this.platform,
    this.duration,
    required this.originalUrl,
  });
}

/// 在线视频解析服务
class OnlineVideoService {
  /// 从文本中提取URL
  String? extractUrl(String text) {
    // URL正则表达式，支持http/https
    final urlPattern = RegExp(
      r'https?://[^\s\u4e00-\u9fa5]+',
      caseSensitive: false,
    );

    final match = urlPattern.firstMatch(text);
    return match?.group(0);
  }

  /// 从文本中提取视频标题（URL前的中文描述）
  String? extractTitle(String text) {
    final url = extractUrl(text);
    if (url == null) return null;

    // 获取URL前的文本
    final urlIndex = text.indexOf(url);
    if (urlIndex > 0) {
      var title = text.substring(0, urlIndex).trim();
      // 移除常见的分隔符
      title = title.replaceAll(RegExp(r'[【】\[\]\-—_]+'), ' ').trim();
      if (title.isNotEmpty) {
        return title;
      }
    }

    return null;
  }

  /// 检测视频平台
  VideoPlatform detectPlatform(String input) {
    // 先尝试从文本中提取URL
    final url = extractUrl(input) ?? input;

    final uri = Uri.tryParse(url);
    if (uri == null) return VideoPlatform.unknown;

    final host = uri.host.toLowerCase();

    if (host.contains('bilibili.com') || host.contains('b23.tv')) {
      return VideoPlatform.bilibili;
    } else if (host.contains('youtube.com') || host.contains('youtu.be')) {
      return VideoPlatform.youtube;
    } else if (url.endsWith('.mp4') ||
        url.endsWith('.m3u8') ||
        url.endsWith('.flv') ||
        url.contains('video')) {
      return VideoPlatform.direct;
    }

    return VideoPlatform.unknown;
  }

  /// 解析视频信息
  Future<OnlineVideoInfo?> parseVideo(String input) async {
    try {
      // 先提取URL
      var url = extractUrl(input) ?? input;
      
      // 处理重定向 (特别是 b23.tv)
      if (url.contains('b23.tv') || url.contains('youtu.be')) {
        try {
          final dio = Dio();
          final response = await dio.head(url);
          if (response.realUri.toString() != url) {
            url = response.realUri.toString();
            AppLogger.info('解析重定向后的URL: $url');
          }
        } catch (e) {
          AppLogger.warning('处理URL重定向失败: $e');
        }
      }

      final platform = detectPlatform(url);

      switch (platform) {
        case VideoPlatform.bilibili:
          return await _parseBilibili(url);
        case VideoPlatform.youtube:
          return await _parseYouTube(url);
        case VideoPlatform.direct:
          return await _parseDirect(url);
        default:
          AppLogger.warning('不支持的视频平台: $url');
          return null;
      }
    } catch (e) {
      AppLogger.error('解析视频失败', e);
      return null;
    }
  }

  /// 获取页面标题
  Future<String?> _fetchPageTitle(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get(url);
      final html = response.data.toString();
      
      // 匹配 <title> 标签
      final titleMatch = RegExp(r'<title>(.*?)<\/title>', dotAll: true).firstMatch(html);
      if (titleMatch != null) {
        var title = titleMatch.group(1)?.trim() ?? '';
        // 清理常见的后缀
        title = title.replaceAll('_哔哩哔哩_bilibili', '');
        title = title.replaceAll(' - YouTube', '');
        return title;
      }
    } catch (e) {
      AppLogger.warning('获取页面标题失败: $e');
    }
    return null;
  }

  /// 解析哔哩哔哩视频
  Future<OnlineVideoInfo?> _parseBilibili(String url) async {
    try {
      AppLogger.info('解析B站视频: $url');

      // 提取 BVID
      final bvidMatch = RegExp(r'BV[a-zA-Z0-9]+').firstMatch(url);
      if (bvidMatch == null) return null;
      final bvid = bvidMatch.group(0)!;

      final dio = Dio();
      
      // 1. 获取视频详情 (包含标题、描述、封面、cid)
      final viewResponse = await dio.get('https://api.bilibili.com/x/web-interface/view?bvid=$bvid');
      final viewData = viewResponse.data['data'];
      final title = viewData['title'];
      final description = viewData['desc'];
      final thumbnail = viewData['pic'];
      final cid = viewData['cid'];
      final duration = viewData['duration'];

      // 2. 获取播放地址 (优先获取高质量)
      // 注意：B站API返回的链接通常需要 Referer: https://www.bilibili.com 才能播放
      final playResponse = await dio.get(
        'https://api.bilibili.com/x/player/playurl',
        queryParameters: {
          'bvid': bvid,
          'cid': cid,
          'qn': 64, // 720P
          'type': 'mp4',
          'platform': 'html5',
          'high_quality': 1,
        },
      );
      
      final playData = playResponse.data['data'];
      final videoUrl = playData['durl'][0]['url'];

      return OnlineVideoInfo(
        title: title,
        description: description,
        thumbnailUrl: thumbnail,
        videoUrl: videoUrl,
        platform: VideoPlatform.bilibili,
        duration: duration,
        originalUrl: url,
      );
    } catch (e) {
      AppLogger.error('解析B站视频失败', e);
      // 降级：返回网页标题
      final title = await _fetchPageTitle(url) ?? '哔哩哔哩视频';
      return OnlineVideoInfo(
        title: title,
        videoUrl: url,
        platform: VideoPlatform.bilibili,
        originalUrl: url,
      );
    }
  }

  /// 解析YouTube视频
  Future<OnlineVideoInfo?> _parseYouTube(String url) async {
    try {
      AppLogger.info('解析YouTube视频: $url');

      final yt = YoutubeExplode();
      final video = await yt.videos.get(url);
      
      // 获取视频流
      final manifest = await yt.videos.streamsClient.getManifest(video.id);
      final streamInfo = manifest.muxed.withHighestBitrate();
      final videoUrl = streamInfo.url.toString();

      yt.close();

      return OnlineVideoInfo(
        title: video.title,
        description: video.description,
        thumbnailUrl: video.thumbnails.highResUrl,
        videoUrl: videoUrl,
        platform: VideoPlatform.youtube,
        duration: video.duration?.inSeconds,
        originalUrl: url,
      );
    } catch (e) {
      AppLogger.error('解析YouTube视频失败', e);
      final title = await _fetchPageTitle(url) ?? 'YouTube视频';
      return OnlineVideoInfo(
        title: title,
        videoUrl: url,
        platform: VideoPlatform.youtube,
        originalUrl: url,
      );
    }
  }

  /// 解析直接视频链接
  Future<OnlineVideoInfo?> _parseDirect(String url) async {
    try {
      AppLogger.info('直接视频链接: $url');

      // 从URL中提取文件名作为标题
      final uri = Uri.parse(url);
      final fileName =
          uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '在线视频';

      final title = fileName.replaceAll(RegExp(r'\.(mp4|m3u8|flv)$'), '');

      return OnlineVideoInfo(
        title: title,
        videoUrl: url,
        platform: VideoPlatform.direct,
        originalUrl: url,
      );
    } catch (e) {
      AppLogger.error('解析直接视频链接失败', e);
      return null;
    }
  }

  /// 验证视频URL是否有效
  Future<bool> validateUrl(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) return false;

      if (!uri.hasScheme || !uri.hasAuthority) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 获取平台名称
  String getPlatformName(VideoPlatform platform) {
    switch (platform) {
      case VideoPlatform.bilibili:
        return '哔哩哔哩';
      case VideoPlatform.youtube:
        return 'YouTube';
      case VideoPlatform.direct:
        return '直接链接';
      case VideoPlatform.unknown:
        return '未知平台';
    }
  }

  /// 获取平台图标
  String getPlatformIcon(VideoPlatform platform) {
    switch (platform) {
      case VideoPlatform.bilibili:
        return '📺';
      case VideoPlatform.youtube:
        return '▶️';
      case VideoPlatform.direct:
        return '🔗';
      case VideoPlatform.unknown:
        return '❓';
    }
  }

  /// 是否支持直接播放
  bool supportDirectPlay(VideoPlatform platform) {
    return platform == VideoPlatform.direct;
  }

  /// 获取建议的操作
  String getSuggestion(VideoPlatform platform) {
    switch (platform) {
      case VideoPlatform.bilibili:
        return '建议使用 you-get 或 BBDown 下载后导入\n'
            '或使用在线工具获取直接链接';
      case VideoPlatform.youtube:
        return '建议使用 yt-dlp 或在线工具下载后导入';
      case VideoPlatform.direct:
        return '支持直接在线播放';
      case VideoPlatform.unknown:
        return '不支持的视频源，请提供直接视频链接';
    }
  }
}
