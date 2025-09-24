import 'package:flutter/material.dart';
import 'package:red_social_utvm/models/post.dart';
import 'package:red_social_utvm/service/api_service.dart';
import 'create_post_screen.dart';

class FeedScreen extends StatefulWidget {
  final ApiService api;
  const FeedScreen({super.key, required this.api});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = widget.api.fetchPosts();
  }

  void _refresh() {
    setState(() {
      _futurePosts = widget.api.fetchPosts();
    });
  }

  void _like(Post post) async {
    await widget.api.likePost(post.id);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final posts = snapshot.data!;
          if (posts.isEmpty) {
            return const Center(child: Text("No hay publicaciones aún"));
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.content, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(post.emoji, style: const TextStyle(fontSize: 24)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("❤️ ${post.likes}"),
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () => _like(post),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreatePostScreen(api: widget.api),
            ),
          );
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
