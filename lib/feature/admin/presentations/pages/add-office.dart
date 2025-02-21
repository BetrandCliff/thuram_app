// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:thuram_app/util/custom-button.dart';
// import 'package:thuram_app/util/custom-input-form.dart';
// import 'package:thuram_app/util/widthandheight.dart';


// class AddOfficer extends StatefulWidget {
//   @override
//   _AddOfficerState createState() => _AddOfficerState();
// }

// class _AddOfficerState extends State<AddOfficer> {
//   String? role;
//   String fullName = '';
//   String email = '';
//   String officeLocation = '';
//   String speciality = '';
//   File? _image;
//   // final picker = ImagePicker();

//   final List<String> roles = ['Office', 'Outlet'];

//   Future<void> _showImagePickerOptions(BuildContext context) {
//     return showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: <Widget>[
//             ListTile(
//               leading: Icon(Icons.camera_alt),
//               title: Text('Camera'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 // final pickedFile = await picker.pickImage(source: ImageSource.camera);
//                 // setState(() {
//                 //   if (pickedFile != null) {
//                 //     _image = File(pickedFile.path);
//                 //   }
//                 // });
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library),
//               title: Text('Gallery'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//                 // setState(() {
//                 //   if (pickedFile != null) {
//                 //     _image = File(pickedFile.path);
//                 //   }
//                 // });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   final TextEditingController _longitudeController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _officeController = TextEditingController();
//   final TextEditingController _latitudeController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text('Add Office/ Outlet')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
             
//               SizedBox(
//                 width: width(context) ,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left:8.0,right: 20),
//                   child: DropdownButton<String>(
//                     hint: Text("Office/Outlet", style: Theme.of(context).textTheme.displayMedium),
//                     dropdownColor: Colors.white,
//                     value: role,
//                     items: roles.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value, style: Theme.of(context).textTheme.displayMedium),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         role = newValue;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//                CustomInputForm(preIcon: Icons.person, label: "Full Name",hint: "",isLabel: true,controller: _usernameController,),
//               const SizedBox(height: 20),
//                CustomInputForm(preIcon: Icons.person, hint: "",label: "Latitude",isLabel: true,controller: _latitudeController,),
//               const SizedBox(height: 20),
//                CustomInputForm(preIcon: Icons.person, label: "Longetude", hint: "",isLabel: true,controller: _longitudeController,),
//               const SizedBox(height: 20),
//                CustomInputForm(preIcon: Icons.person, label: "Official Location",hint: "",isLabel: true,controller: _officeController,),
//               const SizedBox(height: 20),
//               CustomButton(text: "Submit", onTap: () {}),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/custom-button.dart';
import 'package:thuram_app/util/custom-input-form.dart';
import 'package:thuram_app/util/widthandheight.dart';

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

  final List<String> roles = ['Office', 'Outlet'];

  // Controller for the form fields
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _officeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();

  Future<void> _submitForm() async {
    if (_usernameController.text.isEmpty ||
        _latitudeController.text.isEmpty ||
        _longitudeController.text.isEmpty ||
        _officeController.text.isEmpty ||
        role == null) {
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      // Get the current user if needed
      User? user = FirebaseAuth.instance.currentUser;
      
      // Create officer data
      Map<String, dynamic> officerData = {
        'fullName': _usernameController.text,
        'latitude': _latitudeController.text,
        'longitude': _longitudeController.text,
        'officeLocation': _officeController.text,
        'role': role,
        'createdBy': user?.uid, // Track the user who added the officer
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add data to Firestore collection "officers"
      await FirebaseFirestore.instance.collection('officers').add(officerData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Officer added successfully!")),
      );

      // Clear the form fields after submission
      _usernameController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
      _officeController.clear();
      setState(() {
        role = null;
      });

    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: width(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20),
                  child: DropdownButton<String>(
                    hint: Text("Office/Outlet", style: Theme.of(context).textTheme.displayMedium),
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
              ),
              const SizedBox(height: 20),
              CustomInputForm(preIcon: Icons.person, label: "Full Name", hint: "", isLabel: true, controller: _usernameController),
              const SizedBox(height: 20),
              CustomInputForm(preIcon: Icons.person, label: "Latitude", hint: "", isLabel: true, controller: _latitudeController),
              const SizedBox(height: 20),
              CustomInputForm(preIcon: Icons.person, label: "Longitude", hint: "", isLabel: true, controller: _longitudeController),
              const SizedBox(height: 20),
              CustomInputForm(preIcon: Icons.person, label: "Office Location", hint: "", isLabel: true, controller: _officeController),
              const SizedBox(height: 20),
              CustomButton(text: "Submit", onTap: _submitForm),
            ],
          ),
        ),
      ),
    );
  }
}
