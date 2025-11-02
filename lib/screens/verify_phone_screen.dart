// lib/screens/verify_phone_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_disease_detection/screens/home_screen.dart'; // We will navigate here on success

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({Key? key}) : super(key: key);

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _codeSent = false;
  bool _isLoading = false;
  String? _verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _verifyPhoneNumber() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { _isLoading = true; });

    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // This is for Android auto-retrieval.
        setState(() { _isLoading = false; });
        await _linkCredentialToUser(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() { _isLoading = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification Failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // You can handle timeout here if needed
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> _submitSmsCode() async {
    if (_verificationId == null || _smsController.text.isEmpty) return;

    setState(() { _isLoading = true; });

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _smsController.text.trim(),
    );

    await _linkCredentialToUser(credential);
    if (mounted) setState(() { _isLoading = false; });
  }

  Future<void> _linkCredentialToUser(PhoneAuthCredential credential) async {
    try {
      // We are linking the phone credential to the currently signed-in user.
      await _auth.currentUser!.linkWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number successfully linked!'),
          backgroundColor: Colors.green,
        ),
      );
      // On success, navigate to the HomeScreen.
      // The StreamBuilder in main.dart will also handle this automatically.
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false);

    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred linking your phone.';
      if (e.code == 'credential-already-in-use') {
        message = 'This phone number is already linked to another account.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Phone Number'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_codeSent)
                  // UI for entering the phone number
                  Column(
                    children: [
                      const Text(
                        'For security, please link and verify your phone number.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number (e.g., +15551234567)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || !value.startsWith('+')) {
                            return 'Please enter a valid number with country code.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _verifyPhoneNumber,
                          child: const Text('Send Verification Code'),
                        ),
                    ],
                  )
                else
                  // UI for entering the SMS code
                  Column(
                    children: [
                      Text(
                        'Enter the 6-digit code sent to ${_phoneController.text}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _smsController,
                        decoration: const InputDecoration(
                          labelText: 'Verification Code',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                      const SizedBox(height: 20),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _submitSmsCode,
                          child: const Text('Verify and Continue'),
                        ),
                      TextButton(
                        onPressed: () => setState(() => _codeSent = false),
                        child: const Text('Change Phone Number'),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}