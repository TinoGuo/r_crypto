import 'dart:convert';

import 'package:convert/convert.dart' as convert;
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:r_crypto/r_crypto.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  List<int> decode(String input) => convert.hex.decode(input);

  initPlatformState() {
    // List<int> key = decode("feffe9928665731c6d6a8f9467308308");
    // List<int> iv = decode("cafebabefacedbaddecaf888");
    // List<int> add = decode("feedfacedeadbeeffeedfacedeadbeefabaddad2");
    Blowfish blowfish = Blowfish.init("hello");
    String encrypted = blowfish.encrypt("world");
    print("encrypted: $encrypted");
    String decrypted = blowfish.decrypt(encrypted);
    print("decrypted: $decrypted");
    blowfish.close();

    // platformVersion = aesGcm.encrypt(
    //   "d9313225f88406e5a55909c5aff5269a86a7a9531534f7da2e4c303d8a318a721c3c0c95956809532fcf0e2449a6b525b16aedf5aa0de657ba637b39",
    //   "5bc94fbc3221a5db94fae95ae7121a47",
    // );

    setState(() {
      _platformVersion = encrypted;
      // aesGcm.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Rust'),
              ),
              onTap: () async {
                await compute(executeRust, 100000);
              },
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Dart'),
              ),
              onTap: () async {
                await compute(executeDart, 100000);
              },
            ),
          ],
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}

const String input = 'hello';

int executeRust(int loop) {
  final stopwatch = Stopwatch()..start();
  for (int i = 0; i < loop; i++) {
    rCrypto.hmac(Digest.sha512, '12345', input);
  }
  return stopwatch.elapsed.inMicroseconds;
}

int executeDart(int loop) {
  final stopwatch = Stopwatch()..start();
  final crypto.Hmac hmac = crypto.Hmac(crypto.sha512, utf8.encode("12345"));
  for (int i = 0; i < loop; i++) {
    hmac.convert(utf8.encode(input));
  }
  return stopwatch.elapsed.inMicroseconds;
}
