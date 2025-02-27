// import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../../../admin/presentations/database/db.dart';

// class UploadCourseContent extends StatefulWidget {
//   final String courseId; // Course ID to update
//   const UploadCourseContent({Key? key, required this.courseId}) : super(key: key);

//   @override
//   _UploadCourseContentState createState() => _UploadCourseContentState();
// }

// class _UploadCourseContentState extends State<UploadCourseContent> {
//   final ImagePicker _picker = ImagePicker();
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   File? _media;
//   final TextEditingController _lessonTitleController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   /// Pick an image
//   Future<void> _pickMedia() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _media = File(pickedFile.path);
//       });
//     }
//   }

//   /// Pick a video
//   Future<void> _pickVideo() async {
//     final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _media = File(pickedFile.path);
//       });
//     }
//   }

//   /// Submit course content (store in SQLite first, then update Firestore)
//   Future<void> _submitCourseContent(BuildContext context) async {
//     if (_formKey.currentState!.validate()) {
//       final lessonTitle = _lessonTitleController.text.trim();
//       if (_media == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Please select an image or video'),
//             backgroundColor: Colors.orange,
//           ),
//         );
//         return;
//       }

//       final mediaPath = _media!.path;
//       final mediaType = mediaPath.endsWith('.mp4') ? 'video' : 'image';

//       try {
//         // 1️⃣ Store media in SQLite and get media ID
//         int mediaId = await _dbHelper.insertMedia('coursedetails', mediaPath, mediaType);

//         // 2️⃣ Fetch existing content from Firestore
//         DocumentSnapshot courseDoc = await FirebaseFirestore.instance
//             .collection('courses')
//             .doc(widget.courseId)
//             .get();

//         List<dynamic> content = List.from(courseDoc['content'] ?? []);

//         // 3️⃣ Append new object { mediaId, lessonTitle } to Firestore
//         content.add({
//           "mediaId": mediaId,
//           "lessonTitle": lessonTitle,
//         });

//         // 4️⃣ Update Firestore with the new content list
//         await FirebaseFirestore.instance
//             .collection('courses')
//             .doc(widget.courseId)
//             .update({'content': content});

//         Navigator.pop(context); // Go back after successful upload
//       } catch (e) {
//         print("Error submitting course content: $e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to upload course content. Please try again later.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Course Content'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _lessonTitleController,
//                 decoration: InputDecoration(labelText: 'Lesson Title'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a lesson title';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               _media != null
//                   ? Image.file(_media!, width: 200, height: 200)
//                   : Container(),
//               SizedBox(height: 16),
//               Row(
//                 children: [
//                   ElevatedButton(
//                     onPressed: _pickMedia,
//                     child: Text('Pick Image'),
//                   ),
//                   SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: _pickVideo,
//                     child: Text('Pick Video'),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => _submitCourseContent(context),
//                 child: Text('Submit Content'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// // class UploadCourseContent extends StatefulWidget {
// //   final String courseId; // Course ID to update
// //   const UploadCourseContent({Key? key, required this.courseId})
// //       : super(key: key);

// //   @override
// //   _UploadCourseContentState createState() => _UploadCourseContentState();
// // }

// // class _UploadCourseContentState extends State<UploadCourseContent> {
// //   final ImagePicker _picker = ImagePicker();
// //   File? _media;
// //   final TextEditingController _messageController = TextEditingController();
// //   final _formKey = GlobalKey<FormState>();

// //   /// Pick an image or video
// //   Future<void> _pickMedia() async {
// //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

// //     if (pickedFile != null) {
// //       setState(() {
// //         _media = File(pickedFile.path);
// //       });
// //     }
// //   }

// //   /// Pick a video (without generating a thumbnail)
// //   Future<void> _pickVideo() async {
// //     final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

// //     if (pickedFile != null) {
// //       setState(() {
// //         _media = File(pickedFile.path);
// //       });
// //     }
// //   }

// //   /// Submit course content (image/video and message)
// //   Future<void> _submitCourseContent(BuildContext context) async {
// //     if (_formKey.currentState!.validate()) {
// //       final message = _messageController.text;
// //       String? mediaPath;

// //       if (_media != null) {
// //         mediaPath = _media!.path; // Get media path
// //       }

