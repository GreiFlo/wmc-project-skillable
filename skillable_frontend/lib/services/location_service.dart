import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService();

  //AI Prompt 5
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // 2. Check for permissions.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // 3. Get the current position
    return await Geolocator.getCurrentPosition();
  }
}
