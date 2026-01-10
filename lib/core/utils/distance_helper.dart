import 'package:geolocator/geolocator.dart';
import '../../features/user/city/models/provider_model.dart';


List<ProviderModel> sortByNearest({
  required List<ProviderModel> providers,
  required double userLat,
  required double userLng,
}) {
  providers.sort((a, b) {
    final d1 = Geolocator.distanceBetween(
      userLat,
      userLng,
      a.latitude,
      a.longitude,
    );
    final d2 = Geolocator.distanceBetween(
      userLat,
      userLng,
      b.latitude,
      b.longitude,
    );
    return d1.compareTo(d2);
  });

  return providers;
}
