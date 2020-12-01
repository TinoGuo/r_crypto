import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:r_crypto/src/basic/lazy.dart';
import 'package:r_crypto/src/basic/loader.dart';

part 'hash.dart';

/// Singleton instance of Hash util class.
final rHash = _RHash._();

class _RHash with _Hash, _Blake2 {
  _RHash._();
}
