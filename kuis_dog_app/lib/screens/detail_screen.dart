import 'package:flutter/material.dart';
import 'package:kuis_dog_app/models/dog_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Dog dog;
  const DetailScreen({super.key, required this.dog});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<void> _refreshImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? newImageUrl = prefs.getString('newImageUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dog Detail')),
      body: Center(child: Image.network(widget.dog.imageUrl)),
    );
  }
}
