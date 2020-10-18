part of 'r_crypto_impl.dart';

mixin _Sha1 {
  final _rustSha1 = lazyOf(() => nativeLib
      .lookup<NativeFunction<RustSingleUtf8FuncNative>>("sha1")
      .asFunction<RustSingleUtf8Func>());

  String sha1(String input) => loader.executeBlock(input, _rustSha1());
}
