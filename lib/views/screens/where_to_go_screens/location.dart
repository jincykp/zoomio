import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  final String name;
  final LatLng coordinates;
  final String? placeId;

  const Location({
    required this.name,
    required this.coordinates,
    this.placeId,
  });
}
