import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ppid/pages/login_page.dart';
import 'package:ppid/pages/DashboardUserPage.dart';
import 'package:ppid/pages/entrian_permohonan.dart';
import 'package:ppid/pages/entrian_keberatan.dart';
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
            // 🔹 Header User
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
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

            // 🔹 Menu Utama
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 6),
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

                  // 🔹 Entrian Section
                  _buildExpandableMenu(
                    context,
                    title: "Entrian",
                    icon: Icons.edit_document,
                    isSelected: selectedMenu.contains("Entrian"),
                    children: [
                      _buildSubMenu(
                        context,
                        title: "Permohonan",
                        isSelected: selectedMenu == "EntrianPermohonan",
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EntrianPermohonanPage(token: token),
                            ),
                          );
                        },
                      ),
                      _buildSubMenu(
                        context,
                        title: "Keberatan",
                        isSelected: selectedMenu == "EntrianKeberatan",
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EntrianKeberatanPage(token: token), // ✅ FIX
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // 🔹 Monitoring Section
                  _buildExpandableMenu(
                    context,
                    title: "Monitoring",
                    icon: Icons.analytics,
                    isSelected: selectedMenu.contains("Monitoring"),
                    children: [
                      _buildSubMenu(
                        context,
                        title: "Permohonan",
                        isSelected: selectedMenu == "MonitoringPermohonan",
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
                      _buildSubMenu(
                        context,
                        title: "Keberatan",
                        isSelected: selectedMenu == "MonitoringKeberatan",
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

            // 🔹 Logout
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

  // 🔹 Drawer Item Biasa
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey[700]),
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

  // 🔹 Expandable Menu (Entrian / Monitoring)
  Widget _buildExpandableMenu(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.blue.withOpacity(0.08) : Colors.transparent,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey[700]),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
          children: children,
        ),
      ),
    );
  }

  // 🔹 Sub Menu Item
  Widget _buildSubMenu(BuildContext context,
      {required String title,
      required bool isSelected,
      required VoidCallback onTap}) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 60, right: 16),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }

  // 🔹 Logout Confirmation
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
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );

    if (result == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('userData');

      Navigator.of(context).pop(); // close loading
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  Widget _buildLogoutDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
}
