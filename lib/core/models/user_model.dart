class UserModel {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String role;
  final bool isActive;
  final String? emailVerifiedAt;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    this.emailVerifiedAt,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      isActive: json['is_active'] == true,
      emailVerifiedAt: json['email_verified_at'],
      avatar: json['avatar'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}