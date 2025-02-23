class UserModel {
  final String email;
  final String username;
  final String userId;
  final String role;
  final List<String> confess;
  final List<String> lostItems;
  final List<String> following;
  final List<String> followers;
  // final List<String> courses;

  UserModel(
      {required this.email,
      required this.username,
      required this.userId,
      required this.confess,
      required this.role,
      required this.lostItems,
      required this.followers,
      // required this.courses,
      required this.following});

  // Convert UserModel to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'userId': userId,
      'confess': confess,
      'lostItems': lostItems,
      'follower': followers,
      'following': following,
      // "courses": courses,
      "role":role
    };
  }

  // Convert Firestore data to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      username: map['username'],
      userId: map['userId'],
      confess: List<String>.from(map['confess']),
      lostItems: List<String>.from(map['lostItems']),
      followers: List<String>.from(map['follower']),
      following: List<String>.from(map['following']),
      // courses: List<String>.from(map['courses']),
      role: map['role']
    );
  }
}
