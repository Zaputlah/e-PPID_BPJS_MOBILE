import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  final String baseUrl = "https://example.com/api"; // ganti sesuai API kamu

  Future<Map<String, dynamic>> requestPasswordReset(String username, String email) async {
    final url = Uri.parse("$baseUrl/forgot-password");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal request reset password (${response.statusCode})");
    }
  }
}
