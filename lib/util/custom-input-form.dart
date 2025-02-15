import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/values.dart';

class CustomInputForm extends StatelessWidget {
  const CustomInputForm({super.key, required this.preIcon,this.sufIcon, required this.hint });
  final IconData preIcon;
  final IconData? sufIcon;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: double.infinity,
        child: TextField(
          decoration: InputDecoration(
            hintText:hint ,
            hintStyle: Theme.of(context).textTheme.displaySmall,
              prefixIcon: Icon(preIcon),
              suffixIcon: Icon(sufIcon),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(inputBorderRadius))),
        ));
  }
}
