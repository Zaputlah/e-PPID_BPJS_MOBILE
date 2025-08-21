import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import '../config/api_config.dart';

class RegisterService {
  static Future<Map<String, dynamic>> registerUser(Map<String, String> data) async {
    final uri = ApiConfig.getUri('LoginCtrl/RegistrasiUser');

    print(uri);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return {
        'success': json['status'] == 'success',
        'message': json['metadata']?['message'] ?? 'Registrasi gagal',
      };
    } else {
      return {'success': false, 'message': 'Server error'};
    }
  }
}
