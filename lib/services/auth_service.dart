import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/encryption_helper.dart';

class AuthService {
  /// Fungsi untuk melakukan login ke API
  static Future<Map<String, dynamic>> loginRequest(
    String username,
    String password,
  ) async {
    try {
      // Enkripsi username dan password sebelum dikirim
      final encryptedUsername = EncryptionHelper.encryptToBase64(username);
      final encryptedPassword = EncryptionHelper.encryptToBase64(password);

      // Siapkan request body
      final requestBody = {
        'username': encryptedUsername,
        'password': encryptedPassword,
      };

      // Tampilkan request params untuk debugging
      // print('📤 Request Params (JSON body): ${jsonEncode(requestBody)}');
      print('🔐 Encrypted Username: $encryptedUsername');
      print('🔐 Encrypted Password: $encryptedPassword');

      // Endpoint login
      final uri = Uri.parse(
        'https://dvlp.bpjs-kesehatan.go.id/PpidAPI/api/v1.0/Auth/User/Login',
      );

      // Kirim POST request
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Print response server
      print('📡 Response Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      // Cek status HTTP
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Cek metadata dari response API
        if (data['metadata'] != null && data['metadata']['code'] == 200) {
          final token = data['response']?['zxcv'];
          final prefiktoken = 'RmazXc $token';

          return {'success': true, 'data': data, 'token': prefiktoken};
        } else {
          return {
            'success': false,
            'message': data['metadata']?['message'] ?? 'Login gagal',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error (${response.statusCode})',
        };
      }
    } catch (e) {
      print('❌ Error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan jaringan atau parsing data',
      };
    }
  }
}
