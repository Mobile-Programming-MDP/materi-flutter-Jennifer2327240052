import 'package:flutter/material.dart';
import 'package:pilem/screens/home_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilem',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreens(),
    );
  }
}
