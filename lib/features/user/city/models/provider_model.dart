import 'package:flutter/material.dart';

class ProviderModel {
  final String name;
  final String category;
  final String city;
  final double rating;
  final Color bgColor;
  final String buttonText;

  // 📍 GPS location
  final double latitude;
  final double longitude;

  ProviderModel({
    required this.name,
    required this.category,
    required this.city,
    required this.rating,
    required this.bgColor,
    required this.latitude,
    required this.longitude,
    this.buttonText = "Details",
  });
}
