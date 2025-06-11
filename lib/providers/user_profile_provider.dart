import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfileProvider with ChangeNotifier {
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? bio;
  String? profileImagePath;
  String? profileImageUrl;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String? gender,
    required String bio,
    String? profileImagePath,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    String? imageUrl;
    if (profileImagePath != null) {
      final ref = FirebaseStorage.instance.ref().child('user_profiles/$uid.jpg');
      await ref.putFile(File(profileImagePath));
      imageUrl = await ref.getDownloadURL();
    }

    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'bio': bio,
      'profileImageUrl': imageUrl ?? this.profileImageUrl,
    });

    // Local update
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.gender = gender;
    this.bio = bio;
    this.profileImagePath = profileImagePath;
    this.profileImageUrl = imageUrl;

    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      name = data['name'];
      email = data['email'];
      phone = data['phone'];
      gender = data['gender'];
      bio = data['bio'];
      profileImageUrl = data['profileImageUrl'];
      notifyListeners();
    }
  }
}
