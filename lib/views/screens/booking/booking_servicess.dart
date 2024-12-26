// import 'package:firebase_database/firebase_database.dart';

// class BookingService {
//   final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

//   Future<String> saveBooking({
//     required String userId,
//     required String pickupLocation,
//     required String dropOffLocation,
//     required Map<String, dynamic> vehicleDetails,
//   }) async {
//     try {
//       final bookingRef = _dbRef.child('adddelete/bookings').push();
//       final bookingId = bookingRef.key!;

//       final bookingData = {
//         'bookingId': bookingId, // Explicitly saving the booking ID
//         'userId': userId,
//         'pickupLocation': pickupLocation,
//         'dropOffLocation': dropOffLocation,
//         'vehicleDetails': vehicleDetails,
//         'status': 'pending',
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       await bookingRef.set(bookingData);
//       return bookingId;
//     } catch (e) {
//       throw Exception('Failed to save booking: $e');
//     }
//   }

//   Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
//     final snapshot =
//         await _dbRef.child('adddelete/bookings').child(bookingId).get();

//     return snapshot.value as Map<String, dynamic>?;
//   }
// }
