import 'dart:convert';

class Category {
  final int id;
  final String name;
  final String group;
  final String status;
  final String icon;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.group,
    required this.status,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      group: json['group'],
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
      'group': group,
      'status': status,
      'icon': icon,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static String encodeList(List<Category> categories) {
    return jsonEncode(
      categories.map((e) => e.toJson()).toList(),
    );
  }

  static List<Category> decodeList(String source) {
    final List data = jsonDecode(source);
    return data
        .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}