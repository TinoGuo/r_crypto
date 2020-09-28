import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:r_crypto/src/basic/loader.dart';

part 'hmac.dart';
part 'md5.dart';
part 'sha1.dart';

final rCrypto = RCrypto._();

class RCrypto with Loader {
  RCrypto._();

  String md5(String input) => executeBlock(input, rustMd5);

  String sha1(String input) => executeBlock(input, rustSha1);

  String hmac(Digest digest, String key, String input) =>
      executeBlock3(digest.name, key, input, rustHmac);
}
