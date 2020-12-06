![](https://github.com/TinoGuo/r_crypto/workflows/CI%20check/badge.svg?branch=master)
[![pub package](https://img.shields.io/pub/v/r_crypto.svg)](https://pub.dartlang.org/packages/r_crypto)
![GitHub](https://img.shields.io/github/license/TinoGuo/r_crypto)
![GitHub top language](https://img.shields.io/github/languages/top/TinoGuo/r_crypto)
![GitHub language count](https://img.shields.io/github/languages/count/TinoGuo/r_crypto.svg)

# r_crypto

Rust backend support crypto flutter library, much faster than Dart-implementation library, light-weight library.

Some crypto support hardware accelerate.

## Support Algorithm

### Hashes

- MD5
- SHA1
- SHA2
    - SHA224
    - SHA256
    - SHA384
    - SHA512-trunc224
    - SHA512-trunc256
- SHA3
    - SHA3-224
    - SHA3-256
    - SHA3-384
    - SHA3-512
    - SHAKE-128
    - SHAKE-256
    - KECCAK224
    - KECCAK256
    - KECCAK384
    - KECCAK512
- Whirlpool
- Blake2
    - Blake2b
    - Blake2s
- Blake3
- Groestl
    - Groestl224
    - Groestl256
    - Groestl384
    - Groestl512
    - GroestlBig
    - GroestlSmall
- RIPEMD160 (RIPEMD-320 provides only the same security as RIPEMD-160)
- Shabal
    - Shabal192
    - Shabal224
    - Shabal256
    - Shabal384
    - Shabal512

More digest will support soon.

## Support Platform

- Android
    - arm64-v8a
    - armeabi-v7a
    - x86
    - x86_64
- iOS
    - arm64
    - x86_64
- macOS
    - x86_64
    - arm64(WIP)

## Example Usage

### Hash

```dart
import 'package:r_crypto/r_crypto.dart';

//For fixed output length digest
rCrypto.hashString(HashType.MD5, input);
//For dynamic output length digest
rCrypto.hashString(HashType.blake3(length: 64), input);
//For Blake2 only
rCrypto.blake2String(Blake2Type.blake2b(32), input);
//Also accept List<int> as parameter
rCrypto.hashList(HashType.KECCAK_224, [0,1,2]);

//Encode the list
hex.encode(list);
```

## TODO
- [ ] Support file input
- [ ] Support encrypt/decrypt algorithm