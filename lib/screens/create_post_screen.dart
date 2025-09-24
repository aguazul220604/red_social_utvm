import 'package:flutter/material.dart';
import 'package:red_social_utvm/service/api_service.dart';

class CreatePostScreen extends StatefulWidget {
  final ApiService api;
  const CreatePostScreen({super.key, required this.api});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _controller = TextEditingController();
  String _selectedEmoji = "😀"; // Emoji por defecto

  final List<String> _emojiOptions = ["😀", "😂", "🔥", "❤️", "⚡"];

  void _publish() async {
    if (_controller.text.isEmpty) return;
    await widget.api.createPost(_controller.text, _selectedEmoji);
    _controller.clear();
    if (mounted) {
      Navigator.pop(context); // Regresa al feed después de publicar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva publicación")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Escribe tu publicación...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: _emojiOptions.map((emoji) {
                return ChoiceChip(
                  label: Text(emoji, style: const TextStyle(fontSize: 20)),
                  selected: _selectedEmoji == emoji,
                  onSelected: (_) {
                    setState(() => _selectedEmoji = emoji);
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(onPressed: _publish, child: const Text("Publicar")),
          ],
        ),
      ),
    );
  }
}
