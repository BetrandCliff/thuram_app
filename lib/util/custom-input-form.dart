import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/values.dart';

class CustomInputForm extends StatelessWidget {
  const CustomInputForm(
      {super.key,
      required this.preIcon,
      this.sufIcon,
      required this.hint,
      this.label,
      this.width=double.infinity,
      this.isLabel = false});
  final IconData preIcon;
  final IconData? sufIcon;
  final String hint;
  final String? label;
  final bool isLabel;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: width,
        child: TextField(
          decoration: InputDecoration(
              label: isLabel
                  ? Text(
                      "$label",
                      style: Theme.of(context).textTheme.displayMedium,
                    )
                  : null,
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.displaySmall,
              prefixIcon: Icon(preIcon),
              suffixIcon: Icon(sufIcon),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(inputBorderRadius))),
        ));
  }
}
