import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hackathon_rower/screens/main/screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
      )),
    );
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController mapController;
  LatLng? _markerPosition;
  final LatLng _initialCenter = const LatLng(52.2297700, 21.0117800);
  bool _isLocationSelected = false;
  String? _selectedLocationAddress;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> checkLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<String?> getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return '${placemark.locality}, ${placemark.country}';
      }
    } catch (e) {
      print('Błąd podczas geokodowania: $e');
    }
    return 'Adres nie znaleziony';
  }

  Future<void> _setMarker() async {
    if (!_isLocationSelected) {
      final LatLngBounds bounds = await mapController.getVisibleRegion();
      final LatLng center = LatLng(
          (bounds.northeast.latitude + bounds.southwest.latitude) / 2 + 0.003,
          (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

      print('Współrzędne: (${center.latitude}, ${center.longitude})');

      setState(() {
        _markerPosition = center;
        _isLocationSelected = true;
      });

      _selectedLocationAddress =
          await getAddressFromLatLng(center.latitude, center.longitude);
    } else {
      setState(() {
        _markerPosition = null;
        _isLocationSelected = false;
        _selectedLocationAddress = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialCenter,
              zoom: 14.0,
            ),
            markers: _markerPosition != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected-location'),
                      position: _markerPosition!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                    ),
                  }
                : {},
            minMaxZoomPreference: const MinMaxZoomPreference(10.0, 20.0),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                return;
              },
              child: ClipPath(
                clipper: RoundedClipperDown(),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Zanieczyszczenie powietrza',
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '45 µg/m³ – Cóż… Bywało lepiej.',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                return;
              },
              child: ClipPath(
                clipper: RoundedClipperUp(),
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wybierz lokalizacje',
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Twoja lokalizacja',
                        style: GoogleFonts.lato(
                          color: Colors.grey,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _selectedLocationAddress ?? 'Twoja lokalizacja',
                        style: GoogleFonts.lato(
                          color: Colors.grey,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _setMarker,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isLocationSelected
                                ? Colors.green[800]
                                : Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _isLocationSelected ? 'Anuluj' : 'Wybierz',
                            style: GoogleFonts.lato(
                                fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLocationSelected ? _setMarker : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Zatwierdź',
                            style: GoogleFonts.lato(
                                fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_markerPosition == null)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.56,
              left: 0,
              right: 0,
              child: const Center(
                child: Icon(
                  Icons.location_on,
                  size: 50,
                  color: Colors.green,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RoundedClipperDown extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(0, size.height, 30, size.height);
    path.lineTo(size.width - 30, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RoundedClipperUp extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 30);
    path.quadraticBezierTo(0, 0, 30, 0);
    path.lineTo(size.width - 30, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
