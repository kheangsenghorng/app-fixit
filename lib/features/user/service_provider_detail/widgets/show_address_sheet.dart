import 'package:fixit/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/storage/token_storage.dart';
import '../../../../core/models/user_address_model.dart';
import '../../../auth/presentation/ui/login_sheet.dart';
import '../data/service/user_address_service.dart';

void showAddressSheet(
    BuildContext context, {
      required UserAddressService addressService,
      required Map<String, dynamic> providerData,
      required dynamic selectedPackage,
      required int id,
      required String name,
      required String image,
      required String selectedDate,
      required String selectedTime,
    }) {
  final parentContext = context;
  final theme = Theme.of(parentContext);
  final colorScheme = theme.colorScheme;

  final formKey = GlobalKey<FormState>();

  final TextEditingController houseController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoadingLocation = false;
  bool isSubmitting = false;
  bool isLoadingAddresses = true;
  bool hasLoadedAddresses = false;

  String? submitError;

  double? latitude;
  double? longitude;

  List<UserAddress> savedAddresses = [];
  int? selectedAddressId;

  Future<void> loadSavedAddresses(StateSetter setModalState) async {
    if (hasLoadedAddresses) return;

    hasLoadedAddresses = true;

    try {
      final token = await TokenStorage.get();

      if (token == null || token.isEmpty) {
        setModalState(() {
          isLoadingAddresses = false;
        });
        return;
      }

      final addresses = await addressService.getAddresses();

      if (!parentContext.mounted) return;

      setModalState(() {
        savedAddresses = addresses;
        isLoadingAddresses = false;
      });
    } catch (e) {
      if (!parentContext.mounted) return;

      setModalState(() {
        isLoadingAddresses = false;
        submitError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> handleLocationDetection(StateSetter setModalState) async {
    try {
      setModalState(() {
        isLoadingLocation = true;
        submitError = null;
        selectedAddressId = null;
      });

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setModalState(() {
          isLoadingLocation = false;
          submitError = "Location services are disabled.";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          setModalState(() {
            isLoadingLocation = false;
            submitError = "Location permission denied.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setModalState(() {
          isLoadingLocation = false;
          submitError =
          "Location permission denied forever. Please enable location in settings.";
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitude = position.latitude;
      longitude = position.longitude;

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!parentContext.mounted) return;

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        setModalState(() {
          houseController.text = place.subThoroughfare ?? "";
          streetController.text = place.thoroughfare ?? "";
          cityController.text = place.locality ?? "";

          addressController.text = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.country,
          ].where((item) {
            return item != null && item.trim().isNotEmpty;
          }).join(", ");

          isLoadingLocation = false;
        });
      } else {
        setModalState(() {
          isLoadingLocation = false;
          submitError = "Could not find address from current location.";
        });
      }
    } catch (e) {
      debugPrint("Location Error: $e");

      if (!parentContext.mounted) return;

      setModalState(() {
        isLoadingLocation = false;
        submitError = "Failed to detect location.";
      });
    }
  }

  void selectSavedAddress(
      UserAddress item,
      StateSetter setModalState,
      ) {
    setModalState(() {
      selectedAddressId = item.id;

      houseController.text = item.houseNumber ?? "";
      streetController.text = item.streetNumber ?? "";
      cityController.text = item.city ?? "";
      addressController.text = item.address;

      latitude = item.latitude;
      longitude = item.longitude;
      submitError = null;
    });
  }
  void clearFields() {
    selectedAddressId = null;

    houseController.clear();
    streetController.clear();
    cityController.clear();
    addressController.clear();

    latitude = null;
    longitude = null;
  }

// --- Logic: Delete Address ---
  Future<void> deleteSavedAddress(
      UserAddress item,
      StateSetter setModalState,
      ) async {
    if (item.id == null) {
      setModalState(() {
        submitError = "Address ID not found.";
      });
      return;
    }

    try {
      setModalState(() {
        isSubmitting = true;
        submitError = null;
      });

      await addressService.deleteAddress(item.id!);

      if (!parentContext.mounted) return;

      setModalState(() {
        savedAddresses.removeWhere(
              (address) => address.id == item.id,
        );

        if (selectedAddressId == item.id) {
          clearFields();
        }

        isSubmitting = false;
      });
    } catch (e) {
      if (!parentContext.mounted) return;

      setModalState(() {
        isSubmitting = false;
        submitError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

// --- UI: Modern Delete Confirmation ---
  Future<void> showModernDeleteConfirm(
      UserAddress item,
      StateSetter setModalState,
      ) async {
    if (!parentContext.mounted) return;

    final bool? confirm = await showModalBottomSheet<bool>(
      context: parentContext,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(bottomSheetContext).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 24),

                const Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.red,
                  size: 48,
                ),

                const SizedBox(height: 16),

                const Text(
                  "Delete Address?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Are you sure you want to remove this address?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(bottomSheetContext, false);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Keep it"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(bottomSheetContext, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text("Delete"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirm == true) {
      await deleteSavedAddress(item, setModalState);
    }
  }

  showModalBottomSheet(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (modalContext, setModalState) {
          Future.microtask(() {
            loadSavedAddresses(setModalState);
          });

          return Container(
            height: MediaQuery.of(sheetContext).size.height * 0.88,
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
                            onPressed: isSubmitting
                                ? null
                                : () {
                              Navigator.pop(sheetContext);
                            },
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
                        bottom:
                        MediaQuery.of(sheetContext).viewInsets.bottom + 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (submitError != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                colorScheme.errorContainer.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: colorScheme.error,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      submitError!,
                                      style: TextStyle(
                                        color: colorScheme.onErrorContainer,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Saved Addresses",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (savedAddresses.isNotEmpty)
                                Text(
                                  "${savedAddresses.length} Found",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          if (isLoadingAddresses)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (savedAddresses.isEmpty)
                            _buildEmptyState(colorScheme, theme)
                          else
                            Column(
                              children: savedAddresses.map((item) {
                                final isSelected =
                                    selectedAddressId == item.id;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Card(
                                    elevation: isSelected ? 2 : 0,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.outlineVariant
                                            .withOpacity(0.5),
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: isSubmitting
                                                ? null
                                                : () {
                                              selectSavedAddress(
                                                item,
                                                setModalState,
                                              );
                                            },
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? colorScheme.primary
                                                    .withOpacity(0.1)
                                                    : colorScheme
                                                    .surfaceVariant,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                item.isDefault
                                                    ? Icons.home_rounded
                                                    : Icons
                                                    .location_on_rounded,
                                                color: isSelected
                                                    ? colorScheme.primary
                                                    : colorScheme
                                                    .onSurfaceVariant,
                                                size: 20,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          Expanded(
                                            child: InkWell(
                                              onTap: isSubmitting
                                                  ? null
                                                  : () {
                                                selectSavedAddress(
                                                  item,
                                                  setModalState,
                                                );
                                              },
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 4,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            item.label ??
                                                                "Address",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style:
                                                            const TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        if (item.isDefault) ...[
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Container(
                                                            padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                              horizontal: 6,
                                                              vertical: 2,
                                                            ),
                                                            decoration:
                                                            BoxDecoration(
                                                              color: Colors
                                                                  .green
                                                                  .withOpacity(
                                                                  0.1),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  4),
                                                            ),
                                                            child: const Text(
                                                              "DEFAULT",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 9,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      item.address,
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: theme
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                        color: colorScheme
                                                            .onSurface
                                                            .withOpacity(0.6),
                                                      ),
                                                    ),
                                                    if (item.city != null &&
                                                        item.city!
                                                            .isNotEmpty) ...[
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        item.city!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: theme.textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                          color: colorScheme
                                                              .primary,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 8),

                                          IconButton(
                                            onPressed: isSubmitting
                                                ? null
                                                : () async {
                                              await showModernDeleteConfirm(
                                                item,
                                                setModalState,
                                              );
                                            },
                                            icon: Icon(
                                              Icons.delete_outline_rounded,
                                              color: colorScheme.error,
                                              size: 20,
                                            ),
                                            style: IconButton.styleFrom(
                                              backgroundColor: colorScheme.errorContainer.withOpacity(0.4),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          const SizedBox(height: 16),

                          InkWell(
                            onTap: isLoadingLocation || isSubmitting
                                ? null
                                : () {
                              handleLocationDetection(setModalState);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color:
                                colorScheme.primary.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                  colorScheme.primary.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isLoadingLocation)
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.my_location_rounded,
                                      color: colorScheme.primary,
                                      size: 20,
                                    ),
                                  const SizedBox(width: 12),
                                  Text(
                                    isLoadingLocation
                                        ? "Detecting..."
                                        : "Use Current Location",
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          Text(
                            "Address Details",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: _buildModernField(
                                  sheetContext,
                                  "House No.",
                                  "E.g. 12",
                                  houseController,
                                  enabled: !isSubmitting,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildModernField(
                                  sheetContext,
                                  "Street",
                                  "E.g. 5th Ave",
                                  streetController,
                                  enabled: !isSubmitting,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          _buildModernField(
                            sheetContext,
                            "City / Region",
                            "E.g. Phnom Penh",
                            cityController,
                            enabled: !isSubmitting,
                          ),

                          const SizedBox(height: 16),

                          _buildModernField(
                            sheetContext,
                            "Complete Address / Landmark",
                            "Building name, near X...",
                            addressController,
                            maxLines: 3,
                            enabled: !isSubmitting,
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
                        onPressed: isSubmitting
                            ? null
                            : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          setModalState(() {
                            isSubmitting = true;
                            submitError = null;
                          });

                          try {
                            String? token = await TokenStorage.get();

                            if (token == null || token.isEmpty) {
                              final loginSuccess =
                              await showModalBottomSheet<bool>(
                                context: sheetContext,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => const LoginSheet(),
                              );

                              if (loginSuccess != true) {
                                setModalState(() {
                                  isSubmitting = false;
                                });
                                return;
                              }

                              token = await TokenStorage.get();

                              if (token == null || token.isEmpty) {
                                setModalState(() {
                                  isSubmitting = false;
                                  submitError = "Please login first.";
                                });
                                return;
                              }
                            }

                            final houseNo =
                            houseController.text.trim();
                            final street =
                            streetController.text.trim();
                            final city = cityController.text.trim();
                            final detailAddress =
                            addressController.text.trim();

                            final fullAddress =
                                "$houseNo, $street, $city ($detailAddress)";

                            UserAddress? finalAddress;

                            if (selectedAddressId != null) {
                              finalAddress = savedAddresses.firstWhere(
                                    (item) => item.id == selectedAddressId,
                              );
                            } else {
                              final userAddress = UserAddress(
                                label: "Home",
                                streetNumber: street,
                                houseNumber: houseNo,
                                city: city,
                                address: fullAddress,
                                latitude: latitude,
                                longitude: longitude,
                                mapUrl: latitude != null &&
                                    longitude != null
                                    ? "https://maps.google.com/?q=$latitude,$longitude"
                                    : null,
                                isDefault: true,
                              );

                              finalAddress =
                              await addressService.createAddress(
                                userAddress,
                              );
                            }

                            if (!parentContext.mounted) return;

                            if (finalAddress == null) {
                              setModalState(() {
                                isSubmitting = false;
                                submitError =
                                "Failed to save address.";
                              });
                              return;
                            }

                            Navigator.of(
                              parentContext,
                              rootNavigator: true,
                            ).pushNamed(
                              AppRoutes.reviewSummary,
                              arguments: {
                                'providerData': providerData,
                                'selected_package': selectedPackage,

                                // address id
                                'address_id': finalAddress.id,
                                'user_address_id': finalAddress.id,

                                // full address object
                                'user_address': finalAddress.toJson(),

                                'house_no': finalAddress.houseNumber,
                                'street': finalAddress.streetNumber,
                                'city': finalAddress.city,
                                'address': finalAddress.address,
                                'latitude': finalAddress.latitude,
                                'longitude': finalAddress.longitude,
                                'map_url': finalAddress.mapUrl,

                                'date': selectedDate,
                                'time': selectedTime,
                                'name': name,
                                'image': image,
                                'id': id,
                              },
                            );
                            setModalState(() {
                              isSubmitting = false;
                            });
                          } catch (e) {
                            if (!parentContext.mounted) return;

                            setModalState(() {
                              isSubmitting = false;
                              submitError = e
                                  .toString()
                                  .replaceFirst('Exception: ', '');
                            });
                          }
                        },
                        child: isSubmitting
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
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
      bool enabled = true,
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
        enabled: enabled,
        maxLines: maxLines,
        style: theme.textTheme.bodyLarge,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Required field";
          }

          return null;
        },
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
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
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
            borderSide: BorderSide(
              color: theme.colorScheme.error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1.5,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildEmptyState(ColorScheme colorScheme, ThemeData theme) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
    ),
    child: Column(
      children: [
        Icon(
          Icons.location_off_outlined,
          color: colorScheme.outline,
          size: 40,
        ),
        const SizedBox(height: 12),
        Text(
          "No saved addresses yet",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.outline,
          ),
        ),
      ],
    ),
  );
}