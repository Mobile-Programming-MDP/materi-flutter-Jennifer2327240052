import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  final String title;
  final String description;
  String? imaimageBase64;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  
  var imageBase64;

  Note({
    this.id,
    required this.title,
    required this.description,
    this.imageBase64,
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      imageBase64: data['image_base_64'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image_base_64': imageBase64,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
