import 'package:flutter/material.dart';

// Example course data
class Course {
  final String title;
  final String tutor;
  final String level;
  final String duration;

  Course({
    required this.title,
    required this.tutor,
    required this.level,
    required this.duration,
  });
}

class CourseWidget extends StatelessWidget {
  
  final isStudent;
  // Example list of courses
  final List<Course> courses = [
    Course(
      title: 'Introduction to Machine Learning',
      tutor: 'John Doe',
      level: 'Intermediate',
      duration: '3 months',
    ),
    Course(
      title: 'Advanced JavaScript',
      tutor: 'Jane Smith',
      level: 'Advanced',
      duration: '2 months',
    ),
    Course(
      title: 'Python for Data Science',
      tutor: 'Alan Turing',
      level: 'Beginner',
      duration: '4 months',
    ),
  ];

   CourseWidget({super.key, this.isStudent=true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(isStudent?'Registered Courses':"Assigned Courses"),
      // ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return CourseItem(course: courses[index],isStudent: isStudent,);
        },
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final Course course;
final isStudent;
  CourseItem({required this.course, this.isStudent=true});

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
              course.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Tutor: ${course.tutor}'),
            Text('Level: ${course.level}'),
            Text('Duration: ${course.duration}'),
            SizedBox(height: 12),
            
            if(isStudent)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle "View Details" button
                    print('View Details of ${course.title}');
                  },
                  child: Text('View Details'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Unregister" button
                    print('Unregister from ${course.title}');
                  },
                  child: Text('Unregister'),
                  // style: ElevatedButton.styleFrom(
                  //   primary: Colors.red,
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CourseWidget(),
  ));
}
