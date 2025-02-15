// Login Form Widget
import 'package:flutter/material.dart';

import '../../../../util/custom-button.dart';
import '../../../../util/custom-input-form.dart';

class SignupForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          CustomInputForm(
            preIcon: Icons.email,
            hint: "Email Address",
          ),
          SizedBox(
            height: 20,
          ),
          CustomInputForm(
            preIcon: Icons.person,
            // sufIcon: Icons.remove_red_eye,
            hint: "UserName",
          ),
          SizedBox(
            height: 20,
          ),
          CustomInputForm(
            preIcon: Icons.lock,
            sufIcon: Icons.visibility_off,
            hint: "Password",
          ),
          SizedBox(
            height: 20,
          ),
          CustomInputForm(
            preIcon: Icons.lock,
            sufIcon: Icons.visibility_off,
            hint: "Confirm Password",
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton(
            text: 'Register',
          )
        ],
      ),
    );
  }
}
