// import 'dart:ffi';
//
// import 'package:ffi/ffi.dart';
// import 'package:r_crypto/src/basic/closable.dart';
// import 'package:r_crypto/src/basic/lazy.dart';
// import 'package:r_crypto/src/basic/loader.dart';
//
// typedef BlowfishInitFuncNative = Pointer<Uint8> Function(Pointer<Utf8>);
// typedef BlowfishInitFunc = Pointer<Uint8> Function(Pointer<Utf8> key);
//
// typedef BlowfishEncryptProcessNative = Pointer<Utf8> Function(
//     Pointer<Uint8>, Pointer<Utf8>);
// typedef BlowfishProcessFunc = Pointer<Utf8> Function(
//     Pointer<Uint8>, Pointer<Utf8>);
//
// typedef BlowfishDestroyFuncNative = Void Function(Pointer<Uint8>);
// typedef BlowfishDestroyFunc = void Function(Pointer<Uint8>);
//
// class Blowfish implements Closable {
//   final _blowfish = lazyOf(() => nativeLib
//       .lookup<NativeFunction<BlowfishInitFuncNative>>('blowfish_new')
//       .asFunction<BlowfishInitFunc>());
//   final _blowfishEncrypt = lazyOf(() => nativeLib
//       .lookup<NativeFunction<BlowfishEncryptProcessNative>>('blowfish_encrypt')
//       .asFunction<BlowfishProcessFunc>());
//   final _blowfishDecrypt = lazyOf(() => nativeLib
//       .lookup<NativeFunction<BlowfishEncryptProcessNative>>('blowfish_decrypt')
//       .asFunction<BlowfishProcessFunc>());
//   final _blowfishDestroy = lazyOf(() => nativeLib
//       .lookup<NativeFunction<BlowfishDestroyFuncNative>>('blowfish_destroy')
//       .asFunction<BlowfishDestroyFunc>());
//   Pointer<Uint8> _pointer;
//
//   Blowfish.init(String key) {
//     _pointer = loader.executeUint8Block(key, _blowfish());
//   }
//
//   String encrypt(String input) => _process(input, _blowfishEncrypt());
//
//   String decrypt(String hex) => _process(hex, _blowfishDecrypt());
//
//   String _process(String input, BlowfishProcessFunc func) {
//     if (!_pointer.isValid) {
//       throw UnInitializationError();
//     }
//     var pointer = Utf8.toUtf8(input);
//     Pointer<Utf8> resultPointer = func(_pointer, pointer);
//     var result = Utf8.fromUtf8(resultPointer);
//     loader.freeCStrings([pointer, resultPointer]);
//     return result;
//   }
//
//   @override
//   void close() {
//     if (_pointer.isValid) {
//       _blowfishDestroy()(_pointer);
//     }
//   }
// }
