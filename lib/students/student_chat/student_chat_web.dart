import 'package:al_mehdi_online_school/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../teachers/teacher_chat/chats.dart';
import '../components/student_sidebar.dart';

class StudentChatWebView extends StatefulWidget {
  const StudentChatWebView({super.key});

  @override
  State<StudentChatWebView> createState() => _StudentChatWebViewState();
}

class _StudentChatWebViewState extends State<StudentChatWebView> {
  int? selectedChatIndex;

  final List<Map<String, dynamic>> chats = [
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
      body: Row(
        children: [
          const StudentSidebar(selectedIndex: 3),
          // Chat List
          Container(
            width: 320,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFFE5EAF1))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 33, vertical: 14),
                  child: Text('Chats', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,)),
                ),
                const Divider(thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    cursorColor: appGreen,
                    decoration: InputDecoration(
                      hintText: 'Search chats...',
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (_, index) {
                      final chat = chats[index];
                      return ChatListTile(
                        avatar: chat['avatar'],
                        name: chat['name'],
                        message: chat['message'],
                        time: chat['time'],
                        selected: selectedChatIndex == index,
                        onTap: () => setState(() => selectedChatIndex = index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Chat conversation panel
          Expanded(
            child: selectedChatIndex == null
                ? const Center(child: Text('Select a chat to appear', style: TextStyle(fontSize: 16)))
                : ChatConversation(chat: chats[selectedChatIndex!]),
          ),
        ],
      ),
    );
  }
}
