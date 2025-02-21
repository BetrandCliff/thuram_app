import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String title;
  final String tutor;
  final String level;
  final String duration;
  final String courseId;

  Course({
    required this.title,
    required this.tutor,
    required this.level,
    required this.duration,
    required this.courseId,
  });

  // From Firestore data to Course
  factory Course.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return Course(
      title: data['title'] ?? '',
      tutor: data['tutor'] ?? '',
      level: data['level'] ?? '',
      duration: data['duration'] ?? '',
      courseId: doc.id,
    );
  }

  // Convert to Firestore-friendly format
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'tutor': tutor,
      'level': level,
      'duration': duration,
    };
  }
}
