import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  final String avatar;
  final String name;
  final String message;
  final String time;
  final bool selected;
  final VoidCallback onTap;

  const ChatListTile({
    required this.avatar,
    required this.name,
    required this.message,
    required this.time,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFe5faf3) : Colors.transparent,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(avatar),
          radius: 22,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text(
          time,
          style: const TextStyle(fontSize: 13, color: Colors.black),
        ),
        onTap: onTap,
      ),
    );
  }
}
