import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Need Assistance?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'If you’re experiencing issues or have questions, you can reach out to our support team. We’re here to help you!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Contact us at:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '📧 Email: waqasah652@gmail.com\n📞 Phone: +923476421106',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Frequently Asked Questions (FAQs)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '- How to reset password?\n- How to change profile details?\n- How to report a bug?',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
