class ProviderModel {
  final String name;
  final String category;
  final String imageUrl;
  final String rating;
  final Map<String, dynamic> rawData;

  ProviderModel({
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.rawData,
  });

  // ADD THIS METHOD TO FIX THE ERROR
  factory ProviderModel.fromArguments(dynamic args) {
    final Map<String, dynamic> data = (args is Map<String, dynamic>) ? args : {};

    return ProviderModel(
      name: data['name'] ?? "Emily Jani",
      category: data['category'] ?? "Plumber",
      imageUrl: data['image'] ?? 'assets/images/providers/img.png',
      rating: data['rating']?.toString() ?? "4.9",
      rawData: data, // Stores the full map for the booking button
    );
  }
}