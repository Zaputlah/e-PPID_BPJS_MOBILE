import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NPWPInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    String formatted = '';
    for (int i = 0; i < digitsOnly.length && i < 15; i++) {
      formatted += digitsOnly[i];

      if (i == 1 || i == 4 || i == 7) {
        formatted += '.';
      } else if (i == 8) {
        formatted += '-';
      } else if (i == 11) {
        formatted += '.';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class NPWPField extends StatefulWidget {
  final TextEditingController controller;
  const NPWPField({super.key, required this.controller});

  @override
  State<NPWPField> createState() => _NPWPFieldState();
}

class _NPWPFieldState extends State<NPWPField> {
  String? _errorText;

  final _npwpPattern = RegExp(r'^\d{2}\.\d{3}\.\d{3}\.\d-\d{3}\.\d{3}$');

  void _validate(String value) {
    if (value.isEmpty) {
      setState(() => _errorText = 'NPWP tidak boleh kosong');
    } else if (!_npwpPattern.hasMatch(value)) {
      setState(() => _errorText = 'Format NPWP tidak valid atau belum lengkap');
    } else {
      setState(() => _errorText = null); // valid
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        NPWPInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: 'NPWP',
        errorText: _errorText,
      ),
      onChanged: _validate,
    );
  }
}
