import 'dart:convert';
import 'package:http/http.dart' as http;

class ResendActivationService {
  final String baseUrl = "https://dvlp.bpjs-kesehatan.go.id/PpidAPI";

  Future<Map<String, dynamic>> resendActivation(String username) async {
    final url = Uri.parse("$baseUrl/api/v1.0/Auth/Aktivasi/Resend");

    final headers = {
      "Content-Type": "application/json", // penting!
      "Accept": "application/json", // opsional tapi disarankan
    };

    final body = jsonEncode({"username": username});

    final response = await http.post(url, headers: headers, body: body);

    print(
      "🔹 [ResendActivationService] Response status: ${response.statusCode}",
    );
    print("🔹 [ResendActivationService] Response body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print("❌ Gagal decode JSON: $e");
        throw Exception("Gagal parsing respons JSON: ${response.body}");
      }
    } else {
      print(
        "❌ Gagal kirim ulang kode aktivasi. Status: ${response.statusCode}",
      );
      throw Exception(
        "Gagal mengirim ulang kode aktivasi. Status: ${response.statusCode}",
      );
    }
  }
}
