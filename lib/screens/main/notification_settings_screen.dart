import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ThemeProvider.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = false;
  bool _smsNotificationsEnabled = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _notificationFrequency = 'Immediately';

  // Notification Category Toggles
  bool _newMessages = true;
  bool _friendRequests = true;
  bool _promotions = false;
  bool _systemUpdates = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Preferences',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage how you receive notifications',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Push Notifications
            SwitchListTile(
              title: const Text('Push Notifications'),
              value: _pushNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _pushNotificationsEnabled = value;
                });
              },
              secondary: const Icon(Icons.notifications_active),
            ),
            const Divider(),

            // Email Notifications
            SwitchListTile(
              title: const Text('Email Notifications'),
              value: _emailNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _emailNotificationsEnabled = value;
                });
              },
              secondary: const Icon(Icons.email),
            ),
            const Divider(),

            // Chat Notifications
            SwitchListTile(
              title: const Text('Chat Notifications'),
              value: _smsNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _smsNotificationsEnabled = value;
                });
              },
              secondary: const Icon(Icons.sms),
            ),
            const Divider(),

            // Notification Sound
            SwitchListTile(
              title: const Text('Notification Sound'),
              value: _soundEnabled,
              onChanged: _pushNotificationsEnabled ? (value) {
                setState(() {
                  _soundEnabled = value;
                });
              } : null,
              secondary: const Icon(Icons.volume_up),
              inactiveThumbColor: isDarkMode ? Colors.grey[600] : null,
            ),
            const Divider(),

            // Vibration
            SwitchListTile(
              title: const Text('Vibration'),
              value: _vibrationEnabled,
              onChanged: _pushNotificationsEnabled ? (value) {
                setState(() {
                  _vibrationEnabled = value;
                });
              } : null,
              secondary: const Icon(Icons.vibration),
              inactiveThumbColor: isDarkMode ? Colors.grey[600] : null,
            ),
            const Divider(),

            // Notification Frequency
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Notification Frequency'),
              subtitle: Text(_notificationFrequency),
              onTap: () {
                _showFrequencyDialog(context);
              },
            ),
            const Divider(),

            // Notification Categories
            const SizedBox(height: 16),
            Text(
              'Notification Categories',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildNotificationCategorySwitch('New Messages', _newMessages, (value) {
              setState(() {
                _newMessages = value;
              });
            }),
            _buildNotificationCategorySwitch('Friend Requests', _friendRequests, (value) {
              setState(() {
                _friendRequests = value;
              });
            }),
            _buildNotificationCategorySwitch('Promotions', _promotions, (value) {
              setState(() {
                _promotions = value;
              });
            }),
            _buildNotificationCategorySwitch('System Updates', _systemUpdates, (value) {
              setState(() {
                _systemUpdates = value;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCategorySwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: _pushNotificationsEnabled ? onChanged : null,
      secondary: const Icon(Icons.category),
    );
  }

  void _showFrequencyDialog(BuildContext context) {
    final options = ['Immediately', 'Hourly', 'Daily', 'Weekly'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notification Frequency'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  title: Text(options[index]),
                  value: options[index],
                  groupValue: _notificationFrequency,
                  onChanged: (value) {
                    setState(() {
                      _notificationFrequency = value.toString();
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
