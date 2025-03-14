import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoomer/views/screens/cancel_ride_screens/cancel_ride.dart';
import 'package:zoomer/views/screens/chat_screens/chat_screen.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/payment_screens/payment.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class CustomBottomsheet extends StatefulWidget {
  final String bookingId;

  const CustomBottomsheet({
    super.key,
    required this.bookingId,
  });

  @override
  State<CustomBottomsheet> createState() => _CustomBottomsheetState();
}

class _CustomBottomsheetState extends State<CustomBottomsheet>
    with SingleTickerProviderStateMixin {
  late DatabaseReference bookingRef;
  Map<String, dynamic>? driverDetails;
  late AnimationController _progressController;
  Timer? _timeoutTimer;
  bool _hasTimedOut = false;

  @override
  void initState() {
    super.initState();
    bookingRef =
        FirebaseDatabase.instance.ref().child('bookings/${widget.bookingId}');

    // Initialize animation controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _progressController.repeat();
    _startTimeoutTimer();
  }

  void _startTimeoutTimer() {
    _timeoutTimer = Timer(const Duration(minutes: 5), () {
      if (mounted) {
        setState(() {
          _hasTimedOut = true;
        });
        _showTimeoutDialog();
      }
    });
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'No Drivers Available',
            style: TextStyle(color: ThemeColors.primaryColor),
          ),
          content: const Text(
            'We apologize, but no drivers are currently available in your area. Please try booking again later.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  // Update booking status in Firebase with more detailed status
                  await bookingRef.update({
                    'status': 'cancelled_no_drivers',
                    'cancellationReason': 'No drivers available in the area',
                    'cancelledAt': ServerValue.timestamp,
                    'cancellationType': 'system_timeout',
                    'bookingState': {
                      'currentState': 'cancelled',
                      'previousState': 'searching',
                      'updateTimestamp': ServerValue.timestamp,
                    },
                    // Add any additional status information you want to track
                    'systemNotes':
                        'Booking automatically cancelled after 5 minutes of no driver assignment'
                  });

                  // Optional: Log this event to a separate logging node in Firebase
                  final logsRef = FirebaseDatabase.instance
                      .ref()
                      .child('booking_logs')
                      .child(widget.bookingId);

                  await logsRef.push().set({
                    'event': 'booking_timeout',
                    'timestamp': ServerValue.timestamp,
                    'status': 'cancelled_no_drivers',
                    'reason': 'No drivers available after timeout'
                  });

                  // Close both dialog and bottom sheet
                  if (mounted) {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Close bottom sheet
                  }
                } catch (e) {
                  // Handle any errors that occur during the update
                  print('Error updating booking status: $e');

                  // Show error message to user
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Error updating booking status. Please try again.'),
                        backgroundColor: ThemeColors.alertColor,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'OK',
                style: TextStyle(color: ThemeColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWaitingContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Looking for Available Drivers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ThemeColors.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.primaryColor),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please wait while we connect you with nearby drivers...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          if (_hasTimedOut) ...[
            const SizedBox(height: 16),
            const Text(
              'Taking longer than usual. Please be patient.',
              style: TextStyle(
                color: ThemeColors.alertColor,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(String status, double screenWidth,
      double screenHeight, Map<String, dynamic> bookingData) {
    if (status == 'driver_accepted') {
      // return CustomButtons(
      //   text: 'Track Your Ride',
      //   onPressed: () {
      //     // Add navigation to tracking screen if needed
      //   },
      //   backgroundColor: ThemeColors.primaryColor,
      //   textColor: ThemeColors.textColor,
      //   screenWidth: screenWidth,
      //   screenHeight: screenHeight,
      // );
    } else if (status == 'trip_started' || status == 'on_trip') {
      // Extract vehicle details safely
      Map<String, dynamic> vehicleDetails = {};

      // Check if vehicleDetails exists in bookingData
      if (bookingData.containsKey('vehicleDetails')) {
        vehicleDetails =
            Map<String, dynamic>.from(bookingData['vehicleDetails']);
      } else {
        // If not in vehicleDetails, try to get individual fields
        vehicleDetails = {
          'brand': bookingData['vehicleBrand'],
          'vehicleType': bookingData['vehicleType'],
          'seatingCapacity': bookingData['seatingCapacity'],
          'aboutVehicle': bookingData['aboutVehicle'],
          'totalPrice': bookingData['totalPrice'],
        };
      }

      return CustomButtons(
        text: 'Click to Pay Your Amount',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                vehicleDetails: vehicleDetails,
                bookingId: widget.bookingId,
                totalAmount: (bookingData['totalPrice'] ?? 0.0).toDouble(),
                driverId: bookingData['driverId'] ?? '',
              ),
            ),
          );
        },
        backgroundColor: ThemeColors.primaryColor,
        textColor: ThemeColors.textColor,
        screenWidth: screenWidth,
        screenHeight: screenHeight,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildWaitingIndicator() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.grey[200],
          ),
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(
              ThemeColors.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Connecting you with nearby drivers...',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: bookingRef.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> bookingSnapshot) {
        if (bookingSnapshot.hasError) {
          print('Error in snapshot: ${bookingSnapshot.error}');
          return const Center(child: Text('Error loading booking details'));
        }

        if (!bookingSnapshot.hasData ||
            bookingSnapshot.data?.snapshot.value == null) {
          if (_hasTimedOut) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_off,
                    size: 48,
                    color: ThemeColors.alertColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Request Timed Out',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.alertColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No drivers are currently available. Please try again later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return _buildWaitingContent();
        }

        final bookingData = Map<String, dynamic>.from(
            bookingSnapshot.data!.snapshot.value as Map);
        if (bookingData['driverId'] != null && _timeoutTimer != null) {
          _timeoutTimer!.cancel();
        }
        final driverId = bookingData['driverId'];
        final status = bookingData['status'] as String?;

        if (driverId != null && driverDetails == null) {
          FirebaseFirestore.instance
              .collection('driverProfiles')
              .doc(driverId)
              .get()
              .then((doc) {
            if (doc.exists) {
              setState(() {
                driverDetails = {
                  ...doc.data()!,
                  'displayName': doc.data()!['name'] ?? 'Unknown Driver',
                  'email': doc.data()!['email'] ?? 'no-email',
                };
              });
            }
          });
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Getting you the quickest ride',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.primaryColor,
                ),
              ),
              if (driverId == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _buildWaitingIndicator(),
                ),
              const SizedBox(height: 16),
              if (driverDetails != null) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor:
                          ThemeColors.primaryColor.withOpacity(0.1),
                      backgroundImage: driverDetails?['profileImageUrl'] != null
                          ? NetworkImage(driverDetails!['profileImageUrl'])
                          : null,
                      child: driverDetails?['profileImageUrl'] == null
                          ? const Icon(Icons.person,
                              color: ThemeColors.primaryColor, size: 32)
                          : null,
                    ),
                    title: Text(
                      driverDetails!['name'] ?? 'Unknown Driver',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        driverDetails!['contactNumber'] ?? 'No contact info',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ThemeColors.baseColor.withOpacity(0.8),
                                  ThemeColors.baseColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (driverDetails != null &&
                                    driverDetails!['contactNumber'] != null) {
                                  makePhoneCall(
                                      driverDetails!['contactNumber']);
                                } else {
                                  print('No contact information available');
                                }
                              },
                              icon: const Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ThemeColors.successColor.withOpacity(0.8),
                                  ThemeColors.successColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      receiverUserId: driverId,
                                      receiverName: driverDetails!['name'] ??
                                          'Unknown Driver',
                                      receiverAvatar:
                                          driverDetails!['profileImageUrl'],
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.message,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (status != 'trip_started' && status != 'on_trip')
                  CustomButtons(
                    text: 'Cancel Ride',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CancelRideScreen(
                            bookingId: widget.bookingId,
                          ),
                        ),
                      );
                    },
                    backgroundColor: ThemeColors.primaryColor,
                    textColor: Colors.white,
                    screenWidth: screenWidth * 0.8,
                    screenHeight: screenHeight,
                  ),
              ],
              const SizedBox(height: 16),
              if (status == 'trip_started' || status == 'on_trip')
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: ThemeColors.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: ThemeColors.successColor.withOpacity(0.3)),
                  ),
                  child: const Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(Icons.directions_car,
                          color: ThemeColors.successColor),
                      Text(
                        'Trip has started. Enjoy your ride!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.successColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              if (bookingData['estimatedArrival'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time,
                            size: 18, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          'ETA: ${bookingData['estimatedArrival']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              _buildActionButton(
                  status ?? '', screenWidth, screenHeight, bookingData),
            ],
          ),
        );
      },
    );
  }
}
