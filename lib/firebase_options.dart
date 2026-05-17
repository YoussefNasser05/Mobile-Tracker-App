// Generated from google-services.json for project: billing-b4dae

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
          'Web is not configured. Add a web app in Firebase console first.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
            'iOS is not configured. Add an iOS app in Firebase console first.');
      case TargetPlatform.macOS:
        throw UnsupportedError(
            'macOS is not configured. Add a macOS app in Firebase console first.');
      case TargetPlatform.windows:
        throw UnsupportedError(
            'Windows is not configured. Add a Windows app in Firebase console first.');
      default:
        throw UnsupportedError(
            'Unsupported platform: $defaultTargetPlatform');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHTHxKYHpEQOccJFPBEj8kBEll1rhv2YA',
    appId: '1:1040505253411:android:a2d0e66386b0de895b0b96',
    messagingSenderId: '1040505253411',
    projectId: 'billing-b4dae',
    databaseURL: 'https://billing-b4dae-default-rtdb.firebaseio.com',
    storageBucket: 'billing-b4dae.firebasestorage.app',
  );
}
