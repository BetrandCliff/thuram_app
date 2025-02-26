import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  final String id;
  final String name;
  final String email;
  final String location;
  final String specialty;
  final List<String> courses;
  final String position;

  Staff({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.specialty,
    required this.courses,
    required this.position,
  });

  factory Staff.fromMap(String id, Map<String, dynamic> data) {
    return Staff(
      id: id,
      name: data['username'] ?? 'Unknown',
      email: data['email'] ?? 'No Email',
      location: data['office'] ?? 'No Location',
      specialty: data['specialty'] ?? 'No Specialty',
      courses: List<String>.from(data['courses'] ?? []),
      position: data['role'] ?? 'No Position',
    );
  }
}

class StaffListScreen extends StatefulWidget {
  @override
  _StaffListScreenState createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  List<Staff> staffList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllStaff();
  }

  Future<void> fetchAllStaff() async {
    print("Fetching all staff...");
    setState(() => isLoading = true);

    try {
      QuerySnapshot staffSnapshot =
          await FirebaseFirestore.instance.collection('staff').get();

      List<Staff> fetchedStaff = staffSnapshot.docs.map((doc) {
        return Staff.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      setState(() {
        staffList = fetchedStaff;
        isLoading = false;
      });

      print("Fetched ${fetchedStaff.length} staff members.");
    } catch (e) {
      print("Error fetching staff: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch staff')));
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteStaff(String staffId) async {
    try {
      await FirebaseFirestore.instance
          .collection('staff')
          .doc(staffId)
          .delete();
      setState(() {
        staffList.removeWhere((staff) => staff.id == staffId);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Staff deleted successfully')));
    } catch (e) {
      print("Error deleting staff: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete staff')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Staff List')),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader
          : staffList.isEmpty
              ? Center(child: Text("No staff members found"))
              : ListView.builder(
                  itemCount: staffList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(staffList[index].id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        deleteStaff(staffList[index].id);
                      },
                      child: StaffCard(staff: staffList[index]),
                    );
                  },
                ),
    );
  }
}

class StaffCard extends StatelessWidget {
  final Staff staff;

  StaffCard({required this.staff});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Make it fit the screen
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                staff.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Email: ${staff.email}'),
              Text('Location: ${staff.location}'),
              Text('Specialty: ${staff.specialty}'),
              Text('Position: ${staff.position}'),
              SizedBox(height: 8),
              Text(
                'Courses: ${staff.courses.isNotEmpty ? staff.courses.join(", ") : "No assigned courses"}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
