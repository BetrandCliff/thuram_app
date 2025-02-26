import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class CourseContentDisplay extends StatefulWidget {
  final String courseName; // Course name for fetching content
  const CourseContentDisplay({Key? key, required this.courseName}) : super(key: key);

  @override
  _CourseContentDisplayState createState() => _CourseContentDisplayState();
}

class _CourseContentDisplayState extends State<CourseContentDisplay> {
  List<String> _content = []; // To store the media paths (image/video URLs)

  @override
  void initState() {
    super.initState();
    _fetchCourseContent();
  }

  /// Fetch course content from Firestore
  Future<void> _fetchCourseContent() async {
    try {
      // Query Firestore for the course document by course name
      final courseSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('courseName', isEqualTo: widget.courseName)
          .limit(1)
          .get();

      if (courseSnapshot.docs.isNotEmpty) {
        // Get the first document (since we limit the query to 1)
        var courseData = courseSnapshot.docs.first.data();
        setState(() {
          _content = List<String>.from(courseData['content'] ?? []);
        });
      } else {
        // No course found with that name
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course not found')),
        );
      }
    } catch (e) {
      print("Error fetching course content: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch course content')),
      );
    }
  }

  /// Display content based on its type (image or video)
  Widget _buildMediaItem(String mediaPath) {
    // Check if the media path is an image or video
    if (mediaPath.endsWith('.jpg') || mediaPath.endsWith('.png')) {
      return Image.network(mediaPath, fit: BoxFit.cover, height: 200);
    } else if (mediaPath.endsWith('.mp4')) {
      // For video, use the VideoPlayer widget
      return _buildVideoPlayer(mediaPath);
    } else {
      return SizedBox(); // If media type is not recognized, return empty widget
    }
  }

  /// Video player widget for video content
  Widget _buildVideoPlayer(String videoPath) {
    VideoPlayerController _controller = VideoPlayerController.network(videoPath);

    return FutureBuilder(
      future: _controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              IconButton(
                icon: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course: ${widget.courseName}'),
      ),
      body: _content.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _content.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildMediaItem(_content[index]),
                );
              },
            ),
    );
  }
}
