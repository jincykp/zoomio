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
        'status': 'pending', // Add initial status
        'timestamp': DateTime.now().toIso8601String(),
      };
      await newBookingRef.set(bookingData);
      print("Booking saved successfully!");
    } catch (error) {
      print("Error saving booking: $error");
    }
  }

  // Method to update the booking status
  Future<void> updateBookingStatus({
    required String bookingId,
    required String newStatus,
  }) async {
    try {
      // Update the status field for the specific booking
      await _bookingRef.child(bookingId).update({
        'status': newStatus,
      });
      print("Booking status updated to: $newStatus");
    } catch (error) {
      print("Error updating booking status: $error");
    }
  }
}
