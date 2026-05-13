import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_provider.dart';
import '../../../../../core/models/user_address_model.dart';
import '../service/user_address_service.dart';

final userAddressServiceProvider = Provider<UserAddressService>((ref) {
  final dio = ref.watch(dioProvider);
  return UserAddressService(dio);
});

class UserAddressState {
  final bool loading;
  final bool creating;
  final bool updating;
  final bool deleting;
  final String? error;
  final List<UserAddress> addresses;
  final UserAddress? selectedAddress;

  const UserAddressState({
    this.loading = false,
    this.creating = false,
    this.updating = false,
    this.deleting = false,
    this.error,
    this.addresses = const [],
    this.selectedAddress,
  });

  bool get isEmpty => !loading && addresses.isEmpty;

  UserAddressState copyWith({
    bool? loading,
    bool? creating,
    bool? updating,
    bool? deleting,
    String? error,
    bool clearError = false,
    List<UserAddress>? addresses,
    UserAddress? selectedAddress,
    bool clearSelectedAddress = false,
  }) {
    return UserAddressState(
      loading: loading ?? this.loading,
      creating: creating ?? this.creating,
      updating: updating ?? this.updating,
      deleting: deleting ?? this.deleting,
      error: clearError ? null : error ?? this.error,
      addresses: addresses ?? this.addresses,
      selectedAddress: clearSelectedAddress
          ? null
          : selectedAddress ?? this.selectedAddress,
    );
  }
}

class UserAddressNotifier extends StateNotifier<UserAddressState> {
  final UserAddressService service;

  UserAddressNotifier(this.service) : super(const UserAddressState());

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<void> getAddresses() async {
    state = state.copyWith(
      loading: true,
      clearError: true,
    );

    try {
      final addresses = await service.getAddresses();

      state = state.copyWith(
        loading: false,
        addresses: addresses,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: _cleanError(e),
      );
    }
  }

  Future<UserAddress?> createAddress(UserAddress address) async {
    state = state.copyWith(
      creating: true,
      clearError: true,
    );

    try {
      final createdAddress = await service.createAddress(address);

      if (createdAddress == null) {
        state = state.copyWith(
          creating: false,
          error: 'Failed to create address',
        );

        return null;
      }

      state = state.copyWith(
        creating: false,
        selectedAddress: createdAddress,
        addresses: [
          createdAddress,
          ...state.addresses,
        ],
      );

      return createdAddress;
    } catch (e) {
      state = state.copyWith(
        creating: false,
        error: _cleanError(e),
      );

      return null;
    }
  }

  Future<UserAddress?> updateAddress({
    required int id,
    required UserAddress address,
  }) async {
    state = state.copyWith(
      updating: true,
      clearError: true,
    );

    try {
      final updatedAddress = await service.updateAddress(
        id: id,
        address: address,
      );

      if (updatedAddress == null) {
        state = state.copyWith(
          updating: false,
          error: 'Failed to update address',
        );

        return null;
      }

      final updatedList = state.addresses.map((item) {
        if (item.id == id) {
          return updatedAddress;
        }

        return item;
      }).toList();

      state = state.copyWith(
        updating: false,
        selectedAddress: updatedAddress,
        addresses: updatedList,
      );

      return updatedAddress;
    } catch (e) {
      state = state.copyWith(
        updating: false,
        error: _cleanError(e),
      );

      return null;
    }
  }

  Future<bool> deleteAddress(int id) async {
    state = state.copyWith(
      deleting: true,
      clearError: true,
    );

    try {
      final success = await service.deleteAddress(id);

      if (!success) {
        state = state.copyWith(
          deleting: false,
          error: 'Failed to delete address',
        );

        return false;
      }

      state = state.copyWith(
        deleting: false,
        addresses: state.addresses
            .where((address) => address.id != id)
            .toList(),
        clearSelectedAddress: state.selectedAddress?.id == id,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        deleting: false,
        error: _cleanError(e),
      );

      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final userAddressProvider =
StateNotifierProvider<UserAddressNotifier, UserAddressState>((ref) {
  final service = ref.watch(userAddressServiceProvider);
  return UserAddressNotifier(service);
});