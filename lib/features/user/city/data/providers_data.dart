import 'package:flutter/material.dart';
import '../models/provider_model.dart';

final electricianData = [
  ProviderModel(
    name: "Jackson",
    category: "Electrician",
    city: "New York",
    rating: 4.3,
    bgColor: Colors.purple,
    latitude: 40.7128,
    longitude: -74.0060,
  ),
  ProviderModel(
    name: "Emily",
    category: "Electrician",
    city: "Chicago",
    rating: 4.8,
    bgColor: Colors.orange,
    latitude: 11.5664,
    longitude: 104.8804,
  ),
];

final plumberData = [
  ProviderModel(
    name: "Ethan",
    category: "Plumber",
    city: "New York",
    rating: 4.7,
    bgColor: Colors.green,
    latitude: 40.7130,
    longitude: -74.0055,
  ),
];

final painterData = [
  ProviderModel(
    name: "Lucas",
    category: "Painter",
    city: "Chicago",
    rating: 4.4,
    bgColor: Colors.pink,
    latitude: 41.8818,
    longitude: -87.6231,
  ),
];
