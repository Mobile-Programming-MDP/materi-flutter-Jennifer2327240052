import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Contoh model Post sederhana
class Post {
  final String title;
  final double latitude;
  final double longitude;

  Post({required this.title, required this.latitude, required this.longitude});
}

class MapDetailScreen extends StatefulWidget {
  final Post post;

  const MapDetailScreen({super.key, required this.post});

  @override
  State<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends State<MapDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Koordinat dari data post
    final LatLng postLocation = LatLng(
      widget.post.latitude,
      widget.post.longitude,
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.post.title)),
      body: FlutterMap(
        options: MapOptions(initialCenter: postLocation, initialZoom: 15.0),
        children: [
          // Layer Peta (Menggunakan OpenStreetMap)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          // Layer Marker
          MarkerLayer(
            markers: [
              Marker(
                point: postLocation,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
