import 'package:flutter/material.dart';
import 'package:ppid/widgets/app_drawer.dart';
import 'package:ppid/pages/dashboard_content_page.dart';

class DashboardUserPage extends StatefulWidget {
  final String token;

  const DashboardUserPage({super.key, required this.token});

  @override
  State<DashboardUserPage> createState() => _DashboardUserPageState();
}

class _DashboardUserPageState extends State<DashboardUserPage> {
  Map<String, dynamic>? userData;
  bool isLoading = false;

  Future<void> _confirmLogout() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue,
      ),
      drawer: AppDrawer(
        selectedMenu: "Dashboard",
        token: widget.token,
        userData: userData,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DashboardContent(
              userData: userData ?? {"nama": "User", "userId": "-"},
              onLogout: _confirmLogout,
              token: widget.token,
            ),
    );
  }
}
