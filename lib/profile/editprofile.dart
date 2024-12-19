import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:probas/profile/profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _phone = "";
  String _address = "";
  String _oldPassword = "";
  String _newPassword = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userData = await _firestore.collection('users').doc(user.uid).get();
        if (userData.exists) {
          print("User Data: ${userData.data()}");
          setState(() {
            _name = userData['fullName'] ?? "";
            _phone = userData['phone'] ?? "";
            _address = userData['address'] ?? "";
          });
        } else {
          print("No data found for this user.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    } else {
      print("No user is logged in.");
    }
  }


  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = _auth.currentUser;

      if (user != null) {
        setState(() {
          _isLoading = true; // Show loading indicator
        });

        try {
          // Validate old password
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _oldPassword,
          );

          await user.reauthenticateWithCredential(credential);

          // Update password if provided
          if (_newPassword.isNotEmpty) {
            await user.updatePassword(_newPassword);
          }

          // Update Firestore data
          await _firestore.collection('users').doc(user.uid).update({
            'fullName': _name,
            'phone': _phone,
            'address': _address,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
        } finally {
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ProfilePic(
                image: 'https://i.ibb.co.com/3sySM2d/20240918-231222-1.jpg',
                imageUploadBtnPress: () {},
              ),
              const Divider(),
              UserInfoEditField(
                text: "Name",
                child: TextFormField(
                  initialValue: _name,
                  onSaved: (value) => _name = value ?? "",
                  decoration: _inputDecoration(),
                ),
              ),
              UserInfoEditField(
                text: "Phone",
                child: TextFormField(
                  initialValue: _phone,
                  onSaved: (value) => _phone = value ?? "",
                  decoration: _inputDecoration(),
                ),
              ),
              UserInfoEditField(
                text: "Address",
                child: TextFormField(
                  initialValue: _address,
                  onSaved: (value) => _address = value ?? "",
                  decoration: _inputDecoration(),
                ),
              ),
              UserInfoEditField(
                text: "Old Password",
                child: TextFormField(
                  obscureText: true,
                  onSaved: (value) => _oldPassword = value ?? "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Old password is required";
                    }
                    return null;
                  },
                  decoration: _inputDecoration(),
                ),
              ),
              UserInfoEditField(
                text: "New Password",
                child: TextFormField(
                  obscureText: true,
                  onSaved: (value) => _newPassword = value ?? "",
                  decoration: _inputDecoration(hintText: "New Password"),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 48),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  SizedBox(
                    width: 160,
                    child: _isLoading
                        ? const Center(
                      child: CircularProgressIndicator(), // Show loader if loading
                    )
                        : ElevatedButton(
                      onPressed: _updateUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text("Save Update"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16.0 * 1.5, vertical: 16.0),
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}

