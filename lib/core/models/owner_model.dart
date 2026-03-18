class Owner {
  final int id;
  final int userId;
  final String businessName;
  final String address;
  final double lat;
  final double lng;
  final String mapUrl;
  final List<String> images;
  final String logo;
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
      id: json['id'],
      userId: json['user_id'],
      businessName: json['business_name'],
      address: json['address'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      mapUrl: json['map_url'],
      images: List<String>.from(json['images']),
      logo: json['logo'],
      status: json['status'],
    );
  }
}