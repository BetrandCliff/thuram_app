// Login Form Widget
import 'package:flutter/material.dart';
import 'package:thuram_app/feature/student/landing/presentation/pages/landingpage.dart';
import 'package:thuram_app/util/next-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../util/custom-button.dart';
import '../../../../util/custom-input-form.dart';
import '../../../admin/presentations/pages/admin-landing-page.dart';
import '../../../lecturer/presentation/pages/lecturer-landing-page.dart';

class SignupForm extends StatefulWidget {

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

   Future<void> _signup() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to LandingPage on success
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>_emailController.text.trim().contains("admin")?AdminLandingPage():_emailController.text.trim().contains("staff")?LecturerLandingPage():LandingPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred. Please try again.";
      if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            CustomInputForm(
              controller: _emailController,
              preIcon: Icons.email,
              hint: "Email Address",
            ),
            SizedBox(
              height: 20,
            ),
            CustomInputForm(
              controller: _usernameController,
              preIcon: Icons.person,
              // sufIcon: Icons.remove_red_eye,
              hint: "UserName",
            ),
            SizedBox(
              height: 20,
            ),
            CustomInputForm(
              controller: _passwordController,
              preIcon: Icons.lock,
              sufIcon: Icons.visibility_off,
              hint: "Password",
            ),
            SizedBox(
              height: 20,
            ),
            CustomInputForm(
              controller: _confirmPasswordController,
              preIcon: Icons.lock,
              sufIcon: Icons.visibility_off,
              hint: "Confirm Password",
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              text: 'Register',
              onTap:_signup
            )
          ],
        ),
      ),
    );
  }
}
