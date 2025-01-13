import 'package:flutter/material.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: ThemeColors.primaryColor,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                const Text(
                  "Welcome to Zoomio!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),

                // Introduction
                _buildSection(
                  "Zoomio is your reliable and convenient cab booking service, designed to get you where you need to be safely and on time. Whether you're going to work, heading to an airport, or traveling for leisure, we have got you covered. Our easy-to-use app allows you to book rides in just a few taps, offering fast, affordable, and comfortable transportation.",
                ),
                const SizedBox(height: 24),

                // Mission Section
                _buildHeader("Our Mission"),
                _buildSection(
                  "To provide seamless and stress-free travel experiences with safe, professional drivers and competitive pricing. Zoomio strives to offer you the best ride every time, making your transportation experience smoother and more reliable.",
                ),
                const SizedBox(height: 24),

                // Features Section
                _buildHeader("Why Choose Zoomio?"),
                const SizedBox(height: 16),

                // Feature List
                _buildFeatureItem("Convenient Booking",
                    "Book your ride easily with just a few taps"),
                _buildFeatureItem("Professional Drivers",
                    "Experienced and friendly drivers for a safe journey"),
                _buildFeatureItem("Affordable Rates",
                    "Transparent pricing with no hidden charges"),
                _buildFeatureItem("Real-time Tracking",
                    "Track your ride in real time for peace of mind"),
                const SizedBox(height: 24),

                // Thank You Note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThemeColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Thank you for choosing Zoomio! We look forward to serving you and making your journey more enjoyable.",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: ThemeColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: ThemeColors.primaryColor,
      ),
    );
  }

  Widget _buildSection(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        height: 1.5,
        //color: Colors.black87,
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ThemeColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_circle,
              color: ThemeColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    //  color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
