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
                  height: 150,
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
    );
  }
}




/*
class _CreateConfessionScreenState extends State<CreateConfessionScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _messageController = TextEditingController();
  File? _mediaFile;
  final ImagePicker _picker = ImagePicker();
  Database? _database;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // Initialize SQLite database
  Future<void> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'confessions.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE confessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mediaPath TEXT
          )
        ''');
      },
    );
  }

  // Save media to local storage and store its path in SQLite
  Future<String?> _saveMediaLocally(File mediaFile) async {
    final directory = await getApplicationDocumentsDirectory();
    String fileExt = extension(mediaFile.path); // Get file extension
    String fileName = 'confession_${DateTime.now().millisecondsSinceEpoch}$fileExt';
    String filePath = join(directory.path, fileName);

    try {
      await mediaFile.copy(filePath);

      // Insert media path into SQLite
      await _database?.insert('confessions', {'mediaPath': filePath});

      return filePath;
    } catch (e) {
      print("Error saving media locally: $e");
      return null;
    }
  }

  // Pick an image or video
  Future<void> _pickMedia() async {
    final pickedFile = await _picker.pickMedia(); // Picks both image & video
    if (pickedFile != null) {
      File file = File(pickedFile.path);

      setState(() {
        _mediaFile = file;
      });

      // If it's a video, initialize video player
      if (_isVideoFile(file.path)) {
        _videoController = VideoPlayerController.file(file)
          ..initialize().then((_) {
            setState(() {}); // Update UI after video is ready
          });
      }
    }
  }

  // Check if file is a video
  bool _isVideoFile(String filePath) {
    List<String> videoExtensions = ['.mp4', '.mov', '.avi', '.mkv'];
    return videoExtensions.contains(extension(filePath).toLowerCase());
  }

  // Submit confession (store details in Firestore and media path in SQLite)
  Future<void> _submitConfession(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final message = _messageController.text;
      String? localMediaPath;

      if (_mediaFile != null) {
        localMediaPath = await _saveMediaLocally(_mediaFile!);
      }

      try {
        await FirebaseFirestore.instance.collection('confessions').add({
          'message': message,
          'createdAt': FieldValue.serverTimestamp(),
          'userName': 'Anonymous', // Replace with actual username
          'profilePic': 'assets/profile_placeholder.png',
          'mediaPath': localMediaPath, // Store local media path
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
      appBar: AppBar(title: Text('Create Confession')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter your confession:', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 10),
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
                onTap: _pickMedia,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[200],
                  child: _mediaFile == null
                      ? Center(child: Text('Tap to select an image or video'))
                      : _isVideoFile(_mediaFile!.path)
                          ? _videoController != null && _videoController!.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                )
                              : Center(child: CircularProgressIndicator())
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
    );
  }
}*/

/*
class _CreateConfessionScreenState extends State<CreateConfessionScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _messageController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  // Initialize SQLite database
  Future<void> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'confessions.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE confessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  // Save image to local storage and store its path in SQLite
  Future<String?> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = join(directory.path, 'confession_${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      await imageFile.copy(filePath);

      // Insert image path into SQLite
      await _database?.insert('confessions', {'imagePath': filePath});

      return filePath;
    } catch (e) {
      print("Error saving image locally: $e");
      return null;
    }
  }

  // Pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Submit confession (store details in Firestore and image path in SQLite)
  Future<void> _submitConfession(BuildContext context ) async {
    if (_formKey.currentState!.validate()) {
      final message = _messageController.text;
      String? localImagePath;

      if (_image != null) {
        localImagePath = await _saveImageLocally(_image!);
      }

      try {
        await FirebaseFirestore.instance.collection('confessions').add({
          'message': message,
          'createdAt': FieldValue.serverTimestamp(),
          'userName': 'Anonymous', // You can replace this with the actual username
          'profilePic': 'assets/profile_placeholder.png', // Optional: User profile pic URL
          'imagePath': localImagePath, // Store local image path
          'status': 'pending', // Initially set as pending
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
              SizedBox(height: 10,),
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
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey[200],
                  child: _image == null
                      ? Center(child: Text('Tap to select an image'))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:()=> _submitConfession(context),
                child: Text('Submit Confession'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
