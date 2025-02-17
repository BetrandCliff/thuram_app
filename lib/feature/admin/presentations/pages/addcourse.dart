import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thuram_app/util/custom-button.dart';
import 'package:thuram_app/util/custom-input-form.dart';
import 'package:thuram_app/util/widthandheight.dart';
// import 'package:file_picker/file_picker.dart';  // Import the file_picker package

import '../../../../core/constants/asset-paths.dart';
import '../../../../core/constants/colors.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  String? role;
  String fullName = '';
  String email = '';
  String officeLocation = '';
  String speciality = '';
  File? _image; // Declare a variable for the image
  // final List<String> roles = ['Professor', 'Teaching Assistant'];

  // Function to pick an image
  Future<void> _pickImage() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.image,
    // );

    // if (result != null) {
    //   setState(() {
    //     _image = File(result.files.single.path!);  // Save the picked image
    //   });
    // } else {
    //   // User canceled the picker
    // }
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
                        color: AppColors.secondaryColor, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: _image != null
                          ? FileImage(
                              _image!) // If an image is picked, display it
                          : AssetImage(AppImages.equation) as ImageProvider,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -2,
                    child: GestureDetector(
                      onTap: _pickImage, // Open image picker on tap
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height(context) / 20,
              ),
              const CustomInputForm(
                preIcon: Icons.person,
                hint: "CSEN403",
                label: "course code",
                isLabel: true,
              ),
              const SizedBox(height: 20),
              const CustomInputForm(
                preIcon: Icons.person,
                label: "Course Name",
                hint: "programming concepts",
                isLabel: true,
              ),
              const SizedBox(height: 20),
              const CustomInputForm(
                preIcon: Icons.person,
                label: "Description",
                hint: "",
                isLabel: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Submit",
                onTap: () {},
                width: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
