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
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  // Colores consistentes con la aplicación
  final Color _primaryColor = const Color(0xFF6366F1);
  final Color _secondaryColor = const Color(0xFF10B981);
  final Color _backgroundColor = const Color(0xFFF8FAFC);
  final Color _textColor = const Color(0xFF1E293B);
  final Color _hintColor = const Color(0xFF64748B);
  final Color _errorColor = const Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _futurePosts = widget.api.fetchPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      _futurePosts = widget.api.fetchPosts();
    });
    await _futurePosts;
  }

  void _like(Post post) async {
    await widget.api.likePost(post.id);
    _refresh();
  }

  void _showPostOptions(Post post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.share, color: _primaryColor),
              title: Text('Compartir', style: TextStyle(color: _textColor)),
              onTap: () {
                Navigator.pop(context);
                // Implementar compartir
              },
            ),
            ListTile(
              leading: Icon(Icons.flag, color: _primaryColor),
              title: Text('Reportar', style: TextStyle(color: _textColor)),
              onTap: () {
                Navigator.pop(context);
                // Implementar reportar
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.close, color: _hintColor),
              title: Text('Cancelar', style: TextStyle(color: _hintColor)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(Post post) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: _primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Usuario UTVM',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                  fontSize: 14,
                ),
              ),
              Text(
                _formatTimeAgo(
                  DateTime.now(),
                ), // Aquí deberías usar post.createdAt
                style: TextStyle(color: _hintColor, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: _hintColor),
          onPressed: () => _showPostOptions(post),
        ),
      ],
    );
  }

  Widget _buildLikeButton(Post post) {
    return GestureDetector(
      onTap: () => _like(post),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: post.likes > 0
              ? _primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: post.likes > 0 ? _primaryColor : _hintColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              post.likes > 0 ? Icons.favorite : Icons.favorite_border,
              color: post.likes > 0 ? _errorColor : _hintColor,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              post.likes.toString(),
              style: TextStyle(
                color: post.likes > 0 ? _errorColor : _hintColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Ahora';
    if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes}m';
    if (difference.inHours < 24) return 'Hace ${difference.inHours}h';
    if (difference.inDays < 30) return 'Hace ${difference.inDays}d';
    return 'Hace ${(difference.inDays / 30).floor()}mes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Comunidad UTVM",
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: _textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: _textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        backgroundColor: Colors.white,
        color: _primaryColor,
        child: FutureBuilder<List<Post>>(
          future: _futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }

            final posts = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _buildPostCard(post);
              },
            );
          },
        ),
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
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(post),
            const SizedBox(height: 16),

            // Contenido del post
            if (post.content.isNotEmpty) ...[
              Text(
                post.content,
                style: TextStyle(color: _textColor, fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 12),
            ],

            // Emoji
            if (post.emoji.isNotEmpty) ...[
              Center(
                child: Text(post.emoji, style: const TextStyle(fontSize: 32)),
              ),
              const SizedBox(height: 12),
            ],

            // Acciones del post
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLikeButton(post),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        color: _hintColor,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share_outlined,
                        color: _hintColor,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: ShimmerLoading(),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: _errorColor, size: 64),
          const SizedBox(height: 16),
          Text(
            'Error al cargar publicaciones',
            style: TextStyle(
              color: _textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: _hintColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, color: _hintColor, size: 64),
          const SizedBox(height: 16),
          Text(
            'No hay publicaciones aún',
            style: TextStyle(
              color: _textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sé el primero en compartir algo',
            style: TextStyle(color: _hintColor),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatePostScreen(api: widget.api),
                ),
              );
              _refresh();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Crear primera publicación'),
          ),
        ],
      ),
    );
  }
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({super.key});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.5 + _controller.value * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 100, height: 12, color: Colors.grey),
                        const SizedBox(height: 4),
                        Container(width: 60, height: 10, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(width: double.infinity, height: 14, color: Colors.grey),
              const SizedBox(height: 8),
              Container(width: double.infinity, height: 14, color: Colors.grey),
              const SizedBox(height: 16),
              Container(width: 80, height: 20, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}
