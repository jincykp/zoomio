import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomer/services/booking_services.dart';

import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';
import 'package:zoomer/views/screens/where_to_go_screens/cubit/selected_vehicle_cubit.dart';

class CustomAlertCard extends StatelessWidget {
  final String pickupText;
  final String dropoffText;
  const CustomAlertCard({
    super.key,
    required this.pickupText,
    required this.dropoffText,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // GetAccessToken getAccessToken = GetAccessToken();

    return BlocBuilder<SelectedVehicleCubit, SelectedVehicleState>(
      builder: (context, state) {
        if (state is VehicleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VehicleLoaded) {
          final vehicle = state.vehicle;
          print("Vehicle Data: $vehicle");
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.7,
              ),
              child: SizedBox(
                width: screenWidth * 0.8,
                child: Card(
                  elevation: 35,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${vehicle['brand'] ?? 'No Brand'}",
                          style: Textstyles.gTextdescriptionSecond,
                        ),
                        // SizedBox(height: screenHeight * 0.0),
                        Text(vehicle['aboutVehicle'] ??
                            'No details about the vehicle available.'), // Display aboutVehicle
                        SizedBox(height: screenHeight * 0.04),
                        Text.rich(TextSpan(
                            text: "Total fare includes taxes: ",
                            children: [
                              TextSpan(
                                  text:
                                      "₹${vehicle['totalPrice']?.toStringAsFixed(2) ?? 'N/A'}",
                                  style: Textstyles.gTextdescriptionWithColor)
                            ]))
                        // Text(
                        //   "Total fare includes taxes: ₹ ${vehicle['totalPrice']?.toStringAsFixed(2) ?? 'N/A'}", // Display totalPrice
                        // ),
                        ,
                        SizedBox(height: screenHeight * 0.02),
                        const Text(
                          "Total fare may change if toll, route, or destination changes, or if your ride takes longer due to traffic or other factors.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: ThemeColors.primaryColor),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomButtons(
                                text: "CANCEL",
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                backgroundColor: ThemeColors.primaryColor,
                                textColor: ThemeColors.textColor,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: CustomButtons(
                                text: "BOOK NOW",
                                onPressed: () async {
                                  // getAccessToken.sendFCMMessage();
                                  final bookingService = BookingService();
                                  String userId = FirebaseAuth
                                          .instance.currentUser?.uid ??
                                      "unknown_user"; // Fetch current user ID
                                  String pickupLocation = pickupText;
                                  String dropOffLocation = dropoffText;
                                  Map<String, dynamic> vehicleDetails =
                                      state.vehicle;

                                  await bookingService.saveBooking(
                                    userId: userId,
                                    pickupLocation: pickupLocation,
                                    dropOffLocation: dropOffLocation,
                                    vehicleDetails: vehicleDetails,
                                  );

// Confirmation message or navigate to next screen
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Booking confirmed successfully!"),
                                    ),
                                  );
                                },
                                backgroundColor: ThemeColors.primaryColor,
                                textColor: ThemeColors.textColor,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text("Error: Unable to load vehicle details."),
          );
        }
      },
    );
  }
}
