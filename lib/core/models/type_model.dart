

import 'category_model.dart';

class TypeModel {
  final int id;
  final String name;
  final String icon;
  final String status;
  final String createdAt;
  final Category category;

  TypeModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.status,
    required this.createdAt,
    required this.category,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(
      id: json['id'],
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      category: Category.fromJson(json['category']),
    );
  }
}