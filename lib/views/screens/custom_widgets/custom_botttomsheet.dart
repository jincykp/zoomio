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
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Widget _buildMovingProgressBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Driver is on the way',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ThemeColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.grey[200],
            ),
            child: AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: const [
                        ThemeColors.primaryColor,
                        ThemeColors.primaryColor,
                        Colors.transparent,
                        ThemeColors.primaryColor,
                      ],
                      stops: [
                        0.0,
                        _progressController.value,
                        _progressController.value + 0.1,
                        1.0,
                      ],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 4,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String status, double screenWidth,
      double screenHeight, Map<String, dynamic> bookingData) {
    if (status == 'driver_accepted') {
      // ... existing code ...
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
          // Print debug information
          print('Booking Data: $bookingData');
          print('Vehicle Details: $vehicleDetails');

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
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Getting you the quickest ride',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.primaryColor,
                  ),
                ),
                _buildWaitingIndicator(),
              ],
            ),
          );
        }

        final bookingData = Map<String, dynamic>.from(
            bookingSnapshot.data!.snapshot.value as Map);

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
                  // Add other required fields with default values
                };
              });
            }
          });
        }

        if (driverId != null && driverDetails == null) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Getting you the quickest ride',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.primaryColor,
                  ),
                ),
                _buildWaitingIndicator(),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Getting you the quickest ride',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.primaryColor,
                ),
              ),
              // Show progress indicator only when no driver is assigned yet
              if (driverId == null) _buildWaitingIndicator(),
              const SizedBox(height: 16),
              if (driverDetails != null) ...[
                // Using spread operator to add multiple widgets
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: driverDetails?['profileImageUrl'] != null
                        ? NetworkImage(driverDetails!['profileImageUrl'])
                        : null,
                    child: driverDetails?['profileImageUrl'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(driverDetails!['name'] ?? 'Unknown Driver'),
                  subtitle: Text(
                      driverDetails!['contactNumber'] ?? 'No contact info'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        elevation: 8,
                        child: IconButton(
                          onPressed: () {
                            if (driverDetails != null &&
                                driverDetails!['contactNumber'] != null) {
                              makePhoneCall(driverDetails!['contactNumber']);
                            } else {
                              print('No contact information available');
                            }
                          },
                          icon: const Icon(
                            Icons.call,
                            color: ThemeColors.baseColor,
                            size: 30,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 8,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  receiverUserEmail:
                                      driverDetails!['email'] ?? 'Driver',
                                  receiverUserId: driverId,
                                  receiverName: driverDetails!['name'] ??
                                      'Unknown Driver', // Add fallback value
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.message,
                            color: ThemeColors.successColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Add Cancel Ride button right after driver details
                if (status != 'trip_started' &&
                    status !=
                        'on_trip') // Show cancel button before trip starts
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
                const Text(
                  'Trip has started. Enjoy your ride!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.successColor,
                  ),
                ),
              if (bookingData['estimatedArrival'] != null)
                Text('ETA: ${bookingData['estimatedArrival']}'),
              const SizedBox(height: 16),
              _buildActionButton(
                  status ?? '', screenWidth, screenHeight, bookingData),
            ],
          ),
        );
      },
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }
}
