import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/util/custom-button.dart';

import '../../../../../util/country-code.dart';
import '../../../../../util/custom-input-form.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    child: Icon(Icons.camera_alt_outlined,color: AppColors.primaryColor,))
                ],
              ),
              SizedBox(height: 20,),

              CustomInputForm(hint: 'Hakeem Smith', preIcon: Icons.person,label: "Full Name", isLabel: true,),
               SizedBox(height: 20,),
                 SizedBox(
                  height: 50,
                  child: PhoneNumberScreen()),
                 
                            CustomInputForm(hint: 'Watch the movie 🎬', preIcon: Icons.person,label: "Bio", isLabel: true,),
               SizedBox(height: 20,),
              CustomInputForm(hint: '******', preIcon: Icons.person,label: "Password", isLabel: true,sufIcon: Icons.visibility_off,),

                 SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(text: "Edit Profile", onTap: (){},width: 200,))

            ],
          ),
        ),
      ),
    );
  }
}