// Login Form Widget
import 'package:flutter/material.dart';
import 'package:thuram_app/feature/admin/presentations/pages/add-staff.dart';
import 'package:thuram_app/util/next-screen.dart';

import '../../../../util/custom-button.dart';
import '../../../../util/custom-input-form.dart';
import '../../../admin/presentations/pages/admin-landing-page.dart';

class LoginForm extends StatelessWidget {
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
            preIcon: Icons.lock,
            sufIcon: Icons.visibility_off,
            hint: "Password",
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton(
            text: 'Login',
            onTap: () {
              nextScreen(context, AdminLandingPage());
            },
          )
        ],
      ),
    );
  }
}
