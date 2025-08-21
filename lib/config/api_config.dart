class ApiConfig {
  static const String baseUrl = 'https://e-ppid.bpjs-kesehatan.go.id/eppid/';

  static Uri getUri(String endpoint) {
    return Uri.parse('$baseUrl$endpoint');
  }
}
