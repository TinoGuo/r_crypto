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

  static const MD5 = HashType._(0, 16);
  static const SHA1 = HashType._(10, 20);
  static const SHA224 = HashType._(20, 28);
  static const SHA256 = HashType._(21, 32);
  static const SHA384 = HashType._(22, 48);
  static const SHA512 = HashType._(23, 64);
  static const SHA512_TRUNC224 = HashType._(24, 28);
  static const SHA512_TRUNC256 = HashType._(25, 32);
  static const SHA3_224 = HashType._(30, 28);
  static const SHA3_256 = HashType._(31, 32);
  static const SHA3_384 = HashType._(32, 48);
  static const SHA3_512 = HashType._(33, 64);
  static const KECCAK_224 = HashType._(34, 28);
  static const KECCAK_256 = HashType._(35, 32);
  static const KECCAK_384 = HashType._(36, 48);
  static const KECCAK_512 = HashType._(37, 64);
  static const WHIRLPOOL = HashType._(50, 64);
  static const GROESTL_224 = HashType._(70, 28);
  static const GROESTL_256 = HashType._(71, 32);
  static const GROESTL_384 = HashType._(72, 48);
  static const GROESTL_512 = HashType._(73, 64);
  static const RIPEMD160 = HashType._(80, 20);
  static const SHABAL192 = HashType._(90, 24);
  static const SHABAL224 = HashType._(91, 28);
  static const SHABAL256 = HashType._(92, 32);
  static const SHABAL384 = HashType._(93, 48);
  static const SHABAL512 = HashType._(94, 64);
}
