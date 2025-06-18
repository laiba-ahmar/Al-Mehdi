import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/colors.dart';
import '../../teachers/teacher_chat/chats.dart';
import '../components/student_navbar.dart';
import '../../services/chat_service.dart';

class StudentChatMobileView extends StatefulWidget {
  const StudentChatMobileView({super.key});

  @override
  State<StudentChatMobileView> createState() =>
      _StudentChatScreenMobileState();
}

class _StudentChatScreenMobileState extends State<StudentChatMobileView> {
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
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('students')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Student data not found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final studentData = snapshot.data!.data() as Map<String, dynamic>;
          final assignedTeacherId = studentData['assignedTeacherId'];

          if (assignedTeacherId == null) {
            return const Center(
              child: Text(
                'No teacher assigned yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance
                    .collection('teachers')
                    .doc(assignedTeacherId)
                    .get(),
            builder: (context, teacherSnapshot) {
              if (teacherSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (teacherSnapshot.hasError ||
                  !teacherSnapshot.hasData ||
                  !teacherSnapshot.data!.exists) {
                return const Center(
                  child: Text(
                    'Teacher data not found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              final teacherData =
                  teacherSnapshot.data!.data() as Map<String, dynamic>;
              final teacherName = teacherData['fullName'] ?? 'Teacher';

              return StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('chatRooms')
                        .where('participants', arrayContains: assignedTeacherId)
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
                    avatar: 'https://i.pravatar.cc/100?u=$assignedTeacherId',
                    name: teacherName,
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
                                      'https://i.pravatar.cc/100?u=$assignedTeacherId',
                                  'name': teacherName,
                                  'online': true,
                                  'teacherId': assignedTeacherId,
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
          icon: const Icon(Icons.arrow_back),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
