import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:probas/feedback.dart';
import 'package:probas/homepage.dart';
import 'package:probas/labour/labor_main.dart';
import 'package:probas/profile/profile.dart';
import 'package:probas/auth/signin.dart';
import 'package:probas/student/stu_main.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userName = "Loading..."; // Placeholder for the user's name
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          userName = userDoc['username'] ?? 'Unknown User'; // Update the name
        });
      }
    } catch (e) {
      setState(() {
        userName = "Error loading name"; // Handle errors gracefully
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Custom Drawer Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/probash.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  userName, // Use the fetched user name
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to Profile screen for editing
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text("View Profile"),
                  style: ElevatedButton.styleFrom(),
                ),
              ],
            ),
          ),
          // Drawer menu items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeActivity()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Students'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudentSection()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Labors'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LaborerSection()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Provide Feedback'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FeedbackSection()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              _auth.signOut(); // Sign out the user
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
