import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/api_endpoints.dart';

class LocationController extends GetxController {
  DateTime? _lastApiCallTime;

  Future<void> uploadLocation() async {
    try {
      const throttleDuration = Duration(seconds: 10);
      final now = DateTime.now();

      if (_lastApiCallTime != null &&
          now.difference(_lastApiCallTime!) < throttleDuration) {
        print("Skipping API call due to throttle.");
        return;
      }

      _lastApiCallTime = now;

      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert latitude and longitude to address using geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Assuming the first placemark contains the desired address details
      Placemark place = placemarks[0];

      // Construct the address string (or customize it as needed)
      String address =
          '${place.street},${place.subLocality}(${place.postalCode}),${place.locality},${place.administrativeArea},${place.country}';

      ApiClient().postGeoLocation(
        add: address,
        endPoint: ApiEndpoints.postGeoLocation,
        lat: position.latitude.toString(),
        long: position.longitude.toString(),
        // address: address, // Add the address here
      );

      // print("Location uploaded: $address");
    } catch (e) {
      print("Error during location upload: $e");
    }
  }
}
