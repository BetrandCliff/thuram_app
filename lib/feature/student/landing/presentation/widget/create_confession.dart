import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; // For picking images
import 'package:thuram_app/util/next-screen.dart';
import 'package:thuram_app/util/widthandheight.dart';
import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../admin/presentations/database/db.dart';


import 'package:http/http.dart' as http;

/*
class CreateConfessionScreen extends StatefulWidget {
  const CreateConfessionScreen({Key? key}) : super(key: key);

  @override
  _CreateConfessionScreenState createState() =>
      _CreateConfessionScreenState();
}




class _CreateConfessionScreenState extends State<CreateConfessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _mediaFile;
  String? _mediaUrl;
  String? _mediaType; // 'image' or 'video'

  /// Pick media (image or video)
  Future<void> _pickMedia({required bool isVideo}) async {
    final pickedFile = isVideo
        ? await _picker.pickVideo(source: ImageSource.gallery)
        : await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
        _mediaType = isVideo ? 'video' : 'image';
      });
    }
  }

  /// Upload media file to the server
  Future<String?> _uploadMedia(File file) async {
    final uri = Uri.parse(fileURL.trim()); // Change this to your API URL
    var request = http.MultipartRequest("POST", uri);

    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var response = await request.send();

    if (response.statusCode == 201) {
      String responseBody =  await response.stream.bytesToString(); // Server returns file URL
      var jsonResponse = jsonDecode(responseBody);
      return jsonResponse['url'];
    } else {
      return null;
    }
  }

  /// Submit confession
  Future<void> _submitConfession(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final message = _messageController.text;
    final user = FirebaseAuth.instance.currentUser;

    if (_mediaFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploading media...')),
      );

      final uploadedMediaUrl = await _uploadMedia(_mediaFile!);
      if (uploadedMediaUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload media. Try again.'), backgroundColor: Colors.red),
        );
        return;
      }
      _mediaUrl = uploadedMediaUrl;
    }

    try {
      await FirebaseFirestore.instance.collection('confessions').add({
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
        'userName': user?.displayName ?? "Anonymous",
        'profilePic': user?.photoURL ?? 'assets/profile_placeholder.png',
        'mediaUrl': _mediaUrl,
        'type': _mediaType,
        'status': 'pending',
        'userId': user?.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Confession submitted!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Confession')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter your confession:', style: Theme.of(context).textTheme.displayMedium),
                SizedBox(height: 10),
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your confession here...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a message' : null,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Select Media'),
                      actions: [
                        TextButton(onPressed: () => _pickMedia(isVideo: false), child: Text('Pick Image')),
                        TextButton(onPressed: () => _pickMedia(isVideo: true), child: Text('Pick Video')),
                      ],
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    // height: 150,
                    color: Colors.grey[200],
                    child: _mediaFile == null
                        ? Center(child: Text('Tap to select media'))
                        : _mediaType == 'video'
                        ? Icon(Icons.video_camera_front, size: 50, color: Colors.grey)
                        : Image.file(_mediaFile!, fit: BoxFit.cover),
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
      ),
    );
  }
}*/


class CreateConfessionScreen extends StatefulWidget {
  const CreateConfessionScreen({Key? key}) : super(key: key);

  @override
  _CreateConfessionScreenState createState() => _CreateConfessionScreenState();
}

class _CreateConfessionScreenState extends State<CreateConfessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _mediaFile;
  String? _mediaUrl;
  String? _mediaType; // 'image' or 'video'

  /// Pick media (image or video)
  Future<void> _pickMedia({required bool isVideo}) async {
    final pickedFile = isVideo
        ? await _picker.pickVideo(source: ImageSource.gallery)
        : await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
        _mediaType = isVideo ? 'video' : 'image';
      });
    }
  }

  /// Upload media file to the server
  Future<String?> _uploadMedia(File file) async {
    final uri = Uri.parse(fileURL.trim()); // Change this to your API URL
    var request = http.MultipartRequest("POST", uri);

    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var response = await request.send();

    if (response.statusCode == 201) {
      String responseBody = await response.stream.bytesToString(); // Server returns file URL
      var jsonResponse = jsonDecode(responseBody);
      return jsonResponse['url'];
    } else {
      return null;
    }
  }

  /// Submit confession
  Future<void> _submitConfession(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final message = _messageController.text;
    final user = FirebaseAuth.instance.currentUser;

    if (_mediaFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploading media...')),
      );

      final uploadedMediaUrl = await _uploadMedia(_mediaFile!);
      if (uploadedMediaUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload media. Try again.'), backgroundColor: Colors.red),
        );
        return;
      }
      _mediaUrl = uploadedMediaUrl;
    }

    try {
      await FirebaseFirestore.instance.collection('confessions').add({
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
        'userName': user?.displayName ?? "Anonymous",
        'profilePic': user?.photoURL ?? 'assets/profile_placeholder.png',
        'mediaUrl': _mediaUrl,
        'type': _mediaType,
        'status': 'pending',
        'userId': user?.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Confession submitted!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Confession')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter your confession:', style: Theme.of(context).textTheme.displayMedium),
                SizedBox(height: 10),
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your confession here...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a message' : null,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Select Media'),
                      actions: [
                        TextButton(onPressed: () => _pickMedia(isVideo: false), child: Text('Pick Image')),
                        TextButton(onPressed: () => _pickMedia(isVideo: true), child: Text('Pick Video')),
                      ],
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: _mediaFile == null
                        ? Center(child: Text('Tap to select media'))
                        : _mediaType == 'video'
                        ? Icon(Icons.video_camera_front, size: 50, color: Colors.grey)
                        : Image.file(_mediaFile!, fit: BoxFit.cover),
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
      ),
    );
  }
}

