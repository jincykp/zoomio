import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
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
  LatLng _currentLocation = const LatLng(0, 0);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  List<dynamic> _placeSuggestions = [];
  bool _isLoading = false;
  bool _isPickupField = true;

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
    _addMarker(_currentLocation);
    _moveCameraToCurrentLocation();
  }

  // Add a marker on the map
  void _addMarker(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: position,
          infoWindow: const InfoWindow(title: 'Your Location'),
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
  void _onPlaceSelected(String placeName) {
    if (_isPickupField) {
      _pickupController.text = placeName;
    } else {
      _dropoffController.text = placeName;
    }
    setState(() {
      _placeSuggestions.clear(); // Clear suggestions after selection
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
                                  icon: const Icon(Icons.cancel)),
                              onChanged: (text) {
                                _isPickupField = true; // Set to pickup mode
                                if (text.isNotEmpty) {
                                  _fetchPlaces(
                                      text); // Fetch places on text change
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
                              onChanged: (text) {
                                _isPickupField = false; // Set to dropoff mode
                                if (text.isNotEmpty) {
                                  _fetchPlaces(text);
                                }
                              },
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _dropoffController.clear();
                                  },
                                  icon: const Icon(Icons.cancel)),
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
                  constraints: BoxConstraints(
                    maxHeight: screenHeight *
                        0.5, // Set max height to control expansion
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _placeSuggestions.length,
                    itemBuilder: (context, index) {
                      var place = _placeSuggestions[index];
                      return ListTile(
                        title: Text(place['place_name']),
                        onTap: () => _onPlaceSelected(place['place_name']),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(), // Adds a divider between items
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
