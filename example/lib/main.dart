import 'dart:convert';

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

  initPlatformState() {
    String platformVersion;
    platformVersion = rCrypto.hmac(Digest.sha512, '12345', 'hello');

    setState(() {
      _platformVersion = platformVersion;
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
