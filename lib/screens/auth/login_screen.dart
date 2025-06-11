import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:new_app/screens/forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await _animationController.reverse();

      try {
        await Provider.of<AppAuthProvider>(context, listen: false).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        _animationController.forward();
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Widget _buildAnimatedButton({
    required VoidCallback? onPressed,
    required Widget child,
    bool isPrimary = true,
    bool isLoading = false,
  }) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: isPrimary
                ? (isLoading
                ? theme.colorScheme.primary.withOpacity(0.7)
                : theme.colorScheme.primary)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isPrimary ? null : Border.all(color: theme.colorScheme.primary),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: isLoading ? null : onPressed,
              child: Center(
                child: isLoading && isPrimary
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary),
                  strokeWidth: 2,
                )
                    : AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isPrimary
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.primary,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.primary; // Using primary color for borders
    final iconColor = theme.colorScheme.primary;   // Using primary color for icons

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      'Welcome Back',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: borderColor),
                    prefixIcon: Icon(Icons.email, color: iconColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor.withOpacity(0.8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.error),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: borderColor),
                    prefixIcon: Icon(Icons.lock, color: iconColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: iconColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor.withOpacity(0.8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.error),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnimatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: const Text('LOGIN'),
                  isPrimary: true,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 15),
                _buildAnimatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text('CREATE ACCOUNT'),
                  isPrimary: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}