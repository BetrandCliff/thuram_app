// import 'package:flutter/material.dart';

// // Example course data
// class Course {
//   final String title;
//   final String tutor;
//   final String level;
//   final String duration;

//   Course({
//     required this.title,
//     required this.tutor,
//     required this.level,
//     required this.duration,
//   });
// }

// class CourseWidget extends StatelessWidget {

//   final isStudent;
//   // Example list of courses
//   final List<Course> courses = [
//     Course(
//       title: 'Introduction to Machine Learning',
//       tutor: 'John Doe',
//       level: 'Intermediate',
//       duration: '3 months',
//     ),
//     Course(
//       title: 'Advanced JavaScript',
//       tutor: 'Jane Smith',
//       level: 'Advanced',
//       duration: '2 months',
//     ),
//     Course(
//       title: 'Python for Data Science',
//       tutor: 'Alan Turing',
//       level: 'Beginner',
//       duration: '4 months',
//     ),
//   ];

//    CourseWidget({super.key, this.isStudent=true});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text(isStudent?'Registered Courses':"Assigned Courses"),
//       // ),
//       body: ListView.builder(
//         itemCount: courses.length,
//         itemBuilder: (context, index) {
//           return CourseItem(course: courses[index],isStudent: isStudent,);
//         },
//       ),
//     );
//   }
// }

// class CourseItem extends StatelessWidget {
//   final Course course;
// final isStudent;
//   CourseItem({required this.course, this.isStudent=true});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               course.title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text('Tutor: ${course.tutor}'),
//             Text('Level: ${course.level}'),
//             Text('Duration: ${course.duration}'),
//             SizedBox(height: 12),

//             if(isStudent)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle "View Details" button
//                     print('View Details of ${course.title}');
//                   },
//                   child: Text('View Details'),
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle "Unregister" button
//                     print('Unregister from ${course.title}');
//                   },
//                   child: Text('Unregister'),
//                   // style: ElevatedButton.styleFrom(
//                   //   primary: Colors.red,
//                   // ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../admin/presentations/model/course.dart';

class CourseWidget extends StatefulWidget {
  final bool isStudent;

  CourseWidget({super.key, this.isStudent = true});

  @override
  _CourseWidgetState createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  late List<Course> courses;

  @override
  void initState() {
    super.initState();
    courses = [];
    print("\n\nFetching courses");
    fetchCoursesByCurrentUser();
  }

  // Future<void> fetchCourses() async {
  //   String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  //   QuerySnapshot snapshot;
  //   List<Course> fetchedCourses = [];
  //   print("current staff id ${currentUserId}");
  //   try {
  //     // Fetch the staff document
  //     DocumentSnapshot staffSnapshot = await FirebaseFirestore.instance
  //         .collection('staff')
  //         .doc(currentUserId) // Fetch the current staff document
  //         .get();

  //     // Check if the staff document exists
  //     if (staffSnapshot.exists) {
  //       // Cast the staff data to a Map<String, dynamic> and get the list of course IDs from the 'courses' field
  //       Map<String, dynamic> staffData =
  //           staffSnapshot.data() as Map<String, dynamic>;
  //       List<String> assignedCourses = staffData['courses'] ?? [];

  //       if (assignedCourses.isNotEmpty) {
  //         // Fetch courses based on the list of course IDs in the 'courses' field
  //         snapshot = await FirebaseFirestore.instance
  //             .collection('courses')
  //             .where(FieldPath.documentId,
  //                 whereIn: assignedCourses) // Get courses by IDs
  //             .get();

  //         // Map the results to a list of Course objects
  //         fetchedCourses = snapshot.docs.map((doc) {
  //           return Course(
  //             courseName: doc['courseName'],
  //             courseCode: doc['courseCode'],
  //             description: doc['description'],
  //             // Add other fields if necessary
  //           );
  //         }).toList();
  //       } else {
  //         // If no courses are assigned to the staff, set an empty list
  //         fetchedCourses = [];
  //       }
  //     } else {
  //       print("Staff document not found");
  //     }

  //     // Update the UI with the fetched courses
  //     setState(() {
  //       courses = fetchedCourses;
  //     });
  //   } catch (e) {
  //     print("Error fetching courses: $e");
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Failed to fetch courses')));
  //   }
  // }

  Future<void> fetchCoursesByCurrentUser() async {
    print("FETCHING COURSES");
    String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    print("CURRENT USER EMAIL IS $currentUserEmail");
    if (currentUserEmail.isEmpty) {
      print("No user is currently logged in");
      return;
    }

    List<Course> fetchedCourses = [];
    print("Fetching courses for current user with email: $currentUserEmail");

    try {
      // Fetch the staff document based on the current user's email
      QuerySnapshot staffSnapshot = await FirebaseFirestore.instance
          .collection('staff')
          .where('email', isEqualTo: currentUserEmail) // Query staff by email
          .get();

      // Check if the staff document exists
      if (staffSnapshot.docs.isNotEmpty) {
        // Get the first document (since email is unique, there should be only one staff document)
        DocumentSnapshot staffDoc = staffSnapshot.docs.first;

        // Cast the staff data to a Map<String, dynamic> and get the list of course IDs from the 'courses' field
        Map<String, dynamic> staffData =
            staffDoc.data() as Map<String, dynamic>;
        List<String> assignedCourses =
            List<String>.from(staffData['courses'] ?? []);
        print("ASSIGNED COURSES ARE");
        print(assignedCourses);
        // If courses are assigned to the staff member
        if (assignedCourses.isNotEmpty) {
          // Fetch courses based on the list of course IDs in the 'courses' field
          QuerySnapshot courseSnapshot = await FirebaseFirestore.instance
              .collection('courses')
              .where("courseName",
                  whereIn: assignedCourses) // Query for courses by IDs
              .get();

          // .where(FieldPath.documentId,
          //         whereIn: assignedCourses) //
          // Map the results to a list of Course objects
          print("COURSE FROM COURSE DOCUMENT");
          print(courseSnapshot);
          fetchedCourses = courseSnapshot.docs.map((doc) {
            return Course(
              courseName: doc['courseName'],
              courseCode: doc['courseCode'],
              description: doc['description'],
              // Add other fields if necessary
            );
          }).toList();
        } else {
          // If no courses are assigned to the staff, set an empty list
          fetchedCourses = [];
        }
      } else {
        print("Staff document not found for email: $currentUserEmail");
      }

      // Update the UI with the fetched courses
      setState(() {
        courses = fetchedCourses;
      });
    } catch (e) {
      print("Error fetching courses: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch courses')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isStudent ? 'Registered Courses' : 'Assigned Courses'),
      ),
      body: courses.length == 0
          ? Center(
              child: Text(widget.isStudent
                  ? "No  Registered Courses"
                  : "No Course Assigned "),
            )
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return CourseItem(
                    course: courses[index], isStudent: widget.isStudent);
              },
            ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final Course course;
  final bool isStudent;

  CourseItem({required this.course, this.isStudent = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.courseName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Course: ${course.courseName}'),
            Text('Code: ${course.courseCode}'),
            Text('Description: ${course.description}'),
            SizedBox(height: 12),
            if (isStudent)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle "View Details" button
                      print('View Details of ${course.courseName}');
                    },
                    child: Text('View Details'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Unregister" button
                      print('Unregister from ${course.courseName}');
                    },
                    child: Text('Unregister'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
