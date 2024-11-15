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
  List<LatLng> routePoints = [];
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
  bool _isRideActive = false;
  Timer? _timer;
  int _secondsElapsed = 0;
  final List<LatLng> _rideRoutePoints = [];

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
    _drawRoute();
  }

  Future<void> _drawRoute() async {
    final start = _routeSelectionData.currentCoordinates;
    final destination = _routeSelectionData.destinationCoordinates;

    if (start == null || destination == null) return;

    final route = await fetchRoute(start, destination);

    if (route == null) return;

    setState(() {
      _routeSelectionData.routePoints = route;
    });
  }

  void _startRide() {
    setState(() {
      _isRideActive = true;
      _secondsElapsed = 0;
      _rideRoutePoints.clear();
    });

    // Śledzenie lokalizacji podczas przejazdu
    _location.onLocationChanged.listen((locationData) async {
      if (!_isRideActive) return;

      final newPoint = LatLng(locationData.latitude!, locationData.longitude!);
      setState(() {
        _rideRoutePoints.add(newPoint);
      });

      // Aktualizacja kamery, aby śledzić aktualną pozycję
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(newPoint));
    });

    // Uruchomienie licznika czasu przejazdu
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopRide() {
    setState(() {
      _isRideActive = false;
    });
    _timer?.cancel();
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
            mapToolbarEnabled: false,
            markers: _routeSelectionData.destinationCoordinates != null
                ? {
                    Marker(
                        markerId: const MarkerId('destination'),
                        position: _routeSelectionData.destinationCoordinates!)
                  }
                : {},
            polylines: {
              if (_routeSelectionData.routePoints.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('route'),
                  color: Colors.green,
                  width: 5,
                  points: _routeSelectionData.routePoints,
                ),
              if (_rideRoutePoints.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('ride'),
                  color: Colors.blue,
                  width: 5,
                  points: _rideRoutePoints,
                ),
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Planowanie trasy",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 4),
                  Text(_routeSelectionData.currentLocationText),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.flag),
                  const SizedBox(width: 4),
                  Text(_routeSelectionData.destinationLocationText),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _isRideActive
                      ? Text(
                          "Czas przejazdu: ${_secondsElapsed ~/ 60} min ${_secondsElapsed % 60} sek",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      : const Text(
                          "",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _isRideActive
                      ? OutlinedButton(
                          onPressed: _stopRide,
                          child: const Text("Zakończ"),
                        )
                      : FilledButton(
                          onPressed: _startRide,
                          child: const Text("Rozpocznij"),
                        )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
