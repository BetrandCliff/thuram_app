import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/core/constants/values.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      required this.onTap,
        this.isColorBlack=false,
      this.height=60,
      this.width = double.infinity});
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final bool isColorBlack;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
          color: isColorBlack?Color(0xff000000):AppColors.primaryColor,
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
      ),
    );
  }
}
