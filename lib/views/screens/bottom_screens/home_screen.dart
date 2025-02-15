import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_drawer.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';
import 'package:zoomer/views/screens/where_to_go_screens/where_togo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String mapTheme = '';
  final Completer<GoogleMapController> _googleMapCompleterController =
      Completer<GoogleMapController>();
  Position? _currentPositionOfUser;
  late GoogleMapController _controllerGoogleMap;

  // Marker to store current location
  Set<Marker> _markers = {};

  // Initial position (you can set any valid latitude/longitude)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(9.9312, 76.2673), // Coordinates for Kochi, Kerala
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
      if (valueOfPermission) {
        Permission.locationWhenInUse.request();
      }
    });
    getCurrentLiveLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Stack to layer Google Map and other widgets
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController mapController) {
              mapController.setMapStyle(mapTheme);
              _controllerGoogleMap = mapController;
            },
            markers: _markers,
          ),

          // Left-side Drawer trigger
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: 34,
                  color: ThemeColors.titleColor,
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
          ),
          // Search bar at the bottom
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
                      padding: const EdgeInsets.only(left: 10, right: 48),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(255, 46, 44, 44)
                                  : const Color.fromARGB(255, 201, 201, 201),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WhereToGoScreen()));
                          },
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "Where would you go?",
                              hintStyle: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey
                                    : Colors.black54,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 25,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey
                                    : Colors.black54,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide.none,
                              ),
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
      // Drawer added
      drawer: const CustomDrawerawer(
        userEmail: '',
        userName: '',
        photoUrl: null,
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

    if (!mounted)
      return; // Ensure the widget is still mounted before calling setState()

    setState(() {
      _currentPositionOfUser = positionUser;
    });

    LatLng positionOfUserLatLng = LatLng(
        _currentPositionOfUser!.latitude, _currentPositionOfUser!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserLatLng, zoom: 15);

    // Create a marker at the user's current location
    Marker userLocationMarker = Marker(
      markerId: const MarkerId('userLocation'),
      position: positionOfUserLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed), // Red color for the marker
    );

    // Add the marker to the set
    setState(() {
      _markers.add(userLocationMarker);
    });

    // Ensure the controller is initialized before using it
    if (_controllerGoogleMap != null) {
      _controllerGoogleMap.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    }
  }
}
