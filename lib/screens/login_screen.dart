import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_erp/components/plain_background.dart';
import 'package:school_erp/components/textfield.dart';
import 'package:school_erp/screens/home_screen.dart';
import 'package:school_erp/screens/events/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController enrollmentController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      // Fetch email associated with the enrollment number from Firestore
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('enrollmentNumber', isEqualTo: enrollmentController.text.trim())
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Get the email corresponding to the enrollment number
        var email = snapshot.docs.first.get('email');

        // Proceed with login using the email fetched from Firestore
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: passwordController.text.trim(),
        );

        // Navigate to HomeScreen on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        // Enrollment number not found in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enrollment number not found")),
        );
      }
    } catch (e) {
      // Handle login error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D83C6),
      body: SafeArea(
        child: Stack(
          children: [
            const PlainBackground(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container for the user image
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/matbuck.jpg', // Path to the image in assets
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Enrollment Number TextField
                  CommonTextField(
                    controller: enrollmentController,
                    hintText: "Enrollment Number",
                    textStyle: const TextStyle(color: Colors.white),
                    hintTextStyle: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),

                  // Password TextField
                  CommonTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                    textStyle: const TextStyle(color: Colors.white),
                    hintTextStyle: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text("Login"),
                  ),

                  // Signup Redirect Button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
