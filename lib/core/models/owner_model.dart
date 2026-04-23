class OwnerImage {
  final String url;
  final String path;

  OwnerImage({
    required this.url,
    required this.path,
  });

  factory OwnerImage.fromJson(Map<String, dynamic> json) {
    return OwnerImage(
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
}

class Owner {
  final int id;
  final int userId;
  final String businessName;
  final String address;
  final double lat;
  final double lng;
  final String mapUrl;
  final List<OwnerImage> images;
  final String? logo;
  final String status;

  Owner({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.mapUrl,
    required this.images,
    required this.logo,
    required this.status,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      businessName: json['business_name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      lat: double.tryParse(json['lat']?.toString() ?? '') ?? 0,
      lng: double.tryParse(json['lng']?.toString() ?? '') ?? 0,
      mapUrl: json['map_url']?.toString() ?? '',
      images: (json['images'] as List? ?? [])
          .map((e) => OwnerImage.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      logo: json['logo']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'business_name': businessName,
      'address': address,
      'lat': lat,
      'lng': lng,
      'map_url': mapUrl,
      'images': images.map((e) => e.toJson()).toList(),
      'logo': logo,
      'status': status,
    };
  }
}