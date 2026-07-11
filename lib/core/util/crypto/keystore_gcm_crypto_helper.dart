import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dynamic_app/core/util/extension/string_ext.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/export.dart';

@lazySingleton
class KeystoreGcmCryptoHelper {
  final FlutterSecureStorage _secureStorage;
  final int keySize = 32; // 256-bit key
  final int ivSize = 12; // 96-bit IV
  final String _keyAlias = 'aes_key';
  final String _ivAlias = 'aes_iv';

  Uint8List? _key;
  Uint8List? _iv;

  KeystoreGcmCryptoHelper() : _secureStorage = const FlutterSecureStorage();

  // ignore: unused_element
  Uint8List _generateSeed(int length) {
    final random = Random.secure();
    final seed = List<int>.generate(length, (_) => random.nextInt(256));
    return Uint8List.fromList(seed);
  }

  Future<void> initializeSecureKey() async {
    _key = Uint8List.fromList([
      41,
      173,
      92,
      214,
      7,
      188,
      63,
      149,
      231,
      18,
      121,
      76,
      203,
      54,
      162,
      239,
      113,
      29,
      198,
      87,
      244,
      136,
      11,
      175,
      68,
      222,
      101,
      35,
      156,
      9,
      190,
      72,
    ]);

    _iv = Uint8List.fromList([183, 44, 219, 6, 125, 234, 81, 157, 32, 196, 103, 14, 241, 75, 168, 57]);
    // String? base64Key = await _secureStorage.read(key: _keyAlias);
    // String? base64Iv = await _secureStorage.read(key: _ivAlias);
    //
    // if (base64Key == null || base64Iv == null) {
    //   final secureRandom = SecureRandom('Fortuna')..seed(KeyParameter(_generateSeed(keySize))); // seed اولیه
    //
    //   final secureKey = secureRandom.nextBytes(keySize);
    //
    //   final iv = secureRandom.nextBytes(ivSize);
    //
    //   _key = secureKey;
    //   _iv = iv;
    //
    //   await _storeKeyAndIv(secureKey, iv);
    // } else {
    //   _key = base64.decode(base64Key);
    //   _iv = base64.decode(base64Iv);
    // }
  }

  String encrypt(String data) {
    if (data == '') return '';
    // if (data.isEmpty) throw Exception('Input data is empty.');
    if (_key == null || _iv == null) throw Exception('Key or IV not initialized.');

    final gcm = GCMBlockCipher(AESEngine())..init(true, AEADParameters(KeyParameter(_key!), 128, _iv!, Uint8List(0)));

    final encrypted = gcm.process(Uint8List.fromList(utf8.encode(data)));
    return base64.encode(encrypted);
  }

  String decrypt(String? base64EncryptedData) {
    if (base64EncryptedData.isNullOrBlank) return '';
    if (_key == null || _iv == null) throw Exception('Key or IV not initialized.');

    final gcm = GCMBlockCipher(AESEngine())..init(false, AEADParameters(KeyParameter(_key!), 128, _iv!, Uint8List(0)));

    final encryptedData = base64.decode(base64EncryptedData!);
    final decrypted = gcm.process(encryptedData);
    return utf8.decode(decrypted);
  }

  // ignore: unused_element
  Future<void> _storeKeyAndIv(Uint8List key, Uint8List iv) async {
    await _secureStorage.write(key: _keyAlias, value: base64.encode(key));
    await _secureStorage.write(key: _ivAlias, value: base64.encode(iv));
  }
}
