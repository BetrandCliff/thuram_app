import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/next-screen.dart';

class CreateClubPostScreen extends StatefulWidget {
  const CreateClubPostScreen({super.key});

  @override
  _CreateClubPostScreenState createState() => _CreateClubPostScreenState();
}

class _CreateClubPostScreenState extends State<CreateClubPostScreen> {
  TextEditingController messageController = TextEditingController();

  Future<void> clubPost() async {
    String message = messageController.text.trim();
    if (message.isEmpty) {
      return;
    }

    String userName = FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous';
    String profilePic = FirebaseAuth.instance.currentUser?.photoURL ?? 'https://example.com/default_profile_pic.jpg'; // Replace with a default profile picture URL

    try {
      await FirebaseFirestore.instance.collection('clubPost').add({
        'userName': userName,
        'profilePic': profilePic,
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
      });
      messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post submitted successfully!')));
       Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to post. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Club Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Item description",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: clubPost,
              child: Text("Submit Post"),
            ),
          ],
        ),
      ),
    );
  }
}
