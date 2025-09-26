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
  String _selectedEmoji = "😀";
  bool _isLoading = false;

  final List<String> _emojiOptions = [
    "😀",
    "😂",
    "😍",
    "🔥",
    "❤️",
    "⚡",
    "🎉",
    "🙏",
    "👍",
    "✨",
  ];

  // Colores consistentes con la aplicación
  final Color _primaryColor = const Color(0xFF6366F1);
  final Color _secondaryColor = const Color(0xFF10B981);
  final Color _backgroundColor = const Color(0xFFF8FAFC);
  final Color _textColor = const Color(0xFF1E293B);
  final Color _hintColor = const Color(0xFF64748B);
  final Color _errorColor = const Color(0xFFEF4444);

  void _publish() async {
    if (_controller.text.trim().isEmpty) {
      _showError("Por favor escribe algo para publicar");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.api.createPost(_controller.text.trim(), _selectedEmoji);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("¡Publicación creada exitosamente!"),
            backgroundColor: _secondaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showError("Error al publicar: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _selectEmoji(String emoji) {
    setState(() {
      _selectedEmoji = emoji;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: _textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Crear Publicación",
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "${_controller.text.length}/280",
                style: TextStyle(
                  color: _controller.text.length > 280
                      ? _errorColor
                      : _hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del usuario
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: _primaryColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Usuario UTVM",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Público",
                            style: TextStyle(color: _hintColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Campo de texto
                Container(
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
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "¿Qué quieres compartir con la comunidad?",
                      hintStyle: TextStyle(color: _hintColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    maxLines: 6,
                    maxLength: 280,
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 16,
                      height: 1.4,
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),

                const SizedBox(height: 8),

                // Contador de caracteres
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${_controller.text.length}/280",
                    style: TextStyle(
                      color: _controller.text.length > 280
                          ? _errorColor
                          : _hintColor,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Selección de emoji
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selecciona un estado de ánimo",
                      style: TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Emoji seleccionado preview
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                      child: Column(
                        children: [
                          Text(
                            _selectedEmoji,
                            style: const TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getEmojiDescription(_selectedEmoji),
                            style: TextStyle(color: _hintColor, fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Grid de emojis
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: _emojiOptions.length,
                      itemBuilder: (context, index) {
                        final emoji = _emojiOptions[index];
                        return GestureDetector(
                          onTap: () => _selectEmoji(emoji),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: _selectedEmoji == emoji
                                  ? _primaryColor.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedEmoji == emoji
                                    ? _primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Botón de publicar
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _controller.text.trim().isEmpty || _isLoading
                        ? null
                        : _publish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            "Publicar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botón cancelar
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _hintColor,
                      side: BorderSide(color: _hintColor.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getEmojiDescription(String emoji) {
    switch (emoji) {
      case "😀":
        return "Feliz";
      case "😂":
        return "Divertido";
      case "😍":
        return "Enamorado";
      case "🔥":
        return "Increíble";
      case "❤️":
        return "Amor";
      case "⚡":
        return "Energético";
      case "🎉":
        return "Celebración";
      case "🙏":
        return "Agradecido";
      case "👍":
        return "De acuerdo";
      case "✨":
        return "Mágico";
      default:
        return "Emoción";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
