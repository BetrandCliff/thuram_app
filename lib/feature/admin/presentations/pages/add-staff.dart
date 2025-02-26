// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:image_picker/image_picker.dart';
// import 'package:thuram_app/util/custom-button.dart';
// import 'package:thuram_app/util/custom-input-form.dart';
// import 'package:thuram_app/util/widthandheight.dart';
// import '../../../../core/constants/asset-paths.dart';
// import '../../../../core/constants/colors.dart';
// import 'selected-add-staff-course.dart';

// class AddStaffForm extends StatefulWidget {
//   @override
//   _AddStaffFormState createState() => _AddStaffFormState();
// }

// class _AddStaffFormState extends State<AddStaffForm> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _officeController = TextEditingController();
//   final TextEditingController _specialtyController = TextEditingController();

//   String? role;
//   File? _image;
//   // final ImagePicker _picker = ImagePicker();

//   // Available roles and courses
//   final List<String> roles = ['Staff', 'Senior Staff'];
//   List<String> items = [
//     'Engineering Maths',
//     'Computer Fundamentals',
//     'Database',
//     'Data Structures',
//     'Entrepreneurship'
//   ];

//   List<String> selectedItems = []; // To store selected courses

//   // Firebase Firestore reference
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Method for image picking
//   Future<void> _showImagePickerOptions(BuildContext context) async {
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
//                 // final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//                 // if (pickedFile != null) {
//                 //   setState(() {
//                 //     _image = File(pickedFile.path);
//                 //   });
//                 // }
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library),
//               title: Text('Gallery'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 // final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//                 // if (pickedFile != null) {
//                 //   setState(() {
//                 //     _image = File(pickedFile.path);
//                 //   });
//                 // }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Method to handle staff submission
//   Future<void> _submitStaff() async {
//     try {
//       // Get staff details from controllers
//       String username = _usernameController.text;
//       String email = _emailController.text;
//       String office = _officeController.text;
//       String specialty = _specialtyController.text;

//       // Store the image in Firebase Storage (Optional step)
//       // Upload image to Firebase Storage and get the URL (You may want to configure Firebase storage before)
//       String imageUrl = ""; // Placeholder if you want to store image URL

//       // Prepare staff data
//       Map<String, dynamic> staffData = {
//         'username': username,
//         'email': email,
//         'office': office,
//         'specialty': specialty,
//         'role': role,
//         'courses': selectedItems, // Assign selected courses
//         'imageUrl': imageUrl,
//       };

//       // Add staff data to Firestore
//       await _firestore.collection('staff').add(staffData);
//       // Optionally show success message or navigate to another page
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Staff added successfully')));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add staff')));
//     }
//   }

