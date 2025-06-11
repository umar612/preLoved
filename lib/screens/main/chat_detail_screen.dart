import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDetailScreen extends StatefulWidget {
  final String sender;
  final String avatar;

  const ChatDetailScreen({
    super.key,
    required this.sender,
    required this.avatar,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [
    Message(
      text: 'Hey there!',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Message(
      text: 'Hi! How are you?',
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    Message(
      text: 'I\'m good, thanks for asking. What about you?',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    Message(
      text: 'Doing well! Just working on some Flutter projects.',
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(Message(
          text: _messageController.text,
          isMe: true,
          time: DateTime.now(),
        ));
        _messageController.clear();

        // Scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                widget.avatar,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sender,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'Active 5 min ago',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, size: 26),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, size: 24),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mute',
                child: Text('Mute notifications'),
              ),
              const PopupMenuItem(
                value: 'block',
                child: Text('Block user'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete chat'),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'mute':
                  break;
                case 'block':
                  break;
                case 'delete':
                  break;
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[_messages.length - 1 - index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isMe ? Theme.of(context).primaryColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(message.time),
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.black54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;
  final DateTime time;

  Message({
    required this.text,
    required this.isMe,
    required this.time,
  });
}
