import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'assign_students.dart';

class TeachersDetails extends StatelessWidget {
  final Map<String, dynamic> user;

  const TeachersDetails({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isTeacher = user['role'] == 'Teacher';

    Widget profileSection = Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(user['avatar'] ?? ''),
              backgroundColor: Colors.grey[200],
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.camera_alt, size: 20),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user['name'] ?? '',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          user['role'] ?? 'Teacher',
          style: TextStyle(
            fontSize: 17,
            color: isTeacher ? Colors.blue : Colors.orange[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_box, color: Colors.green, size: 20),
            SizedBox(width: 6),
            Text('Verified',
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.w600, fontSize: 16)),
          ],
        ),
      ],
    );

    Widget infoField(String label, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 8),
          Card(
            color: Theme.of(context).cardColor,
            shadowColor: Theme.of(context).shadowColor,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: Text(
                value,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      );
    }

    Widget infoSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Teacher Information',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        infoField('Full Name', user['fullName'] ?? 'N/A'),
        const SizedBox(height: 24),
        infoField('Email Address', user['email'] ?? 'N/A'),
        const SizedBox(height: 24),
        infoField('Phone Number', user['phoneNumber'] ?? 'N/A'),
        const SizedBox(height: 24),
        infoField('Role', user['role'] ?? 'N/A'),
        const SizedBox(height: 40),
        const Text(
          'Degree Proof',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DegreePreviewScreen(
                  imageUrl: user['degreeProof'] ?? '',
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              user['degreeProof'] ?? '',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Text('Could not load document image.'),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: BackButton(),
        elevation: 0,
        title: const Text(
          'Teacher Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('teachers').doc(user['uid']).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data.'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found.'));
          }

          var teacherData = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                      ),
                      child: Column(
                        children: [
                          profileSection,
                          const SizedBox(height: 40),
                          infoSection,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('teachers')
                            .doc(user['uid'])
                            .update({
                          'assignedStudentId': 'STUDENT_UID', // Replace with the student's UID
                          'assigned': true,
                        });

                        await FirebaseFirestore.instance
                            .collection('unassigned_teachers')
                            .doc(user['uid'])
                            .update({'assigned': true}); // Update 'assigned' field

                        await FirebaseFirestore.instance
                            .collection('unassigned_teachers')
                            .doc(user['uid'])
                            .delete(); // Delete from unassigned_teachers after assignment

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AssignStudents(teacherUid: user['uid'])),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF02D185),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Assign To',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DegreePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const DegreePreviewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Degree Preview')),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),  
      ),
    );
  }
}
