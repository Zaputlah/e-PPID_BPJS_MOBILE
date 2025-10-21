import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ppid/pages/DashboardUserPage.dart';
import '../services/auth_service.dart';

class LoginController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final captchaController = TextEditingController();

  String generatedCaptcha = '';
  final _random = Random();

  bool isLoading = false;
  bool isFormValid = false;

  late BuildContext _context;
  late VoidCallback _refreshUI;

  void init(BuildContext context, VoidCallback refreshUI) {
    _context = context;
    _refreshUI = refreshUI;

    generatedCaptcha = _generateCaptcha();

    usernameController.addListener(_updateFormState);
    passwordController.addListener(_updateFormState);
    captchaController.addListener(_updateFormState);
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    captchaController.dispose();
  }

  void _updateFormState() {
    isFormValid =
        usernameController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        captchaController.text.trim().isNotEmpty;
    _refreshUI();
  }

  void refreshCaptcha() {
    generatedCaptcha = _generateCaptcha();
    _refreshUI();
  }

  void resetForm() {
    usernameController.clear();
    passwordController.clear();
    captchaController.clear();
    refreshCaptcha();
  }

  String _generateCaptcha() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(
      5,
      (index) => chars[_random.nextInt(chars.length)],
    ).join();
  }

  /// 🧠 Fungsi login dengan penyimpanan token
  Future<void> login() async {
    final captchaInput = captchaController.text.trim();
    if (captchaInput != generatedCaptcha) {
      _showDialog('Captcha tidak cocok', success: false);
      resetForm();
      return;
    }

    isLoading = true;
    _refreshUI();

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final response = await AuthService.loginRequest(username, password);

    isLoading = false;
    _refreshUI();

    if (response['success']) {
      final token = response['token'];

      // ✅ Simpan token ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Arahkan ke Dashboard
      Navigator.of(_context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardUserPage(token: token),
        ),
      );
    } else {
      _showDialog(response['message'], success: false);
      resetForm();
    }
  }

  /// 🔑 Ambil token yang tersimpan (untuk auto login)
  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// 🚪 Logout dan hapus token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  void _showDialog(String message, {bool success = false}) {
    showDialog(
      context: _context,
      builder: (context) => AlertDialog(
        title: Text(success ? 'Berhasil' : 'Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }
}
