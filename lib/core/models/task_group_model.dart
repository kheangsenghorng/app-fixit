import 'package:fixit/core/models/task_item_model.dart';

class TaskGroup {
  final int id;
  final int serviceId;
  final String name;
  final String description;
  final String status;
  final int sortOrder;
  final List<TaskItem> taskItems;
  final DateTime createdAt;

  TaskGroup({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.description,
    required this.status,
    required this.sortOrder,
    required this.taskItems,
    required this.createdAt,
  });

  factory TaskGroup.fromJson(Map<String, dynamic> json) {
    return TaskGroup(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      serviceId: int.tryParse(json['service_id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      sortOrder: int.tryParse(json['sort_order']?.toString() ?? '') ?? 0,
      taskItems: (json['task_items'] as List? ?? [])
          .map(
            (e) => TaskItem.fromJson(
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
      'name': name,
      'description': description,
      'status': status,
      'sort_order': sortOrder,
      'task_items': taskItems.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}