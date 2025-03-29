class UserModel {
  final String email;
  final String username;
  final String userId;
  final String role;
  final List<String> confess;
  final List<String> lostItems;
  final List<String> following;
  final List<String> followers;
  final String profilePic;

  UserModel(
      {required this.email,
      required this.username,
      required this.userId,
      required this.confess,
      required this.role,
      required this.lostItems,
      required this.followers,
      required this.profilePic,
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
      "profilePic": profilePic,
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
      profilePic:map['profilePic'],
      role: map['role']
    );
  }
}
