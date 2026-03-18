class ServiceImage {
  final String url;
  final String path;

  ServiceImage({
    required this.url,
    required this.path,
  });

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    return ServiceImage(
      url: json['url'],
      path: json['path'],
    );
  }
}