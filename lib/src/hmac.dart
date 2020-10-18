part of 'r_crypto_impl.dart';

mixin _Hmac {
  final _rustHmac = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustThreeUtf8FuncNative>>("hmac")
      .asFunction<RustThreeUtf8Func>());

  String hmac(Digest digest, String key, String input) =>
      loader.executeBlock3(digest.name, key, input, _rustHmac());
}

class Digest {
  final String name;

  const Digest._(this.name);

  static const md5 = const Digest._('md5');
  static const sha1 = const Digest._('sha1');
  static const sha224 = const Digest._('sha224');
  static const sha256 = const Digest._('sha256');
  static const sha384 = const Digest._('sha384');
  static const sha512 = const Digest._('sha512');
  static const sha512_trunc224 = const Digest._('sha512_trunc224');
  static const sha512_trunc256 = const Digest._('sha512_trunc256');
  static const sha3_224 = const Digest._('sha3_224');
  static const sha3_256 = const Digest._('sha3_256');
  static const sha3_384 = const Digest._('sha3_384');
  static const sha3_512 = const Digest._('sha3_512');
  static const shake_128 = const Digest._('shake_128');
  static const shake_256 = const Digest._('shake_256');
  static const keccak224 = const Digest._('keccak224');
  static const keccak256 = const Digest._('keccak256');
  static const keccak384 = const Digest._('keccak384');
  static const keccak512 = const Digest._('keccak512');
  static const ripemd160 = const Digest._('ripemd160');
  static const whirlpool = const Digest._('whirlpool');
}
