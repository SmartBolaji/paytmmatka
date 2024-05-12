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
    apiKey: 'AIzaSyBfy2JhE3QMrreM4BOCdyOP3emn9jNOHJ8',
    appId: '1:273504583231:web:f1ae8586cbc0fbdd42828a',
    messagingSenderId: '273504583231',
    projectId: 'paytmmatka',
    authDomain: 'paytmmatka.firebaseapp.com',
    storageBucket: 'paytmmatka.appspot.com',
    measurementId: 'G-7DCSTJWNXN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIB3HfOaNb4k0WEMh5Auxbtx-qq2z0vAQ',
    appId: '1:273504583231:android:abd5fabcf254117042828a',
    messagingSenderId: '273504583231',
    projectId: 'paytmmatka',
    storageBucket: 'paytmmatka.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDEO5oC8zahQwaS5JFmYODVHDkXU4J07E',
    appId: '1:273504583231:ios:bb75667ae8434e1042828a',
    messagingSenderId: '273504583231',
    projectId: 'paytmmatka',
    storageBucket: 'paytmmatka.appspot.com',
    iosBundleId: 'com.example.paytmmatka',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDEO5oC8zahQwaS5JFmYODVHDkXU4J07E',
    appId: '1:273504583231:ios:bb75667ae8434e1042828a',
    messagingSenderId: '273504583231',
    projectId: 'paytmmatka',
    storageBucket: 'paytmmatka.appspot.com',
    iosBundleId: 'com.example.paytmmatka',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBfy2JhE3QMrreM4BOCdyOP3emn9jNOHJ8',
    appId: '1:273504583231:web:06b7a572e10ed1cf42828a',
    messagingSenderId: '273504583231',
    projectId: 'paytmmatka',
    authDomain: 'paytmmatka.firebaseapp.com',
    storageBucket: 'paytmmatka.appspot.com',
    measurementId: 'G-62D9S6KD6C',
  );

}