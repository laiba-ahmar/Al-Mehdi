import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../teachers/teacher_chat/chats.dart';
import '../components/student_navbar.dart';

class StudentChatMobileView extends StatelessWidget {
  const StudentChatMobileView({super.key});

  final List<Map<String, dynamic>> chats = const [
    {
      'avatar': 'https://i.imgur.com/AItCxSs.png',
      'name': 'Mr. Hafiz',
      'message': 'Can we do Chapter 4 today?',
      'time': '2:30 PM',
      'online': true,
    },
    {
      'avatar': 'https://i.imgur.com/AItCxSs.png',
      'name': 'Ali',
      'message': "Sure! Let's revise that first.",
      'time': '2:15 PM',
      'online': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Chats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        ),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (_, index) {
          final chat = chats[index];
          return ChatListTile(
            avatar: chat['avatar'],
            name: chat['name'],
            message: chat['message'],
            time: chat['time'],
            selected: false,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentChatConversationScreen(chat: chat),
              ),
            ),
          );
        },
      ),
      // bottomNavigationBar: const StudentNavbar(selectedIndex: 2),
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
