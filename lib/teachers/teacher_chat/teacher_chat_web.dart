import 'package:al_mehdi_online_school/constants/colors.dart';
import 'package:flutter/material.dart';
import '../components/sidebar.dart';
import 'chats.dart';

class TeacherChatScreenWeb extends StatefulWidget {
  const TeacherChatScreenWeb({super.key});

  @override
  State<TeacherChatScreenWeb> createState() => _TeacherChatScreenWebState();
}

class _TeacherChatScreenWebState extends State<TeacherChatScreenWeb> {
  int? selectedChatIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          // Sidebar
          Sidebar(selectedIndex: 3),
          // Chat list
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                right: BorderSide(color: Color(0xFFE5EAF1), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 33,
                    vertical: 14,
                  ),
                  child: const Text(
                    'Chats',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    cursorColor: appGreen,
                    decoration: InputDecoration(
                      hintText: 'Search chats...',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
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
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: [
                      ChatListTile(
                        avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
                        name: 'Mr. Hafiz',
                        message: 'Can we do Chapter 4 today?',
                        time: '2:30 PM',
                        selected: selectedChatIndex == 0,
                        onTap:
                            () => setState(() => selectedChatIndex = 0),
                      ),
                      ChatListTile(
                        avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
                        name: 'Ali',
                        message: "Sure! Let's revise that first.",
                        time: '2:15 PM',
                        selected: selectedChatIndex == 1,
                        onTap:
                            () => setState(() => selectedChatIndex = 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Chat conversation or empty area
          Expanded(
            child:
            selectedChatIndex == null
                ? const Center(
              child: Text(
                'select the chat to appear',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ChatConversation(
              chat:
              selectedChatIndex == 0
                  ? {
                'avatar': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
                'name': 'Mr. Hafiz',
                'online': true,
              }
                  : {
                'avatar': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
                'name': 'Ali',
                'online': false,
              },
            ),
          ),
        ],
      ),
    );
  }
}


