import 'package:fixit/core/models/task_group_model.dart';

import 'included_item_model.dart';

class ServicePackage {
  final int id;
  final int serviceId;
  final String title;
  final String description;
  final int? minArea;
  final int? maxArea;
  final int floorNumber;
  final int bedrooms;
  final String durationHours;
  final int workersCount;
  final String price;
  final String billingType;
  final String status;
  final List<TaskGroup> taskGroups;
  final List<IncludedItem> includedItems;
  final DateTime createdAt;

  ServicePackage({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.minArea,
    required this.maxArea,
    required this.floorNumber,
    required this.bedrooms,
    required this.durationHours,
    required this.workersCount,
    required this.price,
    required this.billingType,
    required this.status,
    required this.taskGroups,
    required this.includedItems,
    required this.createdAt,
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      serviceId: int.tryParse(json['service_id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      minArea: double.tryParse(json['min_area_m2']?.toString() ?? '')?.toInt(),
      maxArea: double.tryParse(json['max_area_m2']?.toString() ?? '')?.toInt(),
      floorNumber: int.tryParse(json['floor_number']?.toString() ?? '') ?? 0,
      bedrooms: int.tryParse(json['bedrooms']?.toString() ?? '') ?? 0,
      durationHours: json['duration_hours']?.toString() ?? '',
      workersCount: int.tryParse(json['workers_count']?.toString() ?? '') ?? 0,
      price: json['price']?.toString() ?? '',
      billingType: json['billing_type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      taskGroups: (json['task_groups'] as List? ?? [])
          .map(
            (e) => TaskGroup.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),
      includedItems: (json['included_items'] as List? ?? [])
          .map(
            (e) => IncludedItem.fromJson(
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
      'service_id': serviceId,
      'title': title,
      'description': description,
      'min_area_m2': minArea,
      'max_area_m2': maxArea,
      'floor_number': floorNumber,
      'bedrooms': bedrooms,
      'duration_hours': durationHours,
      'workers_count': workersCount,
      'price': price,
      'billing_type': billingType,
      'status': status,
      'task_groups': taskGroups.map((e) => e.toJson()).toList(),
      'included_items': includedItems.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}