import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingService {
  final String serverKey = 'YOUR_SERVER_KEY'; // Get this from Firebase settings

  // Method to save a booking
  Future<void> saveBooking({
    required String userId,
    required String pickupLocation,
    required String dropOffLocation,
    required Map<String, dynamic> vehicleDetails,
  }) async {
    try {
      // Save booking details in Firestore or your backend
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': userId,
        'pickupLocation': pickupLocation,
        'dropOffLocation': dropOffLocation,
        'vehicleDetails': vehicleDetails,
        'status': 'pending', // or other relevant status
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Booking saved successfully!");
    } catch (e) {
      print("Error saving booking: $e");
    }
  }

  // Method to send notifications to online drivers
  Future<void> sendNotificationToDrivers({
    required String title,
    required String body,
  }) async {
    // Fetch all online drivers
    QuerySnapshot driversSnapshot = await FirebaseFirestore.instance
        .collection('drivers')
        .where('isOnline', isEqualTo: true)
        .get();

    for (var doc in driversSnapshot.docs) {
      String? driverToken =
          doc['fcmToken']; // Ensure you store FCM tokens in Firestore

      if (driverToken != null) {
        await sendPushNotification(
          title: title,
          body: body,
          driverToken: driverToken,
        );
      }
    }
  }

  // Method to send a push notification to a specific driver
  Future<void> sendPushNotification({
    required String title,
    required String body,
    required String driverToken,
  }) async {
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'to': driverToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'screen':
                'DriverDetailsScreen', // This is the screen to navigate when the notification is clicked
          },
        }),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully!");
      } else {
        print("Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
