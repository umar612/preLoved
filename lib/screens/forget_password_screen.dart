import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      try {
        await Provider.of<AppAuthProvider>(context, listen: false)
            .resetPassword(_emailController.text.trim());

        setState(() {
          _isSending = false;
          _emailSent = true;
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        setState(() => _isSending = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                _emailSent
                    ? 'We have sent a password reset link to your email. Please check your inbox and follow the instructions to reset your password.'
                    : 'Enter your email address and we will send you a link to reset your password.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),
              if (!_emailSent) ...[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button background
                      foregroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: _isSending ? null : _sendResetEmail,
                    child: _isSending
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Send Reset Link'),
                  ),
                ),

              ],
              if (_emailSent) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back to Login'),
                  ),
                ),

              ],
            ],
          ),
        ),
      ),
    );
  }
}