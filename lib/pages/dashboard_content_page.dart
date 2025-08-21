import 'package:flutter/material.dart';
import 'package:ppid/pages/profile_card_page.dart';

class DashboardContent extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onLogout;
  final String token;

  const DashboardContent({
    super.key,
    required this.userData,
    required this.onLogout,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: Colors.white, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Selamat Datang di Layanan ePPID BPJS Kesehatan",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              "Terima kasih telah mengunjungi layanan e-PPID BPJS Kesehatan.\n\n"
              "Layanan ini merupakan sarana layanan online bagi pemohon informasi publik "
              "sebagai salah satu wujud pelaksanaan keterbukaan informasi publik di BPJS Kesehatan.\n\n"
              "👉 Untuk mengajukan permohonan informasi silakan masuk menu Permohonan.",
              style: TextStyle(fontSize: 14, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Profil Anda",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
          ),
          const SizedBox(height: 8),
          ProfileCard(
            nama: userData["nama"],
            userId: userData["userId"],
            onLogout: onLogout,
          ),
        ],
      ),
    );
  }
}
