import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as location;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(52.22977, 21.01178),
    zoom: 14.4746,
  );

  final location.Location _location = location.Location();
  String _currentLocationText = "Włącz lokalizacje";
  bool _isLocationGranted = false;
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.location.isGranted) {
      _setCurrentLocation();
    } else {
      PermissionStatus status = await Permission.location.request();
      if (status.isGranted) {
        _setCurrentLocation();
      }
    }
  }

  Future<void> _setCurrentLocation() async {
    _location.changeSettings(accuracy: location.LocationAccuracy.low);

    final currentLocation = await _location.getLocation();
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(
      currentLocation.latitude!,
      currentLocation.longitude!,
    );

    setState(() {
      _isLocationGranted = true;
      _initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 14.4746,
      );

      geocoding.Placemark place = placemarks[0];
      _currentLocationText = "${place.street}, ${place.locality}";
    });

    final controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: _isLocationGranted,
            myLocationButtonEnabled: _isLocationGranted,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Planowanie trasy",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 4),
                Text(_currentLocationText),
              ]),
              const SizedBox(height: 16),
              const Row(children: [
                Icon(Icons.flag),
                SizedBox(width: 4),
                Text("Lokalizacja końcowa: Puta Barca"),
              ]),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.bottomRight,
                child: FilledButton(
                  onPressed: null,
                  child: Text("Rozpocznij"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
