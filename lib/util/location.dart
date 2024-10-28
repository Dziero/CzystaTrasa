import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

Future<String> getLocationFromCoordinates(LatLng coordinates) async {
  List<geocoding.Placemark> placemarks =
      await geocoding.placemarkFromCoordinates(
    coordinates.latitude,
    coordinates.longitude,
  );
  geocoding.Placemark place = placemarks[0];
  return "${place.street}, ${place.locality}";
}
