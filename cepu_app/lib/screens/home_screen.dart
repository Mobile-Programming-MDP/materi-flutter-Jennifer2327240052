import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pertemuan10/screens/add_post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pertemuan10/screens/sign_in_screen.dart';
import 'package:pertemuan10/services/post-service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (route) => false,
    );
  }

  //Fungsi untuk membuat url foto profile / avatar
  String generateAvatarUrl(String? fullName) {
    final formattedName = fullName!.trim().replaceAll(' ', '+');
    return 'https://ui-avatars.com/api/?name=$formattedName&color=FFFFFF&background=000000';
  }

  //1 Create variable untuk menyimpan ketegori
  String? selectedCategory;
  List<String> get categories {
    return [
      'Jalan Rusak',
      'Lampu Jalan Mati',
      'Lawan Arah',
      'Merokok di Jalan',
      'Tidak Pakai Helm',
    ];
  }

  //2 Create function untuk meampilkan model button sheet untuk memilih kategori
  void _showCategoryFilter() async {
    // ignore: unused_local_variable
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context0) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                ListTile(
                  leading: const Icon(Icons.clear),
                  title: Text("All category"),
                  onTap: () => Navigator.pop(
                    context,
                    null,
                  ), // Null untuk memilih semua kategori
                ),
                const Divider(),
                ...categories.map(
                  (category) => ListTile(
                    title: Text(category),
                    trailing: selectedCategory == category
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () => Navigator.pop(context, category),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          //3 tambahkan IconBottom untuk memunculkan filter kategori
          IconButton(
            onPressed: _showCategoryFilter,
            icon: const Icon(Icons.filter_list),
            tooltip: "Filter",
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8.0),
          Image.network(
            generateAvatarUrl(
              FirebaseAuth.instance.currentUser?.displayName.toString(),
            ),
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 8.0),
          Text(
            FirebaseAuth.instance.currentUser!.displayName!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          const Divider(),
          Expanded(
            child: StreamBuilder(
              //4. Ganti stream dgn memanggil fungsi
              //getPostListByCategory dengan parameter selectedCategory
              stream: PostService.getPostListByCategory(selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final posts = snapshot.data ?? [];
                if (posts.isEmpty) {
                  return const Center(child: Text('No posts yet.'));
                }
                return RefreshIndicator(
                  onRefresh: () async {},
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final isOwner =
                          currentUserId != null && post.userId == currentUserId;
                      //Buat widget PostListItem, di dalam folder widgets
                      //dengan nama file post_list_item.dart
                      return PostListItem(post: post, isOwner: isOwner);
                    },
                  ),
                );
              },
            ),
          ),
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
