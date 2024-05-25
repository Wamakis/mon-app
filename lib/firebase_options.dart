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
    apiKey: 'AIzaSyCHlXt-VI5cWo8UO9tPOQt4xUQQaNNOYII',
    appId: '1:217632775015:web:a743e18c9603abfe7bedc2',
    messagingSenderId: '217632775015',
    projectId: 'famchat-6305f',
    authDomain: 'famchat-6305f.firebaseapp.com',
    storageBucket: 'famchat-6305f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWytbtLRoY06SnM8DaBodCEHBPPrDgbME',
    appId: '1:217632775015:android:b2b51450e12b0bc37bedc2',
    messagingSenderId: '217632775015',
    projectId: 'famchat-6305f',
    storageBucket: 'famchat-6305f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCW0JFspQgBbTPYiQGwzKGaYJrLa5XiG0A',
    appId: '1:217632775015:ios:83a1c8d137c42c947bedc2',
    messagingSenderId: '217632775015',
    projectId: 'famchat-6305f',
    storageBucket: 'famchat-6305f.appspot.com',
    iosBundleId: 'com.example.yohannApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCW0JFspQgBbTPYiQGwzKGaYJrLa5XiG0A',
    appId: '1:217632775015:ios:83a1c8d137c42c947bedc2',
    messagingSenderId: '217632775015',
    projectId: 'famchat-6305f',
    storageBucket: 'famchat-6305f.appspot.com',
    iosBundleId: 'com.example.yohannApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCHlXt-VI5cWo8UO9tPOQt4xUQQaNNOYII',
    appId: '1:217632775015:web:1883aa878decf44d7bedc2',
    messagingSenderId: '217632775015',
    projectId: 'famchat-6305f',
    authDomain: 'famchat-6305f.firebaseapp.com',
    storageBucket: 'famchat-6305f.appspot.com',
  );
}
