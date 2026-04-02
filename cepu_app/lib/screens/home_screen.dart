import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pertemuan10/screens/sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _idToken = " ";
  String? _uid = " ";
  String? _email = " ";

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (route) => false,
    );
  }

  Future<void> getFirebaseAuthUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _uid = user.uid;
      _email = user.email;
      String? token = await user.getIdToken(true);
      setState(() {
        _idToken = token;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("You have been signed in with Token id: $_idToken"),
            Text("Current User: $_uid"),
            Text("Your email: $_email"),
          ],
        ),
      ),
    );
  }
}
