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
  final String? streetNumber;
  final String? houseNumber;
  final String? bookingDate;
  final String? bookingHours;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? mapUrl;
  final int quantity;
  final String? notes;
  final String? bookingStatus;
  final String? customerStatus;
  final String? customerCompletedAt;
  final String? autoCompleteAt;
  final String? createdAt;
  final String? updatedAt;
  final BookingUser? user;
  final BookingService? service;
  final List<Payment> payment;

  ServiceBooking({
    required this.id,
    required this.userId,
    required this.serviceId,
    this.streetNumber,
    this.houseNumber,
    this.bookingDate,
    this.bookingHours,
    this.address,
    this.latitude,
    this.longitude,
    this.mapUrl,
    required this.quantity,
    this.notes,
    this.bookingStatus,
    this.customerStatus,
    this.customerCompletedAt,
    this.autoCompleteAt,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.service,
    required this.payment,
  });

  factory ServiceBooking.fromJson(Map<String, dynamic> json) {
    return ServiceBooking(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      serviceId: json['service_id'] ?? 0,
      streetNumber: json['street_number'],
      houseNumber: json['house_number'],
      bookingDate: json['booking_date'],
      bookingHours: json['booking_hours'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      mapUrl: json['map_url'],
      quantity: json['quantity'] ?? 0,
      notes: json['notes'],
      bookingStatus: json['booking_status'],
      customerStatus: json['customer_status'],
      customerCompletedAt: json['customer_completed_at'],
      autoCompleteAt: json['auto_complete_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? BookingUser.fromJson(json['user']) : null,
      service: json['service'] != null
          ? BookingService.fromJson(json['service'])
          : null,
      payment: (json['payment'] as List<dynamic>? ?? [])
          .map((e) => Payment.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'street_number': streetNumber,
      'house_number': houseNumber,
      'booking_date': bookingDate,
      'booking_hours': bookingHours,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'map_url': mapUrl,
      'quantity': quantity,
      'notes': notes,
      'booking_status': bookingStatus,
      'customer_status': customerStatus,
      'customer_completed_at': customerCompletedAt,
      'auto_complete_at': autoCompleteAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
      'service': service?.toJson(),
      'payment': payment.map((e) => e.toJson()).toList(),
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
  final String? createdAt;
  final String? updatedAt;

  BookingUser({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    required this.isActive,
    this.emailVerifiedAt,
    this.avatar,
    this.createdAt,
    this.updatedAt,
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class BookingService {
  final int id;
  final String? name;
  final int categoryId;
  final int typeId;
  final ServiceCategory? category;
  final ServiceType? type;

  BookingService({
    required this.id,
    this.name,
    required this.categoryId,
    required this.typeId,
    this.category,
    this.type,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) {
    return BookingService(
      id: json['id'] ?? 0,
      name: json['name'],
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
      'category_id': categoryId,
      'type_id': typeId,
      'category': category?.toJson(),
      'type': type?.toJson(),
    };
  }
}

class ServiceCategory {
  final int id;
  final String? name;
  final String? categoryGroup;
  final String? status;
  final String? icon;
  final String? createdAt;
  final String? updatedAt;

  ServiceCategory({
    required this.id,
    this.name,
    this.categoryGroup,
    this.status,
    this.icon,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] ?? 0,
      name: json['name'],
      categoryGroup: json['category_group'],
      status: json['status'],
      icon: json['icon'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_group': categoryGroup,
      'status': status,
      'icon': icon,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ServiceType {
  final int id;
  final int categoryId;
  final String? name;
  final String? icon;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  ServiceType({
    required this.id,
    required this.categoryId,
    this.name,
    this.icon,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      name: json['name'],
      icon: json['icon'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'icon': icon,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
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
      originalAmount: json['original_amount'],
      discountAmount: json['discount_amount'],
      finalAmount: json['final_amount'],
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