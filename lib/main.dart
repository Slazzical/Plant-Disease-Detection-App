// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:plant_disease_detection/firebase_options.dart';
import 'package:plant_disease_detection/screens/auth_screen.dart';
import 'package:plant_disease_detection/screens/home_screen.dart'; // Import your new home screen
import 'package:plant_disease_detection/screens/forgot_password_screen.dart';
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
      // --- Changes Start Here ---
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          }
          if (snapshot.hasData) {
            // User is logged in
            return const HomeScreen(); // Go to home screen
          }
          // User is not logged in
          return const AuthScreen(); // Go to authentication screen
        },
      ),
      routes: {
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
      // --- Changes End Here ---
    );
  }
}