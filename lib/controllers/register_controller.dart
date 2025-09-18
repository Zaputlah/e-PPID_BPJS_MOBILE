import 'package:flutter/material.dart';
import 'package:ppid/services/register_service.dart';

class RegisterController {
  final TextEditingController nama = TextEditingController();
  final TextEditingController ktp = TextEditingController();
  final TextEditingController bpjs = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController nohp = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  int? selectedPekerjaanId;

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
    alamat.dispose();
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
    alamat.addListener(checkFormValidity);
    nohp.addListener(checkFormValidity);
    email.addListener(checkFormValidity);
    username.addListener(checkFormValidity);
    password.addListener(checkFormValidity);
    confirmPassword.addListener(checkFormValidity);
  }

  void setSelectedPekerjaan(int? id) {
    selectedPekerjaanId = id;
    checkFormValidity();
  }

  void checkFormValidity() {
    isFormValid =
        nama.text.trim().isNotEmpty &&
            ktp.text.trim().length == 16 &&
            bpjs.text.trim().isNotEmpty &&
            alamat.text.trim().isNotEmpty &&
            selectedPekerjaanId != null &&
            nohp.text.trim().isNotEmpty &&
            email.text.trim().isNotEmpty &&
            username.text.trim().isNotEmpty &&
            password.text.trim().isNotEmpty &&
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
      'username': username.text.trim(),
      'email': email.text.trim(),
      'password': password.text.trim(),
      'kpassword': confirmPassword.text.trim(),
      'nama': nama.text.trim(),
      'noidentitas': ktp.text.trim(),
      'noka': bpjs.text.trim(),
      'alamat': alamat.text.trim(),
      'pekerjaan': (selectedPekerjaanId ?? 0).toString(), // <- fix
      'nohp': nohp.text.trim(),
    };


    final response = await RegisterService.registerUser(data);

    isLoading = false;
    _refreshUI();

    if (response['success']) {
      _showDialog("Registrasi berhasil. Silakan cek email untuk aktivasi.",
          success: true, onClose: () {
            Navigator.pushNamed(_context, '/activation');
          });
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
              Icon(success ? Icons.check_circle_outline : Icons.error_outline,
                  color: success ? Colors.green : Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(success ? 'Berhasil' : 'Gagal',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: success ? Colors.green : Colors.red)),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: success ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
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
}
