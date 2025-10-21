import 'package:flutter/material.dart';
import '../services/resend_activation_service.dart';

class ResendActivationController {
  final TextEditingController usernameController = TextEditingController();
  final ResendActivationService _service = ResendActivationService();

  bool isLoading = false;

  String sanitizeInput(String input) {
    final withoutTags = input.replaceAll(RegExp(r'<[^>]*>'), '');
    final safeString = withoutTags.replaceAll(
      RegExp(
        r"[;'\\"
        "]",
      ),
      '',
    );
    return safeString.trim();
  }

  Future<void> submit(BuildContext context) async {
    String username = sanitizeInput(usernameController.text);

    // Validasi kosong
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username tidak boleh kosong")),
      );
      return;
    }

    // Validasi panjang minimal & maksimal
    if (username.length < 3 || username.length > 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username harus 3-30 karakter")),
      );
      return;
    }

    // Validasi hanya huruf, angka, titik, underscore
    if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Username hanya boleh huruf, angka, titik, dan underscore",
          ),
        ),
      );
      return;
    }

    isLoading = true;
    try {
      final result = await _service.resendActivation(username);

      // ✅ Ambil pesan langsung dari server (metadata.message)
      final message =
          result["metadata"]?["message"] ?? "Tidak ada pesan dari server.";

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.info, color: Colors.blue, size: 28),
              SizedBox(width: 8),
              Text(
                "Informasi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx); // tutup dialog
                Navigator.pushReplacementNamed(context, '/activation_page');
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );

      usernameController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    } finally {
      isLoading = false;
    }
  }
}
