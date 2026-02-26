import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:karyawan/models/karyawan.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Karyawan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<Karyawan>> loadKaryawan() async {
    final String response = await rootBundle.loadString('assets/karyawan.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Karyawan.fromJson(json)).toList();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Karyawan"),
      ),
      body: futureBuilder(
        future: loadKaryawan(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder();
              },
             } 
            ),
          }
