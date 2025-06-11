import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ThemeProvider.dart';
import '../profile/user_profile_screen.dart';
import 'notification_settings_screen.dart';
import 'privacy_screen.dart';  // Import the privacy screen
import 'help_support_screen.dart';
import '../dashboard/admin_dashboard.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyScreen(),
                ),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),

          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
          ),
        ],
      ),
    );
  }
}