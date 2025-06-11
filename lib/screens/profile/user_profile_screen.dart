import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:new_app/screens/profile/edit_profile_screen.dart';
import 'dart:io';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<UserProfileProvider>(context);
    final authProvider = Provider.of<AppAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profileProvider.profileImagePath != null
                        ? FileImage(File(profileProvider.profileImagePath!))
                        : null,
                    child: profileProvider.profileImagePath == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Name'),
              subtitle: Text(profileProvider.name ?? 'Not set'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(profileProvider.email ?? 'Not set'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(profileProvider.phone ?? 'Not set'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.transgender),
              title: const Text('Gender'),
              subtitle: Text(profileProvider.gender ?? 'Not set'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Bio'),
              subtitle: Text(profileProvider.bio ?? 'Not set'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}