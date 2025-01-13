import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:zoomer/views/home_page.dart';
import 'package:zoomer/views/screens/bottom_screens/home_screen.dart';
import 'package:zoomer/views/screens/custom_widgets/custom_butt.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class FeedbackScreen extends StatefulWidget {
  final String driverId; // ID to associate the rating with a specific driver

  const FeedbackScreen({super.key, required this.driverId});

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
      // Get complaint, feedback, and rating
      String complaint = _complaintController.text.trim();
      String feedback = _feedbackController.text.trim();

      try {
        // Reference to the specific driver's document in Firestore
        DocumentReference driverDoc = FirebaseFirestore.instance
            .collection('drivers')
            .doc(widget.driverId);

        // Save feedback in the driver's subcollection
        await driverDoc.collection('feedbacks').add({
          'complaint': complaint,
          'feedback': feedback,
          'rating': _driverRating,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Fetch the driver's current average rating and total ratings
        DocumentSnapshot driverSnapshot = await driverDoc.get();
        if (driverSnapshot.exists) {
          double currentAverageRating =
              driverSnapshot.get('averageRating') ?? 0.0;
          int currentTotalRatings = driverSnapshot.get('totalRatings') ?? 0;

          // Calculate the new average rating
          double newAverageRating =
              ((currentAverageRating * currentTotalRatings) + _driverRating) /
                  (currentTotalRatings + 1);

          // Update the driver's document with the new rating and count
          await driverDoc.update({
            'averageRating': newAverageRating,
            'totalRatings': currentTotalRatings + 1,
          });
        } else {
          // If the driver document doesn't exist, initialize rating data
          await driverDoc.set({
            'averageRating': _driverRating,
            'totalRatings': 1,
          });
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your feedback has been submitted.')),
        );

        // Clear the form fields
        _complaintController.clear();
        _feedbackController.clear();
        setState(() {
          _driverRating = 3.0; // Reset to default
        });

        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        // Show error message if submission fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit feedback. Try again.')),
        );
      }
    }
  }
}
