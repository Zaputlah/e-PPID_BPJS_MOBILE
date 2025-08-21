import 'package:flutter/material.dart';
import 'package:ppid/widgets/app_drawer.dart';

class MonitoringPermohonanPage extends StatefulWidget {
  final String token;

  const MonitoringPermohonanPage({super.key, required this.token});

  @override
  State<MonitoringPermohonanPage> createState() =>
      _MonitoringPermohonanPageState();
}

class _MonitoringPermohonanPageState extends State<MonitoringPermohonanPage> {
  Map<String, dynamic>? userData;
  bool isLoading = false;

  final TextEditingController nomorController = TextEditingController();
  String? selectedUnitKerja;
  String? selectedStatus;
  DateTime? tglMulai;
  DateTime? tglAkhir;

  final List<String> unitKerjaList = ["Dinas A", "Dinas B", "Dinas C"];
  final List<String> statusList = ["Diproses", "Selesai", "Ditolak"];

  Future<void> _selectDate(BuildContext context, bool isMulai) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isMulai) {
          tglMulai = picked;
        } else {
          tglAkhir = picked;
        }
      });
    }
  }

  void _cariData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pencarian data...")),
    );
  }

  void _kosongkan() {
    setState(() {
      nomorController.clear();
      selectedUnitKerja = null;
      selectedStatus = null;
      tglMulai = null;
      tglAkhir = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoring"),
        backgroundColor: Colors.blue,
      ),
      drawer: AppDrawer(
        selectedMenu: "Monitoring",
        token: widget.token,
        userData: userData,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Judul biru
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Monitoring Permohonan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Kotak putih untuk form filter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: nomorController,
                          decoration: const InputDecoration(
                            labelText: "Nomor",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Unit Kerja",
                            border: OutlineInputBorder(),
                          ),
                          value: selectedUnitKerja,
                          items: unitKerjaList
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedUnitKerja = val),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Status",
                            border: OutlineInputBorder(),
                          ),
                          value: selectedStatus,
                          items: statusList
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedStatus = val),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "Tgl Mulai",
                              border: OutlineInputBorder(),
                            ),
                            child: Text(tglMulai == null
                                ? "-"
                                : "${tglMulai!.day}/${tglMulai!.month}/${tglMulai!.year}"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "Tgl Akhir",
                              border: OutlineInputBorder(),
                            ),
                            child: Text(tglAkhir == null
                                ? "-"
                                : "${tglAkhir!.day}/${tglAkhir!.month}/${tglAkhir!.year}"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _cariData,
                        child: const Text("Cari"),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _kosongkan,
                        child: const Text("Kosongkan"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "* Pencarian by tanggal pembuatan",
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Download data...")),
                      );
                    },
                    icon: const Icon(Icons.download),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    label: const Text("Download"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tabel data
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("No.")),
                  DataColumn(label: Text("Nomor")),
                  DataColumn(label: Text("Pemohon")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Tanggal Diproses")),
                  DataColumn(label: Text("Tanggal Selesai")),
                  DataColumn(label: Text("Action")),
                ],
                rows: const [], // nanti isi dari API
              ),
            ),
            const SizedBox(height: 8),
            const Text("Total: 0 Items."),
          ],
        ),
      ),
    );
  }
}
