part of 'r_crypto_impl.dart';

mixin _Md5 {
  final _rustMd5 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>("md5")
      .asFunction<RustSingleUtf8Func>());

  String md5(String input) => loader.executeBlock(input, _rustMd5());
}
