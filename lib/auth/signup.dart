import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:probas/auth/forgotpassword.dart';
import 'package:probas/auth/signin.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false; // To manage progress bar visibility

  Future<void> signUp(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String username = userNameController.text.trim();
    String fullName = fullNameController.text.trim();
    String address = addressController.text.trim();
    String phone = phoneController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        username.isEmpty ||
        fullName.isEmpty ||
        address.isEmpty ||
        phone.isEmpty) {
      showErrorDialog("Please fill all fields.");
      return;
    }

    if (password != confirmPassword) {
      showErrorDialog("Passwords do not match.");
      return;
    }

    try {
      setState(() {
        _isLoading = true; // Show progress bar
      });

      // Firebase Authentication: Create user
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send Email Verification
      await userCredential.user?.sendEmailVerification();

      // Firestore: Save user information
      await _firestore.collection("users").doc(userCredential.user?.uid).set({
        "username": username,
        "fullName": fullName,
        "email": email,
        "address": address,
        "phone": phone,
      });

      setState(() {
        _isLoading = false; // Hide progress bar
      });

      // Show Verification Dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Verify Your Email"),
          content: const Text(
              "A verification email has been sent. Please check your inbox to verify."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide progress bar if there's an error
      });
      showErrorDialog(e.toString());
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/probash.png',
                      height: 220, fit: BoxFit.contain),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome To Probash Care',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildTextField('Username', userNameController, Icons.person),
                  const SizedBox(height: 20),
                  buildTextField('Full Name', fullNameController, Icons.person),
                  const SizedBox(height: 20),
                  buildTextField('Email', emailController, Icons.email),
                  const SizedBox(height: 20),
                  buildTextField(
                      'Address', addressController, Icons.location_on),
                  const SizedBox(height: 20),
                  buildTextField('Phone Number', phoneController, Icons.phone),
                  const SizedBox(height: 20),
                  buildTextField(
                      'Password', passwordController, Icons.lock,
                      isPassword: true),
                  const SizedBox(height: 20),
                  buildTextField(
                      'Confirm Password', confirmPasswordController, Icons.lock,
                      isPassword: true),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => signUp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade700,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    child: Text(
                      'Already Registered? Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Show progress indicator when loading
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueGrey.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey.shade700),
        ),
      ),
    );
  }
}

