import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapAppBar extends StatefulWidget {
  const MapAppBar({super.key});

  @override
  State<MapAppBar> createState() => _MapAppBarState();
}

class _MapAppBarState extends State<MapAppBar> {
  late LatLng tappedLatLng;
  Position? position;

  @override
  void initState() {
    super.initState();
    _getScreen();
    _listenCurrentLocation();
  }

  Future<void> _getScreen() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      position = await Geolocator.getCurrentPosition();
      setState(() {});
    } else {
      LocationPermission requestStatus = await Geolocator.requestPermission();
      if (requestStatus == LocationPermission.whileInUse ||
          requestStatus == LocationPermission.always) {
        _getScreen();
      } else {
        log('requestStatus is failed');
      }
    }
  }

  Future<void> _listenCurrentLocation() async {
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
      timeLimit: Duration(seconds: 10),
    )).listen((p) {
      log(p.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
        },
        onTap: (LatLng latLng) {
          setState(() {
            tappedLatLng = latLng;
          });
          log('Tapped location: $tappedLatLng');
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(23.811538370969107, 90.41898358112373),
          zoom: 14.4746,
        ),
        markers: {
          const Marker(
            markerId: MarkerId('Dhaka'),
            position: LatLng(23.811538370969107, 90.41898358112373),
            infoWindow: InfoWindow(
              title: 'Dhaka',
              snippet:
                  "latitude: 23.811538370969107,longitude: 90.41898358112373,",
            ),
            draggable: true,
          ),
          Marker(
            markerId: const MarkerId('My current location'),
            position: LatLng(position?.latitude??0, position?.longitude??0),
            infoWindow: InfoWindow(
              title: 'My current location',
              snippet:
                  "latitude:${position?.latitude},longitude:${position?.longitude}",
            ),
            draggable: true,
          ),
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId('mgo'),
            points: [
              LatLng(position?.latitude??0, position?.longitude??0),
              const LatLng(23.811538370969107, 90.41898358112373),
            ],
            width: 3,
            color: Colors.blue,
          ),
        },
        onLongPress: (LatLng latLng) {
          log('LongPress:$latLng');
        },
      ),
    );
  }
}
