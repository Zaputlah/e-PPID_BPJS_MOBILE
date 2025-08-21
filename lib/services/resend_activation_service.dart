import 'dart:convert';
import 'package:http/http.dart' as http;

class ResendActivationService {
  final String baseUrl = "https://e-ppid.bpjs-kesehatan.go.id/eppid";

  Future<Map<String, dynamic>> resendActivation(String username) async {
    final url = Uri.parse("$baseUrl/LoginCtrl/KirimUlangEmail");

    final response = await http.post(
      url,
      body: {
        "username": username,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengirim ulang kode aktivasi. Status: ${response.statusCode}");
    }
  }
}
