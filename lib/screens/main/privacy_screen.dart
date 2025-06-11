import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ThemeProvider.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _activityStatusVisible = true;
  bool _readReceiptsEnabled = true;
  bool _locationSharingEnabled = false;
  bool _profileVisibilityPublic = true;
  bool _dataCollectionAllowed = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Controls',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage what information you share and who can see it',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Profile Visibility
            SwitchListTile(
              title: const Text('Public Profile'),
              subtitle: const Text('Make your profile visible to everyone'),
              value: _profileVisibilityPublic,
              onChanged: (value) {
                setState(() {
                  _profileVisibilityPublic = value;
                });
              },
              secondary: const Icon(Icons.public),
            ),
            const Divider(),

            // Activity Status
            SwitchListTile(
              title: const Text('Show Activity Status'),
              subtitle: const Text('Let others see when you\'re active'),
              value: _activityStatusVisible,
              onChanged: (value) {
                setState(() {
                  _activityStatusVisible = value;
                });
              },
              secondary: const Icon(Icons.access_time),
            ),
            const Divider(),

            // Read Receipts
            SwitchListTile(
              title: const Text('Read Receipts'),
              subtitle: const Text('Let others know when you\'ve read their messages'),
              value: _readReceiptsEnabled,
              onChanged: (value) {
                setState(() {
                  _readReceiptsEnabled = value;
                });
              },
              secondary: const Icon(Icons.drafts),
            ),
            const Divider(),

            // Location Sharing
            SwitchListTile(
              title: const Text('Location Sharing'),
              subtitle: const Text('Share your location with friends'),
              value: _locationSharingEnabled,
              onChanged: (value) {
                setState(() {
                  _locationSharingEnabled = value;
                });
              },
              secondary: const Icon(Icons.location_on),
            ),
            const Divider(),

            // Data Collection
            SwitchListTile(
              title: const Text('Allow Data Collection'),
              subtitle: const Text('Help improve our service by sharing usage data'),
              value: _dataCollectionAllowed,
              onChanged: (value) {
                setState(() {
                  _dataCollectionAllowed = value;
                });
              },
              secondary: const Icon(Icons.analytics),
            ),
            const Divider(),

            // Advanced Privacy Settings
            const SizedBox(height: 16),
            Text(
              'Advanced Privacy',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Blocked Users'),
              onTap: () {
                // Would navigate to blocked users list
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Data & Permissions'),
              onTap: () {
                // Would navigate to data permissions screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Data Deletion'),
              subtitle: const Text('Request deletion of your data'),
              onTap: () {
                // Would show data deletion options
              },
            ),
          ],
        ),
      ),
    );
  }
}