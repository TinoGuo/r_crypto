/// Extension Hash type, which is not fixed output.
enum ExtensionHash {
  shake128,
  shake256,
  groestlBig,
  groestlSmall,
  blake2b,
  blake2s,
}

class HashType {
  /// The Hash type, see const list and [ExtensionHash].
  final int type;

  /// The expected length.
  final int length;

  /// Not public, only allow internal type.
  const HashType._(this.type, this.length) : assert(length > 0);

  /// For [ExtensionHash.shake128] and [ExtensionHash.shake256]
  const HashType.shake(ExtensionHash shake, this.length)
      : assert(length > 0),
        assert(
            shake == ExtensionHash.shake128 || shake == ExtensionHash.shake256),
        type = shake == ExtensionHash.shake128 ? 38 : 39;

  /// For [ExtensionHash.blake2b] and [ExtensionHash.blake2s]
  const HashType.blake2(ExtensionHash blake2, this.length)
      : assert(length > 0 && length % 8 == 0),
        assert(
            blake2 == ExtensionHash.blake2b || blake2 == ExtensionHash.blake2s),
        type = blake2 == ExtensionHash.blake2b ? 100 : 101;

  /// For Blake3.
  const HashType.blake3({this.length = 32})
      : assert(length > 0),
        type = 60;

  /// For [ExtensionHash.groestlBig] and [ExtensionHash.groestlSmall].
  ///
  /// Length range of [ExtensionHash.groestlBig] from 32(exclusive) to 64(inclusive).
  /// Length range of [ExtensionHash.groestlSmall] from 0(exclusive) to 32(inclusive).
  const HashType.groestlDynamic(ExtensionHash extensionHash, this.length)
      : assert((extensionHash == ExtensionHash.groestlBig &&
                length > 32 &&
                length <= 64) ||
            (extensionHash == ExtensionHash.groestlSmall &&
                length > 0 &&
                length <= 32)),
        type = extensionHash == ExtensionHash.groestlBig ? 74 : 75;

  /// MD5
  /// ignore: constant_identifier_names
  static const MD5 = HashType._(0, 16);

  /// SHA1
  /// ignore: constant_identifier_names
  static const SHA1 = HashType._(10, 20);

  /// SHA224
  /// ignore: constant_identifier_names
  static const SHA224 = HashType._(20, 28);

  /// SHA256
  /// ignore: constant_identifier_names
  static const SHA256 = HashType._(21, 32);

  /// SHA384
  /// ignore: constant_identifier_names
  static const SHA384 = HashType._(22, 48);

  /// SHA512
  /// ignore: constant_identifier_names
  static const SHA512 = HashType._(23, 64);

  /// SHA512_TRUNC224
  /// ignore: constant_identifier_names
  static const SHA512_TRUNC224 = HashType._(24, 28);

  /// SHA512_TRUNC256
  /// ignore: constant_identifier_names
  static const SHA512_TRUNC256 = HashType._(25, 32);

  /// SHA3_224
  /// ignore: constant_identifier_names
  static const SHA3_224 = HashType._(30, 28);

  /// SHA3_256
  /// ignore: constant_identifier_names
  static const SHA3_256 = HashType._(31, 32);

  /// SHA3_384
  /// ignore: constant_identifier_names
  static const SHA3_384 = HashType._(32, 48);

  /// SHA3_512
  /// ignore: constant_identifier_names
  static const SHA3_512 = HashType._(33, 64);

  /// KECCAK_224
  /// ignore: constant_identifier_names
  static const KECCAK_224 = HashType._(34, 28);

  /// KECCAK_256
  /// ignore: constant_identifier_names
  static const KECCAK_256 = HashType._(35, 32);

  /// KECCAK_384
  /// ignore: constant_identifier_names
  static const KECCAK_384 = HashType._(36, 48);

  /// KECCAK_512
  /// ignore: constant_identifier_names
  static const KECCAK_512 = HashType._(37, 64);

  /// WHIRLPOOL
  /// ignore: constant_identifier_names
  static const WHIRLPOOL = HashType._(50, 64);

  /// GROESTL_224
  /// ignore: constant_identifier_names
  static const GROESTL_224 = HashType._(70, 28);

  /// GROESTL_256
  /// ignore: constant_identifier_names
  static const GROESTL_256 = HashType._(71, 32);

  /// GROESTL_384
  /// ignore: constant_identifier_names
  static const GROESTL_384 = HashType._(72, 48);

  /// GROESTL_512
  /// ignore: constant_identifier_names
  static const GROESTL_512 = HashType._(73, 64);

  /// RIPEMD160
  /// ignore: constant_identifier_names
  static const RIPEMD160 = HashType._(80, 20);

  /// SHABAL192
  /// ignore: constant_identifier_names
  static const SHABAL192 = HashType._(90, 24);

  /// SHABAL224
  /// ignore: constant_identifier_names
  static const SHABAL224 = HashType._(91, 28);

  /// SHABAL256
  /// ignore: constant_identifier_names
  static const SHABAL256 = HashType._(92, 32);

  /// SHABAL384
  /// ignore: constant_identifier_names
  static const SHABAL384 = HashType._(93, 48);

  /// SHABAL512
  /// ignore: constant_identifier_names
  static const SHABAL512 = HashType._(94, 64);
}
