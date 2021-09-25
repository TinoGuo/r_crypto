import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:r_crypto/r_crypto.dart';

const int INT_MAX = (1 << 32) - 1;

typedef RustFunc = List<int> Function(String);
typedef DartFunc = List<int> Function(String);
typedef RustExtFunc = List<int> Function(
    String input, int length, List<int> key);

class RustExt {
  final RustExtFunc rustExtFunc;
  final int? min;
  final int? max;

  const RustExt(this.rustExtFunc, {this.min, this.max});
}

class ProfileData {
  final String name;
  final RustFunc? rustFunc;
  final DartFunc? dartFunc;
  final RustExt? rustExt;
  // if less than or equal to 0, means not support key
  final int keyLength;

  const ProfileData(this.name,
      {this.rustFunc, this.dartFunc, this.rustExt, this.keyLength = 0});
}

extension HashExt on crypto.Hash {
  List<int> executeDart(String input) => this.convert(utf8.encode(input)).bytes;
}

var list = [
  ProfileData(
    'MD5',
    rustFunc: (input) => rHash.hashString(HashType.MD5, input),
    dartFunc: (input) => crypto.md5.executeDart(input),
  ),
  ProfileData(
    'SHA1',
    rustFunc: (input) => rHash.hashString(HashType.SHA1, input),
    dartFunc: (input) => crypto.sha1.executeDart(input),
  ),
  ProfileData(
    'SHA224',
    rustFunc: (input) => rHash.hashString(HashType.SHA224, input),
    dartFunc: (input) => crypto.sha224.executeDart(input),
  ),
  ProfileData(
    'SHA256',
    rustFunc: (input) => rHash.hashString(HashType.SHA256, input),
    dartFunc: (input) => crypto.sha256.executeDart(input),
  ),
  ProfileData(
    'SHA384',
    rustFunc: (input) => rHash.hashString(HashType.SHA384, input),
    dartFunc: (input) => crypto.sha384.executeDart(input),
  ),
  ProfileData(
    'SHA512',
    rustFunc: (input) => rHash.hashString(HashType.SHA512, input),
    dartFunc: (input) => crypto.sha512.executeDart(input),
  ),
  ProfileData(
    'SHA512_TRUNC224',
    rustFunc: (input) => rHash.hashString(HashType.SHA512_TRUNC224, input),
  ),
  ProfileData(
    'SHA512_TRUNC256',
    rustFunc: (input) => rHash.hashString(HashType.SHA512_TRUNC256, input),
  ),
];

