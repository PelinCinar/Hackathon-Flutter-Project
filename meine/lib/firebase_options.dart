import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DefaultFirebaseOptions {
  // Static method
  static FirebaseOptions currentPlatform() {
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
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Static constants for FirebaseOptions
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCtv0mVeuvPjdfRU0tpdzIFh2KRoo9KzSw',
    appId: '1:610240444699:web:fd556ba0c81cd3820bfbbe',
    messagingSenderId: '610240444699',
    projectId: 'meine-bb573',
    authDomain: 'meine-bb573.firebaseapp.com',
    storageBucket: 'meine-bb573.firebasestorage.app',
    measurementId: 'G-S1FMSJCTEB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbg3-hcFMLaJ7mrZmWLJEYZXEldoM82rM',
    appId: '1:610240444699:android:f041b324543102de0bfbbe',
    messagingSenderId: '610240444699',
    projectId: 'meine-bb573',
    storageBucket: 'meine-bb573.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBstG48tx56HnLY5prZcjiZy0RNwZQti-o',
    appId: '1:610240444699:ios:efac2f0b2946058e0bfbbe',
    messagingSenderId: '610240444699',
    projectId: 'meine-bb573',
    storageBucket: 'meine-bb573.firebasestorage.app',
    iosBundleId: 'com.meine.meine',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBstG48tx56HnLY5prZcjiZy0RNwZQti-o',
    appId: '1:610240444699:ios:efac2f0b2946058e0bfbbe',
    messagingSenderId: '610240444699',
    projectId: 'meine-bb573',
    storageBucket: 'meine-bb573.firebasestorage.app',
    iosBundleId: 'com.meine.meine',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCtv0mVeuvPjdfRU0tpdzIFh2KRoo9KzSw',
    appId: '1:610240444699:web:b07b0ccf4131db030bfbbe',
    messagingSenderId: '610240444699',
    projectId: 'meine-bb573',
    authDomain: 'meine-bb573.firebaseapp.com',
    storageBucket: 'meine-bb573.firebasestorage.app',
    measurementId: 'G-RX6W2J0RLL',
  );
}
