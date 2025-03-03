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
    apiKey: 'AIzaSyCVMTEQS2nU3oHh0iSedfGZrDVqkVtSdgY',
    appId: '1:527609679972:web:8175d8879c295fb9ae8f71',
    messagingSenderId: '527609679972',
    projectId: 'tuberculoseapp',
    authDomain: 'tuberculoseapp.firebaseapp.com',
    storageBucket: 'tuberculoseapp.firebasestorage.app',
    measurementId: 'G-D50FZQ81GD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAoZKmVTat__r3zLJdP2D4Dutufnowkbaw',
    appId: '1:527609679972:android:e08a6af71055cfd4ae8f71',
    messagingSenderId: '527609679972',
    projectId: 'tuberculoseapp',
    storageBucket: 'tuberculoseapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBpoOqYjawqMa9sL-E3wRIjxMPIQYdGVDM',
    appId: '1:527609679972:ios:e0c1ae350f119a14ae8f71',
    messagingSenderId: '527609679972',
    projectId: 'tuberculoseapp',
    storageBucket: 'tuberculoseapp.firebasestorage.app',
    iosBundleId: 'com.example.mytb',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBpoOqYjawqMa9sL-E3wRIjxMPIQYdGVDM',
    appId: '1:527609679972:ios:e0c1ae350f119a14ae8f71',
    messagingSenderId: '527609679972',
    projectId: 'tuberculoseapp',
    storageBucket: 'tuberculoseapp.firebasestorage.app',
    iosBundleId: 'com.example.mytb',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCVMTEQS2nU3oHh0iSedfGZrDVqkVtSdgY',
    appId: '1:527609679972:web:6c57e0bc9dc0443fae8f71',
    messagingSenderId: '527609679972',
    projectId: 'tuberculoseapp',
    authDomain: 'tuberculoseapp.firebaseapp.com',
    storageBucket: 'tuberculoseapp.firebasestorage.app',
    measurementId: 'G-3BPN1MZVN1',
  );
}
