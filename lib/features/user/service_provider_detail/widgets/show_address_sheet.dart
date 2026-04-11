import 'package:fixit/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/storage/token_storage.dart';
import '../../../auth/presentation/ui/login_sheet.dart';

void showAddressSheet(
    BuildContext context, {
      required Map<String, dynamic> providerData,
      required int id,
      required String name,
      required String image,
      required String selectedDate,
      required String selectedTime,
    }) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final formKey = GlobalKey<FormState>();

  final TextEditingController houseController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoadingLocation = false;

  double? latitude;
  double? longitude;

  Future<void> handleLocationDetection(StateSetter setModalState) async {
    try {
      setModalState(() => isLoadingLocation = true);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setModalState(() => isLoadingLocation = false);
        debugPrint("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setModalState(() => isLoadingLocation = false);
          debugPrint("Location permission denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setModalState(() => isLoadingLocation = false);
        debugPrint("Location permission denied forever.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        setModalState(() {
          houseController.text = place.subThoroughfare ?? "";
          streetController.text = place.thoroughfare ?? "";
          cityController.text = place.locality ?? "";
          addressController.text =
          "${place.street ?? ""}, ${place.subLocality ?? ""}, ${place.locality ?? ""} ${place.postalCode ?? ""}";
          isLoadingLocation = false;
        });
      } else {
        setModalState(() => isLoadingLocation = false);
      }
    } catch (e) {
      debugPrint("Location Error: $e");
      setModalState(() => isLoadingLocation = false);
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                            ),
                            color: colorScheme.primary,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "Booking Address",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: isLoadingLocation
                                ? null
                                : () => handleLocationDetection(setModalState),
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isLoadingLocation)
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colorScheme.primary,
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.gps_fixed,
                                      color: colorScheme.primary,
                                      size: 20,
                                    ),
                                  const SizedBox(width: 12),
                                  Text(
                                    isLoadingLocation
                                        ? "Locating..."
                                        : "Detect Current Location",
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),
                          Text(
                            "Address Details",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildModernField(
                                  context,
                                  "House No.",
                                  "E.g. 12",
                                  houseController,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildModernField(
                                  context,
                                  "Street",
                                  "E.g. 5th Ave",
                                  streetController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          _buildModernField(
                            context,
                            "City / Region",
                            "E.g. New York",
                            cityController,
                          ),
                          const SizedBox(height: 20),

                          _buildModernField(
                            context,
                            "Complete Address",
                            "Landmark, Apartment, etc.",
                            addressController,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          var token = await TokenStorage.get();

                          if (token == null || token.isEmpty) {
                            final loginSuccess = await showModalBottomSheet<bool>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const LoginSheet(),
                            );

                            if (loginSuccess != true) return;

                            token = await TokenStorage.get();
                            if (token == null || token.isEmpty) return;
                          }

                          if (!context.mounted) return;

                          Navigator.pop(context);
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.reviewSummary,
                            arguments: {
                              'providerData': providerData,
                              'house_no': houseController.text,
                              'street': streetController.text,
                              'address':
                              "${houseController.text}, ${streetController.text}, ${cityController.text} (${addressController.text})",
                              'latitude': latitude,
                              'longitude': longitude,
                              'map_url': 'https://maps.google.com/?q=$latitude,$longitude',
                              'date': selectedDate,
                              'time': selectedTime,
                              'name': name,
                              'image': image,
                              'id': id,
                            },
                          );
                        },
                        child: const Text(
                          "Confirm & Next",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildModernField(
    BuildContext context,
    String label,
    String hint,
    TextEditingController controller, {
      int maxLines = 1,
    }) {
  final theme = Theme.of(context);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: theme.textTheme.bodyLarge,
        validator: (value) =>
        (value == null || value.isEmpty) ? "Required field" : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          filled: true,
          fillColor:
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),
        ),
      ),
    ],
  );
}