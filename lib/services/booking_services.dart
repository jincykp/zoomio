import 'package:firebase_database/firebase_database.dart';

class BookingService {
  final DatabaseReference _bookingRef = FirebaseDatabase.instance
      .ref('bookings'); // Reference to the bookings node

  Future<void> saveBooking({
    required String userId,
    required String pickupLocation,
    required String dropOffLocation,
    required Map<String, dynamic> vehicleDetails,
  }) async {
    try {
      // Generate a unique key for the booking
      final newBookingRef = _bookingRef.push();
      final bookingData = {
        'userId': userId,
        'pickupLocation': pickupLocation,
        'dropOffLocation': dropOffLocation,
        'vehicleDetails': vehicleDetails,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await newBookingRef.set(bookingData);
      print("Booking saved successfully!");
    } catch (error) {
      print("Error saving booking: $error");
    }
  }
}
