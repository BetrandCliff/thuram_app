import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/util/next-screen.dart';

import 'post_course_content.dart';
import 'view_coursedetails.dart';

class RegisterCourseItem extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final String courseId;
  final bool isStudent;
  final Function(String) onRegister;

  RegisterCourseItem({
    required this.courseData,
    required this.courseId,
    this.isStudent = true,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(6),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(AppImages.equation),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Name
              Text(
                courseData['courseName'] ?? 'Unknown Course',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: 8),
              
              // Course Details
              Text('code: ${courseData['courseCode'] ?? 'N/A'}', style: TextStyle(fontSize: 14)),
              Text('description: ${courseData['description'] ?? 'N/A'}', style: TextStyle(fontSize: 14)),
              Text('Duration: ${courseData['duration'] ?? 'N/A'}', style: TextStyle(fontSize: 14)),
              SizedBox(height: 12),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ElevatedButton(
                  //   onPressed: () => print('View Details of ${courseData['name']}'),
                  //   child: Text('View Details'),
                  // ),
                  // SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => isStudent ? onRegister(courseId) : _unassignCourse(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isStudent ? Colors.green : Colors.red,
                    ),
                    child: Text(isStudent ? 'Register' : 'Unassign'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Placeholder function for unassigning a course (for non-students)
  void _unassignCourse() {
    print('Unassign from ${courseData['name']}');
  }
}
