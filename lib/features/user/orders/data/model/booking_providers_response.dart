class BookingProvidersResponse {
  final bool success;
  final String message;
  final List<ServiceBookingProvider> data;

  BookingProvidersResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingProvidersResponse.fromJson(Map<String, dynamic> json) {
    return BookingProvidersResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => ServiceBookingProvider.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class ServiceBookingProvider {
  final int id;
  final int serviceBookingId;
  final int providerId;
  final int assignedBy;
  final String role;
  final String status;
  final String? assignedAt;
  final String? completedAt;
  final String? createdAt;
  final String? updatedAt;
  final Provider provider;
  final AssignedByOwner assignedByOwner;

  ServiceBookingProvider({
    required this.id,
    required this.serviceBookingId,
    required this.providerId,
    required this.assignedBy,
    required this.role,
    required this.status,
    this.assignedAt,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
    required this.provider,
    required this.assignedByOwner,
  });

  factory ServiceBookingProvider.fromJson(Map<String, dynamic> json) {
    return ServiceBookingProvider(
      id: json['id'] ?? 0,
      serviceBookingId: json['service_booking_id'] ?? 0,
      providerId: json['provider_id'] ?? 0,
      assignedBy: json['assigned_by'] ?? 0,
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      assignedAt: json['assigned_at'],
      completedAt: json['completed_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      provider: Provider.fromJson(json['provider'] ?? {}),
      assignedByOwner: AssignedByOwner.fromJson(json['assigned_by_owner'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_booking_id': serviceBookingId,
      'provider_id': providerId,
      'assigned_by': assignedBy,
      'role': role,
      'status': status,
      'assigned_at': assignedAt,
      'completed_at': completedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'provider': provider.toJson(),
      'assigned_by_owner': assignedByOwner.toJson(),
    };
  }
}

class Provider {
  final int providerId;
  final int userId;
  final int ownerId;
  final int categoryId;
  final String providerType;
  final String status;
  final String rating;
  final int totalJobs;
  final String? customerComment;
  final String? createdAt;
  final String? updatedAt;
  final ProviderUser user;

  Provider({
    required this.providerId,
    required this.userId,
    required this.ownerId,
    required this.categoryId,
    required this.providerType,
    required this.status,
    required this.rating,
    required this.totalJobs,
    this.customerComment,
    this.createdAt,
    this.updatedAt,
    required this.user,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      providerId: json['providerId'] ?? 0,
      userId: json['user_id'] ?? 0,
      ownerId: json['owner_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      providerType: json['provider_type'] ?? '',
      status: json['status'] ?? '',
      rating: json['rating'] ?? '0.0',
      totalJobs: json['total_jobs'] ?? 0,
      customerComment: json['customer_comment'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: ProviderUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'providerId': providerId,
      'user_id': userId,
      'owner_id': ownerId,
      'category_id': categoryId,
      'provider_type': providerType,
      'status': status,
      'rating': rating,
      'total_jobs': totalJobs,
      'customer_comment': customerComment,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user.toJson(),
    };
  }
}

class ProviderUser {
  final int id;
  final int? ownerId;
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool isActive;
  final String? emailVerifiedAt;
  final String? avatar;
  final String? createdAt;
  final String? updatedAt;

  ProviderUser({
    required this.id,
    this.ownerId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    this.emailVerifiedAt,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory ProviderUser.fromJson(Map<String, dynamic> json) {
    return ProviderUser(
      id: json['id'] ?? 0,
      ownerId: json['owner_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      isActive: json['is_active'] ?? false,
      emailVerifiedAt: json['email_verified_at'],
      avatar: json['avatar'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'email_verified_at': emailVerifiedAt,
      'avatar': avatar,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class AssignedByOwner {
  final int id;
  final int userId;
  final String businessName;
  final String address;
  final double lat;
  final double lng;
  final String mapUrl;
  final List<String> images;
  final String? logo;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  AssignedByOwner({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.mapUrl,
    required this.images,
    this.logo,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory AssignedByOwner.fromJson(Map<String, dynamic> json) {
    return AssignedByOwner(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      businessName: json['business_name'] ?? '',
      address: json['address'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      mapUrl: json['map_url'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      logo: json['logo'],
      status: json['status'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
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
      'images': images,
      'logo': logo,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}