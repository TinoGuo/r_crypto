import 'dart:convert' show utf8;
import 'dart:ffi';

import 'package:r_crypto/src/basic/closable.dart';
import 'package:r_crypto/src/basic/lazy.dart';
import 'package:r_crypto/src/basic/loader.dart';

//WIP

typedef AesGcmInitFuncNative = Pointer<Uint8> Function(
  Pointer<Uint8>,
  Uint32,
  Pointer<Uint8>,
  Uint32,
  Pointer<Uint8>,
  Uint32,
);
typedef AesGcmInitFunc = Pointer<Uint8> Function(
  Pointer<Uint8> key,
  int keyLen,
  Pointer<Uint8> iv,
  int ivLen,
  Pointer<Uint8> add,
  int addLen,
);

typedef AesGcmEncryptFuncNative = Void Function(
  Pointer<Uint8>,
  Pointer<Uint8>,
  Uint32,
  Pointer<Uint8>,
  Uint32,
  Pointer<Uint8>,
  Uint32,
);
typedef AesGcmEncryptFunc = void Function(
  Pointer<Uint8>,
  Pointer<Uint8>,
  int,
  Pointer<Uint8>,
  int,
  Pointer<Uint8>,
  int,
);

typedef AesGcmDestroyFuncNative = Void Function(Pointer<Uint8>);
typedef AesGcmDestroyFunc = void Function(Pointer<Uint8>);

class AesGcm implements Closable {
  final _rustDestroy = lazyOf(() => nativeLib
      .lookup<NativeFunction<AesGcmDestroyFuncNative>>('aes_gcm_destroy')
      .asFunction<AesGcmDestroyFunc>());
  final _rustEncrypt = lazyOf(() => nativeLib
      .lookup<NativeFunction<AesGcmEncryptFuncNative>>('aes_gcm_encrypt')
      .asFunction<AesGcmEncryptFunc>());
  Pointer<Uint8> _aesGcmPointer;

  AesGcm._();

  String encrypt(String input, String tag) {
    assert(_aesGcmPointer != null);
    var inputP = utf8.encode(input);
    var output = List.filled(inputP.length, 0);
    var tagP = utf8.encode(tag);
    _rustEncrypt()(
      _aesGcmPointer,
      inputP,
      inputP.length,
      output,
      output.length,
      tagP,
      tagP.length,
    );
    var result = utf8.decode(output);
    print('aes gcm $result');
    return result;
  }

  @override
  void close() {
    assert(_aesGcmPointer != null);
    _rustDestroy()(_aesGcmPointer);
    _aesGcmPointer = null;
  }
}

AesGcmNative aesGcmNative = AesGcmNative._();

class AesGcmNative {
  final _rustAesGcm = lazyOf(() => nativeLib
      .lookup<NativeFunction<AesGcmInitFuncNative>>('aes_gcm_new')
      .asFunction<AesGcmInitFunc>());

  AesGcmNative._();

  AesGcm initAesGcm(List<int> key, List<int> iv, List<int> add) {
    assert(key.length == 16 || key.length == 24 || key.length == 32);
    assert(iv.length == 12);
    var actualKey = loader.uint8ListToArray(key);
    var actualIV = loader.uint8ListToArray(iv);
    var actualAdd = loader.uint8ListToArray(add);
    print('length ${key.length} ${iv.length} ${add.length}');
    var pointer = _rustAesGcm()(
      actualKey,
      key.length,
      actualIV,
      iv.length,
      actualAdd,
      add.length,
    );

    AesGcm aesGcm = AesGcm._().._aesGcmPointer = pointer;
    loader.freePointerList([actualAdd, actualIV, actualAdd]);
    return aesGcm;
  }
}
