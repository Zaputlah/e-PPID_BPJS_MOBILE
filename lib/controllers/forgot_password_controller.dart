import 'package:flutter/material.dart';
import '../services/forgot_password_service.dart';

class ForgotPasswordController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final ForgotPasswordService _service = ForgotPasswordService();
  bool isLoading = false;

  Future<void> submitForgotPassword(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();

    // Validasi input
    if (username.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan email wajib diisi")),
      );
      return;
    }

    // Validasi email sederhana
    if (!RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$").hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Format email tidak valid")),
      );
      return;
    }

    isLoading = true;

    try {
      final result = await _service.requestPasswordReset(username, email);
      final message = result["message"] ?? "Permintaan reset password berhasil";

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
}
