import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zoomer/services/stripe_services.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/feedback_screen/feedback_screen.dart';

import '../styles/appstyles.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> vehicleDetails;
  final String bookingId;
  final double totalAmount;
  final String driverId;

  const PaymentScreen({
    Key? key,
    required this.vehicleDetails,
    required this.bookingId,
    required this.totalAmount,
    required this.driverId,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void startPayment() async {
    setState(() => _isLoading = true);

    try {
      var options = {
        'key': 'rzp_test_i8191KFpq7S1w1', // Replace with your actual key
        'amount': (widget.totalAmount * 100)
            .toInt(), // Amount in smallest currency unit
        'name': 'Vehicle Booking',
        'description': 'Booking ID: ${widget.bookingId}',
        'currency': 'INR', // Changed to INR as you're using ₹
        'prefill': {
          'contact': '', // Add user's phone number here
          'email': '', // Add user's email here
        },
        'external': {
          'wallets': ['paytm']
        },
        'theme': {
          'color': '#2196F3' // Match with your primary color
        }
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      // Display success message
      _showSuccess('Payment Successful!\nPayment ID: ${response.paymentId}');

      // Simulate backend API call to update booking status
      // await YourApiService.updateBookingStatus(widget.bookingId, response.paymentId);

      // Navigate to the HomeScreen after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FeedbackScreen(
                      driverId: widget.driverId,
                      bookingId: widget.bookingId,
                    )));
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => const HomePage()),
        //   (Route<dynamic> route) => false, // Remove all previous routes
        // );
      });
    } catch (e) {
      _showError(
          'Payment verified but could not update booking. Please contact support.');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showError('Payment Failed: ${response.message ?? 'Something went wrong'}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showMessage('External Wallet Selected: ${response.walletName}');
  }

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                      const Text(
                        'Vehicle Details',
                        style: Textstyles.gTextdescriptionSecond,
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            widget.vehicleDetails['vehicleType']
                                        ?.toString()
                                        .toLowerCase() ==
                                    'bike'
                                ? Icons.directions_bike
                                : Icons.directions_car,
                          ),
                        ),
                        title: Text(
                          widget.vehicleDetails['brand']?.toString() ??
                              'No Brand',
                          style: Textstyles.gTextdescription,
                        ),
                        subtitle: Text(
                          'for ${widget.vehicleDetails['seatingCapacity']?.toString() ?? 'N/A'} Person',
                        ),
                      ),
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
                      const Text(
                        'Payment Summary',
                        style: Textstyles.gTextdescriptionSecond,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Trip Fare'),
                          Text('₹${widget.totalAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: Textstyles.gTextdescriptionWithColor,
                          ),
                          Text(
                            '₹${widget.totalAmount.toStringAsFixed(2)}',
                            style: Textstyles.gTextdescriptionWithColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Payment Button
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButtons(
                        text: "Proceed to Payment",
                        onPressed: startPayment,
                        backgroundColor: ThemeColors.primaryColor,
                        textColor: ThemeColors.textColor,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
