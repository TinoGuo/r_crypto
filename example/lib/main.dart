import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r_crypto/r_crypto.dart';
import 'package:r_crypto_example/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var list = [
      ProfileData(
        'MD5',
        rustFunc: () => rCrypto.md5(input),
        dartFunc: () => crypto.md5.executeDart(),
      ),
      ProfileData(
        'SHA1',
        rustFunc: () => rCrypto.sha1(input),
        dartFunc: () => crypto.sha1.executeDart(),
      ),
      ProfileData(
        'SHA224',
        rustFunc: () => rCrypto.sha224(input),
        dartFunc: () => crypto.sha224.executeDart(),
      ),
      ProfileData(
        'SHA256',
        rustFunc: () => rCrypto.sha256(input),
        dartFunc: () => crypto.sha256.executeDart(),
      ),
      ProfileData(
        'SHA384',
        rustFunc: () => rCrypto.sha384(input),
        dartFunc: () => crypto.sha384.executeDart(),
      ),
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) => ProfileItemWidget(list[index]),
          itemCount: list.length,
        ),
      ),
    );
  }
}

const String input = '1234567890zxcvbnmasdfghjklqwertyuiop';

extension HashExt on crypto.Hash {
  String executeDart() => hex.encode(this.convert(utf8.encode(input)).bytes);
}
