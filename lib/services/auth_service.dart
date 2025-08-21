import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/encryption_helper.dart';

class AuthService {
  static Future<Map<String, dynamic>> loginRequest(String username, String password) async {
    try {
      final encryptedUsername = EncryptionHelper.encryptToBase64(username);
      final encryptedPassword = EncryptionHelper.encryptToBase64(password);

      // print('📤 Username: $username');
      print('🔐 Encrypted Username: $encryptedUsername');
      // print('📤 Password: $password');
      print('🔐 Encrypted Password: $encryptedPassword');

      final uri = ApiConfig.getUri('LoginCtrl/Login');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': encryptedUsername,
          'password': encryptedPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['metadata']['code'] == 200) {
          final token = data['response']['zxcv'];
          final prefiktoken = 'RmazXc $token'; 
          return {
            'success': true,
            'data': data,
            'token': prefiktoken
          };
        } else {
          return {
            'success': false,
            'message': data['metadata']['message'] ?? 'Login gagal'
          };
        }
      } else {
        return {'success': false, 'message': 'Server error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan'};
    }
  }
}
