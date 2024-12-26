import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    bookingRef =
        FirebaseDatabase.instance.ref().child('bookings/${widget.bookingId}');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bookingRef.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> bookingSnapshot) {
        if (bookingSnapshot.hasError) {
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
        final status = bookingData['status'];

        if (status != 'driver_accepted' || driverId == null) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Waiting for driver acceptance...'),
              ],
            ),
          );
        }

        // Once we have a driver, show their details
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('driverProfiles')
              .doc(driverId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> driverSnapshot) {
            if (driverSnapshot.hasError) {
              return const Center(child: Text('Error loading driver details'));
            }

            if (!driverSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final driverData =
                driverSnapshot.data!.data() as Map<String, dynamic>?;

            if (driverData == null) {
              return const Center(child: Text('Driver details not found'));
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
                        color: ThemeColors.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  // Display driver details
                  ListTile(
                    leading: CircleAvatar(
                     // radius: 50,
                      backgroundImage: driverData['profileImageUrl'] != null
                          ? NetworkImage(driverData['profileImageUrl'])
                          : null,
                      child: driverData['profileImageUrl'] == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(driverData['name'] ?? 'Unknown Driver'),
                    subtitle:
                        Text(driverData['contactNumber'] ?? 'No i contact nfo'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.message)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Add more driver details as needed

                  if (bookingData['estimatedArrival'] != null)
                    Text('ETA: ${bookingData['estimatedArrival']}'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
