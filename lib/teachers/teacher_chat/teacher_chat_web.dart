import 'package:al_mehdi_online_school/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/sidebar.dart';
import 'chats.dart';
import '../../services/chat_service.dart';

class TeacherChatScreenWeb extends StatefulWidget {
  const TeacherChatScreenWeb({super.key});

  @override
  State<TeacherChatScreenWeb> createState() => _TeacherChatScreenWebState();
}

class _TeacherChatScreenWebState extends State<TeacherChatScreenWeb> {
  int? selectedChatIndex;
  String? selectedStudentId;
  List<Map<String, dynamic>> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignedStudents();
  }

  Future<void> _loadAssignedStudents() async {
    try {
      final studentsSnapshot =
          await FirebaseFirestore.instance
              .collection('students')
              .where(
                'assignedTeacherId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .get();

      setState(() {
        students =
            studentsSnapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'name': data['fullName'] ?? 'Student',
                'avatar': 'https://i.pravatar.cc/100?u=${doc.id}',
              };
            }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading assigned students: $e');
    }
  }

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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                const Divider(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    cursorColor: appGreen,
                    decoration: InputDecoration(
                      hintText: 'Search students...',
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
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : students.isEmpty
                          ? const Center(
                            child: Text(
                              'No assigned students found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];

                              return StreamBuilder<QuerySnapshot>(
                                stream:
                                    FirebaseFirestore.instance
                                        .collection('chatRooms')
                                        .where(
                                          'participants',
                                          arrayContains: student['id'],
                                        )
                                        .orderBy('updatedAt', descending: true)
                                        .limit(1)
                                        .snapshots(),
                                builder: (context, chatSnapshot) {
                                  String lastMessage =
                                      'Click to start chatting';
                                  String timeText = 'Now';

                                  if (chatSnapshot.hasData &&
                                      chatSnapshot.data!.docs.isNotEmpty) {
                                    final chatData =
                                        chatSnapshot.data!.docs.first.data()
                                            as Map<String, dynamic>;
                                    lastMessage =
                                        chatData['lastMessage'] ??
                                        'Click to start chatting';
                                    final lastMessageTime =
                                        chatData['lastMessageTime']
                                            as Timestamp?;
                                    timeText = _formatTime(lastMessageTime);
                                  }

                                  return ChatListTile(
                                    avatar: student['avatar'],
                                    name: student['name'],
                                    message: lastMessage,
                                    time: timeText,
                                    selected: selectedChatIndex == index,
                                    onTap:
                                        () => setState(() {
                                          selectedChatIndex = index;
                                          selectedStudentId = student['id'];
                                        }),
                                  );
                                },
                              );
                            },
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
                        'Select a student to start messaging',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    : students.isEmpty
                    ? const Center(
                      child: Text(
                        'No assigned students found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : selectedChatIndex! >= students.length
                    ? const Center(child: Text('Student not found'))
                    : ChatConversation(
                      chat: {
                        'avatar': students[selectedChatIndex!]['avatar'],
                        'name': students[selectedChatIndex!]['name'],
                        'online': true,
                        'studentId': students[selectedChatIndex!]['id'],
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
