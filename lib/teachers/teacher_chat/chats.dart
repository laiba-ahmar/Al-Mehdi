import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class ChatListTile extends StatelessWidget {
  final String avatar;
  final String name;
  final String message;
  final String time;
  final bool selected;
  final VoidCallback onTap;

  const ChatListTile({super.key,
    required this.avatar,
    required this.name,
    required this.message,
    required this.time,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Material(
      color: selected ? (isLightTheme ? const Color(0xFFe5faf3) : Colors.white10) // Use selected color for light theme
        : Colors.transparent, // No color for unselected state
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(avatar),
          radius: 22,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text(
          time,
          style: const TextStyle(fontSize: 13,),
        ),
        onTap: onTap,
      ),
    );
  }
}

class ChatConversation extends StatelessWidget {
  final Map<String, dynamic> chat;
  final bool showHeader;
  const ChatConversation({
    required this.chat,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {

    Color Mecolor = Theme.of(context).brightness == Brightness.dark
        ? appGreen// Dark theme
        : appLightGreen; // Light theme

    Color fromColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade800// Dark theme
        : Colors.grey.shade200; // Light theme

    // Example chat messages
    final messages = [
      {
        'fromMe': false,
        'text': "Sure! Let's revise that first.",
        'time': '2:33 PM',
      },
      {'fromMe': true, 'text': "Can we do Chapter 4 today?", 'time': '2:32 PM'},
      {'fromMe': true, 'text': "Thanks! 🙌", 'time': '2:34 PM'},
      {
        'fromMe': false,
        'text': "Join via the same link at 2 PM.",
        'time': '2:35 PM',
      },
    ];

    return Column(
      children: [
        if (showHeader)
        // Chat header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5EAF1), width: 1),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(chat['avatar']),
                  radius: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  chat['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                if (chat['online'])
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: appGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        // Chat messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 5),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMe = msg['fromMe'] as bool;
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? Mecolor : fromColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          msg['text'].toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        msg['time'].toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Message input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: Color(0xFFE5EAF1), width: 1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  cursorColor: appGreen,
                  decoration: InputDecoration(
                    hintText: 'Write your message...',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey, // Grey outline color
                        width: 1.0, // Adjust thickness as needed
                      ), // No focus border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey, // Grey outline color
                        width: 1.0, // Adjust thickness as needed
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.send, color: appGreen),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StudentChatConversationScreen extends StatelessWidget {
  final Map<String, dynamic> chat;
  const StudentChatConversationScreen({required this.chat, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(chat['avatar']),
              radius: 18,
            ),
            const SizedBox(width: 8),
            Text(
              chat['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            if (chat['online'])
              const Text(
                'Online',
                style: TextStyle(
                  color: appGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
      body: ChatConversation(chat: chat, showHeader: false),
    );
  }
}