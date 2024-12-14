import 'package:firebase_database/firebase_database.dart';

class RideRequestService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> saveRideRequest({
    required String userId,
    required String pickupLocation,
    required String dropoffLocation,
    required String vehicleType,
    required double distance,
  }) async {
    try {
      DatabaseReference ridesRef = _database.ref("rides");

      // Generate unique ID for the ride request
      String rideRequestId = ridesRef.push().key!;

      // Save ride request
      await ridesRef.child(rideRequestId).set({
        'userId': userId,
        'pickupLocation': pickupLocation,
        'dropoffLocation': dropoffLocation,
        'vehicleType': vehicleType,
        'distance': distance,
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
        'driverId': null,
      });

      print("Ride request saved successfully.");
    } catch (e) {
      print("Error saving ride request: $e");
    }
  }

  Future<void> assignDriverToRide(String rideRequestId, String driverId) async {
    try {
      await _database.ref("rides/$rideRequestId").update({
        'driverId': driverId,
        'status': 'accepted',
      });
      print("Driver assigned successfully.");
    } catch (e) {
      print("Error assigning driver: $e");
    }
  }
}
