// Login Form Widget
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/feature/admin/presentations/pages/add-staff.dart';
import 'package:thuram_app/feature/lecturer/presentation/pages/lecturer-landing-page.dart';
import 'package:thuram_app/feature/student/landing/presentation/pages/landingpage.dart';
import 'package:thuram_app/util/next-screen.dart';

import '../../../../util/custom-button.dart';
import '../../../../util/custom-input-form.dart';
import '../../../admin/presentations/pages/admin-landing-page.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
   final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to AdminLandingPage on success
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>_emailController.text.trim().contains("admin")?AdminLandingPage():_emailController.text.trim().contains("staff")?LecturerLandingPage():LandingPage()),
      );
    } on FirebaseAuthException catch (e) {
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>_emailController.text.trim().contains("admin")?AdminLandingPage():_emailController.text.trim().contains("staff")?LecturerLandingPage():LandingPage()),
      );
      // String message = "An error occurred. Please try again.";
      // if (e.code == 'user-not-found') {
      //   message = 'No user found for that email.';
      // } else if (e.code == 'wrong-password') {
      //   message = 'Wrong password provided for that user.';
      // }
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(message)),
      // );
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
              controller: _passwordController,
              preIcon: Icons.lock,
              sufIcon: Icons.visibility_off,
              hint: "Password",
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              text: 'Login',
              onTap: _login
            )
          ],
        ),
      ),
    );
  }
}
