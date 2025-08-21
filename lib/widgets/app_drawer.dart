import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ppid/pages/login_page.dart';
import 'package:ppid/pages/DashboardUserPage.dart';
import 'package:ppid/pages/entrian_page.dart';
import 'package:ppid/pages/monitoring_page.dart';
import 'package:ppid/pages/monitoring_keberatan_page.dart'; 

class AppDrawer extends StatelessWidget {
  final String selectedMenu;
  final String token;
  final Map<String, dynamic>? userData;

  const AppDrawer({
    super.key,
    required this.selectedMenu,
    required this.token,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Drawer(
        elevation: 8,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                userData?["nama"] ?? "User",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: Text(userData?["userId"] ?? "-"),
              currentAccountPicture: const CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.dashboard,
                    text: "Dashboard",
                    isSelected: selectedMenu == "Dashboard",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DashboardUserPage(token: token),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.edit_document,
                    text: "Entrian",
                    isSelected: selectedMenu == "Entrian",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EntrianPage(token: token),
                        ),
                      );
                    },
                  ),
                  // 🔹 Dropdown Monitoring
                  ExpansionTile(
                    leading: Icon(
                      Icons.monitor,
                      color: (selectedMenu.contains("Monitoring"))
                          ? Colors.blue
                          : Colors.grey[700],
                    ),
                    title: Text(
                      "Monitoring",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: (selectedMenu.contains("Monitoring"))
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          "Permohonan",
                          style: TextStyle(
                            color: selectedMenu == "MonitoringPermohonan"
                                ? Colors.blue
                                : Colors.black,
                            fontWeight: selectedMenu == "MonitoringPermohonan"
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MonitoringPermohonanPage(token: token),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Keberatan",
                          style: TextStyle(
                            color: selectedMenu == "MonitoringKeberatan"
                                ? Colors.blue
                                : Colors.black,
                            fontWeight: selectedMenu == "MonitoringKeberatan"
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MonitoringKeberatanPage(token: token),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () => _confirmLogout(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey[700],
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _confirmLogout(BuildContext context) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Logout",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: _buildLogoutDialog(context),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );

  if (result == true) {
    // Tampilkan animasi loading sebelum redirect
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );

    // Simulasi delay animasi sebelum logout
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userData');

    Navigator.of(context).pop(); // Tutup loading
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}

Widget _buildLogoutDialog(BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    backgroundColor: Colors.blue[50],
    title: Row(
      children: const [
        Icon(Icons.logout, color: Colors.red),
        SizedBox(width: 8),
        Text("Konfirmasi Logout"),
      ],
    ),
    content: const Text(
      "Kamu akan keluar dari aplikasi. Pastikan semua data sudah tersimpan. Lanjutkan?",
      style: TextStyle(fontSize: 15),
    ),
    actions: [
      TextButton.icon(
        onPressed: () => Navigator.of(context).pop(false),
        icon: const Icon(Icons.cancel, color: Colors.grey),
        label: const Text("Batal"),
      ),
      ElevatedButton.icon(
        onPressed: () => Navigator.of(context).pop(true),
        icon: const Icon(Icons.check_circle),
        label: const Text("Logout"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
      ),
    ],
  );
}
}