import 'package:flutter/material.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';

import '../styles/appstyles.dart';

class PaymentScreen extends StatelessWidget {
  final Map<String, dynamic> vehicleDetails;
  final String bookingId;
  final double totalAmount;

  const PaymentScreen({
    Key? key,
    required this.vehicleDetails,
    required this.bookingId,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Print debug information
    print('Vehicle Details in PaymentScreen: $vehicleDetails');
    print('Booking ID: $bookingId');
    print('Total Amount: $totalAmount');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: ThemeColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Details Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Details',
                        style: Textstyles.gTextdescriptionSecond,
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            vehicleDetails['vehicleType']
                                        ?.toString()
                                        .toLowerCase() ==
                                    'bike'
                                ? Icons.directions_bike
                                : Icons.directions_car,
                          ),
                        ),
                        title: Text(
                          vehicleDetails['brand']?.toString() ?? 'No Brand',
                          style: Textstyles.gTextdescription,
                        ),
                        subtitle: Text(
                          'for ${vehicleDetails['seatingCapacity']?.toString() ?? 'N/A'} Person',
                        ),
                      ),
                      if (vehicleDetails['aboutVehicle'] != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          vehicleDetails['aboutVehicle'].toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Payment Summary Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Summary',
                        style: Textstyles.gTextdescriptionSecond,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Trip Fare'),
                          Text('₹${totalAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: Textstyles.gTextdescriptionWithColor,
                          ),
                          Text(
                            '₹${totalAmount.toStringAsFixed(2)}',
                            style: Textstyles.gTextdescriptionWithColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),
              const Text("Select Payment method"),
              SizedBox(height: screenHeight * 0.01),
              // Payment Button
              SizedBox(
                  width: double.infinity,
                  child: CustomButtons(
                      text: "Proceed to Payment",
                      onPressed: () {},
                      backgroundColor: ThemeColors.primaryColor,
                      textColor: ThemeColors.textColor,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight)),
            ],
          ),
        ),
      ),
    );
  }
}
