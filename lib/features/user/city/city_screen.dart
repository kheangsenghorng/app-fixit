import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/provider/geocoding_service.dart';
import '../../../core/provider/location_service.dart';
import '../../../core/utils/distance_helper.dart';
import 'data/providers_data.dart';
import 'models/provider_model.dart';
import 'widgets/category_filter.dart';
import 'widgets/provider_section.dart';
import 'map/providers_map_screen.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  StreamSubscription<Position>? _positionStream;

  String _selectedCategory = "All";
  String _selectedCity = "All";

  final bool _nearMeOnly = false;
  double? _userLat;
  double? _userLng;

  bool _shouldShow(String category) =>
      _selectedCategory == "All" || _selectedCategory == category;

  List<ProviderModel> _filterByCity(List<ProviderModel> providers) {
    if (_selectedCity == "All") return providers;
    return providers.where((p) => p.city == _selectedCity).toList();
  }

  List<ProviderModel> _applyFilters(List<ProviderModel> providers) {
    var list = _filterByCity(providers);

    if (_nearMeOnly && _userLat != null && _userLng != null) {
      list = sortByNearest(
        providers: list,
        userLat: _userLat!,
        userLng: _userLng!,
      );
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  Future<void> _startLocationTracking() async {
    final allowed = await LocationService.ensurePermission();
    if (!allowed) return;

    _positionStream = LocationService.positionStream().listen(
          (position) async {
        setState(() {
          _userLat = position.latitude;
          _userLng = position.longitude;
        });

        final city = await GeocodingService.getCityFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (city != null && city != _selectedCity) {
          setState(() => _selectedCity = city);
        }
      },
      onError: (e) {
        debugPrint("Location stream error: $e");
      },
    );
  }


  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Service Providers"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _userLat == null || _userLng == null
                ? null
                : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProvidersMapScreen(
                    providers: _applyFilters(electricianData),
                    userLat: _userLat!,
                    userLng: _userLng!,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryFilter(
              selectedCategory: _selectedCategory,
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 30),

            if (_shouldShow("Electrician"))
              ProviderSection(
                title: "Electricians",
                providers: _applyFilters(electricianData),
              ),
            if (_shouldShow("Plumber"))
              ProviderSection(
                title: "Plumbers",
                providers: _applyFilters(plumberData),
              ),
            if (_shouldShow("Painter"))
              ProviderSection(
                title: "Painters",
                providers: _applyFilters(painterData),
              ),
          ],
        ),
      ),
    );
  }
}
