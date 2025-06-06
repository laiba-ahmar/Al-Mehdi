import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'notifs.dart';

class StudentNotificationWebView extends StatelessWidget {
  const StudentNotificationWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(context),
                    const SizedBox(height: 16),
                    _filterAndSearch(context),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: getStudentNotifications().length,
                        itemBuilder: (context, index) {
                          final notif =  getStudentNotifications()[index];
                          return _notificationCard(context, notif);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _sidebarControls(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Row(
    children: [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      const SizedBox(width: 10),
      const Text(
        'Notifications',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
    ],
  );

  Widget _filterAndSearch(BuildContext context) {
    Color dropColor = Theme.of(context).brightness == Brightness.dark
        ? darkBackground// Dark theme: Red
        : appLightGreen; // Light theme: Green
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          DropdownButton<String>(
            dropdownColor: dropColor,
            focusColor: Colors.transparent,
            value: 'All',
            icon: const Icon(Icons.arrow_drop_down, color: appGreen),
            underline: const SizedBox.shrink(),
            items:
            [
              'All',
              'Read',
              'Unread',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (_) {},
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Notifications...',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
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
        ],
      ),
    );
  }

  Widget _notificationCard(BuildContext context, Map<String, dynamic> notif) => Card(
    elevation: 2,
    shadowColor: Theme.of(context).shadowColor,
    color: Theme.of(context).cardColor,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFe5faf3),
                child: Icon(notif['icon'], color: appGreen),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(notif['text'], style: const TextStyle(fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                notif['time'],
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const Spacer(),
              if (notif['unread'])
                _actionRow('Mark as Read')
              else
                _actionRow('Mark as Unread'),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _actionRow(String markLabel) => Row(
    children: [
      const Icon(Icons.check_circle, color: appGreen, size: 18),
      const SizedBox(width: 6),
      Text(markLabel),
      const SizedBox(width: 16),
      const Icon(Icons.delete, color: appRed, size: 18),
      const SizedBox(width: 6),
      const Text('Delete'),
    ],
  );

  Widget _sidebarControls() => Container(
    decoration: const BoxDecoration(
      border: Border(left: BorderSide(color: Color(0xFFE5EAF1))),
    ),
    width: 280,
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _filterButton('Read'),
        _filterButton('Unread'),
        const SizedBox(height: 24),
        const Text(
          'Preferences',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _prefButton('Mark all as read'),
        _prefButton('Delete all'),
        const SizedBox(height: 24),
        const Text('Stats', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _statRow(Icons.error, '3 Unread'),
        _statRow(Icons.calendar_today, '2 Class Reminders Today'),
        _statRow(Icons.check_circle, '58 Read in past 7 days'),
      ],
    ),
  );

  Widget _filterButton(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: appGreen,
          foregroundColor: Colors.white,
          side: BorderSide.none,
        ),
        child: Text(label),
      ),
    ),
  );

  Widget _prefButton(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: appGreen,
          foregroundColor: Colors.white,
          side: BorderSide.none,
        ),
        child: Text(label),
      ),
    ),
  );

  Widget _statRow(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(icon, color: appGreen, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
