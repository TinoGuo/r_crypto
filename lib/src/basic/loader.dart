import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

final DynamicLibrary nativeLib = _open();

DynamicLibrary _open() {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    return DynamicLibrary.open(
        'rust/target/x86_64-apple-darwin/release/librcrypto.dylib');
  }
  return Platform.isAndroid
      ? DynamicLibrary.open("librcrypto.so")
      : DynamicLibrary.process();
}

typedef RustSingleUtf8Func = Pointer<Utf8> Function(Pointer<Utf8>);
typedef RustSingleUtf8FuncNative = Pointer<Utf8> Function(Pointer<Utf8>);
typedef RustTwoUtf8Func = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef RustTwoUtf8FuncNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);
typedef RustThreeUtf8Func = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
typedef RustThreeUtf8FuncNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);

typedef RustSingleUint8Func = Pointer<Uint8> Function(Pointer<Utf8>);
typedef RustSingleUint8FuncNative = Pointer<Uint8> Function(Pointer<Utf8>);

typedef FreeStringFunc = void Function(Pointer<Utf8>);
typedef FreeStringFuncNative = Void Function(Pointer<Utf8>);

extension PointerChecker on Pointer {
  bool get isValid => this != null && this.address != 0;
}

final loader = Loader._();

class Loader {
  Loader._();

  final FreeStringFunc freeCString = nativeLib
      .lookup<NativeFunction<FreeStringFuncNative>>("rust_cstr_free")
      .asFunction();

  String executeBlock(String input, RustSingleUtf8Func function) {
    final argName = Utf8.toUtf8(input);
    final resPointer = function(argName);
    final resultStr = Utf8.fromUtf8(resPointer);
    freeCStrings([argName, resPointer]);
    return resultStr;
  }

  String executeBlock2(String arg1, String arg2, RustTwoUtf8Func function) {
    final arg1Name = Utf8.toUtf8(arg1);
    final arg2Name = Utf8.toUtf8(arg2);
    final resPointer = function(arg1Name, arg2Name);
    final resultStr = Utf8.fromUtf8(resPointer);
    freeCStrings([arg1Name, arg2Name, resPointer]);
    return resultStr;
  }

  String executeBlock3(
      String arg1, String arg2, String arg3, RustThreeUtf8Func function) {
    final arg1Name = Utf8.toUtf8(arg1);
    final arg2Name = Utf8.toUtf8(arg2);
    final arg3Name = Utf8.toUtf8(arg3);
    final resPointer = function(arg1Name, arg2Name, arg3Name);
    final resultStr = Utf8.fromUtf8(resPointer);
    freeCStrings([arg1Name, arg2Name, arg3Name, resPointer]);
    return resultStr;
  }

  Pointer<Uint8> executeUint8Block(String input, RustSingleUint8Func function) {
    final argName = Utf8.toUtf8(input);
    final resPointer = function(argName);
    freeCString(argName);
    return resPointer;
  }

  Pointer<Uint8> uint8ListToArray(List<int> list) {
    final ptr = allocate<Uint8>(count: list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
  }

  List<int> uint8ArrayToList(Pointer<Uint8> pointer, int length) {
    List<int> result = List(length);
    for (var i = 0; i < length; i++) {
      result[i] = pointer.elementAt(i).value;
    }
    return result;
  }

  Pointer<Uint16> uint16ListToArray(List<int> list) {
    final ptr = allocate<Uint16>(count: list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
  }

  Pointer<Uint32> uint32ListToArray(List<int> list) {
    final ptr = allocate<Uint32>(count: list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
  }

  void freeCStrings(List<Pointer<Utf8>> pointerList) {
    pointerList.forEach((element) => freeCString(element));
  }

  void freePointer<T extends NativeType>(Pointer<T> pointer) {
    free(pointer);
  }

  void freePointerList<T extends NativeType>(List<Pointer<T>> pointerList) {
    pointerList.forEach((element) => free(element));
  }
}

class UnInitializationError extends Error {
  final Object message;

  UnInitializationError([this.message]);

  @override
  String toString() {
    if (message != null) {
      return "UnInitialized error: ${Error.safeToString(message)}";
    }
    return "UnInitialized error";
  }
}
