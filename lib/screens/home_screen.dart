// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userRole;
  String? _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("HomeScreen initState: Starting to fetch user data...");
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {

          print("Firestore document found. Data: ${userDoc.data()}");
          final roleFromDb = userDoc.data()?['role'];
          print("Role retrieved from DB: '$roleFromDb'"); // Added quotes to see spaces

          setState(() {
            _userRole = userDoc.data()?['role'];
            _username = userDoc.data()?['username'];
            _isLoading = false;
          });
        } else {
          // --- DEBUG PRINT 3 ---
          print("Error: Firestore document for user ${user.uid} does not exist.");
          setState(() { _isLoading = false; });
        }
      } catch (e) {
        print("Error fetching user data: $e");
        setState(() { _isLoading = false; });
      }
    } else {
      // --- DEBUG PRINT 4 ---
      print("Error: No current user found in FirebaseAuth.");
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building HomeScreen. Current role state: '$_userRole'");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verdia Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show loading spinner while fetching data
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, ${_username ?? 'User'}!',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your Role: ${_userRole ?? 'N/A'}',
                      style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 40),

                    // --- THIS IS THE ROLE-BASED UI ---
                    if (_userRole == 'admin')
                      ElevatedButton.icon(
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text('Admin Panel'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        onPressed: () {
                          // TODO: Navigate to an admin-only screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Welcome, Admin!')),
                          );
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}