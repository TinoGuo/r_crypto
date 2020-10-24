import 'package:flutter_test/flutter_test.dart';
import 'package:r_crypto/r_crypto.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('verify digest', () async {
    expect(rCrypto.md5("hello"), "5d41402abc4b2a76b9719d911017c592");
    expect(rCrypto.sha1("hello"), "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d");
  });
}
