import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  // Kunci dan IV berdasarkan config.js dari web
  static final _key = Key.fromUtf8('0123456789abcdef0123456789abcdef'); // 32 karakter (AES-256)
  static final _iv = IV.fromUtf8('abcdef9876543210'); // 16 karakter

  static String encryptToBase64(String plainText) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }
}
