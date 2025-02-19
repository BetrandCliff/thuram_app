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

    final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _officeController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();


  String? role;
  String fullName = '';
  String email = '';
  String officeLocation = '';
  String speciality = '';
  File? _image;
  // final picker = ImagePicker();

  final List<String> roles = ['Staff', 'Senior Staff'];

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
            // crossAxisAlignment: CrossAxisAlignment.start,
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
             
               CustomInputForm(preIcon: Icons.person, hint: "Full Name",controller: _usernameController,),
              const SizedBox(height: 20),
               CustomInputForm(preIcon: Icons.email, hint: "Email",controller: _emailController,),
              const SizedBox(height: 20),
              //  CustomInputForm(
              //     preIcon: Icons.person, hint: "Office Location",controller: _officeController,),
              // const SizedBox(height: 20),
              //  CustomInputForm(preIcon: Icons.person, hint: "Speciality",controller:_specialtyController ,),
              //  const SizedBox(height: 20),
               Container(
                      height: height(context) / 15,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xff000000)),
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
                                  height: 30, // Adjust height as needed
                                  width:
                                      width(context) / 2, // Set width as needed
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: selectedItems.length,
                                    itemBuilder: (context, index) => Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      constraints: BoxConstraints(
                                          minWidth: 50), // Minimum width
                                      margin: EdgeInsets.only(
                                          right: 4), // Spacing between items
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
                          items: items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return Row(
                                    children: [
                                      Checkbox(
                                        value: selectedItems.contains(item),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _onItemSelected(
                                                item); // Updates checkbox state
                                          });
                                          this.setState(
                                              () {}); // Updates the dropdown UI
                                        },
                                      ),
                                      Text(item),
                                    ],
                                  );
                                },
                              ),
                            );
                          }).toList(),
                          onChanged:
                              (_) {}, // Keep this empty, selection is handled inside the checkbox
                          isExpanded: true,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
               SizedBox(
                width: width(context) ,
                child: Padding(
                  padding: const EdgeInsets.only(left:2.0,right: 25),
                  child: DropdownButton<String>(
                    hint: Text("Position",style: Theme.of(context).textTheme.displayMedium,),
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

  List<String> items = [
    'Engineering Maths',
    'Computer Fundermental',
    'Database',
    'Data Structure',
    'Entrepreneurship'
  ];
    // List to store selected items
  List<String> selectedItems = [];

  // Function to handle item selection
  void _onItemSelected(String value) {
    setState(() {
      if (selectedItems.contains(value)) {
        selectedItems.remove(value); // Deselect if already selected
      } else {
        selectedItems.add(value); // Add if not selected
      }
    });
  }
}
