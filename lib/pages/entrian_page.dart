import 'package:flutter/material.dart';
import 'package:ppid/widgets/app_drawer.dart';

class EntrianPage extends StatefulWidget {
  final String token;

  const EntrianPage({super.key, required this.token});

  @override
  State<EntrianPage> createState() => _EntrianPageState();
}

class _EntrianPageState extends State<EntrianPage> {
  Map<String, dynamic>? userData; 
  bool isLoading = false;

  Future<void> _confirmLogout() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrian"),
        backgroundColor: Colors.blue,
      ),

      drawer: AppDrawer(
        selectedMenu: "Entrian",
        token: widget.token,
        userData: userData,
      ),

      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "Halaman Entrian\n\n"
            "Di sini nantinya bisa ditampilkan form entrian data, "
            "atau daftar entrian yang sudah dibuat.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
