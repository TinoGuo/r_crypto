part of 'r_crypto_impl.dart';

mixin _Sha3 {
  final _sha3_224 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('sha3_224')
      .asFunction<RustSingleUtf8Func>());

  String sha3_224(String input) => loader.executeBlock(input, _sha3_224());

  final _sha3_256 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('sha3_256')
      .asFunction<RustSingleUtf8Func>());

  String sha3_256(String input) => loader.executeBlock(input, _sha3_256());

  final _sha3_384 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('sha3_384')
      .asFunction<RustSingleUtf8Func>());

  String sha3_384(String input) => loader.executeBlock(input, _sha3_384());

  final _sha3_512 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('sha3_512')
      .asFunction<RustSingleUtf8Func>());

  String sha3_512(String input) => loader.executeBlock(input, _sha3_512());

  final _shake_128 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('shake_128')
      .asFunction<RustSingleUtf8Func>());

  String shake_128(String input) => loader.executeBlock(input, _shake_128());

  final _shake_256 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('shake_256')
      .asFunction<RustSingleUtf8Func>());

  String shake_256(String input) => loader.executeBlock(input, _shake_256());

  final _keccak224 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('keccak224')
      .asFunction<RustSingleUtf8Func>());

  String keccak224(String input) => loader.executeBlock(input, _keccak224());

  final _keccak256 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('keccak256')
      .asFunction<RustSingleUtf8Func>());

  String keccak256(String input) => loader.executeBlock(input, _keccak256());

  final _keccak384 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('keccak384')
      .asFunction<RustSingleUtf8Func>());

  String keccak384(String input) => loader.executeBlock(input, _keccak384());

  final _keccak512 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>('keccak512')
      .asFunction<RustSingleUtf8Func>());

  String keccak512(String input) => loader.executeBlock(input, _keccak512());
}
