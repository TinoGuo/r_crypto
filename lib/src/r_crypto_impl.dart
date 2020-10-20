import 'dart:ffi';

import 'package:r_crypto/src/basic/lazy.dart';
import 'package:r_crypto/src/basic/loader.dart';

part 'hmac.dart';
part 'md5.dart';
part 'sha1.dart';
part 'sha2.dart';
part 'sha3.dart';

final rCrypto = _RCrypto._();

class _RCrypto with _Md5, _Sha1, _Sha2, _Sha3, _Hmac {
  _RCrypto._();
}
