import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_locatiofields.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class WhereToGoScreen extends StatefulWidget {
  const WhereToGoScreen({super.key});

  @override
  _WhereToGoScreenState createState() => _WhereToGoScreenState();
}

class _WhereToGoScreenState extends State<WhereToGoScreen> {
  late GoogleMapController _mapController;
  LatLng _currentLocation = LatLng(0, 0);
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get current location of the user
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled || permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _addMarker(_currentLocation);
    _moveCameraToCurrentLocation();
  }

  // Add a marker on the map
  void _addMarker(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: position,
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      );
    });
  }

  // Move camera to the current location
  void _moveCameraToCurrentLocation() {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLocation, 14),
    );
  }

  // Add a polyline to the map
  void _addPolyline(LatLng destination) {
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('polyline'),
          points: [_currentLocation, destination],
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  // Handle user input for destination location
  void _onConfirmPressed() {
    double? lat = double.tryParse(_latController.text);
    double? lng = double.tryParse(_lngController.text);

    if (lat != null && lng != null) {
      LatLng destination = LatLng(lat, lng);
      _addMarker(destination);
      _addPolyline(destination);
      _moveCameraToCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.4,
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _currentLocation,
                  zoom: 14,
                ),
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                children: [
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        color: ThemeColors.baseColor,
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: CustomLocatiofields(
                          controller: _latController,
                          hintText: "Pick up location",
                          hintStyle: Textstyles.bodytext,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    children: [
                      const FaIcon(
                          FontAwesomeIcons.mapPin,
                          color: ThemeColors.successColor,
                          size:25),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: CustomLocatiofields(
                          controller: _lngController,
                          hintText: "Drop off location",
                          hintStyle: Textstyles.bodytext,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.06,
                    child: CustomButtons(
                      text: "Confirm",
                      onPressed: _onConfirmPressed,
                      backgroundColor: ThemeColors.primaryColor,
                      textColor: ThemeColors.textColor,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
