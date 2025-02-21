import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart'; // For picking images
import 'package:thuram_app/util/next-screen.dart';
import 'package:thuram_app/util/widthandheight.dart';
import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../pages/profile.dart'; // Your ProfilePage (if needed)

class CreateConfessionScreen extends StatefulWidget {
  const CreateConfessionScreen({super.key});

  @override
  _CreateConfessionScreenState createState() => _CreateConfessionScreenState();
}

class _CreateConfessionScreenState extends State<CreateConfessionScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _messageController = TextEditingController();
  File? _image;
  // final ImagePicker _picker = ImagePicker();
  
  // Upload image to Firebase Storage and return the URL
  Future<String?> _uploadImage() async {
    // if (_image == null) return null;

    try {
      final storageRef = FirebaseStorage.instance.ref().child('confession_images/${DateTime.now().toIso8601String()}');
      final uploadTask = storageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Pick an image using Image Picker
  Future<void> _pickImage() async {
    // final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() {
    //     _image = File(pickedFile.path);
    //   });
    // }
  }

  // Submit the confession
  Future<void> _submitConfession() async {
    if (_formKey.currentState!.validate()) {
      final message = _messageController.text;

      // Upload image and get the URL (if any)
      String? imageUrl = await _uploadImage();

      try {
        await FirebaseFirestore.instance.collection('confessions').add({
          'message': message,
          'createdAt': FieldValue.serverTimestamp(),
          'userName': 'Anonymous', // You can replace this with the actual username
          'profilePic': AppImages.profile, // Optional: User profile pic URL
          'image': imageUrl, // Optional: URL of the uploaded image
        });
        // Go back after submitting the confession
        Navigator.pop(context);
      } catch (e) {
        print("Error submitting confession: $e");
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit confession. Please try again later.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Confession'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your confession:',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your confession here...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: width(context),
                  height: 150,
                  color: Colors.grey[200],
                  child: _image == null
                      ? Center(child: Text('Tap to select an image'))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitConfession,
                child: Text('Submit Confession'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
