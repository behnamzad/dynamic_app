import 'dart:typed_data';

import 'package:dynamic_app/core/util/crypto/encryption_manager.dart';
import 'package:encrypt/encrypt.dart';
import 'package:injectable/injectable.dart';
import 'dart:convert';

import 'package:string_validator/string_validator.dart';

@lazySingleton
class EncryptHelper {
  IV? iv;
  Encrypter? _encryptor;
  Encrypter? _encryptorPassword;

  EncryptHelper() {
    iv = IV.fromLength(16);
    var passwordKey = '${EncryptionManager().getPasswordKey()}${EncryptionManager().getPasswordKey2()}';
    _encryptorPassword = Encrypter(AES(Key.fromUtf8(passwordKey), mode: AESMode.ecb));
  }

  // String? encrypt(String? input, {String? key}) {
  //   if (input == null) return null;
  //   key = inject<AppDeviceInfoUtil>().symmetricKey;
  //   if (key == null) return null;
  //   _encryptor = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.ecb));
  //   return _encryptor!.encrypt(input, iv: iv).base64;
  // }

  // String? decrypt(String? input, {String? key}) {
  //   if (input == null) return null;
  //   key = inject<AppDeviceInfoUtil>().symmetricKey;
  //   if (key == null) return null;
  //   _encryptor = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.ecb));
  //   return _encryptor!.decrypt(Encrypted.fromBase64(input), iv: iv);
  // }

  String? encryptWithSecret(String? input) {
    if (input == null) return null;
    var key = EncryptionManager().getSecretKey();
    var encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.ecb));
    return encrypter.encrypt(input, iv: iv).base64;
  }

  String? decryptCbcBySecretKey(String? input, {String? key}) {
    if (input == null) return null;
    var key = EncryptionManager().getSecretKey();
    _encryptor = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.ecb));
    return _encryptor!.decrypt(Encrypted.fromBase64(input), iv: iv);
  }

  @Deprecated('use > inject<KeystoreGcmCryptoHelper>().decrypt')
  String? encryptCbcByPasswordKey(String? input, {String? key}) {
    if (input == null ||input == '') return '';
    return _encryptorPassword!.encrypt(input, iv: iv).base64;
  }

  String? decryptCbcByPasswordKey(String? input, {String? key}) {
    if (input == null || input == '') return '';
    try {
      var isBase64Str = isBase64(input);
      if (isBase64Str) {
        return _encryptorPassword!.decrypt(Encrypted.fromBase64(input), iv: iv);
      } else {
        return input;
      }
    } catch (e) {
      Uint8List data = Uint8List.fromList(utf8.encode(input));
      if (!isDataLengthValid(data, 16)) {
        // print('Data length is not a multiple of block size.');
        return input;// means input is plain  text and not encrypted before
      }else{
        // print('Data length is valid.');
        return null;
      }
    }
  }
  bool isDataLengthValid(Uint8List data, int blockSize) {
    return data.length % blockSize == 0;
  }
}
