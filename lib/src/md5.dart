part of 'r_crypto_impl.dart';

typedef RustMd5Func = Pointer<Utf8> Function(Pointer<Utf8>);
typedef RustMd5FuncNative = Pointer<Utf8> Function(Pointer<Utf8>);

final RustMd5Func rustMd5 =
    nativeLib.lookup<NativeFunction<RustMd5FuncNative>>("md5").asFunction();
