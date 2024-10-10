import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_erp/components/plain_background.dart';
import 'package:school_erp/components/textfield.dart';
import 'package:school_erp/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController enrollmentController = TextEditingController(); // Added Enrollment Number controller
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signup() async {
    try {
      // Perform signup
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Optionally, you can save the enrollment number along with other user details.
      String enrollmentNumber = enrollmentController.text.trim();

      // Navigate to HomeScreen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Signup failed: $e")));
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
                  // Container with white background for the image
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white, // White background
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/matbuck.jpg', // Ensure correct path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Enrollment Number field
                  CommonTextField(
                    controller: enrollmentController,
                    hintText: "Enrollment Number",
                    textStyle: const TextStyle(color: Colors.white),
                    hintTextStyle: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    controller: emailController,
                    hintText: "Email",
                    textStyle: const TextStyle(color: Colors.white),
                    hintTextStyle: const TextStyle(color: Colors.white70),

                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                    textStyle: const TextStyle(color: Colors.white),
                    hintTextStyle: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signup,
                    child: const Text("Sign Up"),
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
