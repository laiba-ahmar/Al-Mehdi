import 'package:al_mehdi_online_school/Screens/Auth%20Screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../main.dart';
import '../../students/student_notifications/student_notifications.dart';
import '../components/sidebar.dart';

class TeacherSettingsScreenWeb extends StatefulWidget {
  const TeacherSettingsScreenWeb({super.key});

  @override
  State<TeacherSettingsScreenWeb> createState() =>
      _TeacherSettingsScreenWebState();
}

class _TeacherSettingsScreenWebState extends State<TeacherSettingsScreenWeb> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Sidebar(selectedIndex: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 18,
                  ),
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
                            MaterialPageRoute(
                              builder: (context) => StudentNotificationScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_buildPreferenceCard()],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Account Settings
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_buildAccountCard()],
                        ),
                      ),
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

  Widget _buildPreferenceCard() {
    Color dropdownColor =
        Theme.of(context).brightness == Brightness.dark
            ? darkBackground // Dark theme: Red
            : appLightGreen; // Light theme: Green
    return Card(
      color: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).shadowColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildCheckboxRow(
              Icons.notifications,
              "Notifications",
              notificationsEnabled,
              (val) {
                setState(() => notificationsEnabled = val!);
              },
            ),
            const Divider(),
            _buildCheckboxRow(
              Icons.nightlight_round,
              "Dark Mode",
              darkModeEnabled,
              (val) {
                setState(() {
                  darkModeEnabled = val!;
                  themeNotifier.value =
                      darkModeEnabled ? ThemeMode.dark : ThemeMode.light;
                });
              },
            ),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.language, color: appGreen),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text("Language", style: TextStyle(fontSize: 16)),
                ),
                DropdownButton<String>(
                  focusColor: Colors.transparent,
                  icon: const Icon(Icons.arrow_drop_down, color: appGreen),
                  underline: SizedBox.shrink(),
                  dropdownColor: dropdownColor,
                  value: selectedLanguage,
                  items: const [
                    DropdownMenuItem(
                      value: 'English',
                      child: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Arabic',
                      child: Text(
                        'Arabic',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() => selectedLanguage = val!);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).cardColor,
        shadowColor: Theme.of(context).shadowColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Change Password",
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appRed,
                        foregroundColor: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Logout",
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Delete Account",
                      style: TextStyle(color: appRed, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      children: [
        Icon(icon, color: appGreen),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: appGreen,
          side: BorderSide(color: appGreen),
        ),
      ],
    );
  }
}
