import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thuram_app/util/next-screen.dart';

import '../../../../../core/constants/constants.dart';
/*
class PostLostFoundScreen extends StatefulWidget {
  const PostLostFoundScreen({super.key});

  @override
  _PostLostFoundScreenState createState() => _PostLostFoundScreenState();
}

class _PostLostFoundScreenState extends State<PostLostFoundScreen> {
  TextEditingController messageController = TextEditingController();

  Future<void> postLostFoundItem() async {
    String message = messageController.text.trim();
    if (message.isEmpty) {
      return;
    }

    String userName = FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous';
    String profilePic = FirebaseAuth.instance.currentUser?.photoURL ?? 'https://example.com/default_profile_pic.jpg'; // Replace with a default profile picture URL

    try {
      await FirebaseFirestore.instance.collection('lostFoundPosts').add({
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
      appBar: AppBar(title: Text("Post Lost or Found Item")),
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
              onPressed: postLostFoundItem,
              child: Text("Submit Post"),
            ),
          ],
        ),
      ),
    );
  }
}*/






class PostLostFoundScreen extends StatefulWidget {
  const PostLostFoundScreen({Key? key}) : super(key: key);

  @override
  _PostLostFoundScreenState createState() => _PostLostFoundScreenState();
}

class _PostLostFoundScreenState extends State<PostLostFoundScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _media;
  bool _isUploading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _media = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _media = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadMedia() async {
    if (_media == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(fileURL.trim()));
      request.files.add(await http.MultipartFile.fromPath('file', _media!.path));

      var response = await request.send();
      if (response.statusCode == 201) {
        String responseBody = await response.stream.bytesToString(); // Server returns file URL
        var jsonResponse = jsonDecode(responseBody);
        return jsonResponse['url']; // Expecting the file URL from API
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload media"), backgroundColor: Colors.red),
        );
        return null;
      }
    } catch (e) {
      print("Upload error: $e");
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      final message = _messageController.text;
      String? mediaPath = await _uploadMedia();

      try {
        await FirebaseFirestore.instance.collection('lostFoundPosts').add({
          'message': message,
          'userId': FirebaseAuth.instance.currentUser?.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'userName': FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous",
          'profilePic': 'assets/profile_placeholder.png',
          'mediaPath': mediaPath,
          'status': 'pending',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Post submitted successfully"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } catch (e) {
        print("Error submitting post: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit post. Try again later.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showMediaPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick Media'),
        actions: [
          TextButton(
            onPressed: () {
              _pickImage();
              Navigator.pop(context);
            },
            child: Text('Pick Image'),
          ),
          TextButton(
            onPressed: () {
              _pickVideo();
              Navigator.pop(context);
            },
            child: Text('Pick Video'),
          ),
        ],
      ),
    );
  }

  Widget _mediaPreview() {
    if (_media == null) {
      return Center(child: Text('Tap to select media'));
    } else if (_media!.path.endsWith('.mp4')) {
      return Icon(Icons.video_camera_front, size: 50, color: Colors.grey);
    } else {
      return Image.file(_media!, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Missing Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter your post:', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 10),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.displaySmall,
                  hintText: 'Write your message here...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a message' : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _showMediaPicker,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey[200],
                  child: _mediaPreview(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isUploading ? null : _submitPost,
                child: _isUploading ? CircularProgressIndicator() : Text('Submit Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}