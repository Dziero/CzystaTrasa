import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getLocationFromCoordinates(LatLng coordinates) async {
  List<geocoding.Placemark> placemarks =
      await geocoding.placemarkFromCoordinates(
    coordinates.latitude,
    coordinates.longitude,
  );
  geocoding.Placemark place = placemarks[0];
  return "${place.street}, ${place.locality}";
}

final String _apiKey = dotenv.env["GOOGLE_MAPS_API_KEY"]!;
Future<List<LatLng>?> fetchRoute(LatLng origin, LatLng destination) async {
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=bicycling&avoid=tolls|highways|ferries&alternatives=true&key=$_apiKey',
  );

  final response = await http.get(url);
  print("Response: ${response.statusCode}"); // Debug API Google

  if (response.statusCode != 200) return null;

  final data = json.decode(response.body);
  if (data['routes'].isEmpty) return null;

  final points = data['routes'][0]['overview_polyline']['points'];
  return _decodePolyline(points);
}

List<LatLng> _decodePolyline(String polyline) {
  List<LatLng> points = [];
  int index = 0, len = polyline.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = polyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = polyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    points.add(LatLng(lat / 1E5, lng / 1E5));
  }

  return points;
}
