import 'package:flutter/material.dart';

class PrivacyPolicyContent extends StatelessWidget {
  const PrivacyPolicyContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a ListView instead of a Column for better scrolling behavior
    return ListView(
      shrinkWrap: true, // Important for proper sizing
      physics: const ClampingScrollPhysics(), // Prevents scroll conflicts
      children: [
        Text(
          'Last updated: January 12, 2025',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 24),
        const PolicySection(
          title: 'Interpretation and Definitions',
          content: '''
The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.

Definitions:
• Account: A unique account created for You to access our Service.
• Application: Refers to zoomio, the software program provided by the Company.
• Company: Refers to zoomio.
• Country: Refers to Kerala, India.
• Device: Any device that can access the Service.
''',
        ),
        // Other policy sections...
        const PolicySection(
          title: 'Collecting and Using Your Personal Data',
          content: '''
Types of Data Collected:

Personal Data
While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. This may include:
• Email address
• First name and last name
• Phone number
• Address, State, Province, ZIP/Postal code, City
• Usage Data

Usage Data
Usage Data is collected automatically when using the Service, including:
• Device's Internet Protocol address
• Browser type and version
• Pages visited and time spent
• Device identifiers
• Other diagnostic data
''',
        ),
        const PolicySection(
          title: 'Use of Your Personal Data',
          content: '''
The Company may use Personal Data for the following purposes:

• To provide and maintain our Service
• To manage Your Account
• For the performance of a contract
• To contact You regarding updates
• To provide You with news and special offers
• To manage Your requests
• For business transfers
• For other purposes with Your consent
''',
        ),
        const PolicySection(
          title: 'Security of Your Personal Data',
          content: '''
The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.
''',
        ),
        const PolicySection(
          title: 'Contact Us',
          content: '''
If you have any questions about this Privacy Policy, You can contact us:
By email: jincyjanani@gmail.com
''',
        ),
      ],
    );
  }
}

class PolicySection extends StatefulWidget {
  final String title;
  final String content;

  const PolicySection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<PolicySection> createState() => _PolicySectionState();
}

class _PolicySectionState extends State<PolicySection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Use a simpler approach to avoid gesture detection issues
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Make the header a regular button instead of ExpansionTile
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          // Show content conditionally
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
