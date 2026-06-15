import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for the VELOUR project.
/// Generated from google-services.json & GoogleService-Info.plist.
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDWhfZsQlSbTdijNqZu-VB_VzMKP4XOx5s',
    appId: '1:193753426658:web:768ce91fcf9f049724ccbb',
    messagingSenderId: '193753426658',
    projectId: 'velour-8002d',
    authDomain: 'velour-8002d.firebaseapp.com',
    storageBucket: 'velour-8002d.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwWaC65w-IHKEop7L0Dq7tmk-XuktMN6I',
    appId: '1:193753426658:android:f8f4aa201b5ac23424ccbb',
    messagingSenderId: '193753426658',
    projectId: 'velour-8002d',
    storageBucket: 'velour-8002d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCcR34cj20IpvttAydiPxDlXuCzAEH-Gto',
    appId: '1:193753426658:ios:37b75ac72f213ecb24ccbb',
    messagingSenderId: '193753426658',
    projectId: 'velour-8002d',
    storageBucket: 'velour-8002d.firebasestorage.app',
    iosBundleId: 'com.example.velour',
  );
}
