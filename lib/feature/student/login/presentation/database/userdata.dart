// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../model/user.dart';

// Future<void> _signup() async {
//   if (_passwordController.text != _confirmPasswordController.text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Passwords do not match.')),
//     );
//     return;
//   }

//   try {
//     // Create the user with Firebase Authentication
//     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//     );

//     // Get the user ID
//     String userId = userCredential.user!.uid;

//     // Create a UserModel instance
//     UserModel userModel = UserModel(
//       email: _emailController.text.trim(),
//       username: _usernameController.text.trim(),
//       userId: userId,
//       confess: null, // Initially null, you can later update this field
//       lostItems: [], // Empty list initially, you can add items later
//     );

//     // Save the user model to Firestore
//     await FirebaseFirestore.instance.collection('users').doc(userId).set(userModel.toMap());

//     // Navigate to the appropriate landing page
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => _emailController.text.trim().contains("admin")
//             ? AdminLandingPage()
//             : _emailController.text.trim().contains("staff")
//                 ? LecturerLandingPage()
//                 : LandingPage(),
//       ),
//     );
//   } on FirebaseAuthException catch (e) {
//     String message = "An error occurred. Please try again.";
//     if (e.code == 'email-already-in-use') {
//       message = 'The account already exists for that email.';
//     } else if (e.code == 'weak-password') {
//       message = 'The password provided is too weak.';
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user.dart';

Future<UserModel?> getUserData(String userId) async {
  DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  
  if (docSnapshot.exists) {
    return UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
  }
  return null;
}


Future<void> updateConfess(String userId, String confessText) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'confess': confessText,
  });
}



Future<void> updateLostItems(String userId, List<String> newLostItems) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'lostItems': newLostItems,
  });
}

