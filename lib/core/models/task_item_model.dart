class TaskItem {
  final int id;
  final int taskGroupId;
  final String title;
  final String description;
  final int sortOrder;
  final String status;
  final DateTime createdAt;

  TaskItem({
    required this.id,
    required this.taskGroupId,
    required this.title,
    required this.description,
    required this.sortOrder,
    required this.status,
    required this.createdAt,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      taskGroupId: int.tryParse(json['task_group_id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      sortOrder: int.tryParse(json['sort_order']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_group_id': taskGroupId,
      'title': title,
      'description': description,
      'sort_order': sortOrder,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}