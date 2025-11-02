// lib/widgets/signup_form.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpForm extends StatefulWidget {
  final VoidCallback onSignupSuccess;

  const SignUpForm({
    Key? key,
    required this.onSignupSuccess,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _username = '';

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      if (mounted) setState(() { _isLoading = true; });

      try {
        // Step 1: Create the user in Firebase Auth
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _passwordController.text,
        );

        // --- CORRECTED LOGIC ---
        final user = userCredential.user; // Get the user object from the credential

        // Perform all actions inside a single null check for the user
        if (user != null) {
          // Action 1: Update the display name
          await user.updateDisplayName(_username);

          // Action 2: Create the user document in Firestore with a default role
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'username': _username,
            'email': _email,
            'role': 'user', // Default role for new sign-ups
            'createdAt': Timestamp.now(),
          });
        }
        // --- END OF CORRECTION ---

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
        }
        widget.onSignupSuccess();

      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred, please check your input!';
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is not valid.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const ValueKey('email_signup'),
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!.trim();
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('username_signup'),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                autocorrect: false,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 4) {
                    return 'Please enter at least 4 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('password_signup'),
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 7) {
                    return 'Password must be at least 7 characters long.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('confirm_password_signup'),
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password.';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _trySubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}