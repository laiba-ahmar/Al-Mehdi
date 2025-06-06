import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.person_add_alt_1,
      'text': 'New teacher signed up. Please assign classes.',
      'time': '10 minutes ago',
      'unread': true,
    },
    {
      'icon': Icons.person_add,
      'text': 'New student registered. Assign a teacher soon.',
      'time': '30 minutes ago',
      'unread': true,
    },
    {
      'icon': Icons.email,
      'text': 'User needs your help, has sent an email.',
      'time': '1 hour ago',
      'unread': true,
    },
    {
      'icon': Icons.person_add_alt_1,
      'text': 'Teacher John Doe has been assigned classes.',
      'time': 'Yesterday',
      'unread': false,
    },
    {
      'icon': Icons.person_add,
      'text': 'Student Jane Smith assigned to teacher Ariff.',
      'time': '2 days ago',
      'unread': false,
    },
  ];

  String filterValue = 'All';
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> get filteredNotifications {
    List<Map<String, dynamic>> filtered = notifications;

    if (filterValue == 'Read') {
      filtered = filtered.where((n) => n['unread'] == false).toList();
    } else if (filterValue == 'Unread') {
      filtered = filtered.where((n) => n['unread'] == true).toList();
    }

    if (searchController.text.isNotEmpty) {
      filtered =
          filtered
              .where(
                (n) => n['text'].toString().toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
              )
              .toList();
    }

    return filtered;
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]['unread'] = false;
    });
  }

  void markAsUnread(int index) {
    setState(() {
      notifications[index]['unread'] = true;
    });
  }

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Row(
                children: [
                  // Left: Notifications
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Notifications',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14.0,
                            ),
                            child: Text(
                              'Latest updates about your classes and app.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Filter + Search
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                DropdownButton<String>(
                                  focusColor: Colors.white,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: appGreen,
                                  ),
                                  underline: const SizedBox.shrink(),
                                  value: filterValue,
                                  items:
                                      ['All', 'Read', 'Unread']
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      filterValue = val!;
                                    });
                                  },
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    child: TextField(
                                      controller: searchController,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: 'Search Notifications...',
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 16,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged: (_) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Notifications List
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredNotifications.length,
                              itemBuilder: (context, index) {
                                final notif = filteredNotifications[index];
                                final originalIndex = notifications.indexOf(
                                  notif,
                                );
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade100,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: const Color(
                                              0xFFe5faf3,
                                            ),
                                            child: Icon(
                                              notif['icon'],
                                              color: appGreen,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              notif['text'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            notif['time'],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                          ),
                                          const Spacer(),
                                          notif['unread']
                                              ? Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap:
                                                        () => markAsRead(
                                                          originalIndex,
                                                        ),
                                                    child: Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: appGreen,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text('Mark as Read'),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  GestureDetector(
                                                    onTap:
                                                        () =>
                                                            deleteNotification(
                                                              originalIndex,
                                                            ),
                                                    child: Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.delete,
                                                          color: appRed,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text('Delete'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                              : Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap:
                                                        () => markAsUnread(
                                                          originalIndex,
                                                        ),
                                                    child: Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: appGreen,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text('Mark as Unread'),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  GestureDetector(
                                                    onTap:
                                                        () =>
                                                            deleteNotification(
                                                              originalIndex,
                                                            ),
                                                    child: Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.delete,
                                                          color: appRed,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text('Delete'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        ],
                                      ),
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

                  // Right: Filters & Stats
                  Container(
                    width: 280,
                    padding: const EdgeInsets.all(24),
                    color: Colors.grey[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _filterButton('Read'),
                        _filterButton('Unread'),
                        const SizedBox(height: 24),
                        const Text(
                          'Preferences',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                for (var i = 0; i < notifications.length; i++) {
                                  notifications[i]['unread'] = false;
                                }
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: appGreen,
                              side: BorderSide(color: appGreen),
                            ),
                            child: const Text('Mark all as read'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                notifications.clear();
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: appGreen,
                              side: BorderSide(color: appGreen),
                            ),
                            child: const Text('Delete all'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Stats',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _statRow(
                          Icons.error,
                          '${notifications.where((n) => n['unread']).length} Unread',
                          appGreen,
                        ),
                        _statRow(
                          Icons.calendar_today,
                          '2 Class Reminders Today',
                          appGreen,
                        ),
                        _statRow(
                          Icons.check_circle,
                          '${notifications.where((n) => !n['unread']).length} Read in past 7 days',
                          appGreen,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Mobile layout
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            DropdownButton<String>(
                              focusColor: Colors.white,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: appGreen,
                              ),
                              value: filterValue,
                              underline: const SizedBox(),
                              items:
                                  ['All', 'Read', 'Unread']
                                      .map(
                                        (val) => DropdownMenuItem(
                                          value: val,
                                          child: Text(val),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                setState(() {
                                  filterValue = val!;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Notifications list
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredNotifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final notif = filteredNotifications[index];
                          final originalIndex = notifications.indexOf(notif);
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Icon
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(0xFFe5faf3),
                                  child: Icon(notif['icon'], color: appGreen),
                                ),
                                const SizedBox(width: 12),
                                // Texts
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notif['text'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notif['time'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Green dot if unread
                                if (notif['unread'])
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.circle,
                                      color: appGreen,
                                      size: 12,
                                    ),
                                  ),
                                GestureDetector(
                                  onTap:
                                      () => deleteNotification(originalIndex),
                                  child: const Icon(
                                    Icons.delete,
                                    color: appRed,
                                    size: 18,
                                  ),
                                ),
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
      },
    );
  }

  Widget _filterButton(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              filterValue = label;
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: appGreen,
            side: BorderSide(color: appGreen),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _statRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
