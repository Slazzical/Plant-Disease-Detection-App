// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_disease_detection/firebase_options.dart';
import 'package:plant_disease_detection/screens/auth_screen.dart';
import 'package:plant_disease_detection/screens/home_screen.dart';
import 'package:plant_disease_detection/screens/verify_phone_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verdia',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // This can be const because it's simple and stateless
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            final user = snapshot.data as User;
            if (user.phoneNumber == null || user.phoneNumber!.isEmpty) {
              // This CANNOT be const because it's a StatefulWidget
              return VerifyPhoneScreen();
            } else {
              // This CANNOT be const because it's a StatefulWidget
              return HomeScreen();
            }
          }
          // This CANNOT be const because it's a StatefulWidget
          return AuthScreen();
        },
      ),
    );
  }
}