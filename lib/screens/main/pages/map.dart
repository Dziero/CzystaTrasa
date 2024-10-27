import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Planowanie trasy",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(children: [
                Icon(Icons.location_on),
                SizedBox(width: 4),
                Text(
                  "Lokalizacja początkowa: Twoja lokalizacja",
                )
              ]),
              SizedBox(height: 16),
              Row(children: [
                Icon(Icons.flag),
                SizedBox(width: 4),
                Text(
                  "Lokalizacja końcowa: Puta Barca",
                )
              ]),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: FilledButton(
                  onPressed: null,
                  child: Text("Rozpocznij"),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
