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
    apiKey: 'AIzaSyC9HiwvTLJOh1csHtjmTQvSvt6yowoEyVE',
    appId: '1:477001297448:web:ef4cf8d8295cef006e4f1d',
    messagingSenderId: '477001297448',
    projectId: 'flutter-login-26d6a',
    authDomain: 'flutter-login-26d6a.firebaseapp.com',
    storageBucket: 'flutter-login-26d6a.appspot.com',
    measurementId: 'G-BBD70Z9BMN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbzuCz_YxHBLvrkZ5QvW3sbjuozXcZpyM',
    appId: '1:477001297448:android:19406b173e19d4d06e4f1d',
    messagingSenderId: '477001297448',
    projectId: 'flutter-login-26d6a',
    storageBucket: 'flutter-login-26d6a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQKl3pIZsfVCgtcH3FAYahH6Vt-WRdV0c',
    appId: '1:477001297448:ios:76cd01eaa207f1866e4f1d',
    messagingSenderId: '477001297448',
    projectId: 'flutter-login-26d6a',
    storageBucket: 'flutter-login-26d6a.appspot.com',
    iosBundleId: 'com.example.flutterTodoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQKl3pIZsfVCgtcH3FAYahH6Vt-WRdV0c',
    appId: '1:477001297448:ios:76cd01eaa207f1866e4f1d',
    messagingSenderId: '477001297448',
    projectId: 'flutter-login-26d6a',
    storageBucket: 'flutter-login-26d6a.appspot.com',
    iosBundleId: 'com.example.flutterTodoApp',
  );
}
