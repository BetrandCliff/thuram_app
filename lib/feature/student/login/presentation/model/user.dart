class UserModel {
  final String email;
  final String username;
  final String userId;
  final String? confess;
  final List<String> lostItems;

  UserModel({
    required this.email,
    required this.username,
    required this.userId,
    this.confess,
    required this.lostItems,
  });

  // Convert UserModel to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'userId': userId,
      'confess': confess,
      'lostItems': lostItems,
    };
  }

  // Convert Firestore data to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      username: map['username'],
      userId: map['userId'],
      confess: map['confess'],
      lostItems: List<String>.from(map['lostItems']),
    );
  }
}