var fileList = [
  ProfileData(
    'MD5',
    rustFunc: (input) => rHash.filePath(HashType.MD5, input),
  ),
  ProfileData(
    'SHA1',
    rustFunc: (input) => rHash.filePath(HashType.SHA1, input),
  ),
  ProfileData(
    'SHA224',
    rustFunc: (input) => rHash.filePath(HashType.SHA224, input),
  ),
  ProfileData(
    'SHA256',
    rustFunc: (input) => rHash.filePath(HashType.SHA256, input),
  ),
  ProfileData(
    'SHA384',
    rustFunc: (input) => rHash.filePath(HashType.SHA384, input),
  ),
  ProfileData(
    'SHA512',
    rustFunc: (input) => rHash.filePath(HashType.SHA512, input),
  ),
  ProfileData(
    'SHA512_TRUNC224',
    rustFunc: (input) => rHash.filePath(HashType.SHA512_TRUNC224, input),
  ),
  ProfileData(
    'SHA512_TRUNC256',
    rustFunc: (input) => rHash.filePath(HashType.SHA512_TRUNC256, input),
  ),
  ProfileData(
    'SHA3_224',
    rustFunc: (input) => rHash.filePath(HashType.SHA3_224, input),
  ),
  ProfileData(
    'SHA3_256',
    rustFunc: (input) => rHash.filePath(HashType.SHA3_256, input),
  ),
  ProfileData(
    'SHA3_384',
    rustFunc: (input) => rHash.filePath(HashType.SHA3_384, input),
  ),
  ProfileData(
    'SHA3_512',
    rustFunc: (input) => rHash.filePath(HashType.SHA3_512, input),
  ),
  ProfileData(
    'SHA3_512',
    rustFunc: (input) => rHash.filePath(HashType.SHA3_512, input),
  ),
  ProfileData(
    'KECCAK_224',
    rustFunc: (input) => rHash.filePath(HashType.KECCAK_224, input),
  ),
  ProfileData(
    'KECCAK_256',
    rustFunc: (input) => rHash.filePath(HashType.KECCAK_256, input),
  ),
  ProfileData(
    'KECCAK_384',
    rustFunc: (input) => rHash.filePath(HashType.KECCAK_384, input),
  ),
  ProfileData(
    'KECCAK_512',
    rustFunc: (input) => rHash.filePath(HashType.KECCAK_512, input),
  ),
  ProfileData(
    'SHAKE_128',
    rustExt: RustExt(
      (input, length, key) =>
          rHash.filePath(HashType.shake(ExtensionHash.shake128, length), input),
      min: 1,
      max: INT_MAX,
    ),
  ),
  ProfileData(
    'SHAKE_256',
    rustExt: RustExt(
      (input, length, key) =>
          rHash.filePath(HashType.shake(ExtensionHash.shake256, length), input),
      min: 1,
      max: INT_MAX,
    ),
  ),
  ProfileData(
    'WHIRLPOOL',
    rustFunc: (input) => rHash.filePath(HashType.WHIRLPOOL, input),
  ),
  ProfileData(
    'GROESTL_224',
    rustFunc: (input) => rHash.filePath(HashType.GROESTL_224, input),
  ),
  ProfileData(
    'GROESTL_256',
    rustFunc: (input) => rHash.filePath(HashType.GROESTL_256, input),
  ),
  ProfileData(
    'GROESTL_384',
    rustFunc: (input) => rHash.filePath(HashType.GROESTL_384, input),
  ),
  ProfileData(
    'GROESTL_512',
    rustFunc: (input) => rHash.filePath(HashType.GROESTL_512, input),
  ),
  ProfileData(
    'Groestl_Big',
    rustExt: RustExt(
      (input, length, key) => rHash.filePath(
          HashType.groestlDynamic(ExtensionHash.groestlBig, length), input),
      min: 33,
      max: 64,
    ),
  ),
  ProfileData(
    'Groestl_Small',
    rustExt: RustExt(
      (input, length, key) => rHash.filePath(
          HashType.groestlDynamic(ExtensionHash.groestlSmall, length), input),
      min: 1,
      max: 32,
    ),
  ),
  ProfileData(
    'RIPEMD160',
    rustFunc: (input) => rHash.filePath(HashType.RIPEMD160, input),
  ),
  ProfileData(
    'SHABAL192',
    rustFunc: (input) => rHash.filePath(HashType.SHABAL192, input),
  ),
  ProfileData(
    'SHABAL224',
    rustFunc: (input) => rHash.filePath(HashType.SHABAL224, input),
  ),
  ProfileData(
    'SHABAL256',
    rustFunc: (input) => rHash.filePath(HashType.SHABAL256, input),
  ),
  ProfileData(
    'SHABAL384',
    rustFunc: (input) => rHash.filePath(HashType.SHABAL384, input),
  ),
  ProfileData(
    'SHABAL512',
    rustFunc: (input) => rHash.filePath(HashType.SHABAL512, input),
  ),
  ProfileData(
    'BLAKE3',
    rustExt: RustExt(
      (input, length, key) =>
          rHash.filePath(HashType.blake3(length: length), input, key: key),
      min: 1,
      max: INT_MAX,
    ),
    keyLength: 32,
  ),
];
