import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignStudents extends StatefulWidget {
  final String teacherUid;
  const AssignStudents({super.key, required this.teacherUid});

  @override
  State<AssignStudents> createState() => _AssignStudentsState();
}

class _AssignStudentsState extends State<AssignStudents> {
  List<Map<String, dynamic>> unassignedStudents = [];
  Map<String, bool> assignedStatus = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUnassignedStudents();
  }

  Future<void> fetchUnassignedStudents() async {
    final snapshot = await FirebaseFirestore.instance
      .collection('unassigned_students')
      .where('assigned', isEqualTo: false)
      .get();

    setState(() {
      unassignedStudents = snapshot.docs.map((doc) => {
        'uid': doc['uid'],
        'name': doc['fullName'],
      }).toList();

      assignedStatus = { for (var s in unassignedStudents) s['name'] : false };
      loading = false;
    });
  }

  Future<void> assignStudent(Map<String, dynamic> student) async {
    // Update student assignment in Firestore
    await FirebaseFirestore.instance.collection('unassigned_students').doc(student['uid']).update({'assigned': true});
    
    // Optionally add student uid to teacher document or a separate collection to track assignments
    await FirebaseFirestore.instance.collection('students').doc(student['uid']).update({
      'assignedTeacherId': widget.teacherUid, // Assign the teacher's UID
    });

    // Update teacher's assignedStudentId field
    await FirebaseFirestore.instance.collection('teachers').doc(widget.teacherUid).update({
      'assignedStudentId': student['uid'], // Assign the student's UID to the teacher
    });

    setState(() {
      assignedStatus[student['name']] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 700;

    double baseFontSize = isWide ? 20 : 14;
    double labelFontSize = isWide ? 18 : 14;

    if (loading) return const Center(child: CircularProgressIndicator());
    if (unassignedStudents.isEmpty) return const Center(child: Text('No unassigned students'));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Assign Students',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: BackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 16, vertical: 24),
        child: Column(
          children: [
            Expanded(
              child: Card(
                color: Theme.of(context).cardColor,
                shadowColor: Theme.of(context).shadowColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  itemCount: unassignedStudents.length,
                  separatorBuilder: (_, __) => Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final student = unassignedStudents[index];
                    final assigned = assignedStatus[student['name']] ?? false;
                    return ListTile(
                      title: Text(
                        student['name'],
                        style: TextStyle(fontSize: labelFontSize),
                      ),
                      trailing: assigned
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check, size: 16, color: Colors.white),
                                  const SizedBox(width: 6),
                                  Text('Assigned', style: TextStyle(color: Colors.white, fontSize: labelFontSize)),
                                ],
                              ),
                            )
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF02D185),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () => assignStudent(student),
                              icon: const Icon(Icons.check, size: 16, color: Colors.white),
                              label: Text('Assign', style: TextStyle(fontSize: labelFontSize, color: Colors.white)),
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
