import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  String? _email;
  String? _name;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get name => _name;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _isLoggedIn = true;
        _email = user.email;
        _name = user.displayName;
      } else {
        _isLoggedIn = false;
        _email = null;
        _name = null;
      }
      notifyListeners();
    });
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      _setLoading(true);

      // Firebase authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user data
      _isLoggedIn = true;
      _email = userCredential.user?.email;
      _name = userCredential.user?.displayName;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        default:
          errorMessage = 'Login failed. Please try again.';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      _setLoading(true);

      // Firebase authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user display name
      await userCredential.user?.updateDisplayName(name);

      // Update user data
      _isLoggedIn = true;
      _email = email;
      _name = name;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        default:
          errorMessage = 'An unknown error occurred.';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      await _auth.signOut();

      // Clear user data
      _isLoggedIn = false;
      _email = null;
      _name = null;
      notifyListeners();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _setLoading(true);
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> checkSession() async {
    try {
      _setLoading(true);
      // Firebase automatically maintains the session
      // We just need to check the current user
      return _auth.currentUser != null;
    } finally {
      _setLoading(false);
    }
  }

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
}