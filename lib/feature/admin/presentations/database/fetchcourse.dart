import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> fetchCourses() async {
  try {
    // Get the 'courses' collection from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('courses').get();
    
    // Extract course names from Firestore documents and return them
    return snapshot.docs.map((doc) => doc['courseName'] as String).toList();
  } catch (e) {
    print("Error fetching courses: $e");
    return [];
  }
}