// //       try {
// //         // Fetch current course content
// //         DocumentSnapshot courseDoc = await FirebaseFirestore.instance
// //             .collection('courses')
// //             .doc(widget.courseId)
// //             .get();
// //         List<dynamic> content = List.from(courseDoc['content'] ?? []);

// //         // Add new media path to course content
// //         if (mediaPath != null) {
// //           content.add(mediaPath);
// //         }

// //         // Update course content in Firestore
// //         await FirebaseFirestore.instance
// //             .collection('courses')
// //             .doc(widget.courseId)
// //             .update({
// //           'content': content, // Store media path in content field
// //         });

// //         // Optionally, store the message as well
// //         await FirebaseFirestore.instance
// //             .collection('courses')
// //             .doc(widget.courseId)
// //             .update({
// //           'message': message,
// //         });

// //         Navigator.pop(context); // Go back after successful upload
// //       } catch (e) {
// //         print("Error submitting course content: $e");
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(
// //                 'Failed to upload course content. Please try again later.'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     print("COURSEID IS ${widget.courseId}");
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Upload Course Content'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               TextFormField(
// //                 controller: _messageController,
// //                 decoration:
// //                     InputDecoration(labelText: 'Course Content Message'),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter a message';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 16),
// //               _media != null
// //                   ? Image.file(_media!, width: 200, height: 200)
// //                   : Container(),
// //               SizedBox(height: 16),
// //               Row(
// //                 children: [
// //                   ElevatedButton(
// //                     onPressed: _pickMedia,
// //                     child: Text('Pick Media (Image)'),
// //                   ),
// //                   SizedBox(width: 10),
// //                   ElevatedButton(
// //                     onPressed: _pickVideo,
// //                     child: Text('Pick Video'),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: () => _submitCourseContent(context),
// //                 child: Text('Submit Content'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../admin/presentations/database/db.dart';

class UploadCourseContent extends StatefulWidget {
  final String courseId; // Course ID to update
  const UploadCourseContent({Key? key, required this.courseId}) : super(key: key);

  @override
  _UploadCourseContentState createState() => _UploadCourseContentState();
}

class _UploadCourseContentState extends State<UploadCourseContent> {
  final ImagePicker _picker = ImagePicker();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  File? _media;
  String? _mediaType; // Track type (image, video, pdf)
  final TextEditingController _lessonTitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _media = File(pickedFile.path);
        _mediaType = 'image';
      });
    }
  }

  /// Pick a video
  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _media = File(pickedFile.path);
        _mediaType = 'video';
      });
    }
  }

  /// Pick a PDF file
  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _media = File(result.files.single.path!);
        _mediaType = 'pdf';
      });
    }
  }

  /// Submit course content (store in SQLite first, then update Firestore)
  Future<void> _submitCourseContent(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final lessonTitle = _lessonTitleController.text.trim();
      if (_media == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image, video, or PDF'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final mediaPath = _media!.path;

      try {
        // 1️⃣ Store media in SQLite and get media ID
        int mediaId = await _dbHelper.insertMedia('coursedetails', mediaPath, _mediaType!);

        // 2️⃣ Fetch existing content from Firestore
        DocumentSnapshot courseDoc = await FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseId)
            .get();

        List<dynamic> content = List.from(courseDoc['content'] ?? []);

        // 3️⃣ Append new object { mediaId, lessonTitle, mediaType } to Firestore
        content.add({
          "mediaId": mediaId,
          "lessonTitle": lessonTitle,
          "mediaType": _mediaType,
        });

        // 4️⃣ Update Firestore with the new content list
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseId)
            .update({'content': content});

        Navigator.pop(context); // Go back after successful upload
      } catch (e) {
        print("Error submitting course content: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to upload course content. Please try again later.'),
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
        title: const Text('Upload Course Content'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _lessonTitleController,
                decoration: const InputDecoration(labelText: 'Lesson Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a lesson title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Preview selected file
              if (_media != null) 
                if (_mediaType == 'image') 
                  Image.file(_media!, width: 200, height: 200)
                else if (_mediaType == 'pdf') 
                  const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red)
                else 
                  const Icon(Icons.video_library, size: 100, color: Colors.blue),

              const SizedBox(height: 16),

              // Buttons for picking media
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickVideo,
                    child: const Text('Pick Video'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickPDF,
                    child: const Text('Pick PDF'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _submitCourseContent(context),
                child: const Text('Submit Content'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
