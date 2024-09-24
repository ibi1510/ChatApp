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
    apiKey: 'AIzaSyCB4E6f_XUhHgjGjUQCRa1GR8gvABPTunM',
    appId: '1:270889206627:web:506cf5fb1404d5530f0956',
    messagingSenderId: '270889206627',
    projectId: 'chat-app-a6bf6',
    authDomain: 'chat-app-a6bf6.firebaseapp.com',
    storageBucket: 'chat-app-a6bf6.appspot.com',
    measurementId: 'G-FDRR32WJT0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhhf0lL4MwQbO9-oB4INB1qKOOdNOSCRM',
    appId: '1:270889206627:android:d1c77c5e520369600f0956',
    messagingSenderId: '270889206627',
    projectId: 'chat-app-a6bf6',
    storageBucket: 'chat-app-a6bf6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCkKNqCri5jX-n7zUTG7yFVA9xsxiUSanQ',
    appId: '1:270889206627:ios:fde566d0f9551cb10f0956',
    messagingSenderId: '270889206627',
    projectId: 'chat-app-a6bf6',
    storageBucket: 'chat-app-a6bf6.appspot.com',
    iosBundleId: 'com.chatapp.chatApp',
  );
}
