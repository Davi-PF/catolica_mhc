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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBXeSDYb0o2azQfHTB2CjYOrYcqPzaYOpQ',
    appId: '1:407547194289:web:b05053a2b4cb2d83cdeb90',
    messagingSenderId: '407547194289',
    projectId: 'catolica-mhc-database',
    authDomain: 'catolica-mhc-database.firebaseapp.com',
    storageBucket: 'catolica-mhc-database.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvPev3zDvzJ-DOIzD1kZtaWG9IbB--huc',
    appId: '1:407547194289:android:0f9b598fd0159b9ccdeb90',
    messagingSenderId: '407547194289',
    projectId: 'catolica-mhc-database',
    storageBucket: 'catolica-mhc-database.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYPhPUZgOUXUpDzpEzojdB15-qCLFRRP8',
    appId: '1:407547194289:ios:b5c385e0edc64f59cdeb90',
    messagingSenderId: '407547194289',
    projectId: 'catolica-mhc-database',
    storageBucket: 'catolica-mhc-database.appspot.com',
    iosClientId: '407547194289-sfb6s8lu5q887phj0tnp7hcu0b1h5iqb.apps.googleusercontent.com',
    iosBundleId: 'com.example.catolicaMhc',
  );
}
