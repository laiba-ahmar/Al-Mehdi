import 'package:flutter/material.dart';
import '../components/teacher_main_screen.dart';
import 'chats.dart';

class TeacherChatScreenMobile extends StatefulWidget {
  const TeacherChatScreenMobile({super.key});

  @override
  State<TeacherChatScreenMobile> createState() => _TeacherChatScreenMobileState();
}

class _TeacherChatScreenMobileState extends State<TeacherChatScreenMobile> {
  int? selectedChatIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Chats',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          ChatListTile(
            avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
            name: 'Mr. Hafiz',
            message: 'Can we do Chapter 4 today?',
            time: '2:30 PM',
            selected: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => StudentChatConversationScreen(
                    chat: {
                      'avatar':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
                      'name': 'Mr. Hafiz',
                      'online': true,
                    },
                  ),
                ),
              );
            },
          ),
          ChatListTile(
            avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
            name: 'Ali',
            message: "Sure! Let's revise that first.",
            time: '2:15 PM',
            selected: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => StudentChatConversationScreen(
                    chat: {
                      'avatar': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
                      'name': 'Ali',
                      'online': false,
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // bottomNavigationBar: buildBottomNavigationBar(context, 2),
    );
  }
}

