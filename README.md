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

More digest will support soon.

## Support Platform

- Android
    - arm64-v8a
    - armeabi-v7a
    - x86
    - x86_64
- iOS(All)
- macOS(WIP)