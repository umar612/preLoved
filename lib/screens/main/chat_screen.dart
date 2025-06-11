import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';
import 'new_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _allMessages = [
    ChatMessage(
      sender: 'WAQAS AHMED',
      message: 'Hey, how are you doing?',
      time: '10:30 AM',
      avatar: 'WA',
      isRead: false,
    ),
    ChatMessage(
      sender: 'HASEEB SULMAN',
      message: 'Meeting at 2 PM tomorrow',
      time: '9:45 AM',
      avatar: 'HS',
      isRead: false,
    ),
    ChatMessage(
      sender: 'UMER AFTAB',
      message: 'Did you see the latest project updates?',
      time: 'Yesterday',
      avatar: 'UA',
      isRead: true,
    ),
  ];

  List<ChatMessage> _filteredMessages = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredMessages = _allMessages;
    _searchController.addListener(_searchMessages);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchMessages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMessages = _allMessages.where((message) {
        final senderMatch = message.sender.toLowerCase().contains(query);
        final messageMatch = message.message.toLowerCase().contains(query);
        return senderMatch || messageMatch;
      }).toList();
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search messages...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.grey[400],
          onPressed: () {
            setState(() {
              _searchController.clear();
              _isSearching = false;
              _filteredMessages = _allMessages;
            });
          },
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [];
    }
    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          setState(() {
            _isSearching = true;
          });
        },
      ),
    ];
  }

  Widget _buildAppBarTitle() {
    return _isSearching ? _buildSearchField() : const Text('Messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        actions: _buildAppBarActions(),
        leading: _isSearching
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              _filteredMessages = _allMessages;
            });
          },
        )
            : null,
      ),
      body: ListView.builder(
        itemCount: _filteredMessages.length,
        itemBuilder: (context, index) {
          final message = _filteredMessages[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                message.avatar,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              message.sender,
              style: TextStyle(
                fontWeight: message.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    message.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: message.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ),
                if (!message.isRead)
                  const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(
                      Icons.circle,
                      color: Colors.blue,
                      size: 10,
                    ),
                  ),
              ],
            ),
            trailing: Text(
              message.time,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              setState(() {
                message.isRead = true;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    sender: message.sender,
                    avatar: message.avatar,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewChatScreen(),
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String message;
  final String time;
  final String avatar;
  bool isRead;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.time,
    required this.avatar,
    this.isRead = false,
  });
}