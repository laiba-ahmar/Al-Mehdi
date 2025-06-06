import 'package:al_mehdi_online_school/students/student_settings/widgets.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../components/student_navbar.dart';
import '../../main.dart';

class StudentSettingsMobileView extends StatefulWidget {
  const StudentSettingsMobileView({super.key});

  @override
  State<StudentSettingsMobileView> createState() =>
      _StudentSettingsMobileViewState();
}

class _StudentSettingsMobileViewState extends State<StudentSettingsMobileView> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PreferenceCard(
              notificationsEnabled: notificationsEnabled,
              darkModeEnabled: isDarkMode,
              selectedLanguage: selectedLanguage,
              onNotificationChanged:
                  (val) => setState(() => notificationsEnabled = val),
              onDarkModeChanged: (val) {
                setState(() => darkModeEnabled = val);
                themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
              },
              onLanguageChanged:
                  (lang) => setState(() => selectedLanguage = lang),
            ),
            const SizedBox(height: 24),
            const AccountCard(),
            const SizedBox(height: 16),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Need help? ',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 13,
                  ),
                  children: [
                    TextSpan(
                      text: 'Tap here for support ',
                      style: TextStyle(
                        color: appGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    WidgetSpan(
                      child: Icon(
                        Icons.support_agent,
                        size: 16,
                        color: appGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const StudentNavbar(selectedIndex: 3),
    );
  }
}
