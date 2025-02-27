import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class AcademyPostScreen extends StatefulWidget {
  @override
  _AcademyPostScreenState createState() => _AcademyPostScreenState();
}

class _AcademyPostScreenState extends State<AcademyPostScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  File? _media;
  String? _thumbnailPath;
  VideoPlayerController? _videoPlayerController;
  final ImagePicker _picker = ImagePicker();

  // Pick an image
  Future<void> _pickMedia() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _media = File(pickedFile.path);
        _thumbnailPath = null; // Reset thumbnail path if picking an image
        _videoPlayerController?.dispose(); // Dispose the video controller if it's previously set
        _videoPlayerController = null;
      });
    }
  }

  // Pick a video and generate a thumbnail
  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _media = File(pickedFile.path);
        // _generateThumbnail(pickedFile.path); // Generate a thumbnail for the video
        _initializeVideoPlayer(pickedFile.path); // Initialize video player
      });
    }
  }

  // Generate thumbnail for video
  // Future<void> _generateThumbnail(String videoPath) async {
  //   final String? thumbnail = await VideoThumbnail.thumbnailFile(
  //     video: videoPath,
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: ImageFormat.JPEG,
  //     maxWidth: 200, // Width of the thumbnail
  //     quality: 75, // Quality of the thumbnail
  //   );

  //   setState(() {
  //     _thumbnailPath = thumbnail;
  //   });
  // }

  // Initialize video player
  Future<void> _initializeVideoPlayer(String videoPath) async {
    final controller = VideoPlayerController.file(File(videoPath));
    await controller.initialize();
    setState(() {
      _videoPlayerController = controller;
    });
  }

  // Create post with image/video
  Future<void> _createPost() async {
    if (_messageController.text.isEmpty && _media == null) {
      return;
    }

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

      // Upload media if any
      String? mediaPath;
      if (_media != null) {
        // Here, implement your media upload to Firebase storage and get the URL.
        // For example:
        // mediaPath = await _uploadMedia(_media!);
        mediaPath = _media!.path; // Simulating media upload with path
      }

      // Create post
      await FirebaseFirestore.instance.collection('academy').add({
        'name': user.displayName ?? 'Anonymous',
        'profilePic': user.photoURL ?? '',
        'message': _messageController.text,
        'likes': [],
        'comments': [],
        'userId':user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'mediaPath': mediaPath, // Store media path or URL
        'thumbnailPath': _thumbnailPath, // Store the thumbnail path if it's a video
      });

      // Clear the input field
      _messageController.clear();
      setState(() {
        _media = null;
        _thumbnailPath = null;
        _videoPlayerController?.dispose();
        _videoPlayerController = null;
      });

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Media picker buttons (for image/video)
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickMedia,
                    child: Text('Pick Image'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickVideo,
                    child: Text('Pick Video'),
                  ),
                ],
              ),
              if (_media != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child:SizedBox(
                    height: 200,
                    child:  _thumbnailPath != null
                        ? Image.file(File(_thumbnailPath!)) // Display video thumbnail
                        : _videoPlayerController != null
                        ? AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    ) // Display video player
                        : Image.file(_media!),
                  ) // Display image
                ),
              SizedBox(height: 20),
              TextField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.displaySmall,
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
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }
}



/*
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
}*/
