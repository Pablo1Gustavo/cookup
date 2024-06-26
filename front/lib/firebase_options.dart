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
    apiKey: 'AIzaSyA0agoZ4HZV7qYElHqTX1L5AwuwWLbf7xA',
    appId: '1:212980562016:web:791dca788dada33131ab05',
    messagingSenderId: '212980562016',
    projectId: 'cookup-abbd8',
    authDomain: 'cookup-abbd8.firebaseapp.com',
    storageBucket: 'cookup-abbd8.appspot.com',
    measurementId: 'G-WG3QG0WZX3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA97m2WOLlxZ0uU0AK_20Caz5n63HT272Y',
    appId: '1:212980562016:android:db3eb3db96b6b9db31ab05',
    messagingSenderId: '212980562016',
    projectId: 'cookup-abbd8',
    storageBucket: 'cookup-abbd8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIJXK7rRkhsK19ALomVWVL17Jp3aZG9QI',
    appId: '1:212980562016:ios:488e68023b5b8c2131ab05',
    messagingSenderId: '212980562016',
    projectId: 'cookup-abbd8',
    storageBucket: 'cookup-abbd8.appspot.com',
    iosBundleId: 'com.example.front',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAIJXK7rRkhsK19ALomVWVL17Jp3aZG9QI',
    appId: '1:212980562016:ios:488e68023b5b8c2131ab05',
    messagingSenderId: '212980562016',
    projectId: 'cookup-abbd8',
    storageBucket: 'cookup-abbd8.appspot.com',
    iosBundleId: 'com.example.front',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA0agoZ4HZV7qYElHqTX1L5AwuwWLbf7xA',
    appId: '1:212980562016:web:53fb1bc30b63570331ab05',
    messagingSenderId: '212980562016',
    projectId: 'cookup-abbd8',
    authDomain: 'cookup-abbd8.firebaseapp.com',
    storageBucket: 'cookup-abbd8.appspot.com',
    measurementId: 'G-JC6JD5N5Z8',
  );
}
