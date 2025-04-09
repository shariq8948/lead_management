import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LiveMapScreen extends StatefulWidget {
  @override
  _LiveMapScreenState createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users");
  Timer? _locationUpdateTimer;
  double currentLat = 19.1533691; // Default starting latitude
  double currentLong = 72.8841954; // Default starting longitude
  late MapController _mapController;

  // List to store the polyline points
  List<LatLng> polylinePoints = [];

  @override
  void initState() {
    super.initState();

    _mapController = MapController();

    // Start a timer to update location continuously
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      updateMyLocation(); // Call method to update location every 5 seconds
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> updateMyLocation() async {
    print("Started updating location");

    final userId = "user1"; // Example user ID

    // Get the current location from the device
    Position position = await _getCurrentLocation();
    currentLat = position.latitude;
    currentLong = position.longitude;

    final newLocation = LatLng(currentLat, currentLong);

    // Update the user's location in Firebase
    try {
      await _dbRef.child(userId).set({
        "lat": newLocation.latitude,
        "long": newLocation.longitude,
        "name": "User demo", // You can add any user-related info
      });

      print("Updated location for $userId: $newLocation");

      // Add the new location to the polyline points
      polylinePoints.add(newLocation);

      // Only update the UI if the widget is still mounted
      if (mounted) {
        setState(() {
          // Update the map center to the current position
          _mapController.move(
              newLocation, 16.0); // Move map center to the new location
        });
      }
    } catch (e) {
      print(
          "Error updating location: ${e.toString()}"); // Print the error to understand what went wrong
    }
  }

  // Method to get current location
  Future<Position> _getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return Future.error("Location services are disabled.");
    }

    // Check and request permission to access location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission denied forever');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live User Tracking"),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter:
              LatLng(currentLat, currentLong), // Initial center of the map
          initialZoom: 16.0, // Initial zoom level
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 50,
                height: 50,
                point:
                    LatLng(currentLat, currentLong), // Updated location point
                child: Icon(
                  Icons.location_pin,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ],
          ),
          // Add PolylineLayer to display the path
          PolylineLayer(
            polylines: [
              Polyline(
                points: polylinePoints, // List of points for the polyline
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
