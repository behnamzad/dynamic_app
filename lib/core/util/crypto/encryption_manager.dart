import 'dart:convert';

class EncryptionManager {
  getSecretKey() {
    return 'secretKey1234567';
  }

  String   getPasswordKey() {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    //get it from cpp native with method channel
    ///base64
    return stringToBase64.decode('JmFzcjI0KyFAIzczOTElXg==');
  }

  String getPasswordKey2() {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    //base64
    return stringToBase64.decode('bWJhbmsqJl4lMTkzN1pYQw==');
  }
}
