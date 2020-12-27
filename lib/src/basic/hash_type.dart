/// Extension Hash type, which is not fixed output.
enum ExtensionHash {
  Shake128,
  Shake256,
  GroestlBig,
  GroestlSmall,
  Blake2b,
  Blake2s,
}

class HashType {
  /// The Hash type, see const list and [ExtensionHash].
  final int type;

  /// The expected length.
  final int length;

  /// Not public, only allow internal type.
  const HashType._(this.type, this.length) : assert(length > 0);

  /// For [ExtensionHash.Shake128] and [ExtensionHash.Shake256]
  const HashType.shake(ExtensionHash shake, int length)
      : assert(length > 0),
        assert(
            shake == ExtensionHash.Shake128 || shake == ExtensionHash.Shake256),
        type = shake == ExtensionHash.Shake128 ? 38 : 39,
        length = length;

  /// For [ExtensionHash.Blake2b] and [ExtensionHash.Blake2s]
  const HashType.blake2(ExtensionHash blake2, int length)
      : assert(length > 0 && length % 8 == 0),
        assert(
            blake2 == ExtensionHash.Blake2b || blake2 == ExtensionHash.Blake2s),
        length = length,
        type = blake2 == ExtensionHash.Blake2b ? 100 : 101;

  /// For Blake3.
  const HashType.blake3({int length = 32})
      : assert(length > 0),
        type = 60,
        length = length;

  /// For [ExtensionHash.GroestlBig] and [ExtensionHash.GroestlSmall].
  ///
  /// Length range of [ExtensionHash.GroestlBig] from 32(exclusive) to 64(inclusive).
  /// Length range of [ExtensionHash.GroestlSmall] from 0(exclusive) to 32(inclusive).
  const HashType.groestlDynamic(ExtensionHash extensionHash, int length)
      : assert((extensionHash == ExtensionHash.GroestlBig &&
                length > 32 &&
                length <= 64) ||
            (extensionHash == ExtensionHash.GroestlSmall &&
                length > 0 &&
                length <= 32)),
        type = extensionHash == ExtensionHash.GroestlBig ? 74 : 75,
        length = length;

  /// MD5
  static const MD5 = HashType._(0, 16);

  /// SHA1
  static const SHA1 = HashType._(10, 20);

  /// SHA224
  static const SHA224 = HashType._(20, 28);

  /// SHA256
  static const SHA256 = HashType._(21, 32);

  /// SHA384
  static const SHA384 = HashType._(22, 48);

  /// SHA512
  static const SHA512 = HashType._(23, 64);

  /// SHA512_TRUNC224
  static const SHA512_TRUNC224 = HashType._(24, 28);

  /// SHA512_TRUNC256
  static const SHA512_TRUNC256 = HashType._(25, 32);

  /// SHA3_224
  static const SHA3_224 = HashType._(30, 28);

  /// SHA3_256
  static const SHA3_256 = HashType._(31, 32);

  /// SHA3_384
  static const SHA3_384 = HashType._(32, 48);

  /// SHA3_512
  static const SHA3_512 = HashType._(33, 64);

  /// KECCAK_224
  static const KECCAK_224 = HashType._(34, 28);

  /// KECCAK_256
  static const KECCAK_256 = HashType._(35, 32);

  /// KECCAK_384
  static const KECCAK_384 = HashType._(36, 48);

  /// KECCAK_512
  static const KECCAK_512 = HashType._(37, 64);

  /// WHIRLPOOL
  static const WHIRLPOOL = HashType._(50, 64);

  /// GROESTL_224
  static const GROESTL_224 = HashType._(70, 28);

  /// GROESTL_256
  static const GROESTL_256 = HashType._(71, 32);

  /// GROESTL_384
  static const GROESTL_384 = HashType._(72, 48);

  /// GROESTL_512
  static const GROESTL_512 = HashType._(73, 64);

  /// RIPEMD160
  static const RIPEMD160 = HashType._(80, 20);

  /// SHABAL192
  static const SHABAL192 = HashType._(90, 24);

  /// SHABAL224
  static const SHABAL224 = HashType._(91, 28);

  /// SHABAL256
  static const SHABAL256 = HashType._(92, 32);

  /// SHABAL384
  static const SHABAL384 = HashType._(93, 48);

  /// SHABAL512
  static const SHABAL512 = HashType._(94, 64);
}
