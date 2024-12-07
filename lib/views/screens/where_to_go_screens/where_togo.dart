import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zoomer/global/global_variable.dart';
import 'package:zoomer/model/vehicle_model.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_alertcard.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_locatiofields.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';
import 'package:zoomer/views/screens/where_to_go_screens/bloc/vehicle_bloc.dart';
import 'package:zoomer/views/screens/where_to_go_screens/cubit/selected_vehicle_cubit.dart';
import 'package:zoomer/views/screens/where_to_go_screens/database_services.dart';
import 'package:zoomer/views/screens/where_to_go_screens/price_services.dart';
import 'dart:math';

class WhereToGoScreen extends StatefulWidget {
  const WhereToGoScreen({super.key});

  @override
  _WhereToGoScreenState createState() => _WhereToGoScreenState();
}

class _WhereToGoScreenState extends State<WhereToGoScreen> {
  late GoogleMapController mapController;
  LatLng _currentLocation = const LatLng(0, 0);
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  List<dynamic> _placeSuggestions = [];
  bool _isLoading = false;
  bool _isPickupField = true;
  Map<PolylineId, Polyline> _polylinesMap = {};
  PriceServices priceServices = PriceServices();
  String? _totalDistance; // Default value for distance
  String? _totalPrice;
  DatabaseServices databaseServices = DatabaseServices();
  final VehicleBloc _vehicleBloc = VehicleBloc(PriceServices());
  double? _calculatedDistance;
  // Mapbox API Key
  final String _accessToken =
      'pk.eyJ1IjoiamluY3lrcCIsImEiOiJjbTNmdmd2ejYwMDFrMmlzZmZya3dxOXJ6In0.65j6783wEmjz7pcehss0eA'; // Replace with your Mapbox API Key

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  // Get current location of the user
  Future<void> getCurrentLocation() async {
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
    addMarker(_currentLocation, "Your Location");
    moveCameraToCurrentLocation();

    // Reverse geocode to get the actual place name
    await reverseGeocode(_currentLocation);
  }

  // Reverse geocode the coordinates to get the place name
  Future<void> reverseGeocode(LatLng coordinates) async {
    final String reverseGeocodeUrl =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinates.longitude},${coordinates.latitude}.json?access_token=$_accessToken';

    final response = await http.get(Uri.parse(reverseGeocodeUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final placeName = data['features'][0]['place_name'];

      setState(() {
        // Update the pickup field with the real place name
        pickupController.text = placeName;
        _pickupLocation = coordinates; // Store the coordinates for future use
      });
    } else {
      throw Exception('Failed to reverse geocode');
    }
  }

