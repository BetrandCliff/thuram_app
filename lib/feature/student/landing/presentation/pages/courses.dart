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
    widget.isStudent?fetchCoursesForStudent():
    fetchCoursesByCurrentUser();

  }

  /*
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
    // Fetch the student document based on the current user's email
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users') // Assuming a 'users' collection exists
        .where('email', isEqualTo: currentUserEmail)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = userSnapshot.docs.first;
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Assuming you have a 'role' field to distinguish between staff and student
      String role = userData['role'] ?? 'student'; // Default to student if role is missing
      print("USER ROLE IS $role");

      if (role == 'student') {
        // Fetch registered courses for student
        String userId = FirebaseAuth.instance.currentUser!.uid;
        // Fetch all the courses the student is registered for from the 'registrations/{userId}/courses' collection
        QuerySnapshot courseSnapshot = await FirebaseFirestore.instance
            .collection('registrations')
            .doc(userId)
            .collection('courses')
            .get();

        if (courseSnapshot.docs.isNotEmpty) {
          // Fetch courses details for each registered course
          var courseFutures = courseSnapshot.docs.map((doc) async {
            String courseId = doc['courseId'];
            // Fetch the course details from the 'courses' collection
            DocumentSnapshot courseDoc = await FirebaseFirestore.instance
                .collection('courses')
                .doc(courseId)
                .get();

            if (courseDoc.exists) {
              Map<String, dynamic> courseData = courseDoc.data() as Map<String, dynamic>;
              return Course(
                courseName: courseData['courseName'] ?? 'Unknown Course',
                courseCode: courseData['courseCode'] ?? 'Unknown Code',
                description: courseData['description'] ?? 'No description available',
              );
            }
            return null; // If course document does not exist, return null
          }).where((course) => course != null); // Filter out null courses

          // Wait for all the course futures to complete and collect them in a list
          fetchedCourses = (await Future.wait(courseFutures)).whereType<Course>().toList();
        } else {
          fetchedCourses = [];
        }
      } else {
        print("User role is not student, skipping course fetch");
        fetchedCourses = [];
      }
    } else {
      print("User document not found for email: $currentUserEmail");
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
*/

Future<void> fetchCoursesForStudent() async {
  String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
  if (currentUserEmail.isEmpty) {
    print("No user is currently logged in");
    return;
  }

  List<Course> fetchedCourses = [];
  try {
    // Fetch the student document based on the current user's email
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users') // Assuming a 'users' collection exists
        .where('email', isEqualTo: currentUserEmail)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = userSnapshot.docs.first;
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Assuming the role is 'student' and we're dealing with a student
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch all the courses the student is registered for
      QuerySnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection('registrations')
          .doc(userId)
          .collection('courses')
          .get();

      if (courseSnapshot.docs.isNotEmpty) {
        // Fetch course details for each registered course
        var courseFutures = courseSnapshot.docs.map((doc) async {
          String courseId = doc['courseId'];
          // Fetch the course details from the 'courses' collection
          DocumentSnapshot courseDoc = await FirebaseFirestore.instance
              .collection('courses')
              .doc(courseId)
              .get();

          if (courseDoc.exists) {
            Map<String, dynamic> courseData = courseDoc.data() as Map<String, dynamic>;
            return Course(
              courseName: courseData['courseName'] ?? 'Unknown Course',
              courseCode: courseData['courseCode'] ?? 'Unknown Code',
              description: courseData['description'] ?? 'No description available',
            );
          }
          return null; // If course document does not exist, return null
        }).where((course) => course != null); // Filter out null courses

        // Wait for all the course futures to complete and collect them in a list
        fetchedCourses = (await Future.wait(courseFutures)).whereType<Course>().toList();
      } else {
        fetchedCourses = [];
      }
    } else {
      print("User document not found for email: $currentUserEmail");
    }

    // Update the UI with the fetched courses
    setState(() {
      courses = fetchedCourses;
    });
  } catch (e) {
    print("Error fetching courses for student: $e");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Failed to fetch courses')));
  }
}


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
// */
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
