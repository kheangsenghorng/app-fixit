import 'category_model.dart';

class TypeModel {
  final int id;
  final String name;
  final String icon;
  final String status;
  final String createdAt;
  final Category? category;

  const TypeModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.status,
    required this.createdAt,
    this.category,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'status': status,
      'created_at': createdAt,
      'category': category?.toJson(),
    };
  }
}