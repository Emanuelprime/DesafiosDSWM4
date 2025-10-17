import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyArf87H82RRYponnqIJz6QFlGtm4EoO6Es',
      appId: '1:246137444053:android:a18bb9f128d9a29792745c',
      messagingSenderId: '246137444053',
      projectId: 'prontuario-b0e08',
      storageBucket: 'prontuario-b0e08.firebasestorage.app',
    );
  }
}
