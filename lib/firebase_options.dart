// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCsACTdym7LKCN066-uTDhdWXCgGlFqAZk',
    appId: '1:445906960289:web:45d5753498047c916815e0',
    messagingSenderId: '445906960289',
    projectId: 'attendance-app-479e1',
    authDomain: 'attendance-app-479e1.firebaseapp.com',
    storageBucket: 'attendance-app-479e1.appspot.com',
    measurementId: 'G-RZNGCDJN7F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAxIbGm8JyZ4yKXy6AhIxx-F1NM5nR17yU',
    appId: '1:445906960289:android:83d8b82e5951559c6815e0',
    messagingSenderId: '445906960289',
    projectId: 'attendance-app-479e1',
    storageBucket: 'attendance-app-479e1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_kNYjQdvKmDemNlWHwT1p5FcvxUaUhdQ',
    appId: '1:445906960289:ios:ded0bb1e7667a4e06815e0',
    messagingSenderId: '445906960289',
    projectId: 'attendance-app-479e1',
    storageBucket: 'attendance-app-479e1.appspot.com',
    iosBundleId: 'com.example.attendxpert',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB_kNYjQdvKmDemNlWHwT1p5FcvxUaUhdQ',
    appId: '1:445906960289:ios:ab8c47db6460a3626815e0',
    messagingSenderId: '445906960289',
    projectId: 'attendance-app-479e1',
    storageBucket: 'attendance-app-479e1.appspot.com',
    iosBundleId: 'com.example.attendxpert.RunnerTests',
  );
}
