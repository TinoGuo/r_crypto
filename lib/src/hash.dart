part of 'r_crypto_impl.dart';

/// Extension Hash type, which is not fixed output.
enum ExtensionHash {
  Shake128,
  Shake256,
  GroestlBig,
  GroestlSmall,
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

mixin _Hash {
  final _hash = lazyOf(() => nativeLib
      .lookup<NativeFunction<GenericVecFuncNative>>("hash_data")
      .asFunction<GenericVecFunc>());

  /// [input] is the source string to hash.
  /// [key] is optional, currently only for Blake3.
  ///
  /// Return the int of [List], which can be encode as hex string.
  List<int> hashString(HashType hashType, String input, {String key}) {
    List<int> list = utf8.encode(input);
    List<int> keyList = key == null ? null : utf8.encode(key);
    return hashList(hashType, list, key: keyList);
  }

  /// [input] is the source list to hash, which can be decode from hex string.
  /// [key] is optional, currently only for Blake3.
  ///
  /// Return the int of [List], which can be encode as hex string.
  List<int> hashList(HashType hashType, List<int> list, {List<int> key}) {
    Pointer<Uint8> pointer = loader.uint8ListToArray(list);
    Pointer<Uint8> outputPointer = allocate(count: hashType.length);
    Pointer<Uint8> keyP = key == null ? nullptr : loader.uint8ListToArray(key);
    int keyLen = key == null ? 0 : key.length;
    _hash()(
      hashType.type,
      keyP,
      keyLen,
      pointer,
      list.length,
      outputPointer,
      hashType.length,
    );
    List<int> output = loader.uint8ArrayToList(outputPointer, hashType.length);
    loader.freePointerList([pointer, keyP, outputPointer]);
    return output;
  }
}

typedef Blake2FuncNative = Void Function(
  Pointer<Uint8>,
  Uint32,
  Pointer<Uint8>,
  Uint32,
  Pointer<Uint8>,
  Uint32,
  Pointer<Uint8>,
  Uint32,
  Pointer<Uint8>,
  Uint32,
);
typedef Blake2Func = void Function(
  Pointer<Uint8>,
  int,
  Pointer<Uint8>,
  int,
  Pointer<Uint8>,
  int,
  Pointer<Uint8>,
  int,
  Pointer<Uint8>,
  int,
);

/// [Blake2](https://en.wikipedia.org/wiki/BLAKE_(hash_function))
enum Blake2 {
  Blake2b,
  Blake2s,
}

class Blake2Type {
  /// The Hash type, see [Blake2].
  final Blake2 type;

  /// The expected length, must larger than 0.
  final int length;

  const Blake2Type.blake2b(this.length) : type = Blake2.Blake2b;

  const Blake2Type.blake2s(this.length) : type = Blake2.Blake2s;
}

mixin _Blake2 {
  final _blake2b = lazyOf(() => nativeLib
      .lookup<NativeFunction<Blake2FuncNative>>("blake2b")
      .asFunction<Blake2Func>());
  final _blake2s = lazyOf(() => nativeLib
      .lookup<NativeFunction<Blake2FuncNative>>("blake2s")
      .asFunction<Blake2Func>());

  /// [input] is the source string to hash.
  /// [persona], [salt], [key] is optional, which can be null.
  ///
  /// Return the int of [List], which can be encode as hex string.
  List<int> blake2String(
    Blake2Type hashType,
    String input, {
    List<int> persona,
    List<int> salt,
    List<int> key,
  }) {
    List<int> list = utf8.encode(input);
    return blake2List(hashType, list, persona: persona, key: key, salt: salt);
  }

  /// [input] is the source list to hash, which can be decode from hex string.
  /// [persona], [salt], [key] is optional, which can be null.
  ///
  /// Return the int of [List], which can be encode as hex string.
  List<int> blake2List(
    Blake2Type hashType,
    List<int> list, {
    List<int> persona,
    List<int> salt,
    List<int> key,
  }) {
    Pointer<Uint8> pointer = loader.uint8ListToArray(list);
    Pointer<Uint8> outputPointer = allocate(count: hashType.length);
    var personaP = persona == null ? nullptr : loader.uint8ListToArray(persona);
    var personaLen = persona == null ? 0 : persona.length;
    var saltP = salt == null ? nullptr : loader.uint8ListToArray(salt);
    var saltLen = salt == null ? 0 : salt.length;
    var keyP = key == null ? nullptr : loader.uint8ListToArray(key);
    var keyLen = key == null ? 0 : key.length;
    switch (hashType.type) {
      case Blake2.Blake2b:
        _blake2b()(personaP, personaLen, saltP, saltLen, keyP, keyLen, pointer,
            list.length, outputPointer, hashType.length);
        break;
      case Blake2.Blake2s:
        _blake2s()(personaP, personaLen, saltP, saltLen, keyP, keyLen, pointer,
            list.length, outputPointer, hashType.length);
        break;
    }
    List<int> output = loader.uint8ArrayToList(outputPointer, hashType.length);
    loader.freePointerList([pointer, personaP, saltP, keyP, outputPointer]);
    return output;
  }
}
