import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:r_crypto/src/basic/lazy.dart';

const String _kTestDylib =
    'rust/target/x86_64-apple-darwin/release/librcrypto.dylib';
final DynamicLibrary nativeLib = _open();

DynamicLibrary _open() {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    final path = Directory.current;
    if (path.path.endsWith('test')) {
      return DynamicLibrary.open('../$_kTestDylib');
    } else {
      return DynamicLibrary.open(_kTestDylib);
    }
  }
  if (Platform.isMacOS) {
    return DynamicLibrary.open("librcrypto.dylib");
  } else if (Platform.isAndroid) {
    return DynamicLibrary.open("librcrypto.so");
  } else {
    return DynamicLibrary.process();
  }
}

typedef _FreeStringFunc = void Function(Pointer<Utf8>);
typedef _FreeStringFuncNative = Void Function(Pointer<Utf8>);

final loader = _Loader._();

class _Loader {
  _Loader._();

  final freeCString = lazyOf(() => nativeLib
      .lookup<NativeFunction<_FreeStringFuncNative>>("rust_cstr_free")
      .asFunction<_FreeStringFunc>());

  Pointer<Uint8> uint8ListToArray(List<int> list) {
    final ptr = allocate<Uint8>(count: list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
  }

  List<int> uint8ArrayToList(Pointer<Uint8> pointer, int length) {
    List<int> result = List.filled(length, 0);
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
    pointerList.forEach((element) => freeCString()(element));
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
