import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/screens/otp_verification_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification email sent. Please check your inbox."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OtpVerificationScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Signup failed.";
      if (e.code == 'email-already-in-use') {
        message = "This email is already in use.";
      } else if (e.code == 'weak-password') {
        message = "Password should be at least 6 characters.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Name is required";
                  return null;
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email is required";
                  if (!value.contains("@")) return "Enter a valid email";
                  return null;
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _showPassword = !_showPassword);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) return "Minimum 6 characters required";
                  return null;
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _showConfirmPassword = !_showConfirmPassword);
                    },
                  ),
                ),
                validator: (value) {
                  if (value != _passwordController.text) return "Passwords do not match";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
