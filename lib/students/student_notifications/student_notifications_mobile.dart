import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'notifs.dart';

class StudentNotificationMobileView extends StatelessWidget {
  const StudentNotificationMobileView({super.key});

  @override
  Widget build(BuildContext context) {

    final Widget? subtitleWidget;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: 'All',
                        icon: const Icon(Icons.arrow_drop_down, color: appGreen),
                        underline: const SizedBox(),
                        items: ['All', 'Read', 'Unread']
                            .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                            .toList(),
                        onChanged: (val) {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Notifications
              Expanded(
                child: ListView.separated(
                  itemCount: getStudentNotifications().length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final notif =  getStudentNotifications()[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFe5faf3),
                            child: Icon(notif['icon'], color: appGreen),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notif['text'], style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(notif['time'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          if (notif['unread']) const Icon(Icons.circle, color: appGreen, size: 12),
                          const SizedBox(width: 10),
                          const Icon(Icons.delete, color: appRed, size: 18),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