//   // Method to handle course selection
//   void _onItemSelected(String value) {
//     setState(() {
//       if (selectedItems.contains(value)) {
//         selectedItems.remove(value);
//       } else {
//         selectedItems.add(value);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 45,
//                     backgroundImage: _image != null
//                         ? FileImage(_image!)
//                         : AssetImage(AppImages.profile) as ImageProvider,
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: -2,
//                     child: GestureDetector(
//                       onTap: () => _showImagePickerOptions(context),
//                       child: Icon(
//                         Icons.camera_alt_outlined,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               CustomInputForm(
//                 preIcon: Icons.person,
//                 hint: "Full Name",
//                 controller: _usernameController,
//               ),
//               const SizedBox(height: 20),
//               CustomInputForm(
//                 preIcon: Icons.email,
//                 hint: "Email",
//                 controller: _emailController,
//               ),
//               const SizedBox(height: 20),
//               CustomInputForm(
//                 preIcon: Icons.location_on,
//                 hint: "Office Location",
//                 controller: _officeController,
//               ),
//               const SizedBox(height: 20),
//               CustomInputForm(
//                 preIcon: Icons.work,
//                 hint: "Specialty",
//                 controller: _specialtyController,
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 height: height(context) / 15,
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 1, color: Color(0xff000000)),
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
//                     dropdownColor: Colors.white,
//                     hint: selectedItems.isNotEmpty
//                         ? Container(
//                             height: 30,
//                             width: width(context) / 2,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               scrollDirection: Axis.horizontal,
//                               itemCount: selectedItems.length,
//                               itemBuilder: (context, index) => Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 8),
//                                 constraints: BoxConstraints(minWidth: 50),
//                                 margin: EdgeInsets.only(right: 4),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(width: 1, color: Color(0xffdcdcdc)),
//                                 ),
//                                 child: Center(
//                                   child: Text(selectedItems[index], style: TextStyle(fontSize: 14)),
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Text(
//                             "Courses",
//                             style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14),
//                           ),
//                     items: items.map((String item) {
//                       return DropdownMenuItem<String>(
//                         value: item,
//                         child: StatefulBuilder(
//                           builder: (context, setState) {
//                             return Row(
//                               children: [
//                                 Checkbox(
//                                   value: selectedItems.contains(item),
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       _onItemSelected(item);
//                                     });
//                                   },
//                                 ),
//                                 Text(item),
//                               ],
//                             );
//                           },
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (_) {},
//                     isExpanded: true,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: width(context),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 2.0, right: 25),
//                   child: DropdownButton<String>(
//                     hint: Text("Position", style: Theme.of(context).textTheme.displayMedium),
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
//               CustomButton(
//                 text: "Submit",
//                 onTap: _submitStaff,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:thuram_app/util/custom-button.dart';
import 'package:thuram_app/util/custom-input-form.dart';
import 'package:thuram_app/util/widthandheight.dart';
import '../../../../core/constants/asset-paths.dart';
import '../../../../core/constants/colors.dart';
import 'selected-add-staff-course.dart';

class AddStaffForm extends StatefulWidget {
  @override
  _AddStaffFormState createState() => _AddStaffFormState();
}

class _AddStaffFormState extends State<AddStaffForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _officeController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();

  String? role;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Available roles
  final List<String> roles = ['Staff', 'Senior Staff'];

  List<String> selectedItems = []; // To store selected courses

  // Firebase Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch courses from Firestore
  Future<List<String>> _fetchCourses() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('courses').get();
      List<String> courseList =
          snapshot.docs.map((doc) => doc['courseName'] as String).toList();
      print("PRINTING LIST OF COURSES");
      print(courseList);
      return courseList;
    } catch (e) {
      print("Error fetching courses: $e");
      return [];
    }
  }

  // Method for image picking
  Future<void> _showImagePickerOptions(BuildContext context) async {
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
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method to handle staff submission
  Future<void> _submitStaff() async {
    try {
      // Get staff details from controllers
      String username = _usernameController.text;
      String email = _emailController.text;
      String office = _officeController.text;
      String specialty = _specialtyController.text;

      // Store the image in Firebase Storage (Optional step)
      // Upload image to Firebase Storage and get the URL (You may want to configure Firebase storage before)
      String imageUrl = ""; // Placeholder if you want to store image URL

      // Prepare staff data
      Map<String, dynamic> staffData = {
        'username': username,
        'email': email,
        'office': office,
        'specialty': specialty,
        'role': role,
        'courses': selectedItems, // Assign selected courses
        'imageUrl': imageUrl,
      };

      // Add staff data to Firestore
      await _firestore.collection('staff').add(staffData);
      // Optionally show success message or navigate to another page
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Staff added successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add staff')));
    }
  }

  // Method to handle course selection
  void _onItemSelected(String value) {
    setState(() {
      if (selectedItems.contains(value)) {
        selectedItems.remove(value);
      } else {
        selectedItems.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const SizedBox(height: 20),
              CustomInputForm(
                preIcon: Icons.person,
                hint: "Full Name",
                controller: _usernameController,
              ),
              const SizedBox(height: 20),
              CustomInputForm(
                preIcon: Icons.email,
                hint: "Email",
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              CustomInputForm(
                preIcon: Icons.location_on,
                hint: "Office Location",
                controller: _officeController,
              ),
              const SizedBox(height: 20),
              CustomInputForm(
                preIcon: Icons.work,
                hint: "Specialty",
                controller: _specialtyController,
              ),
              const SizedBox(height: 20),
              // Fetch courses and display in a dropdown
              FutureBuilder<List<String>>(
                future: _fetchCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error fetching courses');
                  }
                  List<String> courses = snapshot.data ?? [];
                  return Container(
                    height: height(context) / 15,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xff000000)),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 14),
                        dropdownColor: Colors.white,
                        hint: selectedItems.isNotEmpty
                            ? Container(
                                height: 30,
                                width: width(context) / 2,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: selectedItems.length,
                                  itemBuilder: (context, index) => Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    constraints: BoxConstraints(minWidth: 50),
                                    margin: EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 1, color: Color(0xffdcdcdc)),
                                    ),
                                    child: Center(
                                      child: Text(selectedItems[index],
                                          style: TextStyle(fontSize: 14)),
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                "Courses",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14),
                              ),
                        items: courses.map((String course) {
                          return DropdownMenuItem<String>(
                            value: course,
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                return Row(
                                  children: [
                                    Checkbox(
                                      value: selectedItems.contains(course),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _onItemSelected(course);
                                        });
                                      },
                                    ),
                                    Text(course),
                                  ],
                                );
                              },
                            ),
                          );
                        }).toList(),
                        onChanged: (_) {},
                        isExpanded: true,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 25),
                  child: DropdownButton<String>(
                    hint: Text("Position",
                        style: Theme.of(context).textTheme.displayMedium),
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
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Submit",
                onTap: _submitStaff,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
