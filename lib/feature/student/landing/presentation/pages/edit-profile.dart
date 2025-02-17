import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/util/custom-button.dart';

import '../../../../../util/country-code.dart';
import '../../../../../util/custom-input-form.dart';

class EditProfile extends StatelessWidget {
   EditProfile({super.key});
final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      backgroundImage: AssetImage(AppImages.profile),
                    ),
                    Positioned(
                        bottom: 0,
                        right: -2,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.primaryColor,
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                CustomInputForm(
                  controller:_usernameController ,
                  hint: 'Hakeem Smith',
                  preIcon: Icons.person,
                  label: "Full Name",
                  isLabel: true,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CountryCodePicker(
                      onChanged: print,
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: 'IT',
                      //You can set the margin between the flag and the country name to your taste.
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      comparator: (a, b) => b.name!.compareTo(a.name!),
                      //Get the country information relevant to the initial selection
                      onInit: (code) => debugPrint(
                          "on init ${code?.name} ${code?.dialCode} ${code?.name}"),
                    ),
                    Expanded(
                        child: CustomInputForm(
                          controller: _Controller,
                      preIcon: Icons.phone,
                      hint: "673109557",
                      label: "Phone Number",
                      isLabel: true,
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                CustomInputForm(
                  controller: _bioController,
                  hint: 'Watch the movie 🎬',
                  preIcon: Icons.person,
                  label: "Bio",
                  isLabel: true,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomInputForm(
                  controller: _passwordController,
                  hint: '******',
                  preIcon: Icons.person,
                  label: "Password",
                  isLabel: true,
                  sufIcon: Icons.visibility_off,
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      height: 50,
                      text: "Edit Profile",
                      onTap: () {},
                      width: 150,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
