import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

import 'package:thuram_app/util/mediaviewer.dart'; // For File handling if needed
// You might need to add more imports like video_player or flutter_pdfview for media

class CourseContentDisplay extends StatefulWidget {
  final dynamic course; // Assuming you have a course object with course data
  final String courseId;
  const CourseContentDisplay({Key? key, required this.course, required this.courseId}) : super(key: key);

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
          .doc(widget.courseId)
          .get();

      if (courseSnapshot.exists) {
        var courseData = courseSnapshot.data() as Map<String, dynamic>;
        if (_isMounted) {
          setState(() {
            _content = List<Map<String, dynamic>>.from(courseData['content'] ?? []);
          });
          print("COURSE DETAILS FETCHED");
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

  /// Display content with media and lesson title
  Widget _buildMediaItem(Map<String, dynamic> content) {
    final String lessonTitle = content['lessonTitle']??"";
    final String mediaPath = content['mediaPath']??""; // Assuming mediaPath is directly available

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${lessonTitle??""}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        _buildMediaWidget(mediaPath),
        SizedBox(height: 16),
      ],
    );
  }

  /// Determines media type and displays it accordingly
  Widget _buildMediaWidget(String mediaPath) {
    if ( mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')|| mediaPath.endsWith('.jpg')|| mediaPath.endsWith('.png')) {
      return MediaViewer(mediaPath: mediaPath,);

    } else if (mediaPath.endsWith('.pdf')) {
      return _buildPdfViewer(mediaPath);
    } else {
      return Text("Unsupported file format");
    }
  }


  Widget _buildPdfViewer(String mediaPath) {
    print("THE MEDIA PDF LINK IS $mediaPath");
    return Container(
      height: 400,
      color: Colors.grey[300],
      child: PDF().fromUrl(
        // "https://www.hq.nasa.gov/alsj/a17/A17_FlightPlan.pdf",
        mediaPath, // URL of the PDF file
        errorWidget: (error) => Center(child: Text("Failed to load PDF: $error")),
        placeholder: (progress) => Center(child: CircularProgressIndicator()),
      ),
    );
  }
  /// Example of how to build a PDF viewer
  // Widget _buildPdfViewer(String mediaPath) {
  //   return Container(
  //     height: 400, // Set appropriate height
  //     color: Colors.grey[300],
  //     child: PDFView(
  //       filePath: mediaPath, // Path to the PDF file (could be a URL or local file)
  //       onPageError: (page, error) {
  //         // Handle any errors
  //         print("Error on page $page: $error");
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.course.courseName)),
      body: ListView.builder(
        itemCount: _content.length,
        itemBuilder: (context, index) {
          return Container(
            child: Card(
                elevation: 3,
                child: _buildMediaItem(_content[index])),
          );
        },
      ),
    );
  }
}
