import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thuram_app/util/custom-button.dart';
import 'package:thuram_app/util/custom-input-form.dart';
import 'package:thuram_app/util/widthandheight.dart';
// import 'package:file_picker/file_picker.dart';  // Import the file_picker package
// import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/constants/asset-paths.dart';
import '../../../../core/constants/colors.dart';
import 'selected-add-staff-course.dart';

class AddStaffForm extends StatefulWidget {
  @override
  _AddStaffFormState createState() => _AddStaffFormState();
}

class _AddStaffFormState extends State<AddStaffForm> {
  String? role;
  String fullName = '';
  String email = '';
  String officeLocation = '';
  String speciality = '';
  File? _image;
  // final picker = ImagePicker();

  final List<String> roles = ['Professor', 'Teaching Assistant'];

  Future<void> _showImagePickerOptions(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                // final pickedFile = await picker.pickImage(source: ImageSource.camera);
                // setState(() {
                //   if (pickedFile != null) {
                //     _image = File(pickedFile.path);
                //   }
                // });
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                // setState(() {
                //   if (pickedFile != null) {
                //     _image = File(pickedFile.path);
                //   }
                // });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Add Staff')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : AssetImage(AppImages.profile) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: -2,
                    child: GestureDetector(
                      onTap: () => _showImagePickerOptions(context),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: width(context) / 2,
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: role,
                  items: roles.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: Theme.of(context).textTheme.displayMedium),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      role = newValue;
                    });
                  },
                ),
              ),
              const CustomInputForm(preIcon: Icons.person, hint: "Full Name"),
              const SizedBox(height: 20),
              const CustomInputForm(preIcon: Icons.person, hint: "Email"),
              const SizedBox(height: 20),
              const CustomInputForm(
                  preIcon: Icons.person, hint: "Office Location"),
              const SizedBox(height: 20),
              const CustomInputForm(preIcon: Icons.person, hint: "Speciality"),
              const SizedBox(height: 20),
              CustomButton(
                  text: "Submit",
                  onTap: () {
                    _showSelectionDialog(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

    void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectionDialog();
      },
    );
  }
}
