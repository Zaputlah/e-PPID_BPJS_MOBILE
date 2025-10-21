import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ppid/pages/DashboardUserPage.dart';
import 'package:ppid/pages/dashboard_content_page.dart';
import 'package:ppid/widgets/app_drawer.dart';

class MonitoringKeberatanPage extends StatefulWidget {
  final String token;

  const MonitoringKeberatanPage({super.key, required this.token});

  @override
  State<MonitoringKeberatanPage> createState() =>
      _MonitoringKeberatanPageState();
}

class _MonitoringKeberatanPageState extends State<MonitoringKeberatanPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  final List<Map<String, String>> _data = [];

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _endDate = picked;
          _endController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  void _search() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pencarian data berdasarkan tanggal")),
    );
  }

  void _refresh() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _startController.clear();
      _endController.clear();
      _data.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoring Keberatan Informasi"),
        backgroundColor: Colors.blue,
      ),
      drawer: AppDrawer(
        selectedMenu: "MonitoringKeberatan",
        token: widget.token,
        userData: {"nama": "User Demo", "userId": "demo123"},
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Monitoring Keberatan Informasi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardUserPage(
                            token: widget.token, // wajib
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('home'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Input tanggal horizontal + tombol Cari
            // Input tanggal vertikal + tombol Cari
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tanggal Awal
                TextFormField(
                  readOnly: true,
                  controller: _startController,
                  decoration: InputDecoration(
                    labelText: "Tanggal Awal",
                    prefixIcon: const Icon(Icons.date_range),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onTap: () => _selectDate(context, true),
                ),
                const SizedBox(height: 12),

                // Tanggal Akhir
                TextFormField(
                  readOnly: true,
                  controller: _endController,
                  decoration: InputDecoration(
                    labelText: "Tanggal Akhir",
                    prefixIcon: const Icon(Icons.date_range),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onTap: () => _selectDate(context, false),
                ),
                const SizedBox(height: 12),

                // Tombol Cari
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _search,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cari",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "* Pencarian by tanggal pembuatan",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tabel Data
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue[100],
                    ),
                    columns: const [
                      DataColumn(label: Text("No.")),
                      DataColumn(label: Text("Nomor")),
                      DataColumn(label: Text("Nama Pemohon")),
                      DataColumn(label: Text("Tgl.")),
                      DataColumn(label: Text("Status")),
                    ],
                    rows: _data.isEmpty
                        ? [
                            const DataRow(
                              cells: [
                                DataCell(Text("-")),
                                DataCell(Text("-")),
                                DataCell(
                                  Text(
                                    "Tidak ada data",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                DataCell(Text("-")),
                                DataCell(Text("-")),
                              ],
                            ),
                          ]
                        : List.generate(_data.length, (index) {
                            final item = _data[index];
                            return DataRow(
                              color: MaterialStateProperty.resolveWith(
                                (states) => index % 2 == 0
                                    ? Colors.grey[100]
                                    : Colors.white,
                              ),
                              cells: [
                                DataCell(Text("${index + 1}")),
                                DataCell(Text(item["nomor"] ?? "-")),
                                DataCell(Text(item["pemohon"] ?? "-")),
                                DataCell(Text(item["tanggal"] ?? "-")),
                                DataCell(Text(item["status"] ?? "-")),
                              ],
                            );
                          }),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total : ${_data.length} Items",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.orange),
                  onPressed: _refresh,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
