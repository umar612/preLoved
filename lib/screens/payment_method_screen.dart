import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedPaymentMethod;

  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();
  final _paypalController = TextEditingController();
  final _googlePayController = TextEditingController();
  final _applePayController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _paypalController.dispose();
    _googlePayController.dispose();
    _applePayController.dispose();
    super.dispose();
  }

  void _pay() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Processing Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Please wait...'),
            ],
          ),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Payment successful via $_selectedPaymentMethod')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }
  }

  Widget _buildPaymentInputs() {
    switch (_selectedPaymentMethod) {
      case 'Credit Card':
        return Column(
          children: [
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                prefixIcon: Icon(Icons.credit_card),
              ),
              maxLength: 16,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.replaceAll(' ', '').length != 16) {
                  return 'Enter valid 16-digit card number';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cardExpiryController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    maxLength: 5,
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$')
                              .hasMatch(value)) {
                        return 'Enter valid expiry MM/YY';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _cardCvvController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    maxLength: 3,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length != 3) {
                        return 'Enter 3-digit CVV';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        );

      case 'PayPal':
        return TextFormField(
          controller: _paypalController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'PayPal Email',
            prefixIcon: Icon(Icons.email),
          ),
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
              return 'Enter valid email';
            }
            return null;
          },
        );

      case 'Google Pay':
        return TextFormField(
          controller: _googlePayController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Google Pay Email/Phone',
            prefixIcon: Icon(Icons.phone_android),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter Google Pay account';
            }
            return null;
          },
        );

      case 'Apple Pay':
        return TextFormField(
          controller: _applePayController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Apple Pay Email/Phone',
            prefixIcon: Icon(Icons.phone_iphone),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter Apple Pay account';
            }
            return null;
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...['Credit Card', 'PayPal', 'Google Pay', 'Apple Pay']
                  .map(
                    (method) => RadioListTile<String>(
                  title: Text(method),
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;

                      // Clear all inputs
                      _cardNumberController.clear();
                      _cardExpiryController.clear();
                      _cardCvvController.clear();
                      _paypalController.clear();
                      _googlePayController.clear();
                      _applePayController.clear();
                    });
                  },
                ),
              )
                  .toList(),
              const SizedBox(height: 10),
              _buildPaymentInputs(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedPaymentMethod == null ? null : _pay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Change to any color you want
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Pay Now'),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
