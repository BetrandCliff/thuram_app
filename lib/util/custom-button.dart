import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/core/constants/values.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
        color: AppColors.primaryColor,
      ),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
