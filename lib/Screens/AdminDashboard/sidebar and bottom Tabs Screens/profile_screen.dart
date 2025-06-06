import 'package:al_mehdi_online_school/Screens/AdminDashboard/notification_screen.dart';
import 'package:al_mehdi_online_school/components/admin_sidebar.dart';
import 'package:al_mehdi_online_school/components/custom_bottom_nabigator.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:al_mehdi_online_school/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isWeb
          ? Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            AdminSidebar(selectedIndex: 5),
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
                          'Profile',
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
                  const Divider(
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 150,
                            child: Card(
                              color: Theme.of(context).cardColor,
                              shadowColor: Theme.of(context).shadowColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 70,
                                      backgroundImage: NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    TextButton(
                                        onPressed: () {},
                                        child: Text("Upload", style: TextStyle(color: appGreen, fontSize: 15),)
                                    ),
                                    SizedBox(height: 20,),
                                    Text("Mohammad Ahmar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    Text("Admin", style: TextStyle(fontSize: 15,),),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 150,
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
                                    SizedBox(height: 15,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Edit Profile',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          const Text(
                                            'Full Name',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: appGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              border: Border.all(color: appGrey),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              'Name',
                                              style: TextStyle(fontSize: 14,),
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          const Text(
                                            'Email',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: appGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              border: Border.all(color: appGrey),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              'Email',
                                              style: TextStyle(fontSize: 14,),
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          const Text(
                                            'Phone',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: appGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              border: Border.all(color: appGrey),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              '+1234567890',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          const Text(
                                            'Class',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: appGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              border: Border.all(color: appGrey),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              'fourth',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                          LayoutBuilder(
                                              builder: (context, constraints) {
                                                if (constraints.maxWidth > 300) {
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(
                                                          onPressed: (){},
                                                          child: Text("Change Password", style: TextStyle(color: appGreen),)
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: appGreen,
                                                            foregroundColor: Colors.white,
                                                          ),
                                                          child: Text("Edit Changes", style: TextStyle(fontSize: 16),)
                                                      )
                                                    ],
                                                  );
                                                } else {
                                                  return Column(
                                                    children: [
                                                      Center(
                                                        child: TextButton(
                                                            onPressed: (){},
                                                            child: Text("Change Password", style: TextStyle(color: appGreen),)
                                                        ),
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Center(
                                                        child: ElevatedButton(
                                                            onPressed: () {},
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: appGreen,
                                                              foregroundColor: Colors.white,
                                                            ),
                                                            child: Text("Save Changes", style: TextStyle(fontSize: 16),)
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }
                                              }
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
      )
          : Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 54,
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.camera_alt, size: 22, color: appGrey),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Mohammad Ahmar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Card(
                  color: Theme.of(context).cardColor,
                  shadowColor: Theme.of(context).shadowColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: appGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: appGrey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Name',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: appGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: appGrey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Email',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Phone',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: appGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: appGrey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '+1234567890',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Class',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: appGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: appGrey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'fourth',
                            style: TextStyle(fontSize: 16,),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            backgroundColor: appGreen,
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: appGreen,
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Save Changes", style: TextStyle(fontSize: 18),),
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Space between buttons
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            foregroundColor: appGreen,
                            side: BorderSide(
                              color: appGreen,
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Change Password", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3)
      ),
    );
  }
}


