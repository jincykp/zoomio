import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zoomer/views/screens/where_to_go_screens/where_togo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _googleMapCompleterController =
      Completer<GoogleMapController>();
  Position? _currentPositionOfUser;
  late GoogleMapController _controllerGoogleMap;

  // Initial position (you can set any valid latitude/longitude)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Default position: San Francisco
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    getCurrentLiveLocation(); // Fetch user's current location on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // GoogleMap(
          //   mapType: MapType.normal,
          //   myLocationEnabled: true,
          //   initialCameraPosition: _initialPosition,
          //   onMapCreated: (GoogleMapController mapController) {
          //     _googleMapCompleterController.complete(mapController);
          //     _controllerGoogleMap = mapController;
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black // Dark theme shadow
                                  : const Color.fromARGB(
                                      255, 201, 201, 201), // Light theme shadow
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                         WhereToGoScreen()));
                          },
                          decoration: InputDecoration(
                            hintText: "Where would you go?",
                            hintStyle: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey // Dark theme hint color
                                  : Colors.black54, // Light theme hint color
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 25,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey // Dark theme icon color
                                  : Colors.black54, // Light theme icon color
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide.none, // No border line
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getCurrentLiveLocation() async {
    // Check for location permissions
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position positionUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      _currentPositionOfUser = positionUser;
    });

    LatLng positionOfUserLatLng = LatLng(
        _currentPositionOfUser!.latitude, _currentPositionOfUser!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserLatLng, zoom: 15);

    _controllerGoogleMap.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }
}
