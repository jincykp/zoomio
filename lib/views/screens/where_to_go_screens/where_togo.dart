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
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = currentLatLng;
    });

    // Update the map and add a marker for current location
    _addMarker(_currentLocation, "Your Location");
    _moveCameraToCurrentLocation();

    // Reverse geocode to get the actual place name
    await _reverseGeocode(_currentLocation);
  }

  // Reverse geocode the coordinates to get the place name
  Future<void> _reverseGeocode(LatLng coordinates) async {
    final String reverseGeocodeUrl =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinates.longitude},${coordinates.latitude}.json?access_token=$_accessToken';

    final response = await http.get(Uri.parse(reverseGeocodeUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final placeName = data['features'][0]['place_name'];

      setState(() {
        // Update the pickup field with the real place name
        _pickupController.text = placeName;
        _pickupLocation = coordinates; // Store the coordinates for future use
      });
    } else {
      throw Exception('Failed to reverse geocode');
    }
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
    if (_pickupLocation == null || _dropoffLocation == null) {
      return; // Ensure both pickup and dropoff are selected before generating polyline
    }

    // Create a PolylineRequest object
    PolylineRequest request = PolylineRequest(
      origin:
          PointLatLng(_pickupLocation!.latitude, _pickupLocation!.longitude),
      destination:
          PointLatLng(_dropoffLocation!.latitude, _dropoffLocation!.longitude),
      mode:
          TravelMode.driving, // Corrected parameter: mode instead of travelMode
    );

    // Create an instance of PolylinePoints
    PolylinePoints polylinePoints = PolylinePoints();

    // Fetch the route using the request object and API key
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: request,
      googleApiKey: googleMapKey, // Your Google Maps API Key
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      _addPolyline(
          polylineCoordinates); // Call function to add polyline to the map
    } else {
      print('Failed to get polyline points: ${result.errorMessage}');
    }
  }

  // Add polyline to the map
  void _addPolyline(List<LatLng> polylineCoordinates) {
    final PolylineId polylineId = PolylineId('route_polyline');
    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Colors.blue, // Choose a visible color for the polyline
      points: polylineCoordinates,
      width: 5, // Adjust the polyline width
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
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
                          IconButton(
                              onPressed: () async {
                                await _getCurrentLocation();
                              },
                              icon: const Icon(
                                Icons.my_location,
                                color: ThemeColors.successColor,
                              )),
                          SizedBox(width: screenWidth * 0.01),
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
                                icon: const Icon(Icons.cancel),
                              ),
                              onChanged: (text) {
                                _fetchPlaces(text);
                                setState(() {
                                  _isPickupField = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                await _getCurrentLocation();
                              },
                              icon: const Icon(
                                Icons.location_on,
                                color: ThemeColors.alertColor,
                              )),
                          SizedBox(width: screenWidth * 0.01),
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
                                _fetchPlaces(text);
                                setState(() {
                                  _isPickupField = false;
                                });
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
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _placeSuggestions.isNotEmpty
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: _placeSuggestions.length,
                                  itemBuilder: (context, index) {
                                    final place = _placeSuggestions[index];
                                    final placeName = place['place_name'] ?? '';
                                    final coordinates = place['center'] != null
                                        ? LatLng(
                                            place['center'][1],
                                            place['center'][0],
                                          )
                                        : null;

                                    return ListTile(
                                      leading: const Icon(Icons
                                          .location_on), // Adds a leading location icon
                                      title: Text(placeName),
                                      onTap: () => _onPlaceSelected(
                                          placeName, coordinates!),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(); // Adds a separator (Divider) between list items
                                  },
                                )
                              : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
