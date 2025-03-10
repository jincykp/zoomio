import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomer/services/booking_services_now.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_botttomsheet.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';
import 'package:zoomer/views/screens/where_to_go_screens/cubit/selected_vehicle_cubit.dart';

class CustomBookNowContainer extends StatefulWidget {
  final String pickupText;
  final String dropoffText;
  final String seatingCapacity;
  const CustomBookNowContainer({
    super.key,
    required this.pickupText,
    required this.dropoffText,
    required this.seatingCapacity,
  });

  @override
  State<CustomBookNowContainer> createState() => _CustomBookNowContainerState();
}

class _CustomBookNowContainerState extends State<CustomBookNowContainer> {
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      bookingSubscription;
  bool isBookingInProgress = false;

  @override
  void initState() {
    super.initState();
    bookingSubscription = null;
  }

  void _showBookingBottomSheet(String bookingId) {
    bookingSubscription = listenToBookingUpdates(bookingId).listen((snapshot) {
      if (!mounted) return;

      if (snapshot.exists) {
        final data = snapshot.data();

        if (data?['status'] == 'driver_accepted') {
          _bottomsheet(bookingId);
        }
      }
    });
  }

  @override
  void dispose() {
    bookingSubscription?.cancel();
    super.dispose();
  }

  void _bottomsheet(String bookingId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: CustomBottomsheet(bookingId: bookingId),
        );
      },
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToBookingUpdates(
      String bookingId) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02, // Reduce vertical padding
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: SingleChildScrollView(
          // Add this to make content scrollable
          child: BlocBuilder<SelectedVehicleCubit, SelectedVehicleState>(
            builder: (context, state) {
              if (state is VehicleLoading) {
                return Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: ThemeColors.primaryColor,
                    ),
                  ),
                );
              } else if (state is VehicleLoaded) {
                final vehicle = state.vehicle;

                // Main container for dialog
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        // FIXED: Adjusted padding
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical:
                              screenWidth * 0.03, // Reduced vertical padding
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Vehicle title and ratings
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    "${vehicle['brand'] ?? 'No Brand'}",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeColors.primaryColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.white, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${vehicle['rating'] ?? '4.5'}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Vehicle description
                            Text(
                              vehicle['aboutVehicle'] ??
                                  'No details about the vehicle available.',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Features list
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _buildFeatureChip(
                                  Icons.people,
                                  "${widget.seatingCapacity} seats",
                                ),
                                if (vehicle['vehicleType'] != 'Bike' &&
                                    vehicle['vehicleType'] != 'bike')
                                  _buildFeatureChip(Icons.ac_unit, "AC"),
                                _buildFeatureChip(Icons.luggage,
                                    "${vehicle['luggage'] ?? '2'} bags"),
                              ],
                            ),

                            const SizedBox(height: 16),
                            Divider(
                              color:
                                  isDarkMode ? Colors.white24 : Colors.black12,
                            ),
                            const SizedBox(height: 16),

                            // Trip details
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.green, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          widget.pickupText,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Divider(
                                    height: 1,
                                    color: isDarkMode
                                        ? Colors.white24
                                        : Colors.black12,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.red, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          widget.dropoffText,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Fare details - FIXED: Price overflow handling
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total fare (incl. taxes)",
                                  style: TextStyle(
                                    //  fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "₹${vehicle['totalPrice']?.toStringAsFixed(2) ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeColors.primaryColor,
                                    ),
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Fare disclaimer
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Total fare may change if toll, route, or destination changes, or if your ride takes longer due to traffic or other factors.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black54,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDarkMode
                                          ? Colors.grey[800]
                                          : Colors.white,
                                      foregroundColor: ThemeColors.primaryColor,
                                      elevation: 0,
                                      side: BorderSide(
                                          color: ThemeColors.primaryColor),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      "CANCEL",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (isBookingInProgress) return;

                                      setState(() {
                                        isBookingInProgress = true;
                                      });

                                      try {
                                        // Initialize the booking service
                                        final bookingService = BookingService();

                                        // Fetch the current user ID
                                        String userId = FirebaseAuth
                                                .instance.currentUser?.uid ??
                                            "unknown_user";

                                        // Get pickup and drop-off locations from the widget
                                        String pickupLocation =
                                            widget.pickupText;
                                        String dropOffLocation =
                                            widget.dropoffText;

                                        // Retrieve vehicle details from the state
                                        Map<String, dynamic> vehicleDetails =
                                            state.vehicle;

                                        // Save the booking to Firebase and get the booking ID
                                        String bookingId =
                                            await bookingService.saveBooking(
                                          userId: userId,
                                          pickupLocation: pickupLocation,
                                          dropOffLocation: dropOffLocation,
                                          vehicleDetails: vehicleDetails,
                                          totalPrice:
                                              vehicleDetails['totalPrice'] ??
                                                  0.0,
                                        );

                                        // Show confirmation message
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Booking confirmed successfully!"),
                                              backgroundColor: Colors.green,
                                            ),
                                          );

                                          // Close the dialog
                                          Navigator.of(context).pop();

                                          // Open the bottom sheet with the bookingId
                                          _bottomsheet(bookingId);
                                        }
                                      } catch (e) {
                                        // Handle any errors
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Error: ${e.toString()}"),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } finally {
                                        if (mounted) {
                                          setState(() {
                                            isBookingInProgress = false;
                                          });
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: isBookingInProgress
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            "BOOK NOW",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: ThemeColors.alertColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Unable to load vehicle details",
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColors.primaryColor,
                          ),
                          child: const Text("Go Back"),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ThemeColors.primaryColor.withOpacity(0.15)
            : ThemeColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: ThemeColors.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: ThemeColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
