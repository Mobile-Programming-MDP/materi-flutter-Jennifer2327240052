import 'package:pertemuan10/screens/sign_in_screen.dart';
import 'package:pertemuan10/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (route) => false,
    );
  }

  Future<String?> getTokenAuth() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? idToken = await user.getIdToken(true);
      return idToken;
    }

    return null;
  }

  String? _idToken = "";
  String? _uid = "";
  String? _email = "";

  get color => null;

  Future<void> getFirebaseAuthUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _uid = user.uid;
      _email = user.email;
      await user
          .getIdToken(true)
          .then(
            (value) => {
              setState(() {
                _idToken = value;
              }),
            },
          );
    }
  }

  String generatAvatarUrl(String? fullname) {
    final formattedName = fullname?.trim().replaceAll(' ', '+');
    return 'https://ui-avatars.com/api/?name-$formattedName$color=FFFFFF&background=000000';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
      ),
      body: Column(
        children: [
          Image.network(
            generatAvatarUrl(
              FirebaseAuth.instance.currentUser!.displayName.toString(),
            ),
            width: 100,
            height: 100,
          ),
          SizedBox(height: 8.0),
          Text(
            FirebaseAuth.instance.currentUser!.displayName!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text("You have been signed in with Token id: $_idToken"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
