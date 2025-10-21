import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ppid/widgets/app_drawer.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class EntrianPermohonanPage extends StatefulWidget {
  final String token;
  const EntrianPermohonanPage({super.key, required this.token});

  @override
  State<EntrianPermohonanPage> createState() => _EntrianPermohonanPageState();
}

class _EntrianPermohonanPageState extends State<EntrianPermohonanPage> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController ktpController = TextEditingController();
  final TextEditingController pemohonController = TextEditingController();
  final TextEditingController instansiController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController hpController = TextEditingController();

  // HTML Editor Controllers
  final HtmlEditorController alasanHtmlController = HtmlEditorController();
  final HtmlEditorController rincianHtmlController = HtmlEditorController();

  // FocusNodes
  final FocusNode ktpFocus = FocusNode();
  final FocusNode pemohonFocus = FocusNode();
  final FocusNode instansiFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode hpFocus = FocusNode();

  String? selectedKeperluan;
  String? selectedJenisPermohonan;

  File? fileIdentitas;
  File? filePermintaan;
  File? fileSuratPengantar;
  File? fileFormulir;

  // Fungsi unfocus semua
  void _unfocusAll() {
    FocusScope.of(context).unfocus();
    alasanHtmlController.clearFocus();
    rincianHtmlController.clearFocus();
  }

  Future<void> _pickFile(Function(File) onFilePicked) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      withData: true,
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final sizeInMb = file.lengthSync() / (1024 * 1024);
      if (sizeInMb > 2) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("File harus < 2Mb ⚠️")));
        return;
      }
      onFilePicked(file);
    }
  }

  String _stripHtmlTags(String html) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return html.replaceAll(exp, '');
  }

  @override
  void dispose() {
    ktpController.dispose();
    pemohonController.dispose();
    instansiController.dispose();
    emailController.dispose();
    hpController.dispose();
    ktpFocus.dispose();
    pemohonFocus.dispose();
    instansiFocus.dispose();
    emailFocus.dispose();
    hpFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double editorHeight = screenHeight * 0.35; // 35% tinggi layar

    return GestureDetector(
      onTap: _unfocusAll,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Form Permohonan Informasi"),
          backgroundColor: Colors.blue,
        ),
        drawer: AppDrawer(
          selectedMenu: "EntrianPermohonan",
          token: widget.token,
          userData: null,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Form Permohonan Informasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // KTP
                    TextFormField(
                      controller: ktpController,
                      focusNode: ktpFocus,
                      onTap: _unfocusAll,
                      decoration: const InputDecoration(
                        labelText: "KTP/SIM/KITAS Pemohon *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),

                    // Nama
                    TextFormField(
                      controller: pemohonController,
                      focusNode: pemohonFocus,
                      onTap: _unfocusAll,
                      decoration: const InputDecoration(
                        labelText: "Pemohon *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),

                    // Instansi
                    TextFormField(
                      controller: instansiController,
                      focusNode: instansiFocus,
                      maxLength: 50,
                      onTap: _unfocusAll,
                      decoration: const InputDecoration(
                        labelText: "Instansi *",
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return "Wajib diisi";
                        if (val.length < 10) return "Minimal 10 karakter";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocus,
                      onTap: _unfocusAll,
                      decoration: const InputDecoration(
                        labelText: "Email *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return "Wajib diisi";
                        if (!val.contains("@")) return "Email tidak valid";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // HP
                    TextFormField(
                      controller: hpController,
                      focusNode: hpFocus,
                      onTap: _unfocusAll,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "No. HP *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),

                    // Keperluan
                    DropdownButtonFormField<String>(
                      value: selectedKeperluan,
                      decoration: const InputDecoration(
                        labelText: "Keperluan Informasi *",
                        border: OutlineInputBorder(),
                      ),
                      items:
                          ["Penelitian", "Pelaporan", "Pengembangan", "Lainnya"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() {
                        selectedKeperluan = val;
                        // Reset fields saat keperluan diganti
                        selectedJenisPermohonan = null;
                        fileIdentitas = null;
                        filePermintaan = null;
                        fileSuratPengantar = null;
                        fileFormulir = null;
                        alasanHtmlController.setText('');
                        rincianHtmlController.setText('');
                      }),
                      validator: (val) =>
                          val == null ? "Pilih salah satu" : null,
                    ),
                    const SizedBox(height: 20),

                    // Semua bagian ini muncul jika user memilih keperluan
                    if (selectedKeperluan != null) ...[
                      // Jenis Permohonan
                      DropdownButtonFormField<String>(
                        value: selectedJenisPermohonan,
                        decoration: const InputDecoration(
                          labelText: "Jenis Permohonan *",
                          border: OutlineInputBorder(),
                        ),
                        items: ["Data Publik", "Data Internal", "Data Rahasia"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => selectedJenisPermohonan = val),
                        validator: (val) =>
                            val == null ? "Pilih salah satu" : null,
                      ),
                      const SizedBox(height: 12),

                      // Alasan (HTML Editor)
                      _buildHtmlEditor(
                        "Alasan Penggunaan Informasi *",
                        alasanHtmlController,
                        editorHeight,
                      ),

                      // Rincian (HTML Editor)
                      _buildHtmlEditor(
                        "Rincian Informasi *",
                        rincianHtmlController,
                        editorHeight,
                      ),

                      // Upload Fields
                      _buildUploadField(
                        "Upload File Identitas (.pdf < 2Mb)",
                        fileIdentitas,
                        (f) => setState(() => fileIdentitas = f),
                      ),
                      const SizedBox(height: 12),
                      _buildUploadField(
                        "Upload File Permintaan Data (.pdf < 2Mb)",
                        filePermintaan,
                        (f) => setState(() => filePermintaan = f),
                      ),
                      const SizedBox(height: 12),
                      _buildUploadField(
                        "Upload Surat Pengantar (.pdf < 2Mb)",
                        fileSuratPengantar,
                        (f) => setState(() => fileSuratPengantar = f),
                      ),
                      const SizedBox(height: 12),
                      _buildUploadField(
                        "Upload Formulir Informasi Publik (.pdf < 2Mb)",
                        fileFormulir,
                        (f) => setState(() => fileFormulir = f),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Tombol Submit
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text("Ajukan Permohonan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          String alasanHtml = await alasanHtmlController
                              .getText();
                          String rincianHtml = await rincianHtmlController
                              .getText();
                          String alasanPlain = _stripHtmlTags(alasanHtml);
                          String rincianPlain = _stripHtmlTags(rincianHtml);

                          if (_formKey.currentState!.validate()) {
                            if (alasanPlain.trim().length < 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Alasan minimal 10 karakter"),
                                ),
                              );
                              return;
                            }
                            if (rincianPlain.trim().length < 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Rincian minimal 10 karakter"),
                                ),
                              );
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Permohonan berhasil disubmit ✅"),
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

  Widget _buildUploadField(
    String label,
    File? file,
    Function(File) onFilePicked,
  ) {
    return InkWell(
      onTap: () => _pickFile(onFilePicked),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.attach_file),
        ),
        child: Text(
          file != null ? file.path.split("/").last : "Belum ada file",
        ),
      ),
    );
  }

  Widget _buildHtmlEditor(
    String label,
    HtmlEditorController controller,
    double height,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: HtmlEditor(
            controller: controller,
            htmlEditorOptions: HtmlEditorOptions(
              hint: "Tulis minimal 10 karakter",
              shouldEnsureVisible: true,
              initialText: """
                      <body style="
                        background-color: #1E1E2F; 
                        color: #000000; 
                        font-size: 14px; 
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        line-height: 1.6;
                        padding: 10px;
                      ">
                      <p style="color:#AAAAAA;"></p> 
                      </body>
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
        const SizedBox(height: 12),
      ],
    );
  }
}
