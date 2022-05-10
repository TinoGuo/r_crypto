import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:r_crypto/r_crypto.dart';

void main() {
  group('verify hash', () {
    test('verify digest', () {
      expect(
        rHash.hashString(HashType.MD5, "hello"),
        hex.decode("5d41402abc4b2a76b9719d911017c592"),
      );
      expect(
        rHash.hashString(HashType.SHA1, "hello"),
        hex.decode("aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"),
      );
      expect(
        rHash.hashString(HashType.SHA224, "hello"),
        hex.decode("ea09ae9cc6768c50fcee903ed054556e5bfc8347907f12598aa24193"),
      );
      expect(
        rHash.hashString(HashType.SHA256, "hello"),
        hex.decode(
            "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"),
      );
      expect(
        rHash.hashString(HashType.SHA384, "hello"),
        hex.decode(
            "59e1748777448c69de6b800d7a33bbfb9ff1b463e44354c3553bcdb9c666fa90125a3c79f90397bdf5f6a13de828684f"),
      );
      expect(
        rHash.hashString(HashType.SHA512, "hello"),
        hex.decode(
            "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043"),
      );
      expect(
        rHash.hashString(HashType.SHA512_TRUNC224, "hello"),
        hex.decode("fe8509ed1fb7dcefc27e6ac1a80eddbec4cb3d2c6fe565244374061c"),
      );
      expect(
        rHash.hashString(HashType.SHA512_TRUNC256, "hello"),
        hex.decode(
            "e30d87cfa2a75db545eac4d61baf970366a8357c7f72fa95b52d0accb698f13a"),
      );
      expect(
        rHash.hashString(HashType.SHA3_224, "hello"),
        hex.decode("b87f88c72702fff1748e58b87e9141a42c0dbedc29a78cb0d4a5cd81"),
      );
      expect(
        rHash.hashString(HashType.SHA3_256, "hello"),
        hex.decode(
            "3338be694f50c5f338814986cdf0686453a888b84f424d792af4b9202398f392"),
      );
      expect(
        rHash.hashString(HashType.SHA3_384, "hello"),
        hex.decode(
            "720aea11019ef06440fbf05d87aa24680a2153df3907b23631e7177ce620fa1330ff07c0fddee54699a4c3ee0ee9d887"),
      );
      expect(
        rHash.hashString(HashType.SHA3_512, "hello"),
        hex.decode(
            "75d527c368f2efe848ecf6b073a36767800805e9eef2b1857d5f984f036eb6df891d75f72d9b154518c1cd58835286d1da9a38deba3de98b5a53e5ed78a84976"),
      );
      expect(
        rHash.hashString(HashType.KECCAK_224, "hello"),
        hex.decode("45524ec454bcc7d4b8f74350c4a4e62809fcb49bc29df62e61b69fa4"),
      );
      expect(
        rHash.hashString(HashType.KECCAK_256, "hello"),
        hex.decode(
            "1c8aff950685c2ed4bc3174f3472287b56d9517b9c948127319a09a7a36deac8"),
      );
      expect(
        rHash.hashString(HashType.KECCAK_384, "hello"),
        hex.decode(
            "dcef6fb7908fd52ba26aaba75121526abbf1217f1c0a31024652d134d3e32fb4cd8e9c703b8f43e7277b59a5cd402175"),
      );
      expect(
        rHash.hashString(HashType.shake(ExtensionHash.shake128, 10), "hello"),
        hex.decode("8eb4b6a932f280335ee1"),
      );
      expect(
        rHash.hashString(HashType.shake(ExtensionHash.shake256, 64), "hello"),
        hex.decode(
            "1234075ae4a1e77316cf2d8000974581a343b9ebbca7e3d1db83394c30f221626f594e4f0de63902349a5ea5781213215813919f92a4d86d127466e3d07e8be3"),
      );
      expect(
        rHash.hashString(HashType.WHIRLPOOL, "hello"),
        hex.decode(
            "0a25f55d7308eca6b9567a7ed3bd1b46327f0f1ffdc804dd8bb5af40e88d78b88df0d002a89e2fdbd5876c523f1b67bc44e9f87047598e7548298ea1c81cfd73"),
      );
      expect(
        rHash.hashString(const HashType.blake3(), "hello"),
        hex.decode(
            "ea8f163db38682925e4491c5e58d4bb3506ef8c14eb78a86e908c5624a67200f"),
      );
      expect(
        rHash.hashString(const HashType.blake3(length: 64), "hello"),
        hex.decode(
            "ea8f163db38682925e4491c5e58d4bb3506ef8c14eb78a86e908c5624a67200fe992405f0d785b599a2e3387f6d34d01faccfeb22fb697ef3fd53541241a338c"),
      );
      expect(
        rHash.hashString(const HashType.blake3(), "hello",
            key: "01234567890123456789012345678901"),
        hex.decode(
            "a90d00da3185ee3b0212f04238f9fad58199dc63ab71c5f1968d9b03d681919b"),
      );
      expect(
        rHash.hashString(HashType.GROESTL_224, ""),
        hex.decode("f2e180fb5947be964cd584e22e496242c6a329c577fc4ce8c36d34c3"),
      );
      expect(
        rHash.hashString(HashType.GROESTL_256, ""),
        hex.decode(
            "1a52d11d550039be16107f9c58db9ebcc417f16f736adb2502567119f0083467"),
      );
      expect(
        rHash.hashString(HashType.GROESTL_384, ""),
        hex.decode(
            "ac353c1095ace21439251007862d6c62f829ddbe6de4f78e68d310a9205a736d8b11d99bffe448f57a1cfa2934f044a5"),
      );
      expect(
        rHash.hashString(HashType.GROESTL_512, ""),
        hex.decode(
            "6d3ad29d279110eef3adbd66de2a0345a77baede1557f5d099fce0c03d6dc2ba8e6d4a6633dfbd66053c20faa87d1a11f39a7fbe4a6c2f009801370308fc4ad8"),
      );
      expect(
        rHash.hashString(
            HashType.groestlDynamic(ExtensionHash.groestlBig, 64), ""),
        hex.decode(
            "6d3ad29d279110eef3adbd66de2a0345a77baede1557f5d099fce0c03d6dc2ba8e6d4a6633dfbd66053c20faa87d1a11f39a7fbe4a6c2f009801370308fc4ad8"),
      );
      expect(
        rHash.hashString(
            HashType.groestlDynamic(ExtensionHash.groestlSmall, 32), ""),
        hex.decode(
            "1a52d11d550039be16107f9c58db9ebcc417f16f736adb2502567119f0083467"),
      );
      expect(
        rHash.hashString(HashType.RIPEMD160, "hello"),
        hex.decode("108f07b8382412612c048d07d13f814118445acd"),
      );
      expect(
        rHash.hashString(HashType.SHABAL192, "hello"),
        hex.decode("f7303fed54ee00d610c136da488edf5dbfe75f3188dace41"),
      );
      expect(
        rHash.hashString(HashType.SHABAL224, "hello"),
        hex.decode("a0f6a2410c1a6f12dcc98767e9ecbfb5e49e4fe82cb5d29029571e5f"),
      );
      expect(
        rHash.hashString(HashType.SHABAL256, "hello"),
        hex.decode(
            "6563a2d36f2f541e38aaa3f5375bfae8ce1dd2811cdf0993216669d48618aa9a"),
      );
      expect(
        rHash.hashString(HashType.SHABAL384, "hello"),
        hex.decode(
            "ff2e07970744daa5558544ed6d3c6f56e6246ec168439dc155cfd19d38dff67762131843990a4c66af33ab12544ff952"),
      );
      expect(
        rHash.hashString(HashType.SHABAL512, "hello"),
        hex.decode(
            "960314edd29daaaf71e2637f50a221201bf8d6a7f2fbd6487b306ea47f5aa70a122e9e7a23221fa97480e723ac2b3aa2786937ea44aa6fdefa1daebe4b27fbbc"),
      );
      expect(
        rHash.hashString(HashType.blake2(ExtensionHash.blake2b, 64), "hello"),
        hex.decode(
            "e4cfa39a3d37be31c59609e807970799caa68a19bfaa15135f165085e01d41a65ba1e1b146aeb6bd0092b49eac214c103ccfa3a365954bbbe52f74a2b3620c94"),
      );
      expect(
        rHash.hashString(
          HashType.blake2(ExtensionHash.blake2b, 64),
          "hello",
          salt: utf8.decode([0, 1, 2]),
        ),
        hex.decode(
            "145f3c6814436c246f00e5f9ac50f8f651d134be36c51653330620e158aa006b78c5029c1d6025610796ddcaf6dd0b933367b3165749872b5c297af9a4000c9b"),
      );
      expect(
        rHash.hashString(HashType.blake2(ExtensionHash.blake2s, 32), "hello"),
        hex.decode(
            "19213bacc58dee6dbde3ceb9a47cbb330b3d86f8cca8997eb00be456f140ca25"),
      );
    });

    test('should panic', () {
      expect(() {
        HashType.blake2(ExtensionHash.blake2s, 33);
      }, throwsAssertionError);
    });
  });
}
