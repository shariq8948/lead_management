import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;

  // Example locations with names and coordinates
  final Map<String, LatLng> _locations = {
    'Location A': LatLng(37.7749, -122.4194), // San Francisco
    'Location B': LatLng(34.0522, -118.2437), // Los Angeles
    'Location C': LatLng(40.7128, -74.0060),  // New York
  };

  // Marker list
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Creating markers for each location
    _markers = _locations.entries.map((entry) {
      return Marker(
        markerId: MarkerId(entry.key),
        position: entry.value,
        infoWindow: InfoWindow(title: entry.key),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Highlight color
      );
    }).toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Locations'),
        backgroundColor: Colors.teal,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Center the map on the first location
          zoom: 4.0,
        ),
        markers: _markers,
      ),
    );
  }
}
