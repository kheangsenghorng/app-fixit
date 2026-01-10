import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/provider_model.dart';

class ProvidersMapScreen extends StatefulWidget {
  final List<ProviderModel> providers;
  final double userLat;
  final double userLng;

  const ProvidersMapScreen({
    super.key,
    required this.providers,
    required this.userLat,
    required this.userLng,
  });

  @override
  State<ProvidersMapScreen> createState() => _ProvidersMapScreenState();
}

class _ProvidersMapScreenState extends State<ProvidersMapScreen> {
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    // 👤 USER MARKER
    markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: LatLng(widget.userLat, widget.userLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
    );

    // 🧑‍🔧 PROVIDERS
    for (final provider in widget.providers) {
      markers.add(
        Marker(
          markerId: MarkerId(
            '${provider.name}_${provider.latitude}_${provider.longitude}',
          ),
          position: LatLng(provider.latitude, provider.longitude),
          infoWindow: InfoWindow(
            title: provider.name,
            snippet: provider.category,
          ),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Providers Map"),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },

        // 🎯 CAMERA
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.userLat, widget.userLng),
          zoom: 13,
        ),

        // 📍 FEATURES
        markers: _buildMarkers(),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}
