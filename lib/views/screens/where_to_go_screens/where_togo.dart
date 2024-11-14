import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zoomer/global/global_variable.dart';
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
  LatLng _currentLocation = const LatLng(0, 0);
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  List<dynamic> _placeSuggestions = [];
  bool _isLoading = false;
  bool _isPickupField = true;
  Map<PolylineId, Polyline> _polylinesMap = {};

  // Mapbox API Key
  final String _accessToken =
      'pk.eyJ1IjoiamluY3lrcCIsImEiOiJjbTNmdmd2ejYwMDFrMmlzZmZya3dxOXJ6In0.65j6783wEmjz7pcehss0eA'; // Replace with your Mapbox API Key

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
    _addMarker(_currentLocation, "Your Location");
    _moveCameraToCurrentLocation();
  }

  // Add a marker on the map
  void _addMarker(LatLng position, String title) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(title),
          position: position,
          infoWindow: InfoWindow(title: title),
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

  // Fetch places from Mapbox Geocoding API
  Future<void> _fetchPlaces(String query) async {
    setState(() {
      _isLoading = true;
    });

    String encodedQuery = Uri.encodeFull(query);
    final response = await http.get(
      Uri.parse(
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedQuery.json?bbox=68.1097,6.4627,97.3953,35.5133&access_token=$_accessToken'), // Bounding box added for India
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _placeSuggestions = data['features'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load places');
    }
  }

  // Handle selection of a suggestion
  void _onPlaceSelected(String placeName, LatLng coordinates) {
    if (_isPickupField) {
      _pickupController.text = placeName;
      _pickupLocation = coordinates;
      _addMarker(coordinates, "Pickup Location");
    } else {
      _dropoffController.text = placeName;
      _dropoffLocation = coordinates;
      _addMarker(coordinates, "Dropoff Location");
    }
    setState(() {
      _placeSuggestions.clear();
    });

    if (_pickupLocation != null && _dropoffLocation != null) {
      _getPolylinePoints();
    }
  }

  // Generate polyline between pickup and dropoff locations
  Future<void> _getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    // Create the PolylineRequest object
    PolylineRequest polylineRequest = PolylineRequest(
      origin:
          PointLatLng(_pickupLocation!.latitude, _pickupLocation!.longitude),
      destination:
          PointLatLng(_dropoffLocation!.latitude, _dropoffLocation!.longitude),
      mode:
          TravelMode.driving, // You can change this to walking, bicycling, etc.
      avoidHighways: false, // Set to true if you want to avoid highways
      avoidTolls: false, // Set to true if you want to avoid tolls
      optimizeWaypoints: true, // Set this if you want to optimize waypoints
    );

    // Get the Uri for the API request
    Uri uri = polylineRequest.toUri(apiKey: googleMapKey);

    // Fetch the polyline data using the generated URI
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: polylineRequest,
    );

    // Process the result
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      _addPolyline(polylineCoordinates); // Add the polyline to your map
    }
  }

  // Add polyline to the map
  void _addPolyline(List<LatLng> polylineCoordinates) {
    final PolylineId polylineId = PolylineId('polyline');
    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Colors.blue, // Ensure the color is visible on your map
      points: polylineCoordinates,
      width: 6,
    );

    setState(() {
      _polylinesMap[polylineId] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      polylines: _polylinesMap.values
                          .toSet(), // Ensure this is not empty
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    )),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.mapMarkerAlt,
                            color: ThemeColors.successColor,
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: CustomLocatiofields(
                              controller: _pickupController,
                              hintText: "Pick up location",
                              hintStyle: Textstyles.bodytext.copyWith(
                                  color:
                                      const Color.fromARGB(255, 163, 143, 81)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _pickupController.clear();
                                },
                                icon: const Icon(Icons.my_location),
                              ),
                              onChanged: (text) {
                                _isPickupField = true;
                                if (text.isNotEmpty) {
                                  _fetchPlaces(text);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.mapPin,
                              color: ThemeColors.alertColor, size: 25),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: CustomLocatiofields(
                              controller: _dropoffController,
                              hintText: "Drop off location",
                              hintStyle: Textstyles.bodytext.copyWith(
                                  color:
                                      const Color.fromARGB(255, 163, 143, 81)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _dropoffController.clear();
                                },
                                icon: const Icon(Icons.cancel),
                              ),
                              onChanged: (text) {
                                _isPickupField = false;
                                if (text.isNotEmpty) {
                                  _fetchPlaces(text);
                                }
                              },
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
                          onPressed: () {
                            // Handle confirm action
                          },
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
          if (_placeSuggestions.isNotEmpty)
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.06,
              right: screenWidth * 0.09,
              child: Material(
                elevation: 5,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: screenHeight * 0.3),
                  child: ListView.builder(
                    itemCount: _placeSuggestions.length,
                    itemBuilder: (context, index) {
                      var place = _placeSuggestions[index];
                      return ListTile(
                        title: Text(place['place_name']),
                        onTap: () {
                          var coordinates = place['geometry']['coordinates'];
                          _onPlaceSelected(
                            place['place_name'],
                            LatLng(coordinates[1], coordinates[0]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
