import 'package:firebase_database/firebase_database.dart';

class BookingService {
  // Reference directly to the bookings node - cleaner structure
  final DatabaseReference _bookingRef =
      FirebaseDatabase.instance.ref('bookings');

  Future<String> saveBooking({
    required String userId,
    required String pickupLocation,
    required String dropOffLocation,
    required Map<String, dynamic> vehicleDetails,
  }) async {
    try {
      // Use a direct path to bookings without 'adddelete'
      final bookingRef = _bookingRef.push();
      final bookingId = bookingRef.key!;

      final bookingData = {
        'bookingId': bookingId,
        'userId': userId,
        'pickupLocation': pickupLocation,
        'dropOffLocation': dropOffLocation,
        'vehicleDetails': vehicleDetails,
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      };

      await bookingRef.set(bookingData);
      return bookingId;
    } catch (e) {
      throw Exception('Failed to save booking: $e');
    }
  }

  Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
    final snapshot = await _bookingRef.child(bookingId).get();
    return snapshot.value as Map<String, dynamic>?;
  }

  Future<void> updateBookingStatus({
    required String bookingId,
    required String newStatus,
  }) async {
    try {
      await _bookingRef.child(bookingId).update({
        'status': newStatus,
        'statusUpdateTimestamp': DateTime.now().toIso8601String(),
      });
      print("Booking status updated to: $newStatus");
    } catch (error) {
      print("Error updating booking status: $error");
    }
  }
}
