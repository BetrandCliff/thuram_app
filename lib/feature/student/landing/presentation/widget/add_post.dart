import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';  // For selecting profile picture from gallery
import 'dart:io';

class AddPostForm extends StatefulWidget {
  @override
  _AddPostFormState createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  final TextEditingController _messageController = TextEditingController();
  File? _profilePic;

  // final _picker = ImagePicker();

  Future<void> _pickImage() async {
    // final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() {
    //     _profilePic = File(pickedFile.path);
    //   });
    // }
  }

  Future<void> _createPost() async {
    if (_messageController.text.isEmpty || _profilePic == null) {
      // Show error if message or profile picture is missing
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    // Get the current user details
    User? user = FirebaseAuth.instance.currentUser;

    // Store the post data in Firestore
    try {
      CollectionReference posts = FirebaseFirestore.instance.collection('posts');
      await posts.add({
        'message': _messageController.text,
        'profilePic': _profilePic!.path, // Store file path or upload it to Firebase Storage for URL
        'name': user?.displayName ?? 'Anonymous',
        'createdAt': FieldValue.serverTimestamp(),
        'likes': 0,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post created successfully!")));
      _messageController.clear();
      setState(() {
        _profilePic = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePic != null ? FileImage(_profilePic!) : null,
                child: _profilePic == null ? Icon(Icons.camera_alt) : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(hintText: 'Enter your message'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createPost,
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
