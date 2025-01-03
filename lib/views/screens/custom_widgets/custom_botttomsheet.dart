import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zoomer/views/screens/cancel_ride_screens/cancel_ride.dart';
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

  Widget _buildActionButton(
      String status, double screenWidth, double screenHeight) {
    if (status == 'driver_accepted') {
      return Column(
        children: [
          _buildMovingProgressBar(),
          const SizedBox(height: 16),
          CustomButtons(
            text: 'Cancel Ride',
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CancelRideScreen(bookingId: widget.bookingId)));
            },
            backgroundColor: ThemeColors.primaryColor,
            textColor: ThemeColors.textColor,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
        ],
      );
    } else if (status == 'trip_started' || status == 'on_trip') {
      return Column(
        children: [
          _buildMovingProgressBar(),
          const SizedBox(height: 16),
          CustomButtons(
            text: 'Click to Pay Your Amount',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentScreen()));
            },
            backgroundColor: ThemeColors.primaryColor,
            textColor: ThemeColors.textColor,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
        ],
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
                driverDetails = doc.data();
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
                      Card(
                        elevation: 8,
                        child: IconButton(
                          onPressed: () {
                            // Call driver action
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
                            // Message driver action
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
              _buildActionButton(status ?? '', screenWidth, screenHeight),
            ],
          ),
        );
      },
    );
  }
}
