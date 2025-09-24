class Post {
  final int id;
  final String content;
  final String emoji;
  int likes;

  Post({
    required this.id,
    required this.content,
    required this.emoji,
    this.likes = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      emoji: json['emoji'],
      likes: json['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "content": content, "emoji": emoji, "likes": likes};
  }
}
