import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PostService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _postsCollection = _database.collection(
    'posts',
  );

  static Future<void> addPost(Map<String, dynamic> post) async {
    Map<String, dynamic> newPost = {
      'image': post['image'],
      'description': post['description'],
      'category': post['category'],
      'latitude': post['latitude'],
      'longitude': post['longitude'],
      'userId': post['userId'],
      'userfullName': post['userfullName'],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _postsCollection.add(newPost);
  }
}
