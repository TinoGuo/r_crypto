part of 'r_crypto_impl.dart';

typedef RustSha1Func = Pointer<Utf8> Function(Pointer<Utf8>);
typedef RustSha1FuncNative = Pointer<Utf8> Function(Pointer<Utf8>);

final RustMd5Func rustSha1 =
    nativeLib.lookup<NativeFunction<RustMd5FuncNative>>("sha1").asFunction();
