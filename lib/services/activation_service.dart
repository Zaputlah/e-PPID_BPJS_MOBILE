import 'dart:convert';
import 'package:http/http.dart' as http;

class ActivationService {
  final String _baseUrl = "https://e-ppid.bpjs-kesehatan.go.id/eppid/LoginCtrl/AktivasiUser";

  Future<Map<String, dynamic>> activateUser(String username, String code) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "kode_aktivasi": code,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal menghubungi server: ${response.statusCode}");
    }
  }
}
