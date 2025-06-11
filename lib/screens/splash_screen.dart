import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'main/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Makes the animation loop indefinitely

    // Create a curved animation for smoother rotation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => authProvider.isLoggedIn
            ? const HomeScreen()
            : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _animation,
              child: Icon(
                Icons.recycling,
                size: 100,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pre-loved Fashion',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Sustainable Style',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}