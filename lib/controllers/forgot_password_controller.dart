import 'package:flutter/material.dart';
import '../services/forgot_password_service.dart';

class ForgotPasswordController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ForgotPasswordService _service = ForgotPasswordService();

  // Notifier untuk loading state (bisa dipakai di UI pakai ValueListenableBuilder)
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> submitForgotPassword(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();

    // 🔸 Validasi form
    if (username.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan email wajib diisi")),
      );
      return;
    }

    if (!RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$").hasMatch(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Format email tidak valid")));
      return;
    }

    isLoading.value = true;

    try {
      // 🔹 Panggil service untuk kirim request lupa password
      final result = await _service.requestPasswordReset(username, email);

      // 🔹 Ambil pesan langsung dari backend (metadata.message)
      final message =
          result["metadata"]?["message"] ?? "Tidak ada pesan dari server.";

      // 🔹 Tampilkan pesan dari server di popup
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
      // 🔹 Tangani error (misal koneksi atau JSON parsing)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    isLoading.dispose();
  }
}
