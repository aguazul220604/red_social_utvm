import 'dart:async';
import 'package:red_social_utvm/models/post.dart';

class ApiService {
  final List<Post> _posts = [];
  int _counter = 0;

  Future<List<Post>> fetchPosts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _posts;
  }

  Future<Post> createPost(String content, String emoji) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newPost = Post(
      id: _counter++,
      content: content,
      emoji: emoji,
      likes: 0,
    );
    _posts.insert(0, newPost);
    return newPost;
  }

  Future<void> likePost(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final post = _posts.firstWhere((p) => p.id == id);
    post.likes++;
  }
}
