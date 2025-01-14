import 'package:flutter/material.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            //  color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: ThemeColors.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFAQSection(),
              const SizedBox(height: 24),
              _buildContactSupportSection(),
              const SizedBox(height: 24),
              _buildReportIssueSection(),
              const SizedBox(height: 24),
              _buildTermsAndConditionsSection(),
              const SizedBox(height: 24),
              _buildSocialMediaSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        //  color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.titleColor),
        boxShadow: const [
          // BoxShadow(
          //   //color: Colors.grey.withOpacity(0.1),
          //   spreadRadius: 1,
          //   blurRadius: 5,
          //   offset: Offset(0, 2),
          // ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to Zoomio Help & Support!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "We're here to assist you with any questions or issues you may have. Below you'll find helpful answers to your most common queries, as well as ways to contact us if you need further assistance.",
            style: TextStyle(
              fontSize: 16,
              // color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return _buildSection(
      title: "Frequently Asked Questions",
      child: Column(
        children: [
          _buildFAQItem(
            "How do I book a cab?",
            "To book a cab, open the app, enter your pick-up and drop-off locations, and confirm your booking.",
          ),
          _buildFAQItem(
            "How do I track my ride?",
            "Once your ride is confirmed, you can track your driver's location in real-time.",
          ),
          _buildFAQItem(
            "How can I cancel my booking?",
            "Go to 'Your Ride' and tap 'Cancel Ride.'",
          ),
          _buildFAQItem(
            "How are fares calculated?",
            "Fares are based on distance, time, and vehicle type.",
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   //  color: Colors.grey[50],
      //   borderRadius: BorderRadius.circular(8),
      //   border: Border.all(color: ThemeColors.titleColor),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              // color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              //color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSupportSection() {
    return _buildSection(
      title: "Contact Support",
      child: Column(
        children: [
          _buildContactItem(
            "Phone Support",
            "Call us at: 1-800-ZOOMIO (1-800-966-6466)",
            Icons.phone,
          ),
          _buildContactItem(
            "Email Support",
            "Email us at: support@zoomio.com",
            Icons.email,
          ),
          _buildContactItem(
            "Live Chat",
            "Start a live chat with our support team in the app.",
            Icons.chat_bubble,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(String title, String info, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.titleColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: ThemeColors.primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    //color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info,
                  style: const TextStyle(
                    fontSize: 14,
                    // color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportIssueSection() {
    return _buildSection(
      title: "Report an Issue",
      child: _buildContactItem(
        "Submit a Ticket",
        "Click here to submit an issue to our support team.",
        Icons.report_problem,
      ),
    );
  }

  Widget _buildTermsAndConditionsSection() {
    return _buildSection(
      title: "Terms and Conditions / Privacy Policy",
      child: Column(
        children: [
          _buildContactItem(
            "View Terms & Conditions",
            "Read our terms and conditions here.",
            Icons.description,
          ),
          _buildContactItem(
            "View Privacy Policy",
            "Learn how we handle your data.",
            Icons.privacy_tip,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return _buildSection(
      title: "Stay Connected",
      child: Column(
        children: [
          _buildContactItem(
            "Facebook",
            "@ZoomioApp",
            Icons.facebook,
          ),
          _buildContactItem(
            "Twitter",
            "@ZoomioApp",
            Icons.catching_pokemon,
          ),
          _buildContactItem(
            "Instagram",
            "@ZoomioApp",
            Icons.camera_alt,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.titleColor),
        // boxShadow: const [
        //   BoxShadow(
        //     //color: Colors.grey.withOpacity(0.1),
        //     spreadRadius: 1,
        //     blurRadius: 5,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              // color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
