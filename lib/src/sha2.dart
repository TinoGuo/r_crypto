part of 'r_crypto_impl.dart';

mixin _Sha2 {
  final _sha224 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('sha224')
      .asFunction<RustSingleUtf8Func>());

  String sha224(String input) => loader.executeBlock(input, _sha224());

  final _sha256 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>("sha256")
      .asFunction<RustSingleUtf8Func>());

  String sha256(String input) => loader.executeBlock(input, _sha256());

  final _sha384 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>("sha384")
      .asFunction<RustSingleUtf8Func>());

  String sha384(String input) => loader.executeBlock(input, _sha384());

  // ignore: non_constant_identifier_names
  final _sha512_trunc224 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>("sha512_trunc224")
      .asFunction<RustSingleUtf8Func>());

  // ignore: non_constant_identifier_names
  String sha512_trunc224(String input) =>
      loader.executeBlock(input, _sha512_trunc224());

  // ignore: non_constant_identifier_names
  final _sha512_trunc256 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>("sha512_trunc256")
      .asFunction<RustSingleUtf8Func>());

  // ignore: non_constant_identifier_names
  String sha512_trunc256(String input) =>
      loader.executeBlock(input, _sha512_trunc256());
}
