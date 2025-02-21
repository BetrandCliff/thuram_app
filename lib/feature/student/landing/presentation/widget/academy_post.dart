import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AcademyPostScreen extends StatefulWidget {
  @override
  _AcademyPostScreenState createState() => _AcademyPostScreenState();
}

class _AcademyPostScreenState extends State<AcademyPostScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createPost() async {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user info
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You need to be logged in to create a post.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create post
      await FirebaseFirestore.instance.collection('academy').add({
        'name': user.displayName ?? 'Anonymous',
        'profilePic': user.photoURL ?? '',
        'message': _messageController.text,
        'likes': [],
        'comments': [],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear the input field
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'What’s on your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _createPost,
                    child: Text('Post'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
