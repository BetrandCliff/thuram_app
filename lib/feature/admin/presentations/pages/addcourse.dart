import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/custom-button.dart';
import 'package:thuram_app/util/custom-input-form.dart';
import 'package:thuram_app/util/widthandheight.dart';
// import 'package:file_picker/file_picker.dart';  // Import the file_picker package

import '../../../../core/constants/asset-paths.dart';
import '../../../../core/constants/colors.dart';
import '../model/course.dart';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _image; // Declare a variable for the image
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path); // This should now store the file correctly
    });
  } else {
    // Handle case when user cancels image picking
    print("No image selected");
  }
}


  // Function to handle the form submission and save data to Firestore
  Future<void> _submitForm() async {
    String courseName = _courseController.text;
    String courseCode = _codeController.text;
    String description = _descriptionController.text;

    String? imageUrl;

    // If an image is selected, upload it to Firebase Storage
    if (_image != null) {
      try {
        // Upload image to Firebase Storage
        Reference storageRef = FirebaseStorage.instance.ref().child('courses/${DateTime.now().millisecondsSinceEpoch}');
        UploadTask uploadTask = storageRef.putFile(_image!);

        // Get the download URL
        await uploadTask.whenComplete(() async {
          imageUrl = await storageRef.getDownloadURL();
        });
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    // Create a Course object
    Map<String, dynamic> course = {
      'courseCode': courseCode,
      'courseName': courseName,
      'description': description,
      'imageUrl': imageUrl, /// Store the URL of the image (if available)
      "content": []
    };

    // Get the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Add course to Firestore in the "courses" collection
    try {
      await firestore.collection('courses').add(course);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Course added successfully!")));
      // Optionally, clear the fields after submission
      _courseController.clear();
      _codeController.clear();
      _descriptionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add course: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Add Course')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 90, // Diameter of the CircleAvatar (2 * radius)
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: _image != null
                          ? FileImage(_image!) // If an image is picked, display it
                          : AssetImage('assets/placeholder.png') as ImageProvider, // Placeholder image
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -2,
                    child: GestureDetector(
                      onTap: _pickImage, // Open image picker on tap
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              
              // Keeping your custom form fields intact
              CustomInputForm(
                controller: _codeController,
                preIcon: Icons.person,
                hint: "CSEN403",
                label: "Course Code",
                isLabel: true,
              ),
              const SizedBox(height: 20),
              CustomInputForm(
                controller: _courseController,
                preIcon: Icons.person,
                label: "Course Name",
                hint: "Programming Concepts",
                isLabel: true,
              ),
              const SizedBox(height: 20),
              CustomInputForm(
                controller: _descriptionController,
                preIcon: Icons.person,
                label: "Description",
                hint: "",
                isLabel: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Submit",
                onTap: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// class AddCourse extends StatefulWidget {
//   @override
//   _AddCourseState createState() => _AddCourseState();
// }

// class _AddCourseState extends State<AddCourse> {

//   final TextEditingController _courseController = TextEditingController();
//   final TextEditingController _codeController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   // final TextEditingController _confirmPasswordController = TextEditingController();

//   String? role;
//   String fullName = '';
//   String email = '';
//   String officeLocation = '';
//   String speciality = '';
//   File? _image; // Declare a variable for the image
//   // final List<String> roles = ['Professor', 'Teaching Assistant'];

//   // Function to pick an image
//   Future<void> _pickImage() async {
//     // FilePickerResult? result = await FilePicker.platform.pickFiles(
//     //   type: FileType.image,
//     // );

//     // if (result != null) {
//     //   setState(() {
//     //     _image = File(result.files.single.path!);  // Save the picked image
//     //   });
//     // } else {
//     //   // User canceled the picker
//     // }
//   }

//   // File? _image; // Declare a variable for the image

//   // // Function to pick an image (you can implement this with file_picker)
//   // Future<void> _pickImage() async {
//   //   // Implement image picker functionality here
//   // }

//   // Function to handle the form submission and save data to Firestore
//   Future<void> _submitForm() async {
//     String courseName = _courseController.text;
//     String courseCode = _codeController.text;
//     String description = _descriptionController.text;

//     // Create a Course object
//     Course course = Course(
//       courseCode: courseCode,
//       courseName: courseName,
//       description: description,
//       imageUrl: null, // You can add logic to upload the image to Firebase Storage and get the URL
//     );

//     // Get the Firestore instance
//     FirebaseFirestore firestore = FirebaseFirestore.instance;

//     // Add course to Firestore in the "courses" collection
//     try {
//       await firestore.collection('courses').add(course.toMap());
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Course added successfully!")));
//       // Optionally, clear the fields after submission
//       _courseController.clear();
//       _codeController.clear();
//       _descriptionController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add course: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text('Add Course')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     width: 90, // Diameter of the CircleAvatar (2 * radius)
//                     height: 90,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: AppColors.secondaryColor, // Border color
//                         width: 1, // Border width
//                       ),
//                     ),
//                     child: CircleAvatar(
//                       radius: 45,
//                       backgroundImage: _image != null
//                           ? FileImage(
//                               _image!) // If an image is picked, display it
//                           : AssetImage(AppImages.equation) as ImageProvider,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: -2,
//                     child: GestureDetector(
//                       onTap: _pickImage, // Open image picker on tap
//                       child: Icon(
//                         Icons.camera_alt_outlined,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: height(context) / 20,
//               ),
//                CustomInputForm(
//                 controller:_codeController ,
//                 preIcon: Icons.person,
//                 hint: "CSEN403",
//                 label: "course code",
//                 isLabel: true,
//               ),
//               const SizedBox(height: 20),
//                CustomInputForm(
//                 controller: _courseController,
//                 preIcon: Icons.person,
//                 label: "Course Name",
//                 hint: "programming concepts",
//                 isLabel: true,
//               ),
//               const SizedBox(height: 20),
//                CustomInputForm(
//                 controller: _descriptionController,
//                 preIcon: Icons.person,
//                 label: "Description",
//                 hint: "",
//                 isLabel: true,
//               ),
//               const SizedBox(height: 20),
//               CustomButton(
//                 text: "Submit",
//                 onTap: _submitForm,
//                 // width: 250,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
