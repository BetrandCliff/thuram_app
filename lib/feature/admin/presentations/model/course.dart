class Course {
  final String courseCode;
  final String courseName;
  final String description;
  final String?
      imageUrl; // Image URL from Firebase Storage if the course has an image
  final List<String>? content;
  final String? id;
  Course(
      {required this.courseCode,
      required this.courseName,
      required this.description,
      this.imageUrl,
      this.id,
      this.content});

  // Convert Course object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'description': description,
      'imageUrl': imageUrl,
      'content': content,
      'id':id
    };
  }

  // Create Course object from Map (Firestore document)
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
        courseCode: map['courseCode'],
        courseName: map['courseName'],
        description: map['description'],
        imageUrl: map['imageUrl'],
        id:map['id']??"",
        content:
            map['content'] != null ? List<String>.from(map['content']) : []);
  }
}
