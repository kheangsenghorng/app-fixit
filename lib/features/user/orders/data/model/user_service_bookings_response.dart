class UserServiceBookingsResponse {
  final bool success;
  final String message;
  final List<ServiceBooking> data;

  UserServiceBookingsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserServiceBookingsResponse.fromJson(Map<String, dynamic> json) {
    return UserServiceBookingsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ServiceBooking.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class ServiceBooking {
  final int id;
  final int userId;
  final int serviceId;
  final int packageId;
  final int addressId;

  final String? bookingDate;
  final String? bookingHours;
  final int quantity;
  final String? notes;

  final String? bookingStatus;
  final String? customerStatus;
  final String? providerCompletedAt;
  final String? customerCompletedAt;
  final String? autoCompleteAt;

  final String? createdAt;
  final String? updatedAt;

  final BookingUser? user;
  final BookingAddress? address;
  final BookingPackage? package;
  final BookingService? service;
  final List<Payment> payments;

  ServiceBooking({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.packageId,
    required this.addressId,
    this.bookingDate,
    this.bookingHours,
    required this.quantity,
    this.notes,
    this.bookingStatus,
    this.customerStatus,
    this.providerCompletedAt,
    this.customerCompletedAt,
    this.autoCompleteAt,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.address,
    this.package,
    this.service,
    required this.payments,
  });

  factory ServiceBooking.fromJson(Map<String, dynamic> json) {
    return ServiceBooking(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      serviceId: json['service_id'] ?? 0,
      packageId: json['package_id'] ?? 0,
      addressId: json['address_id'] ?? 0,
      bookingDate: json['booking_date'],
      bookingHours: json['booking_hours'],
      quantity: json['quantity'] ?? 0,
      notes: json['notes'],
      bookingStatus: json['booking_status'],
      customerStatus: json['customer_status'],
      providerCompletedAt: json['provider_completed_at'],
      customerCompletedAt: json['customer_completed_at'],
      autoCompleteAt: json['auto_complete_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? BookingUser.fromJson(json['user']) : null,
      address: json['address'] != null
          ? BookingAddress.fromJson(json['address'])
          : null,
      package: json['package'] != null
          ? BookingPackage.fromJson(json['package'])
          : null,
      service: json['service'] != null
          ? BookingService.fromJson(json['service'])
          : null,
      payments: (json['payments'] as List<dynamic>? ?? [])
          .map((e) => Payment.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'package_id': packageId,
      'address_id': addressId,
      'booking_date': bookingDate,
      'booking_hours': bookingHours,
      'quantity': quantity,
      'notes': notes,
      'booking_status': bookingStatus,
      'customer_status': customerStatus,
      'provider_completed_at': providerCompletedAt,
      'customer_completed_at': customerCompletedAt,
      'auto_complete_at': autoCompleteAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
      'address': address?.toJson(),
      'package': package?.toJson(),
      'service': service?.toJson(),
      'payments': payments.map((e) => e.toJson()).toList(),
    };
  }
}

class BookingUser {
  final int id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final bool isActive;
  final String? emailVerifiedAt;
  final String? avatar;

  BookingUser({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    required this.isActive,
    this.emailVerifiedAt,
    this.avatar,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      id: json['id'] ?? 0,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      isActive: json['is_active'] ?? false,
      emailVerifiedAt: json['email_verified_at'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'email_verified_at': emailVerifiedAt,
      'avatar': avatar,
    };
  }
}

class BookingAddress {
  final int id;
  final int userId;
  final String? label;
  final String? streetNumber;
  final String? houseNumber;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? mapUrl;
  final bool isDefault;
  final String? createdAt;
  final String? updatedAt;

  BookingAddress({
    required this.id,
    required this.userId,
    this.label,
    this.streetNumber,
    this.houseNumber,
    this.address,
    this.latitude,
    this.longitude,
    this.mapUrl,
    required this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingAddress.fromJson(Map<String, dynamic> json) {
    return BookingAddress(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      label: json['label'],
      streetNumber: json['street_number'],
      houseNumber: json['house_number'],
      address: json['address'],
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      mapUrl: json['map_url'],
      isDefault: json['is_default'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'label': label,
      'street_number': streetNumber,
      'house_number': houseNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'map_url': mapUrl,
      'is_default': isDefault,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class BookingPackage {
  final int id;
  final int serviceId;
  final String? title;
  final String? description;
  final String? minAreaM2;
  final String? maxAreaM2;
  final int floorNumber;
  final int bedrooms;
  final String? durationHours;
  final int workersCount;
  final String? price;
  final String? billingType;
  final String? status;
  final String? createdAt;

  BookingPackage({
    required this.id,
    required this.serviceId,
    this.title,
    this.description,
    this.minAreaM2,
    this.maxAreaM2,
    required this.floorNumber,
    required this.bedrooms,
    this.durationHours,
    required this.workersCount,
    this.price,
    this.billingType,
    this.status,
    this.createdAt,
  });

  factory BookingPackage.fromJson(Map<String, dynamic> json) {
    return BookingPackage(
      id: json['id'] ?? 0,
      serviceId: json['service_id'] ?? 0,
      title: json['title'],
      description: json['description'],
      minAreaM2: json['min_area_m2']?.toString(),
      maxAreaM2: json['max_area_m2']?.toString(),
      floorNumber: json['floor_number'] ?? 0,
      bedrooms: json['bedrooms'] ?? 0,
      durationHours: json['duration_hours']?.toString(),
      workersCount: json['workers_count'] ?? 0,
      price: json['price']?.toString(),
      billingType: json['billing_type'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'title': title,
      'description': description,
      'min_area_m2': minAreaM2,
      'max_area_m2': maxAreaM2,
      'floor_number': floorNumber,
      'bedrooms': bedrooms,
      'duration_hours': durationHours,
      'workers_count': workersCount,
      'price': price,
      'billing_type': billingType,
      'status': status,
      'created_at': createdAt,
    };
  }
}

class BookingService {
  final int id;
  final String? name;
  final String? title;
  final List<ServiceImage> images;
  final int categoryId;
  final int typeId;
  final ServiceCategory? category;
  final ServiceType? type;

  BookingService({
    required this.id,
    this.name,
    this.title,
    required this.images,
    required this.categoryId,
    required this.typeId,
    this.category,
    this.type,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) {
    return BookingService(
      id: json['id'] ?? 0,
      name: json['name'],
      title: json['title'],
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ServiceImage.fromJson(e))
          .toList(),
      categoryId: json['category_id'] ?? 0,
      typeId: json['type_id'] ?? 0,
      category: json['category'] != null
          ? ServiceCategory.fromJson(json['category'])
          : null,
      type: json['type'] != null ? ServiceType.fromJson(json['type']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'images': images.map((e) => e.toJson()).toList(),
      'category_id': categoryId,
      'type_id': typeId,
      'category': category?.toJson(),
      'type': type?.toJson(),
    };
  }
}

class ServiceImage {
  final String? url;
  final String? path;

  ServiceImage({
    this.url,
    this.path,
  });

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    return ServiceImage(
      url: json['url'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'path': path,
    };
  }
}

class ServiceCategory {
  final int id;
  final String? name;
  final String? icon;
  final String? iconUrl;

  ServiceCategory({
    required this.id,
    this.name,
    this.icon,
    this.iconUrl,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] ?? 0,
      name: json['name'],
      icon: json['icon'],
      iconUrl: json['icon_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'icon_url': iconUrl,
    };
  }
}

class ServiceType {
  final int id;
  final String? name;
  final String? icon;
  final String? iconUrl;

  ServiceType({
    required this.id,
    this.name,
    this.icon,
    this.iconUrl,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      id: json['id'] ?? 0,
      name: json['name'],
      icon: json['icon'],
      iconUrl: json['icon_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'icon_url': iconUrl,
    };
  }
}

class Payment {
  final int id;
  final int userId;
  final int ownerId;
  final int serviceBookingId;
  final int? couponsId;
  final String? transactionId;
  final String? originalAmount;
  final String? discountAmount;
  final String? finalAmount;
  final String? method;
  final String? status;

  Payment({
    required this.id,
    required this.userId,
    required this.ownerId,
    required this.serviceBookingId,
    this.couponsId,
    this.transactionId,
    this.originalAmount,
    this.discountAmount,
    this.finalAmount,
    this.method,
    this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      ownerId: json['owner_id'] ?? 0,
      serviceBookingId: json['service_booking_id'] ?? 0,
      couponsId: json['coupons_id'],
      transactionId: json['transaction_id'],
      originalAmount: json['original_amount']?.toString(),
      discountAmount: json['discount_amount']?.toString(),
      finalAmount: json['final_amount']?.toString(),
      method: json['method'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'owner_id': ownerId,
      'service_booking_id': serviceBookingId,
      'coupons_id': couponsId,
      'transaction_id': transactionId,
      'original_amount': originalAmount,
      'discount_amount': discountAmount,
      'final_amount': finalAmount,
      'method': method,
      'status': status,
    };
  }
}