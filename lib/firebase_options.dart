// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBHPFJ7eS8X5RDcJS8xRAdTjnGzgKNTHdk',
    appId: '1:1003798788019:web:9409847fd28d5191723dc6',
    messagingSenderId: '1003798788019',
    projectId: 'thuram-bcc5e',
    authDomain: 'thuram-bcc5e.firebaseapp.com',
    storageBucket: 'thuram-bcc5e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-eQLqf8rAsJG8J0biJNcCYifBhIvjdJA',
    appId: '1:1003798788019:android:118a407e525536df723dc6',
    messagingSenderId: '1003798788019',
    projectId: 'thuram-bcc5e',
    storageBucket: 'thuram-bcc5e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVONGm2Sp7xGn09WCQxP1nB5eYjRbOrFw',
    appId: '1:1003798788019:ios:37394c7e21ab825d723dc6',
    messagingSenderId: '1003798788019',
    projectId: 'thuram-bcc5e',
    storageBucket: 'thuram-bcc5e.firebasestorage.app',
    iosBundleId: 'com.example.thuramApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCVONGm2Sp7xGn09WCQxP1nB5eYjRbOrFw',
    appId: '1:1003798788019:ios:37394c7e21ab825d723dc6',
    messagingSenderId: '1003798788019',
    projectId: 'thuram-bcc5e',
    storageBucket: 'thuram-bcc5e.firebasestorage.app',
    iosBundleId: 'com.example.thuramApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBHPFJ7eS8X5RDcJS8xRAdTjnGzgKNTHdk',
    appId: '1:1003798788019:web:cab10074f598d0e6723dc6',
    messagingSenderId: '1003798788019',
    projectId: 'thuram-bcc5e',
    authDomain: 'thuram-bcc5e.firebaseapp.com',
    storageBucket: 'thuram-bcc5e.firebasestorage.app',
  );
}
