import 'package:al_mehdi_online_school/students/student_settings/widgets.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../components/student_sidebar.dart';
import '../student_notifications/student_notifications.dart';

class StudentSettingsWebView extends StatefulWidget {
  const StudentSettingsWebView({super.key});

  @override
  State<StudentSettingsWebView> createState() => _StudentSettingsWebViewState();
}

class _StudentSettingsWebViewState extends State<StudentSettingsWebView> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          const StudentSidebar(selectedIndex: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const Divider(color: Color(0xFFE5EAF1), height: 1),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preferences
                      Expanded(
                        flex: 2,
                        child: PreferenceCard(
                          notificationsEnabled: notificationsEnabled,
                          darkModeEnabled: darkModeEnabled,
                          selectedLanguage: selectedLanguage,
                          onNotificationChanged:
                              (val) =>
                                  setState(() => notificationsEnabled = val),
                          onDarkModeChanged: (val) {
                            setState(() => darkModeEnabled = val);
                            themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                            print("Dark mode changed: $val");
                          },
                          onLanguageChanged:
                              (lang) => setState(() => selectedLanguage = lang),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Account
                      Expanded(flex: 1, child: const AccountCard()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: Row(
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StudentNotificationScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
