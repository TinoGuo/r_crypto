import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:r_crypto/r_crypto.dart';
import 'package:r_crypto/src/basic/errors.dart';
import 'package:r_crypto/src/basic/hash_type.dart';
import 'package:r_crypto/src/basic/loader.dart';

part 'hash.dart';

/// Singleton instance of Hash util class.
final rHash = _RHash._();

class _RHash with _Hash {
  _RHash._();
}
