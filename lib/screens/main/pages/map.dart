import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackathon_rower/util/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as location;

class RouteSelectionData {
  String currentLocationText = "";
  String destinationLocationText = "";
  LatLng? currentCoordinates;
  LatLng? destinationCoordinates;
}

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
    zoom: 6,
  );

  final location.Location _location = location.Location();
  final RouteSelectionData _routeSelectionData = RouteSelectionData();
  bool _isLocationGranted = false;

  List<LatLng> _routePoints = [];

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
    String locationName = await getLocationFromCoordinates(
        LatLng(currentLocation.latitude!, currentLocation.longitude!));
    setState(() {
      _isLocationGranted = true;
      _initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 14.4746,
      );

      _routeSelectionData.currentLocationText = locationName;
      _routeSelectionData.currentCoordinates =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
    });

    final controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
  }

  Future<void> _setDestinationLocation(LatLng coordinates) async {
    String locationName = await getLocationFromCoordinates(coordinates);

    setState(() {
      _routeSelectionData.destinationLocationText = locationName;
      _routeSelectionData.destinationCoordinates = coordinates;
    });
  }

  Future<void> _drawRoute() async {
    final start = _routeSelectionData.currentCoordinates;
    final destination = _routeSelectionData.destinationCoordinates;

    if (start == null || destination == null) return;

    final route = await fetchRoute(start, destination);

    if (route == null) return;

    setState(() {
      _routePoints = route;
    });
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
            onTap: _setDestinationLocation,
            markers: _routeSelectionData.destinationCoordinates != null
                ? {
                    Marker(
                        markerId: const MarkerId('destination'),
                        position: _routeSelectionData.destinationCoordinates!)
                  }
                : {},
            polylines: _routePoints.isNotEmpty
                ? {
                    Polyline(
                      polylineId: const PolylineId('route'),
                      color: Colors.green,
                      width: 5,
                      points: _routePoints,
                    )
                  }
                : {},
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
                Text(_routeSelectionData.currentLocationText),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                const Icon(Icons.flag),
                const SizedBox(width: 4),
                Text(_routeSelectionData.destinationLocationText),
              ]),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                    onPressed: _drawRoute,
                    child: const Text("Wyznacz trasę"),
                  ),
                  FilledButton(
                    onPressed: () {
                      print("Akcja rozpocznij");
                    },
                    child: const Text("Rozpocznij"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
