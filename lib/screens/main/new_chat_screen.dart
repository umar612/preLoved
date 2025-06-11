import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Chat"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("New Individual Chat"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateIndividualChatScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text("New Group"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateGroupScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CreateIndividualChatScreen extends StatefulWidget {
  const CreateIndividualChatScreen({super.key});

  @override
  State<CreateIndividualChatScreen> createState() =>
      _CreateIndividualChatScreenState();
}

class _CreateIndividualChatScreenState
    extends State<CreateIndividualChatScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startChat() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(
            sender: name,
            avatar: name.length >= 2
                ? name.substring(0, 2).toUpperCase()
                : name.substring(0, 1).toUpperCase(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Start New Chat")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Enter Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.chat, color: Colors.white),
              label: const Text("Start Chat", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _startChat,
            ),
          ],
        ),
      ),
    );
  }
}

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _createGroup() {
    final name = _groupNameController.text.trim();
    if (name.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(
            sender: name,
            avatar: name.length >= 2
                ? name.substring(0, 2).toUpperCase()
                : name.substring(0, 1).toUpperCase(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Group")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(
                labelText: "Enter Group Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.group_add, color: Colors.white),
              label: const Text("Create Group", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _createGroup,
            ),
          ],
        ),
      ),
    );
  }
}
