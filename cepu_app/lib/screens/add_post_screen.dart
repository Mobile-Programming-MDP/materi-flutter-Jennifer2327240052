import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _base64Image;
  String? _latitude;
  String? _longitude;
  String? _category;
  bool _isSubmitting = false;
  bool _isGetLocation = false;
  List<String> get categories {
    return [
      'Jalan Rusak',
      'Lampu jalan Mati',
      'Lawan Arah',
      'Merokok di jalan',
      'Tidak Memakai Helm',
    ];
  }

  // 1. Fungsi pick, compress, dan convert image
  Future<void> pickImageAndConvert() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Compress image
      final bytes = await image.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  // 2. Fungsi untuk mendapatkan lokasi

  // 3. Fungsi tampil pilihan kategori
  void _showCategorySelect(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
            shrinkWrap: true,
            children: categories.map((cat) {
              return ListTile(
                title: Text(cat),
                onTap: () {
                  setState(() {
                    _category = cat;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
        );
      },
    );
  }

  // 4. Fungsi widget untuk menampilkan gambar
  Widget _buildImagePreview() {
    if (_base64Image == null) {
      return Container(
        height: 100,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,  
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: const Text(
          'Belum ada gambar yang dipilih',
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(
        base64Decode(_base64Image!),
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  // 5. Fungsi widget tampil lokasi
    Widget _buildLocationInfo() {
        if (_latitude == null || _longitude == null) {
          return const Text(
            'Lokasi belum didapatkan',
            style: TextStyle(color: Colors.red),
          );
        }
          return Text(
            'Lat: $_latitude, Long: $_longitude',
            textAlign: TextAlign.center,
        );
    }

    // 6. Fungsi submit post
    Future<void> _submitPost() async {
      if (_base64Image == null ) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih Gambar terlebih dahulu')),
        );
        return;
      }
      if (_category == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih Kategori terlebih dahulu')),
        );
        return;
      }
      if(_descriptionController.text.trim().isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan Deskripsi terlebih dahulu')),
        );
        return;
      }
      setState(() {
        _isSubmitting = true;
      });

      //ambil user id dan full nama dari firebase
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final fullName = FirebaseAuth.instance.currentUser?.displayName;   
      try{
        if(_latitude == null || _longitude == null){
          await _isGetLocation();
      }   
}    