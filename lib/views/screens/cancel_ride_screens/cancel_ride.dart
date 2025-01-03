import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class CancelRideScreen extends StatefulWidget {
  final String? bookingId;
  const CancelRideScreen({
    Key? key,
    this.bookingId,
  }) : super(key: key);

  @override
  State<CancelRideScreen> createState() => _CancelRideScreenState();
}

class _CancelRideScreenState extends State<CancelRideScreen> {
  final List<String> reasons = [
    "Waiting for long time",
    "Wrong address shown",
    "The price is not reasonable",
  ];

  final Map<String, bool> selectedReasons = {};
  String otherReason = "";

  @override
  void initState() {
    super.initState();
    for (var reason in reasons) {
      selectedReasons[reason] = false;
    }
  }

  Future<void> cancelRide(List<String> reasons, String otherReason) async {
    try {
      if (widget.bookingId == null) {
        throw Exception('Booking ID is null');
      }

      // Create the update data
      Map<String, dynamic> updates = {
        'status': 'customer_cancelled',
        'reasonsList': reasons,
        'otherReason': otherReason.isNotEmpty ? otherReason : null,
        'cancelledAt': ServerValue.timestamp,
      };

      // Update the booking status directly
      await FirebaseDatabase.instance
          .ref()
          .child('bookings')
          .child(widget.bookingId!)
          .update(updates);

      if (mounted && context.mounted) {
        // Pop any existing dialogs first
        Navigator.of(context).popUntil((route) => route.isFirst);

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                backgroundColor: Colors.grey.shade900,
                title: const Text(
                  'Ride Cancelled',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'Your ride has been cancelled successfully.',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Back Home',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      if (mounted && context.mounted) {
        // Pop any existing dialogs first
        Navigator.of(context).pop();

        // Show error dialog
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade900,
              title: const Text(
                'Error',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'Failed to cancel ride: ${e.toString()}',
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.amber),
                  ),
                )
              ],
            );
          },
        );
      }
    }
  }

  void submitCancellation() {
    final selected = selectedReasons.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selected.isEmpty && otherReason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select at least one reason.",
            style: TextStyle(color: ThemeColors.textColor),
          ),
          backgroundColor: ThemeColors.titleColor,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        );
      },
    );

    // Cancel the ride
    cancelRide(selected, otherReason).then((_) {
      // Loading indicator will be dismissed by the success dialog
    }).catchError((error) {
      Navigator.of(context).pop(); // Dismiss loading indicator
      print("Error cancelling ride: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        title: const Text("Cancel Ride"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Please select the reason of cancellation.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...reasons.map((reason) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedReasons[reason] == true
                          ? Colors.amber
                          : Colors.grey.shade700,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      reason,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    activeColor: Colors.amber,
                    checkColor: Colors.black,
                    value: selectedReasons[reason],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedReasons[reason] = value ?? false;
                      });
                    },
                    tileColor: Colors.grey.shade900,
                  ),
                );
              }).toList(),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => setState(() => otherReason = value),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  hintText: "Other",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomButtons(
                  text: "SUBMIT",
                  onPressed: () {
                    submitCancellation();
                  },
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
      backgroundColor: Colors.black,
    );
  }
}
