import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thuram_app/core/constants/localizations.dart';
import 'package:thuram_app/core/constants/theme.dart';
import 'package:thuram_app/splashscreen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          supportedLocales: supportedLocales,
          localizationsDelegates: const [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
          debugShowCheckedModeBanner: false,
          title: '',
          theme: AppTheme.lightTheme,
          home: child,
        );
      },
      child:  SplashScreen(),
    );
  }
}
