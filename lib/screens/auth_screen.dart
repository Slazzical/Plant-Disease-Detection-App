// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:plant_disease_detection/widgets/login_form.dart';
import 'package:plant_disease_detection/widgets/signup_form.dart';

enum AuthMode { login, signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.login;

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.login) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  // --- New method to handle successful signup ---
  void _handleSignupSuccess() {
    setState(() {
      _authMode = AuthMode.login; // Switch to login mode
    });
  }
  // --- End New method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_authMode == AuthMode.login ? 'Login' : 'Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for a logo or app title
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Verdia',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              _authMode == AuthMode.login
                  ? const LoginForm()
                  : SignUpForm(
                      onSignupSuccess: _handleSignupSuccess, // Pass the callback
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _authMode == AuthMode.login
                      ? 'Don\'t have an account? Sign Up'
                      : 'Already have an account? Login',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}