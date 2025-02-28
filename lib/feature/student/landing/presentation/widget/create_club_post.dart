import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thuram_app/util/next-screen.dart';
/*
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
}*/


/*
class CreateClubPostScreen extends StatefulWidget {
  const CreateClubPostScreen({Key? key}) : super(key: key);

  @override
  _CreateClubPostScreenState createState() =>
      _CreateClubPostScreenState();
}

class _CreateClubPostScreenState extends State<CreateClubPostScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _messageController = TextEditingController();
  File? _media; // Can be either an image or a video
  String? _thumbnailPath; // Path to the generated thumbnail if video is selected
  final ImagePicker _picker = ImagePicker();

  /// Pick an image or video
Future<void> _pickMedia() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _media = File(pickedFile.path);
      _thumbnailPath = null; // Reset thumbnail path in case we are picking an image
    });
  }
}

// Pick a video (without generating a thumbnail)
Future<void> _pickVideo() async {
  final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _media = File(pickedFile.path);
      _thumbnailPath = null; // No need for thumbnail generation
    });
  }
}

// Submit confession (image/video and message)
Future<void> _submitConfession(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    final message = _messageController.text;
    String? mediaPath;

    if (_media != null) {
      mediaPath = _media!.path;
    }

    try {
      // Your Firestore upload logic here
      // For example, upload to Firestore:
      await FirebaseFirestore.instance.collection('clubPost').add({
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
        'userName': FirebaseAuth.instance.currentUser?.displayName,
        'profilePic': 'assets/profile_placeholder.png',
        'mediaPath': mediaPath, // Store the media path
        'status': 'pending',
      });

      Navigator.pop(context);
    } catch (e) {
      print("Error submitting confession: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit confession. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Confession'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your confession:',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.displaySmall,
                  hintText: 'Write your confession here...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Show option to pick image or video
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Pick Media'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _pickMedia(); // Pick image
                            Navigator.pop(context);
                          },
                          child: Text('Pick Image'),
                        ),
                        TextButton(
                          onPressed: () {
                            _pickVideo(); // Pick video
                            Navigator.pop(context);
                          },
                          child: Text('Pick Video'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey[200],
                  child: _media == null
                      ? Center(child: Text('Tap to select media'))
                      : _thumbnailPath != null
                          ? Image.file(
                              File(_thumbnailPath!),
                              fit: BoxFit.cover,
                            )
                          : _media!.path.endsWith('.mp4')
                              ? Icon(
                                  Icons.video_camera_front,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : Image.file(
                                  _media!,
                                  fit: BoxFit.cover,
                                ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _submitConfession(context),
                child: Text('Submit Confession'),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

*/


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../../admin/presentations/database/db.dart';



class CreateClubPostScreen extends StatefulWidget {
  const CreateClubPostScreen({Key? key}) : super(key: key);

  @override
  _CreateClubPostScreenState createState() =>
      _CreateClubPostScreenState();
}
class _CreateClubPostScreenState extends State<CreateClubPostScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _messageController = TextEditingController();
  File? _media;
  String? _thumbnailPath;
  final ImagePicker _picker = ImagePicker();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Pick an image
  Future<void> _pickMedia() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _media = File(pickedFile.path);
        _thumbnailPath = null;
      });
    }
  }

  /// Pick a video
  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _media = File(pickedFile.path);
        _thumbnailPath = null;
      });
    }
  }

  /// Submit club post
  Future<void> _submitClubPost(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final message = _messageController.text;
      if (_media != null) {
        final mediaPath = _media!.path;
        final mediaType = mediaPath.endsWith('.mp4') ? 'video' : 'image';

        try {
          // Store media path in SQLite and get the inserted ID
          int mediaId = await _dbHelper.insertMedia('club_posts', mediaPath, mediaType);

          // Upload post details to Firestore, including SQLite media ID
          await FirebaseFirestore.instance.collection('clubPosts').add({
            'message': message,
            'createdAt': FieldValue.serverTimestamp(),
            'userName': FirebaseAuth.instance.currentUser?.displayName,
            'profilePic': 'assets/profile_placeholder.png',
            'mediaId': mediaId, // Store SQLite media ID
            'status': 'pending',
            'userId': FirebaseAuth.instance.currentUser?.uid,
          });

          Navigator.pop(context);
        } catch (e) {
          print("Error submitting club post: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit club post. Please try again later.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an image or video'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Club Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your post:',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintStyle: Theme.of(context).textTheme.displaySmall,
                    hintText: 'Write your post here...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Pick Media'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _pickMedia();
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
                  },
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey[200],
                    child: _media == null
                        ? Center(child: Text('Tap to select media'))
                        : _thumbnailPath != null
                            ? Image.file(
                                File(_thumbnailPath!),
                                fit: BoxFit.cover,
                              )
                            : _media!.path.endsWith('.mp4')
                                ? Icon(
                                    Icons.video_camera_front,
                                    size: 50,
                                    color: Colors.grey,
                                  )
                                : Image.file(
                                    _media!,
                                    fit: BoxFit.cover,
                                  ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _submitClubPost(context),
                  child: Text('Submit Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
