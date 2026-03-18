import 'package:fixit/core/models/service_image_model.dart';
import 'package:fixit/core/models/type_model.dart';

import 'category_model.dart';
import 'owner_model.dart';

class Service {
  final int id;
  final Owner owner;
  final Category category;
  final TypeModel type;
  final String title;
  final String description;
  final String status;
  final String basePrice;
  final int duration;
  final List<ServiceImage> images;
  final DateTime createdAt;

  Service({
    required this.id,
    required this.owner,
    required this.category,
    required this.type,
    required this.title,
    required this.description,
    required this.status,
    required this.basePrice,
    required this.duration,
    required this.images,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      owner: Owner.fromJson(json['owner']),
      category: Category.fromJson(json['category']),
      type: TypeModel.fromJson(json['type']),
      title: json['title'],
      description: json['description'],
      status: json['status'],
      basePrice: json['base_price'],
      duration: json['duration'],
      images: (json['images'] as List)
          .map((e) => ServiceImage.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}