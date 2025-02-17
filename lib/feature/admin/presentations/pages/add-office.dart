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

class AddOfficer extends StatefulWidget {
  @override
  _AddOfficerState createState() => _AddOfficerState();
}

class _AddOfficerState extends State<AddOfficer> {
  String? role;
  String fullName = '';
  String email = '';
  String officeLocation = '';
  String speciality = '';
  File? _image;
  // final picker = ImagePicker();

  final List<String> roles = ['Office', 'Outlet'];

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

  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _officeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Office/ Outlet')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
             
              SizedBox(
                width: width(context) / 2,
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: role,
                  items: roles.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: Theme.of(context).textTheme.displayMedium),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      role = newValue;
                    });
                  },
                ),
              ),
               CustomInputForm(preIcon: Icons.person, label: "Full Name",hint: "",isLabel: true,controller: _usernameController,),
              const SizedBox(height: 20),
               CustomInputForm(preIcon: Icons.person, hint: "",label: "Latitude",isLabel: true,controller: _latitudeController,),
              const SizedBox(height: 20),
               CustomInputForm(preIcon: Icons.person, label: "Longetude", hint: "",isLabel: true,controller: _longitudeController,),
              const SizedBox(height: 20),
               CustomInputForm(preIcon: Icons.person, label: "Official Location",hint: "",isLabel: true,controller: _officeController,),
              const SizedBox(height: 20),
              CustomButton(text: "Submit", onTap: () {},width: 250,),
            ],
          ),
        ),
      ),
    );
  }
}
