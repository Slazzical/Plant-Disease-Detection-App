// lib/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // Close keyboard

    if (isValid) {
      _formKey.currentState!.save();

      if (mounted) setState(() { _isLoading = true; });

      try {
        // --- THIS IS THE SIMPLIFIED LOGIC ---
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // The StreamBuilder in main.dart now handles ALL navigation.
        // We no longer need navigation logic here.
        // We can optionally show a quick success message.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        // --- END OF SIMPLIFIED LOGIC ---

      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred, please check your credentials!';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
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

  // Password Reset Dialog (remains unchanged)
  void _showPasswordResetDialog(BuildContext context) {
    final TextEditingController resetEmailController = TextEditingController(text: _emailController.text);
    final GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Password'),
        content: Form(
          key: resetFormKey,
          child: TextFormField(
            controller: resetEmailController,
            decoration: const InputDecoration(
              labelText: 'Enter your email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || !value.contains('@') || value.isEmpty) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (resetFormKey.currentState!.validate()) {
                final email = resetEmailController.text.trim();
                Navigator.of(ctx).pop(); // Close dialog first
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password reset email sent to $email.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  // Handle specific errors if needed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message ?? 'Failed to send email.')),
                  );
                }
              }
            },
            child: const Text('Send Reset Email'),
          ),
        ],
      ),
    );
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
                key: const ValueKey('email_login'),
                controller: _emailController,
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
                key: const ValueKey('password_login'),
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
                onSaved: (value) {
                  _password = value!;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showPasswordResetDialog(context),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
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
                    'Login',
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