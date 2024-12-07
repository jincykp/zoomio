import 'package:firebase_database/firebase_database.dart';

class RideRequestService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Function to save the ride request data
  Future<void> saveRideRequest({
    required String userId,
    required String pickupLocation,
    required String dropoffLocation,
    required String vehicleType,
    required double distance,
  }) async {
    DatabaseReference ridesRef = _database.ref("rides");

    // Create a new ride request with a unique ID
    String rideRequestId = ridesRef.push().key!;

    // Save the ride request in Firebase Realtime Database
    await ridesRef.child(rideRequestId).set({
      'userId': userId,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'vehicleType': vehicleType,
      'distance': distance,
      'status': 'pending', // initial status
      'timestamp': DateTime.now().toIso8601String(),
      'driverId': null, // No driver assigned initially
    });
  }
}
