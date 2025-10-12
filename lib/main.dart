import 'package:flutter/material.dart';
import 'package:plant_disease_detection/screens/auth_screen.dart'; // We'll create this file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verdia',
      theme: ThemeData(
        primarySwatch: Colors.green, // A nice plant-related primary color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthScreen(), // Our entry point for authentication
    );
  }
}