class Staff {
  final String fullName;
  final String email;
  final String officeLocation;
  final String speciality;
  final String role;
  final List<String> assignedCourses;  // List of course names the staff is assigned to
  final String? imageUrl;  // Staff image URL (if uploaded)

  Staff({
    required this.fullName,
    required this.email,
    required this.officeLocation,
    required this.speciality,
    required this.role,
    required this.assignedCourses,
    this.imageUrl,
  });

  // Convert Staff object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'officeLocation': officeLocation,
      'speciality': speciality,
      'role': role,
      'assignedCourses': assignedCourses,
      'imageUrl': imageUrl,
    };
  }

  // Create Staff object from Map (Firestore document)
  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      fullName: map['fullName'],
      email: map['email'],
      officeLocation: map['officeLocation'],
      speciality: map['speciality'],
      role: map['role'],
      assignedCourses: List<String>.from(map['assignedCourses']),
      imageUrl: map['imageUrl'],
    );
  }
}
