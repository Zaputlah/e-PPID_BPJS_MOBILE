import 'package:flutter/material.dart';
import '../services/activation_service.dart';

class ActivationController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final ActivationService _service = ActivationService();
  bool isLoading = false;

  Future<void> submitActivation(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final code = codeController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username wajib diisi")),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email wajib diisi")),
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Format email tidak valid")),
      );
      return;
    }

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode aktivasi wajib diisi")),
      );
      return;
    }

    isLoading = true;

    try {
      final result = await _service.activateUser(username, email, code);
      final metadata = result["metadata"];
      final message = metadata?["message"] ?? "Aktivasi berhasil";

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Informasi"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      isLoading = false;
    }
  }

  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    codeController.dispose();
  }
}
