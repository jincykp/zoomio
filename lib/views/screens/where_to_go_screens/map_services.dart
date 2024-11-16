// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:zoomer/global/global_variable.dart';

// class MapHelper {
//   final String accessToken =
//       'pk.eyJ1IjoiamluY3lrcCIsImEiOiJjbTNmdmd2ejYwMDFrMmlzZmZya3dxOXJ6In0.65j6783wEmjz7pcehss0eA'; // Replace with your Mapbox API Key
//   late GoogleMapController _mapController;
//   LatLng currentLocation = const LatLng(0, 0);
//   LatLng? pickupLocation;
//   LatLng? dropoffLocation;
//   final Set<Marker> markers = {};
//   final Set<Polyline> _polylines = {};
//   bool isLoading = false;
//   bool isPickupField = true;

//   Map<PolylineId, Polyline> polylinesMap = {};

//   // Get current location of the user
//   Future<void> getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     LocationPermission permission = await Geolocator.checkPermission();

//     if (!serviceEnabled || permission == LocationPermission.deniedForever) {
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     currentLocation = LatLng(position.latitude, position.longitude);

//     // Update the map and add a marker for current location
//     addMarker(currentLocation, "Your Location");
//     moveCameraToCurrentLocation();

//     // Reverse geocode to get the actual place name
//     await reverseGeocode(currentLocation);
//   }

//   // Reverse geocode the coordinates to get the place name
//   Future<void> reverseGeocode(LatLng coordinates) async {
//     final String reverseGeocodeUrl =
//         'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinates.longitude},${coordinates.latitude}.json?access_token=$accessToken';

//     final response = await http.get(Uri.parse(reverseGeocodeUrl));

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final placeName = data['features'][0]['place_name'];

//       // Update the pickup field with the real place name
//       pickupLocation = coordinates; // Store the coordinates for future use
//     } else {
//       throw Exception('Failed to reverse geocode');
//     }
//   }

//   // Add a marker on the map
//   void addMarker(LatLng position, String title) {
//     markers.add(
//       Marker(
//         markerId: MarkerId(title),
//         position: position,
//         infoWindow: InfoWindow(title: title),
//       ),
//     );
//   }

//   // Move camera to the current location
//   void moveCameraToCurrentLocation() {
//     _mapController.animateCamera(
//       CameraUpdate.newLatLngZoom(currentLocation, 14),
//     );
//   }

//   // Fetch places from Mapbox Geocoding API
//   Future<void> fetchPlaces(String query) async {
//     isLoading = true;

//     String encodedQuery = Uri.encodeFull(query);
//     final response = await http.get(
//       Uri.parse(
//           'https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedQuery.json?bbox=68.1097,6.4627,97.3953,35.5133&access_token=$accessToken'), // Bounding box added for India
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       isLoading = false;
//     } else {
//       throw Exception('Failed to load places');
//     }
//   }

//   // Handle selection of a suggestion
//   void onPlaceSelected(
//       String placeName, LatLng coordinates, bool isPickupField) {
//     if (isPickupField) {
//       pickupLocation = coordinates;
//       addMarker(coordinates, "Pickup Location");
//     } else {
//       dropoffLocation = coordinates;
//       addMarker(coordinates, "Dropoff Location");
//     }

//     if (pickupLocation != null && dropoffLocation != null) {
//       getPolylinePoints(); // Generate polyline
//     }
//   }

//   // Generate polyline between pickup and dropoff locations
//   Future<void> getPolylinePoints() async {
//     if (pickupLocation == null || dropoffLocation == null) {
//       return; // Ensure both pickup and dropoff are selected before generating polyline
//     }

//     PolylineRequest request = PolylineRequest(
//       origin: PointLatLng(pickupLocation!.latitude, pickupLocation!.longitude),
//       destination:
//           PointLatLng(dropoffLocation!.latitude, dropoffLocation!.longitude),
//       mode: TravelMode.driving,
//     );

//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       request: request,
//       googleApiKey: googleMapKey, // Your Google Maps API Key
//     );

//     if (result.points.isNotEmpty) {
//       List<LatLng> polylineCoordinates = [];
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }

//       _addPolyline(polylineCoordinates);
//     }
//   }

//   // Add polyline to the map
//   void _addPolyline(List<LatLng> polylineCoordinates) {
//     final PolylineId polylineId = PolylineId('route_polyline');
//     final Polyline polyline = Polyline(
//       polylineId: polylineId,
//       color: Colors.blue,
//       points: polylineCoordinates,
//       width: 5,
//       startCap: Cap.roundCap,
//       endCap: Cap.roundCap,
//     );

//     polylinesMap[polylineId] = polyline;
//   }
// }
