import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pertemuan10/models/post.dart';
import 'package:pertemuan10/services/post-service.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

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
  Future<void> _getLocation() async {
    setState(() {
      _isGetLocation = true;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Layanan lokasi dinonaktifkan.")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Izin lokasi ditolak.")));
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 10));

      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
      });
    } catch (e) {
      debugPrint('Failed to retrieve location: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengambil lokasi.")));
      setState(() {
        _latitude = null;
        _longitude = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isGetLocation = false;
        });
      }
    }
  }

  // 3. Fungsi tampil pilihan kategori
  void _showCategorySelect() {
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
        child: const Text('Belum ada gambar yang dipilih'),
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
    if (_base64Image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar terlebih dahulu.')),
      );
      return;
    }
    if (_category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kategori terlebih dahulu.')),
      );
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan deskripsi terlebih dahulu.')),
      );
      return;
    }
    setState(() {
      _isSubmitting = true;
    });

    //ambil user id dan full name dari firebaseauth
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final fullName = FirebaseAuth.instance.currentUser?.displayName;
    try {
      if (_latitude == null || _longitude == null) {
        await _getLocation();
      }
      PostService.addPost(
        Post(
          image: _base64Image,
          description: _descriptionController.text,
          category: _category,
          latitude: _latitude,
          longitude: _longitude,
          userId: userId,
          userFullName: fullName,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Posting berhasil disimpan")));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Posting gagal disimpan : $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // 7 fungdi gemerate desciription otomatis berdasarkan gambar
  // panggil fungsi ini setelah gambar dipilih

  Future<void> _generateDescriptionWithAI() async {
    if (_base64Image == null) return;
    setState(() => _isGenerating = true);
    try {
      const apiKey = 'AIzaSyARTOD2QTxqJg-DSQ9VH-XyhK2dvrwH4j4';
      const apiUrl ="https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:streamGenerateContent?key=$apiKey";
      final body = jsonEncode({
        "contents" : [
          {
            "parts" : [
              {
                "inlineData": {
                  "mimeType": "image/jpeg",
                  "data": _base64Image,
                },
              },
              {
                "text" :
                "Berdasarkan foto ini, indentifikasi satu kategori utama kerusakan fasilitas umum"
                "dari daftar berikut: Jalan Rusak, Lampu jalan Mati, Lawan Arah, Merokok di jalan, Tidak Memakai Helm. dan lainnya."
                "Pilih kategori yang paling dominan atau paling mendesak untuk dilaporkan."
                "Buat deskripsi singkat untuk laporan perbaikan, dan tambahkan permohonan perbaikan."
                "Fokus pada kerudakan yang terlihat dan hindari spekulasi. \n\n"
                "Format output yang diinginkan:\n"
                "Kategori: [kategori yang dipilih]\n"
                "Deskripsi: [deskripsi singkat]",
              }
            ]
          }
        ]
      });
      }
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
      }else {
        debugPrint('Failed to generate Ai description: $e');
      }
    } catch (e) {
      debugPrint('Error generating AI description: $e');
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add new post")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImagePreview(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.stretch,
              children: [
                OutlinedButton(
                onPressed: _isGenerating ? null : pickImageAndConvert,
                child: Text(_isGenerating ? 'Generating...' : 'Pick Image'),
              ),
              ],
            ),
            const SizedBox(height: 16),
             if (!_isGenerating && _base64Image != null)
              ElevatedButton(
                onPressed: _isGenerating ? null : _generateDescriptionWithAI,
                child: const Text('Generate Description with AI'),
              ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _isSubmitting ? null : _showCategorySelect,
              child: const Text('Select Category'),
            ),
            const SizedBox(height: 8),
            Text(
              _category ?? 'Belum memilih kategori',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Masukkan deskripsi laporan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: (_isSubmitting || _isGetLocation)
                  ? null
                  : _getLocation,
              child: Text(
                _isGetLocation ? 'Mengambil Lokasi...' : 'Get Location',
              ),
            ),
            const SizedBox(height: 8),
            _buildLocationInfo(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitPost,
              child: Text(_isSubmitting ? 'Submitting...' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
}