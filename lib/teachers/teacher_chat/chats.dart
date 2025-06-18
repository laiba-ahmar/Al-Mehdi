import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/colors.dart';
import '../../services/chat_service.dart';

class ChatListTile extends StatelessWidget {
  final String avatar;
  final String name;
  final String message;
  final String time;
  final bool selected;
  final VoidCallback onTap;

  const ChatListTile({
    super.key,
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
      color:
          selected
              ? (isLightTheme
                  ? const Color(0xFFe5faf3)
                  : Colors.white10) // Use selected color for light theme
              : Colors.transparent, // No color for unselected state
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(avatar),
          radius: 22,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text(time, style: const TextStyle(fontSize: 13)),
        onTap: onTap,
      ),
    );
  }
}

class ChatConversation extends StatefulWidget {
  final Map<String, dynamic> chat;
  final bool showHeader;
  const ChatConversation({required this.chat, this.showHeader = true});

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? currentUserId;
  String? currentUserName;
  String? currentUserRole;

  @override
  void initState() {
    super.initState();
    _getCurrentUserInfo();
  }

  Future<void> _getCurrentUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });

      // Check if current user is a teacher
      final teacherDoc =
          await FirebaseFirestore.instance
              .collection('teachers')
              .doc(user.uid)
              .get();

      if (teacherDoc.exists) {
        setState(() {
          currentUserName = teacherDoc.data()?['fullName'] ?? 'Teacher';
          currentUserRole = 'teacher';
        });
      } else {
        // Check if current user is a student
        final studentDoc =
            await FirebaseFirestore.instance
                .collection('students')
                .doc(user.uid)
                .get();

        if (studentDoc.exists) {
          setState(() {
            currentUserName = studentDoc.data()?['fullName'] ?? 'Student';
            currentUserRole = 'student';
          });
        }
      }
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    final receiverId = widget.chat['studentId'] ?? widget.chat['teacherId'];

    if (receiverId == null ||
        currentUserName == null ||
        currentUserRole == null)
      return;

    try {
      await ChatService.sendMessage(
        receiverId: receiverId,
        message: message,
        senderName: currentUserName!,
        senderRole: currentUserRole!,
      );

      _messageController.clear();

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending message: $e')));
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
    Color meColor =
        Theme.of(context).brightness == Brightness.dark
            ? appGreen // Dark theme
            : appLightGreen; // Light theme

    Color fromColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors
                .grey
                .shade800 // Dark theme
            : Colors.grey.shade200; // Light theme

    final receiverId = widget.chat['studentId'] ?? widget.chat['teacherId'];
    final currentUserId = this.currentUserId;

    if (receiverId == null || currentUserId == null) {
      return const Center(child: Text('Unable to load chat'));
    }

    return Column(
      children: [
        if (widget.showHeader)
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
                  backgroundImage: NetworkImage(widget.chat['avatar']),
                  radius: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.chat['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.chat['online'])
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
          child: StreamBuilder<QuerySnapshot>(
            stream: ChatService.getMessages(currentUserId, receiverId),
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
                    'No messages yet. Start the conversation!',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final messages = snapshot.data!.docs;

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 5,
                ),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index].data() as Map<String, dynamic>;
                  final isMe = msg['senderId'] == currentUserId;
                  final messageText = msg['message'] ?? '';
                  final timestamp = msg['timestamp'] as Timestamp?;

                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? meColor : fromColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              messageText,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(timestamp),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                  controller: _messageController,
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
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.send, color: appGreen),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
