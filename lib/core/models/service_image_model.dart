import 'dart:convert';

class ServiceImage {
  final String url;
  final String path;

  ServiceImage({
    required this.url,
    required this.path,
  });

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    return ServiceImage(
      url: json['url']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'path': path,
    };
  }

  static String encodeList(List<ServiceImage> images) {
    return jsonEncode(images.map((e) => e.toJson()).toList());
  }

  static List<ServiceImage> decodeList(String source) {
    final List data = jsonDecode(source);
    return data
        .map((e) => ServiceImage.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}