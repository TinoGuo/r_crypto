part of 'r_crypto_impl.dart';

typedef _GenericVecFuncNative = Int32 Function(
    Uint32 hashType,
    Pointer<Uint8> key,
    Uint32 keyLen,
    Pointer<Uint8> persona,
    Uint32 personaLen,
    Pointer<Uint8> salt,
    Uint32 saltLen,
    Pointer<Uint8> input,
    Uint32 inputLen,
    Pointer<Uint8> output,
    Uint32 outputLen);
typedef _GenericVecFunc = int Function(
    int hashType,
    Pointer<Uint8> key,
    int keyLen,
    Pointer<Uint8> persona,
    int personaLen,
    Pointer<Uint8> salt,
    int saltLen,
    Pointer<Uint8> input,
    int inputLen,
    Pointer<Uint8> output,
    int outputLen);

typedef _GenericFileFuncNative = Int32 Function(
    Uint32 hashType,
    Pointer<Uint8> key,
    Uint32 keyLen,
    Pointer<Uint8> persona,
    Uint32 personaLen,
    Pointer<Uint8> salt,
    Uint32 saltLen,
    Pointer<Utf8> path,
    Pointer<Uint8> output,
    Uint32 outputLen);
typedef _GenericFileFunc = int Function(
    int hashType,
    Pointer<Uint8> key,
    int keyLen,
    Pointer<Uint8> persona,
    int personaLen,
    Pointer<Uint8> salt,
    int saltLen,
    Pointer<Utf8> path,
    Pointer<Uint8> output,
    int outputLen);

mixin _Hash {
  final _hash = lazyOf(() => nativeLib
      .lookupFunction<_GenericVecFuncNative, _GenericVecFunc>("hash_data"));

  final _hashFile = lazyOf(() => nativeLib
      .lookupFunction<_GenericFileFuncNative, _GenericFileFunc>("hash_file"));

  /// [input] is the source string to hash.
  /// [key] is optional, only for [HashType.blake2] and [HashType.blake3]
  /// [persona] is optional, only for [HashType.blake2]
  /// [salt] is optional, only for [HashType.blake2]
  ///
  /// Return the int of [List], which can be encode as hex string or utf8.
  List<int> hashString(HashType hashType, String input,
      {String key, String persona, String salt}) {
    List<int> list = utf8.encode(input);
    List<int> keyList = key == null || key.isEmpty ? null : utf8.encode(key);
    List<int> personaList =
        persona == null || persona.isEmpty ? null : utf8.encode(persona);
    List<int> saltList =
        salt == null || salt.isEmpty ? null : utf8.encode(salt);
    return hashList(hashType, list,
        key: keyList, persona: personaList, salt: saltList);
  }

  /// [input] is the source list to hash, which can be decode from hex string.
  /// [key] is optional, only for [HashType.blake2] and [HashType.blake3]
  /// [persona] is optional, only for [HashType.blake2]
  /// [salt] is optional, only for [HashType.blake2]
  ///
  /// Return the int of [List], which can be encode as hex string or utf8.
  List<int> hashList(HashType hashType, List<int> list,
      {List<int> key, List<int> persona, List<int> salt}) {
    Pointer<Uint8> pointer = loader.uint8ListToArray(list);
    Pointer<Uint8> outputPointer = allocate(count: hashType.length);
    var keyP = key.isNullOrEmpty ? nullptr : loader.uint8ListToArray(key);
    var keyLen = key.isNullOrEmpty ? 0 : key.length;
    var personaP =
        persona.isNullOrEmpty ? nullptr : loader.uint8ListToArray(persona);
    var personaLen = persona.isNullOrEmpty ? 0 : persona.length;
    var saltP = salt.isNullOrEmpty ? nullptr : loader.uint8ListToArray(salt);
    var saltLen = salt.isNullOrEmpty ? 0 : salt.length;
    _hash()(
      hashType.type,
      keyP,
      keyLen,
      personaP,
      personaLen,
      saltP,
      saltLen,
      pointer,
      list.length,
      outputPointer,
      hashType.length,
    );
    List<int> output = loader.uint8ArrayToList(outputPointer, hashType.length);
    loader.freePointerList([pointer, keyP, personaP, saltP, outputPointer]);
    return output;
  }

  /// [path] is the source file path to hash, which can be decode from hex string.
  /// [key] is optional, only for [HashType.blake2] and [HashType.blake3]
  /// [persona] is optional, only for [HashType.blake2]
  /// [salt] is optional, only for [HashType.blake2]
  ///
  /// Make sure the application has permission to visit the file.
  ///
  /// Return the int of [List], which can be encode as hex string or utf8.
  List<int> filePath(HashType hashType, String path,
      {List<int> key, List<int> persona, List<int> salt}) {
    Pointer<Utf8> pathPointer = Utf8.toUtf8(path);
    Pointer<Uint8> outputPointer = allocate(count: hashType.length);
    var keyP = key.isNullOrEmpty ? nullptr : loader.uint8ListToArray(key);
    var keyLen = key.isNullOrEmpty ? 0 : key.length;
    var personaP =
        persona.isNullOrEmpty ? nullptr : loader.uint8ListToArray(persona);
    var personaLen = persona.isNullOrEmpty ? 0 : persona.length;
    var saltP = salt.isNullOrEmpty ? nullptr : loader.uint8ListToArray(salt);
    var saltLen = salt.isNullOrEmpty ? 0 : salt.length;
    var error = _hashFile()(
      hashType.type,
      keyP,
      keyLen,
      personaP,
      personaLen,
      saltP,
      saltLen,
      pathPointer,
      outputPointer,
      hashType.length,
    );
    List<int> output = loader.uint8ArrayToList(outputPointer, hashType.length);
    loader.freePointerList([keyP, personaP, saltP, outputPointer]);
    loader.freeCStrings([pathPointer]);
    if (error == 0) {
      return output;
    } else {
      throw RustError(error);
    }
  }
}

extension _ListChecker on List<int> {
  bool get isNullOrEmpty => this == null || this.isEmpty;
}
