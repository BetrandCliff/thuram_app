import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../admin/presentations/model/course.dart';











class CourseWidget extends StatefulWidget {
  final bool isStudent;
  final bool isStaff;
  final String? staffId;  // Optional staffId to fetch courses assigned to this staff

  CourseWidget({super.key, this.isStudent = true, this.isStaff = false, this.staffId});

  @override
  _CourseWidgetState createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  late List<Course> courses;

  @override
  void initState() {
    super.initState();
    courses = [];
    fetchCourses();
  }

  // Fetch courses assigned or registered depending on isStudent or isStaff
  Future<void> fetchCourses() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot;

    if (widget.isStudent) {
      // Fetch courses registered by the student from Firestore
      snapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(currentUserId)
          .collection('registeredCourses') // Assuming this collection stores student registrations
          .get();
    } else if (widget.isStaff && widget.staffId != null) {
      // Fetch courses assigned to a specific staff based on the staffId
      snapshot = await FirebaseFirestore.instance
          .collection('staff')
          .doc(widget.staffId) // Use the passed staffId to fetch the assigned courses
          .collection('assignedCourses')
          .get();
    } else if (widget.isStaff) {
      // Fetch courses assigned to the current staff user
      snapshot = await FirebaseFirestore.instance
          .collection('staff')
          .doc(currentUserId) // Use the currentUserId if no staffId is provided
          .collection('assignedCourses')
          .get();
    } else {
      // Fetch all courses if neither student nor staff
      snapshot = await FirebaseFirestore.instance.collection('courses').get();
    }

    setState(() {
      courses = snapshot.docs.map((doc) {
        return Course(
          courseName: doc['courseName'],
          courseCode: doc['courseCode'],
          description: doc['description'],
          // duration: doc['duration'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isStudent
            ? 'Registered Courses'
            : widget.isStaff
                ? 'Assigned Courses'
                : 'All Courses'),
      ),
      body: courses.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return CourseItem(course: courses[index], isStudent: widget.isStudent);
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
            Text('Tutor: ${course.courseName}'),
            Text('Level: ${course.courseCode}'),
            Text('Duration: ${course.description}'),
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
            if (!isStudent)
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
                      // Handle "Unassign" button (if needed)
                      print('Unassign from ${course.courseName}');
                    },
                    child: Text('Unassign'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}



// Example course data
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
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

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

// class CourseWidget extends StatefulWidget {
//   final bool isStudent;
//   final bool isStaff;
//   final String? staffId;  // Optional staffId to fetch courses assigned to this staff

//   CourseWidget({super.key, this.isStudent = true, this.isStaff = false, this.staffId});

//   @override
//   _CourseWidgetState createState() => _CourseWidgetState();
// }

// class _CourseWidgetState extends State<CourseWidget> {
//   late List<Course> courses;

//   @override
//   void initState() {
//     super.initState();
//     courses = [];
//     fetchCourses();
//   }

//   // Fetch courses assigned or registered depending on isStudent or isStaff
//   Future<void> fetchCourses() async {
//     String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//     QuerySnapshot snapshot;

//     if (widget.isStudent) {
//       // Fetch courses registered by the student from Firestore
//       snapshot = await FirebaseFirestore.instance
//           .collection('students')
//           .doc(currentUserId)
//           .collection('courses')
//           .get();
//     } else if (widget.isStaff && widget.staffId != null) {
//       // Fetch courses assigned to staff based on the staffId
//       snapshot = await FirebaseFirestore.instance
//           .collection('staff')
//           .doc(widget.staffId) // Use the passed staffId to fetch the assigned courses
//           .collection('assignedCourses')
//           .get();
//     } else if (widget.isStaff) {
//       // Fetch courses assigned to the current staff user
//       snapshot = await FirebaseFirestore.instance
//           .collection('staff')
//           .doc(currentUserId) // Use the currentUserId if no staffId is provided
//           .collection('assignedCourses')
//           .get();
//     } else {
//       // Fetch all courses if neither student nor staff
//       snapshot = await FirebaseFirestore.instance.collection('courses').get();
//     }

//     setState(() {
//       courses = snapshot.docs.map((doc) {
//         return Course(
//           title: doc['courseName'],
//           tutor: doc['tutor'],
//           level: doc['level'],
//           duration: doc['duration'],
//         );
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isStudent
//             ? 'Registered Courses'
//             : widget.isStaff
//                 ? 'Assigned Courses'
//                 : 'All Courses'),
//       ),
//       body: ListView.builder(
//         itemCount: courses.length,
//         itemBuilder: (context, index) {
//           return CourseItem(course: courses[index], isStudent: widget.isStudent, isStaff: widget.isStaff);
//         },
//       ),
//     );
//   }
// }

// class CourseItem extends StatelessWidget {
//   final Course course;
//   final bool isStudent;
//   final bool isStaff;

//   CourseItem({required this.course, this.isStudent = true, this.isStaff = false});

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
//             if (isStudent)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle "View Details" button
//                       print('View Details of ${course.title}');
//                     },
//                     child: Text('View Details'),
//                   ),
//                   SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle "Unregister" button
//                       print('Unregister from ${course.title}');
//                     },
//                     child: Text('Unregister'),
//                   ),
//                 ],
//               ),
//             if (isStaff)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle "View Details" button
//                       print('View Details of ${course.title}');
//                     },
//                     child: Text('View Details'),
//                   ),
//                   SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle "Unassign" button (if needed)
//                       print('Unassign from ${course.title}');
//                     },
//                     child: Text('Unassign'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
