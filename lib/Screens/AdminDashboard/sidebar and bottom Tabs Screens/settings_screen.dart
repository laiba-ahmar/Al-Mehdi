import 'package:al_mehdi_online_school/Screens/AdminDashboard/notification_screen.dart';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/change%20password.dart';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/login_screen.dart';
import 'package:al_mehdi_online_school/components/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:al_mehdi_online_school/constants/colors.dart';
import '../../../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = 'English';

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
  void _goToChangePassword() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ChangePassword()),
    );
  }

  @override
  Widget build(BuildContext context) {

    Color dropdownColor = Theme.of(context).brightness == Brightness.dark
        ? darkBackground// Dark theme: Red
        : appLightGreen; // Light theme: Green

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          // Desktop Layout
          Widget buildCheckboxRow(IconData icon, String title, bool value, ValueChanged<bool?> onChanged) {
            return Row(
              children: [
                Icon(icon, color: appGreen),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
                Checkbox(
                  value: value,
                  onChanged: onChanged,
                  activeColor: appGreen,
                  side: BorderSide(
                    color: appGreen,
                  ),
                ),
              ],
            );
          }
          Widget buildPreferenceCard() {
            Color dropdownColor = Theme.of(context).brightness == Brightness.dark
                ? darkBackground// Dark theme: Red
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
                    const Text('Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20,),
                    buildCheckboxRow(Icons.notifications, "Notifications",notificationsEnabled, (val) {
                      setState(() => notificationsEnabled = val!);
                    }),
                    const Divider(),
                    buildCheckboxRow(Icons.nightlight_round, "Dark Mode", darkModeEnabled, (val) {
                      setState(() {
                        darkModeEnabled = val!;
                        themeNotifier.value = darkModeEnabled ? ThemeMode.dark : ThemeMode.light;
                      });
                    }),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.language, color: appGreen),
                        const SizedBox(width: 10),
                        const Expanded(child: Text("Language", style: TextStyle(fontSize: 16))),
                        DropdownButton<String>(
                          focusColor: Colors.transparent,
                          icon: const Icon(Icons.arrow_drop_down, color: appGreen),
                          underline: SizedBox.shrink(),
                          dropdownColor: dropdownColor,
                          value: selectedLanguage,
                          items: const [
                            DropdownMenuItem(value: 'English', child: Text('English', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),)),
                            DropdownMenuItem(value: 'Arabic', child: Text('Arabic', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))),
                          ],
                          onChanged: (val) {
                            setState(() => selectedLanguage = val!);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          Widget buildAccountCard() {
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
                      const Text('Account Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _goToChangePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appGreen,
                                foregroundColor: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Change Password", style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _navigateToLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appRed,
                                foregroundColor: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Logout", style: TextStyle(fontSize: 14,),textAlign: TextAlign.center,),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextButton(onPressed: (){}, child: Text("Delete Account", style: TextStyle(color: appRed, fontSize: 14)))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }


          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Row(
              children: [
                AdminSidebar(selectedIndex: 4),
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
                              icon: const Icon(
                                Icons.notifications,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NotificationScreen()),
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
                                children: [
                                  buildPreferenceCard(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Account Settings
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildAccountCard(),
                                ],
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
        } else {
          // Mobile Layout
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              elevation: 0,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customize your experience',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: Theme.of(context).cardColor,
                      shadowColor: Theme.of(context).shadowColor,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Preferences',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.notifications, color: appGreen),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Notifications',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Checkbox(
                                  value: notificationsEnabled,
                                  onChanged: (val) {
                                    setState(() {
                                      notificationsEnabled = val!;
                                    });
                                  },
                                  activeColor: appGreen,
                                  side: BorderSide(
                                    color: appGreen,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Icon(Icons.nightlight_round, color: appGreen),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Dark Mode',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Checkbox(
                                  value: darkModeEnabled,
                                  onChanged: (val) {
                                    setState(() {
                                      darkModeEnabled = val!;
                                      themeNotifier.value = darkModeEnabled ? ThemeMode.dark : ThemeMode.light;
                                    });
                                  },
                                  side: BorderSide(
                                    color: appGreen,
                                  ),
                                  activeColor: appGreen,
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Icon(Icons.language, color: appGreen),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Language',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                DropdownButton<String>(
                                  dropdownColor: dropdownColor,
                                  icon: const Icon(Icons.arrow_drop_down, color: appGreen),
                                  underline: SizedBox.shrink(),
                                  value: selectedLanguage,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'English',
                                      child: Text('English', style: TextStyle(fontWeight: FontWeight.w400),),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Arabic',
                                      child: Text('Arabic', style: TextStyle(fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    setState(() {
                                      selectedLanguage = val!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Card(
                    //   color: Theme.of(context).cardColor,
                    //   shadowColor: Theme.of(context).shadowColor,
                    //   elevation: 2,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Text(
                    //           'Account Settings',
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 18,
                    //           ),
                    //         ),
                    //         const SizedBox(height: 16),
                    //         GestureDetector(
                    //           onTap: () {},
                    //           child: Row(
                    //             children: const [
                    //               Icon(Icons.edit, color: appGreen),
                    //               SizedBox(width: 10),
                    //               Text(
                    //                 'Change Password',
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.w500,
                    //                   decoration: TextDecoration.underline,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         const SizedBox(height: 20),
                    //         SizedBox(
                    //           width: double.infinity,
                    //           child: ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //               backgroundColor: appRed,
                    //               padding: const EdgeInsets.symmetric(vertical: 14),
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //             ),
                    //             onPressed: () {},
                    //             child: const Text(
                    //               'Logout',
                    //               style: TextStyle(fontSize: 16, color: Colors.white),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    AccountCard(),
                    const SizedBox(height: 16),
                    Center(
                      child: RichText(
                        text: const TextSpan(
                          text: 'Need help? ',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
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
            ),
            // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 4),
          );
        }
      },

    );
  }
}

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).shadowColor,
      color: Theme.of(context).cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChangePassword()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Change Password"),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Logout"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
