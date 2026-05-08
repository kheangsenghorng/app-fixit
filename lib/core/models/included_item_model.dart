class IncludedItem {
  final int id;
  final int serviceId;
  final String name;
  final String description;
  final String imageUrl;
  final String status;
  final int sortOrder;
  final DateTime createdAt;

  IncludedItem({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.sortOrder,
    required this.createdAt,
  });

  factory IncludedItem.fromJson(Map<String, dynamic> json) {
    return IncludedItem(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      serviceId: int.tryParse(json['service_id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      sortOrder: int.tryParse(json['sort_order']?.toString() ?? '') ?? 0,
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
      'image_url': imageUrl,
      'status': status,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }
}