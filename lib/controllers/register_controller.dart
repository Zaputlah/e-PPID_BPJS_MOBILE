import 'package:flutter/material.dart';
import 'package:ppid/services/register_service.dart';

class RegisterController {
  final TextEditingController nama = TextEditingController();
  final TextEditingController ktp = TextEditingController();
  final TextEditingController bpjs = TextEditingController();
  final TextEditingController npwp = TextEditingController();
  final TextEditingController nim = TextEditingController();
  final TextEditingController pekerjaan = TextEditingController();
  final TextEditingController nohp = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  late BuildContext _context;
  late VoidCallback _refreshUI;

  bool isLoading = false;
  bool isFormValid = false;

  void init(BuildContext context, VoidCallback refreshUI) {
    _context = context;
    _refreshUI = refreshUI;
    _addListeners();
  }

  void dispose() {
    nama.dispose();
    ktp.dispose();
    bpjs.dispose();
    npwp.dispose();
    nim.dispose();
    pekerjaan.dispose();
    nohp.dispose();
    email.dispose();
    username.dispose();
    password.dispose();
    confirmPassword.dispose();
  }

  void _addListeners() {
    nama.addListener(checkFormValidity);
    ktp.addListener(checkFormValidity);
    bpjs.addListener(checkFormValidity);
    npwp.addListener(checkFormValidity);
    nim.addListener(checkFormValidity);
    pekerjaan.addListener(checkFormValidity);
    nohp.addListener(checkFormValidity);
    email.addListener(checkFormValidity);
    username.addListener(checkFormValidity);
    password.addListener(checkFormValidity);
    confirmPassword.addListener(checkFormValidity);
  }

  void checkFormValidity() {
    isFormValid =
        isOnlyLetters(nama.text, maxLength: 100) &&
        isValid16DigitNumber(ktp.text, exactLength: 16) &&
        isValidBpjs(bpjs.text) &&
        isValidNPWP(npwp.text) &&
        isValidMahasiswa(nim.text) &&
        isOnlyLetters(pekerjaan.text) &&
        isValidPhone(nohp.text) &&
        isValidEmail(email.text) &&
        username.text.trim().isNotEmpty &&
        isValidPassword(password.text) &&
        password.text == confirmPassword.text;

    _refreshUI();
  }

  Future<void> submitRegister() async {
    if (!isFormValid) {
      _showDialog('Silakan lengkapi semua data dengan benar', success: false);
      return;
    }

    isLoading = true;
    _refreshUI();

    final data = {
      'nama': nama.text.trim(),
      'noktp': ktp.text.trim(),
      'nokartu': bpjs.text.trim(),
      'npwp': npwp.text.replaceAll(RegExp(r'\D'), ''),
      'nim': nim.text.trim(),
      'pekerjaan': pekerjaan.text.trim(),
      'nohp': nohp.text.trim(),
      'email': email.text.trim(),
      'username': username.text.trim(),
      'pwd': password.text.trim(),
      'konfirmpwd': confirmPassword.text.trim(),
    };

    print("Data yang dikirim:");
      data.forEach((key, value) {
        print("$key: $value");
      });
      
    final response = await RegisterService.registerUser(data);

    print("res "+ response.toString());

    isLoading = false;
    _refreshUI();

    if (response['success']) {
      _showDialog(
        "Registrasi berhasil. Silakan cek email untuk aktivasi.",
        success: true,
        onClose: () {
          Navigator.pushNamed(_context, '/activation');
        },
      );
    } else {
      _showDialog(response['message'] ?? 'Gagal registrasi', success: false);
    }
  }

  void _showDialog(String message, {bool success = false, VoidCallback? onClose}) {
    showDialog(
      context: _context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.check_circle_outline : Icons.error_outline,
                color: success ? Colors.green : Colors.red,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                success ? 'Berhasil' : 'Gagal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: success ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: success ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.of(_context).pop();
                  if (onClose != null) onClose();
                },
                child: const Text("Tutup"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== VALIDASI ====================

  bool isOnlyLetters(String input, {int maxLength = 50}) {
    final cleaned = input.trim();
    if (cleaned.isEmpty || cleaned.length > maxLength) return false;
    return RegExp(r"^[\p{L}\s]+$", unicode: true).hasMatch(cleaned);
  }
  

  bool isValidBpjs(String input, {int? maxLength}) {
    final cleaned = input.trim();
    if (cleaned.isEmpty) return false;
    if (maxLength != null && cleaned.length > maxLength) return false;
    return RegExp(r'^\d+$').hasMatch(cleaned);
  }

  bool isValid16DigitNumber(String input, {int exactLength = 16}) {
  final cleaned = input.trim();
  return cleaned.length == exactLength && RegExp(r'^\d+$').hasMatch(cleaned);
}


  bool isValidPhone(String input) {
    return RegExp(r'^0\d{9,14}$').hasMatch(input.trim());
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(email.trim());
  }

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,15}$')
        .hasMatch(password.trim());
  }

  bool isValidNPWP(String npwp) {
    final raw = npwp.replaceAll(RegExp(r'\D'), '');
    return RegExp(r'^\d{15}$').hasMatch(raw);
  }

  bool isValidMahasiswa(String input) {
    final cleaned = input.trim();
    return RegExp(r'^\d{8,12}$').hasMatch(cleaned);
  }
}
