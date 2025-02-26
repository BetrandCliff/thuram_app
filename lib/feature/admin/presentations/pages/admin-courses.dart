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
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../model/course.dart';

class Course {
  final String id;
  final String courseName;
  final String courseCode;
  final String description;

  Course({
    required this.id,
    required this.courseName,
    required this.courseCode,
    required this.description,
  });

  factory Course.fromMap(String id, Map<String, dynamic> data) {
    return Course(
      id: id,
      courseName: data['courseName'] ?? 'No Name',
      courseCode: data['courseCode'] ?? 'No Code',
      description: data['description'] ?? 'No Description',
    );
  }
}

class AdminCourseWidget extends StatefulWidget {
  final bool isStudent;

  AdminCourseWidget({super.key, this.isStudent = true});

  @override
  _AdminCourseWidgetState createState() => _AdminCourseWidgetState();
}

class _AdminCourseWidgetState extends State<AdminCourseWidget> {
  List<Course> courses = [];
  bool isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();
    fetchAllCourses();
  }

  Future<void> fetchAllCourses() async {
    print("Fetching all courses...");
    setState(() => isLoading = true);

    try {
      QuerySnapshot courseSnapshot =
          await FirebaseFirestore.instance.collection('courses').get();

      List<Course> fetchedCourses = courseSnapshot.docs.map((doc) {
        return Course.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      setState(() {
        courses = fetchedCourses;
        isLoading = false;
      });

      print("Fetched ${fetchedCourses.length} courses.");
    } catch (e) {
      print("Error fetching courses: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch courses')));
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .delete();
      setState(() {
        courses.removeWhere((course) => course.id == courseId);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Course deleted successfully')));
    } catch (e) {
      print("Error deleting course: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete course')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Courses")),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : courses.isEmpty
              ? Center(child: Text("No Courses Available"))
              : ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(courses[index].id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        deleteCourse(courses[index].id);
                      },
                      child: CourseItem(course: courses[index]),
                    );
                  },
                ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final Course course;

  CourseItem({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Make it responsive
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.courseName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text('Code: ${course.courseCode}',
                  style: TextStyle(fontSize: 14)),
              Text('Description: ${course.description}',
                  style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
