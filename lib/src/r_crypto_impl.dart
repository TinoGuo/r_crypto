import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:r_crypto/src/basic/lazy.dart';
import 'package:r_crypto/src/basic/loader.dart';

part 'hash.dart';
part 'hmac.dart';

final rCrypto = _RCrypto._();

class _RCrypto with _Hmac, _Hash, _Blake2 {
  _RCrypto._();
}
