import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open("librcrypto.so")
    : DynamicLibrary.process();

typedef NativeSingleFunction = Pointer<Utf8> Function(Pointer<Utf8>);
typedef NativeTwoFunction = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);
typedef NativeThreeFunction = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);

typedef FreeStringFunc = void Function(Pointer<Utf8>);
typedef FreeStringFuncNative = Void Function(Pointer<Utf8>);

final FreeStringFunc freeCString = nativeLib
    .lookup<NativeFunction<FreeStringFuncNative>>("rust_cstr_free")
    .asFunction();

mixin Loader {
  String executeBlock(String input, NativeSingleFunction function) {
    final argName = Utf8.toUtf8(input);
    final resPointer = function(argName);
    final resultStr = Utf8.fromUtf8(resPointer);
    freeCString(resPointer);
    return resultStr;
  }

  String executeBlock2(String arg1, String arg2, NativeTwoFunction function) {
    final arg1Name = Utf8.toUtf8(arg1);
    final arg2Name = Utf8.toUtf8(arg2);
    final resPointer = function(arg1Name, arg2Name);
    final resultStr = Utf8.fromUtf8(resPointer);
    freeCString(resPointer);
    return resultStr;
  }

  String executeBlock3(
      String arg1, String arg2, String arg3, NativeThreeFunction function) {
    final arg1Name = Utf8.toUtf8(arg1);
    final arg2Name = Utf8.toUtf8(arg2);
    final arg3Name = Utf8.toUtf8(arg3);
    final resPointer = function(arg1Name, arg2Name, arg3Name);
    final resultStr = Utf8.fromUtf8(resPointer);
    freeCString(resPointer);

    return resultStr;
  }
}