  // Add a marker on the map
  void addMarker(LatLng position, String title) {
    setState(() {
      final Marker marker = Marker(
        markerId: MarkerId(title),
        position: position,
        infoWindow: InfoWindow(title: title),
        icon: title == "Your Location"
            ? BitmapDescriptor.defaultMarkerWithHue(210) // Light blue
            : title == "Pickup Location"
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen) // Green
                : BitmapDescriptor
                    .defaultMarker, // Default color for other markers
      );

      _markers.add(marker);
    });
  }

  // Move camera to the current location
  void moveCameraToCurrentLocation() {
    mapController.animateCamera(
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
      pickupController.text = placeName;
      _pickupLocation = coordinates;
      addMarker(coordinates, "Pickup Location");
    } else {
      dropoffController.text = placeName;
      _dropoffLocation = coordinates;
      addMarker(coordinates, "Dropoff Location");
    }
    setState(() {
      _placeSuggestions.clear();
    });

    if (_pickupLocation != null && _dropoffLocation != null) {
      _getPolylinePoints(); // Generate polyline
      _calculateDistance(); // Calculate distance
    }
  }

  // Generate polyline between pickup and dropoff locations
  Future<void> _getPolylinePoints() async {
    if (_pickupLocation == null || _dropoffLocation == null) {
      print('Pickup or dropoff location is null');
      return;
    }

    try {
      // Use Google Maps Directions API directly instead of PolylinePoints
      final String directionsUrl =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${_pickupLocation!.latitude},${_pickupLocation!.longitude}'
          '&destination=${_dropoffLocation!.latitude},${_dropoffLocation!.longitude}'
          '&key=$googleMapKey';

      final response = await http.get(Uri.parse(directionsUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['status'] == 'OK') {
          // Decode the polyline
          final List<dynamic> routes = responseBody['routes'];
          if (routes.isNotEmpty) {
            final String encodedPolyline =
                routes[0]['overview_polyline']['points'];

            // Decode the polyline points
            List<PointLatLng> decodedPoints =
                PolylinePoints().decodePolyline(encodedPolyline);

            // Convert to LatLng
            List<LatLng> polylineCoordinates = decodedPoints
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();

            // Add polyline to map
            _addPolyline(polylineCoordinates);

            // Adjust camera to show full route
            if (polylineCoordinates.isNotEmpty) {
              LatLngBounds bounds = _calculateBounds(polylineCoordinates);
              mapController
                  .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
            }
          } else {
            print('No routes found');
          }
        } else {
          print('Directions API error: ${responseBody['status']}');
        }
      } else {
        print(
            'Failed to fetch directions. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception in getting polyline points: $e');
    }
  }

// Helper method to calculate bounds of the route
  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLng = points[0].longitude;
    double maxLng = points[0].longitude;

    for (LatLng point in points) {
      minLat = min(minLat, point.latitude);
      maxLat = max(maxLat, point.latitude);
      minLng = min(minLng, point.longitude);
      maxLng = max(maxLng, point.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
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
      _polylinesMap[polylineId] = polyline; // Add the polyline to the map
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
                        mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation,
                        zoom: 14,
                      ),
                      markers: _markers,
                      polylines: _polylinesMap.values
                          .toSet(), // Ensure polyline is passed
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
                                await getCurrentLocation();
                              },
                              icon: const Icon(
                                Icons.my_location,
                                color: ThemeColors.successColor,
                              )),
                          SizedBox(width: screenWidth * 0.01),
                          Expanded(
                            child: CustomLocatiofields(
                              controller: pickupController,
                              hintText: "Pick up location",
                              hintStyle: Textstyles.bodytext.copyWith(
                                  color:
                                      const Color.fromARGB(255, 163, 143, 81)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  pickupController.clear();
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
                          SizedBox(height: screenHeight * 0.08),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                await getCurrentLocation();
                              },
                              icon: const Icon(
                                Icons.location_on,
                                color: ThemeColors.alertColor,
                              )),
                          SizedBox(width: screenWidth * 0.01),
                          Expanded(
                            child: CustomLocatiofields(
                              controller: dropoffController,
                              hintText: "Drop off location",
                              hintStyle: Textstyles.bodytext.copyWith(
                                  color:
                                      const Color.fromARGB(255, 163, 143, 81)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  dropoffController.clear();
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
                            if (pickupController.text.isEmpty ||
                                dropoffController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please select both pickup and drop-off locations.",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              );
                              return; // Stop execution if any field is empty
                            }
                            _calculateDistance();
                            if (_calculatedDistance != null) {
                              _vehicleBloc.add(
                                CalculatePricesEvent(_calculatedDistance!),
                              );

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) {
                                  return BlocProvider.value(
                                    value: _vehicleBloc,
                                    child:
                                        BlocBuilder<VehicleBloc, VehicleState>(
                                      builder: (context, state) {
                                        if (state is VehicleLoadingState) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (state
                                            is VehiclePriceCalculatedState) {
                                          final vehicles = state.vehiclePrices;
                                          return Container(
                                            height: 700,
                                            decoration: const BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(40),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Recommended for you",
                                                    style: Textstyles
                                                        .gTextdescription,
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          screenHeight * 0.02),
                                                  Expanded(
                                                    child: ListView.builder(
                                                      itemCount:
                                                          vehicles.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final vehicle =
                                                            vehicles[index];
                                                        print(vehicle);
                                                        return Card(
                                                          elevation: 18.2,
                                                          child: ListTile(
                                                            onTap: () {
                                                              final vehicleCubit =
                                                                  SelectedVehicleCubit();
                                                              vehicleCubit
                                                                  .loadVehicle(
                                                                      vehicle); // Pass the selected vehicle data

                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return BlocProvider
                                                                      .value(
                                                                    value:
                                                                        vehicleCubit,
                                                                    child:
                                                                        CustomAlertCard(
                                                                      pickupText:
                                                                          pickupController
                                                                              .text,
                                                                      dropoffText:
                                                                          dropoffController
                                                                              .text,
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            title: Text(
                                                              '${vehicle['brand'] ?? 'No Brand'}',
                                                              style: Textstyles
                                                                  .gTextdescription,
                                                            ),
                                                            subtitle: Text(
                                                              'for ${vehicle['seatingCapacity'] ?? 'N/A'} Person',
                                                            ),
                                                            leading:
                                                                CircleAvatar(
                                                              child: Icon(
                                                                vehicle['vehicleType'] ==
                                                                        'Bike'
                                                                    ? Icons
                                                                        .directions_bike
                                                                    : Icons
                                                                        .directions_car,
                                                              ),
                                                            ),
                                                            trailing: Text(
                                                              '₹${vehicle['totalPrice'].toStringAsFixed(2)}',
                                                              style: const TextStyle(
                                                                  color: ThemeColors
                                                                      .successColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else if (state is VehicleErrorState) {
                                          return Center(
                                            child:
                                                Text('Error: ${state.error}'),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  );
                                },
                              );
                            }
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

// Calculate distance between pickup and dropoff locations
  Future<void> _calculateDistance() async {
    if (_pickupLocation == null || _dropoffLocation == null) {
      print("Pickup or Dropoff location is not selected");
      return;
    }

    // Calculate the distance in meters
    double distanceInMeters = Geolocator.distanceBetween(
      _pickupLocation!.latitude,
      _pickupLocation!.longitude,
      _dropoffLocation!.latitude,
      _dropoffLocation!.longitude,
    );

    // Convert to kilometers
    double distanceInKilometers = distanceInMeters / 1000;

    // Debug: Log the calculated distance
    print("Calculated Distance: ${distanceInKilometers.toStringAsFixed(2)} km");

    // Store or display the distance as needed
    setState(() {
      _calculatedDistance = distanceInKilometers;
    });
  }

  Future<void> calculateAndDisplayAllVehiclePrices() async {
    if (_pickupLocation == null || _dropoffLocation == null) {
      print("Pickup or Dropoff location is not selected");
      return;
    }

    // Calculate the distance
    double distanceInMeters = Geolocator.distanceBetween(
      _pickupLocation!.latitude,
      _pickupLocation!.longitude,
      _dropoffLocation!.latitude,
      _dropoffLocation!.longitude,
    );
    double distanceInKilometers = distanceInMeters / 1000;

    // Instantiate the PriceServices class
    PriceServices priceServices = PriceServices();

    // Calculate total prices for all vehicles
    List<Map<String, dynamic>> totalPriceList = await priceServices
        .calculateTotalPriceForAllVehicles(distanceInKilometers);

    // Display the prices
    for (var vehicle in totalPriceList) {
      print("Vehicle Type: ${vehicle['vehicleType']}");
      print("Total Price: ₹${vehicle['totalPrice']}");
    }
  }
}
