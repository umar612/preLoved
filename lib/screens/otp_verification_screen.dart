import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth/login_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool _isVerified = false;
  bool _isLoading = false;

  Future<void> _checkEmailVerified() async {
    setState(() => _isLoading = true);
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      setState(() => _isVerified = true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email is not verified yet. Please check your inbox."),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Your Email")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "A verification link has been sent to your email. Please verify to continue.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _checkEmailVerified,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("I have verified"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
