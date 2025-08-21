import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String nama;
  final String userId;
  final VoidCallback onLogout;

  const ProfileCard({
    super.key,
    required this.nama,
    required this.userId,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              nama,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userId,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profil"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Keluar"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
