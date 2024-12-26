import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
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

class _CustomBottomsheetState extends State<CustomBottomsheet> {
  late DatabaseReference bookingRef;
  Map<String, dynamic>? driverDetails;

  @override
  void initState() {
    super.initState();
    bookingRef =
        FirebaseDatabase.instance.ref().child('bookings/${widget.bookingId}');
  }

  bool shouldShowPaymentButton(String? status) {
    // Add debug print to track status
    print('Current booking status: $status');
    return status == 'driver_accepted' ||
        status == 'trip_started' ||
        status == 'on_trip';
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
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Waiting for driver to accept...'),
              ],
            ),
          );
        }

        final bookingData = Map<String, dynamic>.from(
            bookingSnapshot.data!.snapshot.value as Map);

        final driverId = bookingData['driverId'];
        final status = bookingData['status'] as String?;

        // Debug print for booking data
        print('Booking Data: $bookingData');
        print('Driver ID: $driverId');
        print('Status: $status');

        // Fetch driver details only once and retain them
        if (driverId != null && driverDetails == null) {
          FirebaseFirestore.instance
              .collection('driverProfiles')
              .doc(driverId)
              .get()
              .then((doc) {
            if (doc.exists) {
              setState(() {
                driverDetails = doc.data();
              });
            }
          });
        }

        if (driverId != null && driverDetails == null) {
          return const Center(child: CircularProgressIndicator());
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
              const SizedBox(height: 16),
              if (driverDetails != null)
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
                      IconButton(
                        onPressed: () {
                          // Call driver action
                        },
                        icon: const Icon(
                          Icons.call,
                          color: ThemeColors.baseColor,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Message driver action
                        },
                        icon: const Icon(
                          Icons.message,
                          color: ThemeColors.successColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
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
              // Show payment button for all relevant statuses
              if (shouldShowPaymentButton(status))
                CustomButtons(
                  text: 'Click To Pay Your Amount',
                  onPressed: () {
                    // Payment action
                  },
                  backgroundColor: ThemeColors.primaryColor,
                  textColor: ThemeColors.textColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
            ],
          ),
        );
      },
    );
  }
}
