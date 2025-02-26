import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/util/custom-button.dart';

import '../../../../../util/country-code.dart';
import '../../../../../util/custom-input-form.dart';

// class EditProfile extends StatelessWidget {
//    EditProfile({super.key});
// final TextEditingController _bioController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _Controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 45,
//                       backgroundImage: AssetImage(AppImages.profile),
//                     ),
//                     Positioned(
//                         bottom: 0,
//                         right: -2,
//                         child: Icon(
//                           Icons.camera_alt_outlined,
//                           color: AppColors.primaryColor,
//                         ))
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 CustomInputForm(
//                   controller:_usernameController ,
//                   hint: 'Hakeem Smith',
//                   preIcon: Icons.person,
//                   label: "Full Name",
//                   isLabel: true,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CountryCodePicker(
//                       onChanged: print,
//                       // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
//                       initialSelection: 'IT',
//                       //You can set the margin between the flag and the country name to your taste.
//                       margin: const EdgeInsets.symmetric(horizontal: 6),
//                       comparator: (a, b) => b.name!.compareTo(a.name!),
//                       //Get the country information relevant to the initial selection
//                       onInit: (code) => debugPrint(
//                           "on init ${code?.name} ${code?.dialCode} ${code?.name}"),
//                     ),
//                     Expanded(
//                         child: CustomInputForm(
//                           controller: _Controller,
//                       preIcon: Icons.phone,
//                       hint: "673109557",
//                       label: "Phone Number",
//                       isLabel: true,
//                     ))
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 CustomInputForm(
//                   controller: _bioController,
//                   hint: 'Watch the movie 🎬',
//                   preIcon: Icons.person,
//                   label: "Bio",
//                   isLabel: true,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 CustomInputForm(
//                   controller: _passwordController,
//                   hint: '******',
//                   preIcon: Icons.person,
//                   label: "Password",
//                   isLabel: true,
//                   sufIcon: Icons.visibility_off,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Align(
//                     alignment: Alignment.centerRight,
//                     child: CustomButton(
//                       height: 50,
//                       text: "Edit Profile",
//                       onTap: () {},
//                       width: 150,
//                     ))
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io'; // Import to use File for image
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _profilePic = 'https://example.com/default_profile_pic.jpg'; // Default profile picture
  String _userId = '';
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  File? _imageFile; // Variable to store picked image file

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch the current user's data from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_userId).get();

      if (userDoc.exists) {
        setState(() {
          _usernameController.text = userDoc['username'] ?? '';
          _bioController.text = userDoc['bio'] ?? '';
          _phoneController.text = userDoc['phone'] ?? '';
          _profilePic = userDoc['profilePic'] ?? 'https://example.com/default_profile_pic.jpg'; // Default if no profile pic
        });
      }
    }
  }

  // Update the user's data in Firestore
  Future<void> _updateUserProfile() async {
    String username = _usernameController.text.trim();
    String bio = _bioController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || bio.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all the fields.')));
      return;
    }

    try {
      // Update the user document in Firestore
      await FirebaseFirestore.instance.collection('users').doc(_userId).update({
        'username': username,
        'bio': bio,
        'phone': phone,
        // If the password is provided, update the Firebase Auth password
        if (password.isNotEmpty) 'password': password, // Do not save plain password in Firestore, use FirebaseAuth for password updates
        'profilePic': _profilePic, // Save the profile picture URL
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile. Please try again.')));
    }
  }

  // Pick an image from the gallery or camera
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Use pickImage instead of getImage

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Update the image file with the picked image
        _profilePic = pickedFile.path; // Optionally store the file path for Firestore update
      });
    }
  }

  // Show bottom sheet to pick image
  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                _pickImage(); // Open camera for capturing image
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                _pickImage(); // Open gallery to select image
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: _imageFile != null // Check if imageFile is not null
                          ? FileImage(_imageFile!) // Display the picked image
                          : NetworkImage(_profilePic) as ImageProvider, // Default image or fetched profile picture
                    ),
                    Positioned(
                      bottom: 0,
                      right: -2,
                      child: GestureDetector(
                        onTap: _showImagePickerBottomSheet, // Show bottom sheet on tap
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.blue, // Change this to your desired color
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomInputForm(
                  controller: _usernameController,
                  hint: 'Full Name',
                  preIcon: Icons.person,
                  label: "Full Name",
                  isLabel: true,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CountryCodePicker(
                      onChanged: print,
                      initialSelection: 'IT',
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      comparator: (a, b) => b.name!.compareTo(a.name!),
                    ),
                    Expanded(
                      child: CustomInputForm(
                        controller: _phoneController,
                        preIcon: Icons.phone,
                        hint: "673109557",
                        label: "Phone Number",
                        isLabel: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomInputForm(
                  controller: _bioController,
                  hint: 'Tell us about yourself...',
                  preIcon: Icons.info_outline,
                  label: "Bio",
                  isLabel: true,
                ),
                SizedBox(height: 20),
                CustomInputForm(
                  controller: _passwordController,
                  hint: '******',
                  preIcon: Icons.lock,
                  label: "Password",
                  isLabel: true,
                  sufIcon: Icons.visibility_off,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    height: 50,
                    text: "Save Changes",
                    onTap: _updateUserProfile,
                    width: 150,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

