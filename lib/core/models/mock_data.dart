import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String name;
  final IconData icon;
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class ServiceTypeModel {
  final int id;
  final int categoryId;
  final String name;
  final String image;
  final int availableServices;

  ServiceTypeModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.image,
    required this.availableServices,
  });
}