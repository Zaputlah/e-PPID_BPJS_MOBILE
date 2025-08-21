import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/register_controller.dart';
import '../formaters/npwp_input_formatter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controller = RegisterController();
  final Map<String, String?> _errorMessages = {};

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    controller.init(context, () => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFEF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Text(
                  "Registrasi Permohonan Informasi",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildField(controller.nama, "Nama Lengkap", maxLength: 100),
                    _buildField(controller.ktp, "No KTP / SIM / KITA", maxLength: 16),
                    _buildField(controller.bpjs, "Nomor BPJS Kesehatan", maxLength: 13),
                    _buildField(controller.npwp, "NPWP"),
                    _buildField(controller.nim, "Nomor Mahasiswa", maxLength: 17),
                    _buildField(controller.pekerjaan, "Pekerjaan"),
                    _buildField(controller.nohp, "Nomor Handphone"),
                    _buildField(controller.email, "Email"),
                    _buildField(controller.username, "Username"),
                    _buildPasswordField(controller.password, "Password", isConfirm: false),
                    _buildPasswordField(controller.confirmPassword, "Konfirmasi Password", isConfirm: true),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.isLoading || !controller.isFormValid
                                ? null
                                : controller.submitRegister,
                            icon: const Icon(Icons.app_registration),
                            label: controller.isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text("Register"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text("Kembali"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.black12),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "* Password 8-15 karakter, minimal 1 huruf besar, 1 huruf kecil, 1 angka & 1 karakter spesial\n"
                      "* Isi data dengan benar\n"
                      "* Setelah registrasi, cek email untuk aktivasi",
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController c, String label, {bool obscure = false, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        obscureText: obscure,
        maxLength: maxLength,
        keyboardType: _getKeyboardType(label),
        inputFormatters: _getInputFormatter(label),
        onChanged: (_) {
          controller.checkFormValidity();
          _validateField(c, label);
          setState(() {});
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          errorText: _errorMessages[label],
          counterText: "", // hide character counter
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController c, String label, {required bool isConfirm}) {
    bool isObscure = isConfirm ? _obscureConfirmPassword : _obscurePassword;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        obscureText: isObscure,
        onChanged: (_) {
          controller.checkFormValidity();
          _validateField(c, label);
          setState(() {});
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          errorText: _errorMessages[label],
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                if (isConfirm) {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                } else {
                  _obscurePassword = !_obscurePassword;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  // ================= VALIDASI ===================

  void _validateField(TextEditingController c, String label) {
    final text = c.text.trim();

    switch (label) {
      case "Nama Lengkap":
        _errorMessages[label] = text.isEmpty
            ? "Nama tidak boleh kosong"
            : (text.length > 100 ? "Nama maksimal 100 karakter" : null);
        break;
      case "Pekerjaan":
        _errorMessages[label] = RegExp(r"^[a-zA-Z\s]+$").hasMatch(text)
            ? null
            : "Hanya huruf dan spasi";
        break;

        case "No KTP / SIM / KITA":
        _errorMessages[label] = text.length == 16
            ? null
            : "KTP/SIM/KITA harus 16 karakter";
        break;

      case "Nomor BPJS Kesehatan":
        _errorMessages[label] = text.length == 13
            ? null
            : "BPJS harus 13 digit";
        break;
      case "NPWP":
        _errorMessages[label] = RegExp(r'^\d{2}\.\d{3}\.\d{3}\.\d-\d{3}\.\d{3}$').hasMatch(text)
            ? null
            : "Format NPWP tidak valid atau belum lengkap";
        break;

      case "Nomor Mahasiswa":
      _errorMessages[label] = RegExp(r"^[a-zA-Z0-9]{8,17}$").hasMatch(text)
          ? null
          : "NIM harus 8–17 karakter";
      break;

      case "Nomor Handphone":
        _errorMessages[label] = RegExp(r"^0\d{9,14}$").hasMatch(text)
            ? null
            : "Format nomor tidak valid";
        break;
      case "Email":
        _errorMessages[label] = RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(text)
            ? null
            : "Email tidak valid";
        break;
      case "Password":
        _errorMessages[label] = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,15}$')
                .hasMatch(text)
            ? null
            : "Password tidak valid";
        break;
      case "Konfirmasi Password":
        _errorMessages[label] = text == controller.password.text
            ? null
            : "Password tidak cocok";
        break;
      default:
        _errorMessages[label] = null;
    }
  }

  List<TextInputFormatter>? _getInputFormatter(String label) {
    switch (label) {
      case "Nama Lengkap":
      case "Pekerjaan":
        return [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]"))];
      case "No KTP / SIM / KITA":
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-]'))];
      case "Nomor BPJS Kesehatan":
        return [FilteringTextInputFormatter.digitsOnly ];
      case "NPWP":
        return [FilteringTextInputFormatter.digitsOnly, NPWPInputFormatter()];
      case "Nomor Mahasiswa":
      case "Nomor Handphone":
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  TextInputType? _getKeyboardType(String label) {
    switch (label) {
      case "No KTP / SIM / KITA":
      case "Nomor BPJS Kesehatan":
      case "NPWP":
      case "Nomor Mahasiswa":
      case "Nomor Handphone":
        return TextInputType.number;
      case "Email":
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }
}
