import 'package:flutter/material.dart';
import 'package:ppid/widgets/app_drawer.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class EntrianKeberatanPage extends StatefulWidget {
  final String token;

  const EntrianKeberatanPage({super.key, required this.token});

  @override
  State<EntrianKeberatanPage> createState() => _EntrianKeberatanPageState();
}

class _EntrianKeberatanPageState extends State<EntrianKeberatanPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController ktpController = TextEditingController();
  final TextEditingController pemohonController = TextEditingController();
  final TextEditingController instansiController = TextEditingController();
  final HtmlEditorController tujuanHtmlController = HtmlEditorController();

  // FocusNodes
  final FocusNode ktpFocus = FocusNode();
  final FocusNode pemohonFocus = FocusNode();
  final FocusNode instansiFocus = FocusNode();

  String? selectedNomorPermintaan;
  String? selectedAlasan;

  // Fungsi unfocus semua field termasuk HTML Editor
  void _unfocusAll() {
    FocusScope.of(context).unfocus();
    tujuanHtmlController.clearFocus();
  }

  @override
  void dispose() {
    ktpController.dispose();
    pemohonController.dispose();
    instansiController.dispose();
    ktpFocus.dispose();
    pemohonFocus.dispose();
    instansiFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hitung tinggi layar untuk menentukan tinggi HtmlEditor
    final double screenHeight = MediaQuery.of(context).size.height;
    final double editorHeight = screenHeight * 0.35; // sekitar 35% layar

    return GestureDetector(
      onTap: _unfocusAll, // Ketika tap di luar, semua field unfocus
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Form Pengajuan Keberatan"),
          backgroundColor: Colors.blue,
        ),
        drawer: AppDrawer(
          selectedMenu: "EntrianKeberatan",
          token: widget.token,
          userData: null,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Form Pengajuan Keberatan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 KTP / SIM / KITAS
                    TextFormField(
                      controller: ktpController,
                      focusNode: ktpFocus,
                      onTap: () => tujuanHtmlController.clearFocus(),
                      decoration: const InputDecoration(
                        labelText: "KTP/SIM/KITAS Pemohon *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),

                    // 🔹 Nama Pemohon
                    TextFormField(
                      controller: pemohonController,
                      focusNode: pemohonFocus,
                      onTap: () => tujuanHtmlController.clearFocus(),
                      decoration: const InputDecoration(
                        labelText: "Pemohon *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),

                    // 🔹 Instansi
                    TextFormField(
                      controller: instansiController,
                      focusNode: instansiFocus,
                      onTap: () => tujuanHtmlController.clearFocus(),
                      decoration: const InputDecoration(
                        labelText: "Instansi *",
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                      maxLength: 50,
                      validator: (val) {
                        if (val == null || val.isEmpty) return "Wajib diisi";
                        if (val.length < 10) return "Minimal 10 karakter";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // 🔹 Nomor Permintaan Informasi
                    DropdownButtonFormField<String>(
                      value: selectedNomorPermintaan,
                      decoration: const InputDecoration(
                        labelText: "Nomor Permintaan Informasi *",
                        border: OutlineInputBorder(),
                      ),
                      items: ["001/PPID/2025", "002/PPID/2025", "003/PPID/2025"]
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() {
                        selectedNomorPermintaan = val;
                        _unfocusAll();
                      }),
                      validator: (val) =>
                          val == null ? "Pilih salah satu" : null,
                    ),
                    const SizedBox(height: 12),

                    // 🔹 Alasan Pengajuan Keberatan
                    DropdownButtonFormField<String>(
                      value: selectedAlasan,
                      decoration: const InputDecoration(
                        labelText: "Alasan Pengajuan Keberatan Informasi *",
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        "Permintaan tidak ditanggapi",
                        "Permintaan ditolak",
                        "Informasi tidak sesuai"
                      ]
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() {
                        selectedAlasan = val;
                        _unfocusAll();
                      }),
                      validator: (val) =>
                          val == null ? "Pilih salah satu" : null,
                    ),
                    const SizedBox(height: 12),

                    // 🔹 Tujuan Pengajuan Keberatan (HTML Editor)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tujuan Pengajuan Keberatan *",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            ktpFocus.unfocus();
                            pemohonFocus.unfocus();
                            instansiFocus.unfocus();
                          },
                          child: Container(
                            height: editorHeight, // Lebarin ke bawah
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: HtmlEditor(
                              controller: tujuanHtmlController,
                              htmlEditorOptions: HtmlEditorOptions(
                                hint:
                                    "Tulis rincian informasi minimal 10 karakter",
                                shouldEnsureVisible: true,
                                initialText: """
                                  <html>
                                    <head>
                                      <style>
                                        body { 
                                          background-color: black !important; 
                                          color: white !important; 
                                          font-size: 14px !important; 
                                        }
                                      </style>
                                    </head>
                                    <body></body>
                                  </html>
                                """,
                              ),
                              htmlToolbarOptions: HtmlToolbarOptions(
                                defaultToolbarButtons: [
                                  StyleButtons(),
                                  FontSettingButtons(),
                                  ListButtons(),
                                  ParagraphButtons(),
                                  InsertButtons(),
                                  OtherButtons(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),

                    // 🔹 Tombol Submit
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text("Kirim"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Form berhasil disubmit ✅"),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}