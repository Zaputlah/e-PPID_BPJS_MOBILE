import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  final String baseUrl = "https://dvlp.bpjs-kesehatan.go.id/PpidAPI";

  Future<Map<String, dynamic>> requestPasswordReset(
    String username,
    String email,
  ) async {
    final url = Uri.parse("$baseUrl/api/v1.0/Auth/LupaPassword");

    final body = jsonEncode({"username": username, "email": email});

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json", // 🔹 wajib!
      },
      body: body,
    );

    // Debug print
    print("📤 [ForgotPasswordService] Body: $body");
    print("🔹 [ForgotPasswordService] Status: ${response.statusCode}");
    print("🔹 [ForgotPasswordService] Response: ${response.body}");

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw Exception("Gagal parsing JSON: ${response.body}");
      }
    } else {
      throw Exception("Gagal request reset password (${response.statusCode})");
    }
  }
}
