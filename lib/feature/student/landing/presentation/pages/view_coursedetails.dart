import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:video_player/video_player.dart';

// class CourseContentDisplay extends StatefulWidget {
//   final String courseId; // Course ID for fetching content
//   final String courseName; // Course name to display
//   const CourseContentDisplay(
//       {Key? key, required this.courseId, required this.courseName})
//       : super(key: key);

//   @override
//   _CourseContentDisplayState createState() => _CourseContentDisplayState();
// }

// class _CourseContentDisplayState extends State<CourseContentDisplay> {
//   List<Map<String, dynamic>> _content =
//       []; // List to store lesson titles and media IDs

//   @override
//   void initState() {
//     super.initState();
//     _fetchCourseContent();
//   }

//   /// Fetch course content from Firestore
//   Future<void> _fetchCourseContent() async {
//     try {
//       print("THE COURSE ID IS ${widget.courseName}");
//       // Fetch the course document from Firestore using course ID
//       final DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
//           .collection('courses')
//           .doc(widget.courseId)
//           .get();

//       if (courseSnapshot.exists) {
//         var courseData = courseSnapshot.data() as Map<String, dynamic>;
//         setState(() {
//           _content =
//               List<Map<String, dynamic>>.from(courseData['content'] ?? []);
//         });
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Course not found')),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to fetch course content')),
//         );
//       }
//     }
//   }

//   /// Fetch media path from SQLite using media ID
//   Future<String?> _fetchMediaPath(int mediaId) async {
//     // TODO: Replace this with your actual SQLite query
//     return "https://example.com/media/$mediaId"; // Placeholder URL
//   }

//   /// Display content with media and lesson title
//   Widget _buildMediaItem(Map<String, dynamic> content) {
//     final int mediaId = content['mediaId']; // Media ID stored in Firestore
//     final String lessonTitle = content['lessonTitle'];

//     return FutureBuilder<String?>(
//       future: _fetchMediaPath(mediaId),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         final String? mediaPath = snapshot.data;

//         if (mediaPath == null) {
//           return Text("Media not found");
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               lessonTitle,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             if (mediaPath.endsWith('.jpg') || mediaPath.endsWith('.png'))
//               Image.file(File(mediaPath), fit: BoxFit.cover, height: 200)
//             else if (mediaPath.endsWith('.mp4'))
//               _buildVideoPlayer(mediaPath),
//             SizedBox(height: 16),
//           ],
//         );
//       },
//     );
//   }

//   /// Video player widget for video content
//   Widget _buildVideoPlayer(String videoPath) {
//     VideoPlayerController _controller =
//         VideoPlayerController.network(videoPath);

//     return FutureBuilder(
//       future: _controller.initialize(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Column(
//             children: [
//               AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               ),
//               IconButton(
//                 icon: Icon(_controller.value.isPlaying
//                     ? Icons.pause
//                     : Icons.play_arrow),
//                 onPressed: () {
//                   setState(() {
//                     if (_controller.value.isPlaying) {
//                       _controller.pause();
//                     } else {
//                       _controller.play();
//                     }
//                   });
//                 },
//               ),
//             ],
//           );
//         } else {
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Course: ${widget.courseId}')),
//       body: _content.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _content.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: _buildMediaItem(_content[index]),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

import '../../../../admin/presentations/database/db.dart';
import '../../../../admin/presentations/model/course.dart';

class CourseContentDisplay extends StatefulWidget {
  final Course course;

  const CourseContentDisplay(
      {Key? key, required this.course, required String courseId})
      : super(key: key);

  @override
  _CourseContentDisplayState createState() => _CourseContentDisplayState();
}

class _CourseContentDisplayState extends State<CourseContentDisplay> {
  List<Map<String, dynamic>> _content = [];
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _fetchCourseContent();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  /// Fetch course content from Firestore
  Future<void> _fetchCourseContent() async {
    try {
      print("Fetching content for course: ${widget.course.courseName}");
      final DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.course.id)
          .get();

      if (courseSnapshot.exists) {
        var courseData = courseSnapshot.data() as Map<String, dynamic>;
        if (_isMounted) {
          setState(() {
            _content =
                List<Map<String, dynamic>>.from(courseData['content'] ?? []);
          });
        }
      } else {
        if (_isMounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Course not found')),
          );
        }
      }
    } catch (e) {
      if (_isMounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch course content')),
        );
      }
    }
  }

  /// Fetch media path from SQLite using media ID
  Future<String?> _fetchMediaPath(int mediaId) async {
     final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> mediaRecords = await db.query(
      'confessions', // Assuming you have a table for confessions
      where: 'id = ?',
      whereArgs: [mediaId],
    );
    if (mediaRecords.isNotEmpty) {
      return mediaRecords.first['mediaPath'] as String?;
    }
    return null; 
  }

  /// Display content with media and lesson title
  Widget _buildMediaItem(Map<String, dynamic> content) {
    final int mediaId = content['mediaId']; // Media ID stored in Firestore
    final String lessonTitle = content['lessonTitle'];

    return FutureBuilder<String?>(
      future: _fetchMediaPath(mediaId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final String? mediaPath = snapshot.data;

        if (mediaPath == null) {
          return Text("Media not found");
        }
        print("MEDIA PATH $mediaPath");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lessonTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildMediaWidget(mediaPath),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  /// Determines media type and displays it accordingly
  Widget _buildMediaWidget(String mediaPath) {
    if (mediaPath.endsWith('.jpg') || mediaPath.endsWith('.png')) {
      return Image.file(File(mediaPath), fit: BoxFit.cover, height: 200);
    } else if (mediaPath.endsWith('.mp4')) {
      return _buildVideoPlayer(mediaPath);
    } else if (mediaPath.endsWith('.pdf')) {
      return _buildPdfViewer(mediaPath);
    } else {
      return Text("Unsupported file format");
    }
  }

  /// Video player widget for video content
  Widget _buildVideoPlayer(String videoPath) {
    VideoPlayerController _controller =
        VideoPlayerController.network(videoPath);

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
                icon: Icon(_controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
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

  /// PDF viewer widget for displaying PDFs
  Widget _buildPdfViewer(String pdfPath) {
    return SizedBox(
      height: 300,
      child: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Course: ${widget.course.courseName}')),
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
