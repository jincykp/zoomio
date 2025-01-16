import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/bottom_screens/home_screen.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class FeedbackScreen extends StatefulWidget {
  final String driverId;
  final String bookingId;

  const FeedbackScreen({
    super.key,
    required this.driverId,
    required this.bookingId,
  });

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  double _driverRating = 3.0; // Default rating

  // Function to submit feedback

  @override
  void dispose() {
    _complaintController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        title: const Text('Complaint & Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver Rating Section
              const Text(
                "Rate Your Driver:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                initialRating: _driverRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: ThemeColors.primaryColor),
                onRatingUpdate: (rating) {
                  setState(() {
                    _driverRating = rating;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Complaint Section
              TextFormField(
                controller: _complaintController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Complaint about the Vehicle',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your complaint';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Feedback Section
              TextFormField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Overall Travel Experience',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              CustomButtons(
                text: "Submit",
                onPressed: submitFeedback,
                backgroundColor: ThemeColors.primaryColor,
                textColor: ThemeColors.textColor,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitFeedback() async {
    if (_formKey.currentState?.validate() ?? false) {
      String complaint = _complaintController.text.trim();
      String feedback = _feedbackController.text.trim();
      double rating = _driverRating;
      String driverId = widget.driverId;
      String bookingId = widget.bookingId; // Access the bookingId from widget

      DatabaseReference bookingRef =
          FirebaseDatabase.instance.ref('bookings/$bookingId');

      try {
        await bookingRef.update({
          'feedback': {
            'complaint': complaint,
            'feedback': feedback,
            'rating': rating,
            'timestamp': ServerValue.timestamp,
            'driverId': driverId
          },
          'hasCustomerFeedback': true
        });

        // Optionally update driver's average rating
        DatabaseReference driverRef =
            FirebaseDatabase.instance.ref('drivers/$driverId');
        // You would need to implement the logic to recalculate average rating

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your feedback has been submitted.')),
        );

        _complaintController.clear();
        _feedbackController.clear();
        setState(() {
          _driverRating = 3.0;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit feedback: ${e.toString()}')),
        );
      }
    }
  }
}
