import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyC88ABnucoOL_0HryNDzzOCv1il6LtoMS0",
            authDomain: "verdia-2jcffa.firebaseapp.com",
            projectId: "verdia-2jcffa",
            storageBucket: "verdia-2jcffa.firebasestorage.app",
            messagingSenderId: "223834220558",
            appId: "1:223834220558:web:14713acee4cb7a9565b45f"));
  } else {
    await Firebase.initializeApp();
  }
}
