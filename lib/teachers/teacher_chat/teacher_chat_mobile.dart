import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/teacher_main_screen.dart';
import 'chats.dart';
import '../../services/chat_service.dart';

class TeacherChatScreenMobile extends StatefulWidget {
  const TeacherChatScreenMobile({super.key});

  @override
  State<TeacherChatScreenMobile> createState() =>
      _TeacherChatScreenMobileState();
}

class _TeacherChatScreenMobileState extends State<TeacherChatScreenMobile> {
  int? selectedChatIndex;

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return 'Now';

    final now = DateTime.now();
    final messageTime = timestamp.toDate();
    final difference = now.difference(messageTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${messageTime.day}/${messageTime.month}/${messageTime.year}';
    }
  }

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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('students')
                .where(
                  'assignedTeacherId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                )
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No assigned students found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index].data() as Map<String, dynamic>;
              final studentName = student['fullName'] ?? 'Student';
              final studentId = students[index].id;

              return StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('chatRooms')
                        .where('participants', arrayContains: studentId)
                        .orderBy('updatedAt', descending: true)
                        .limit(1)
                        .snapshots(),
                builder: (context, chatSnapshot) {
                  String lastMessage = 'Click to start chatting';
                  String timeText = 'Now';

                  if (chatSnapshot.hasData &&
                      chatSnapshot.data!.docs.isNotEmpty) {
                    final chatData =
                        chatSnapshot.data!.docs.first.data()
                            as Map<String, dynamic>;
                    lastMessage =
                        chatData['lastMessage'] ?? 'Click to start chatting';
                    final lastMessageTime =
                        chatData['lastMessageTime'] as Timestamp?;
                    timeText = _formatTime(lastMessageTime);
                  }

                  return ChatListTile(
                    avatar: 'https://i.pravatar.cc/100?u=$studentId',
                    name: studentName,
                    message: lastMessage,
                    time: timeText,
                    selected: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => StudentChatConversationScreen(
                                chat: {
                                  'avatar':
                                      'https://i.pravatar.cc/100?u=$studentId',
                                  'name': studentName,
                                  'online': true,
                                  'studentId': studentId,
                                },
                              ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      // bottomNavigationBar: buildBottomNavigationBar(context, 2),
    );
  }
}
