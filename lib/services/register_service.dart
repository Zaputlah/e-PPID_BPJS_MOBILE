import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static Future<Map<String, dynamic>> registerUser(
    Map<String, String> data,
  ) async {
    final uri = Uri.parse(
      'https://dvlp.bpjs-kesehatan.go.id/PpidAPI/api/v1.0/Auth/Registrasi',
    );

    print('Mengirim ke: $uri');
    print('Data: $data');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final json = jsonDecode(response.body);

      final code = json['metadata']?['code'];
      final message = json['metadata']?['message'] ?? 'Terjadi kesalahan';

      return {'success': code == 200, 'message': message};
    } catch (e) {
      print('Error: $e');
      return {'success': false, 'message': 'Gagal menghubungi server: $e'};
    }
  }
}
