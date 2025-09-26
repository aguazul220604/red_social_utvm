import 'package:flutter/material.dart';
import 'package:red_social_utvm/service/api_service.dart';

class RegisterScreen extends StatefulWidget {
  final ApiService api;

  const RegisterScreen({super.key, required this.api});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true; // para mostrar/ocultar contraseña
  bool _obscureConfirmPassword = true; // para mostrar/ocultar confirmación

  void _register() {
    // Ejemplo simple de validación de contraseñas
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }

    // Aquí iría la llamada a la API:
    // widget.api.registerUser(...);

    Navigator.pop(context); // Regresa al login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrarse")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nombre
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nombre",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),

            // Correo
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Correo",
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            // Contraseña
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Contraseña",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Confirmar Contraseña
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: "Confirmar contraseña",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _register,
              child: const Text("Registrarme"),
            ),
          ],
        ),
      ),
    );
  }
}
