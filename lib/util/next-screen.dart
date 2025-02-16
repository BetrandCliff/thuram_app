import 'package:flutter/material.dart';

nextScreen(BuildContext context, Widget page) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
