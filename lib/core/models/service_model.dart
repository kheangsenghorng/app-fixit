import 'dart:convert';

import 'package:fixit/core/models/service_image_model.dart';
import 'package:fixit/core/models/service_package_model.dart';

import 'package:fixit/core/models/type_model.dart';

import 'category_model.dart';
import 'owner_model.dart';

class Service {
  final int id;
  final Owner owner;
  final Category category;
  final TypeModel type;
  final List<ServicePackage> servicePackages;
  final String title;
  final String description;
  final String status;
  final List<ServiceImage> images;
  final DateTime createdAt;

  Service({
    required this.id,
    required this.owner,
    required this.category,
    required this.type,
    required this.servicePackages,
    required this.title,
    required this.description,
    required this.status,
    required this.images,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      owner: Owner.fromJson(
        Map<String, dynamic>.from(json['owner'] ?? {}),
      ),
      category: Category.fromJson(
        Map<String, dynamic>.from(json['category'] ?? {}),
      ),
      type: TypeModel.fromJson(
        Map<String, dynamic>.from(json['type'] ?? {}),
      ),
      servicePackages: (json['service_packages'] as List? ?? [])
          .map(
            (e) => ServicePackage.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      images: (json['images'] as List? ?? [])
          .map(
            (e) => ServiceImage.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner.toJson(),
      'category': category.toJson(),
      'type': type.toJson(),
      'service_packages': servicePackages.map((e) => e.toJson()).toList(),
      'title': title,
      'description': description,
      'status': status,
      'images': images.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  static String encodeList(List<Service> services) {
    return jsonEncode(services.map((e) => e.toJson()).toList());
  }

  static List<Service> decodeList(String raw) {
    final List data = jsonDecode(raw);

    return data
        .map(
          (e) => Service.fromJson(
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }
}