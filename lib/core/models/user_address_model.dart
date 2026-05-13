class UserAddressResponse {
  final bool success;
  final String message;
  final UserAddress? data;

  UserAddressResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UserAddressResponse.fromJson(Map<String, dynamic> json) {
    return UserAddressResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? UserAddress.fromJson(
        Map<String, dynamic>.from(json['data']),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class UserAddressListResponse {
  final bool success;
  final String message;
  final List<UserAddress> data;

  UserAddressListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserAddressListResponse.fromJson(Map<String, dynamic> json) {
    return UserAddressListResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is List
          ? (json['data'] as List)
          .map(
            (item) => UserAddress.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : [],
    );
  }
}

class UserAddress {
  final int? id;
  final int? userId;
  final String? label;
  final String? streetNumber;
  final String? houseNumber;
  final String? city;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? mapUrl;
  final bool isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserAddress({
    this.id,
    this.userId,
    this.label,
    this.streetNumber,
    this.houseNumber,
    this.city,
    required this.address,
    this.latitude,
    this.longitude,
    this.mapUrl,
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      label: json['label']?.toString(),
      streetNumber: json['street_number']?.toString(),
      houseNumber: json['house_number']?.toString(),
      city: json['city']?.toString(),
      address: json['address']?.toString() ?? '',
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      mapUrl: json['map_url']?.toString(),
      isDefault: _toBool(json['is_default']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'label': label,
      'street_number': streetNumber,
      'house_number': houseNumber,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'map_url': mapUrl,
      'is_default': isDefault,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'label': label,
      'street_number': streetNumber,
      'house_number': houseNumber,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'map_url': mapUrl,
      'is_default': isDefault,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'label': label,
      'street_number': streetNumber,
      'house_number': houseNumber,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'map_url': mapUrl,
      'is_default': isDefault,
    };
  }

  UserAddress copyWith({
    int? id,
    int? userId,
    String? label,
    String? streetNumber,
    String? houseNumber,
    String? city,
    String? address,
    double? latitude,
    double? longitude,
    String? mapUrl,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAddress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      streetNumber: streetNumber ?? this.streetNumber,
      houseNumber: houseNumber ?? this.houseNumber,
      city: city ?? this.city,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      mapUrl: mapUrl ?? this.mapUrl,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static bool _toBool(dynamic value) {
    if (value == true) return true;
    if (value == 1) return true;
    if (value == '1') return true;
    if (value == 'true') return true;
    return false;
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}