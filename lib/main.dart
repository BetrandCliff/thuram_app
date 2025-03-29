import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thuram_app/core/constants/localizations.dart';
import 'package:thuram_app/core/constants/theme.dart';
import 'package:thuram_app/core/constants/values.dart';
import 'package:thuram_app/feature/chat/push_notification.dart';
import 'package:thuram_app/splashscreen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
 // Ensure this file exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter is initialized first


  // Initialize Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBHPFJ7eS8X5RDcJS8xRAdTjnGzgKNTHdk",
        authDomain: "thuram-bcc5e.firebaseapp.com",
        projectId: "thuram-bcc5e",
        storageBucket: "thuram-bcc5e.firebasestorage.app",
        messagingSenderId: "1003798788019",
        appId: "1:1003798788019:web:9409847fd28d5191723dc6",
      ),
    );
  } else {


    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Use platform-specific options
    );
  }

  await dotenv.load();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  PushNotificationService pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize(); // ✅ Initialize notifications
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
          title: 'Thuram App',
          theme: AppTheme.lightTheme,
          home: child,
        );
      },
      child: SplashScreen(),
    );
  }
}

