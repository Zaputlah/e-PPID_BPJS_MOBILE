import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ActivationService {
  final String _baseUrl =
      "https://dvlp.bpjs-kesehatan.go.id/PpidAPI/api/v1.0/Auth/Aktivasi";

  Future<Map<String, dynamic>> activateUser(
      String username, String email, String kode) async {
    final client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; // bypass SSL

    final ioClient = IOClient(client);

    final body = jsonEncode({
      "username": username,
      "email": email,
      "kode": kode,
    });

    final response = await ioClient.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 500) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal menghubungi server: ${response.statusCode}");
    }
  }
}
