import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r_crypto/r_crypto.dart';
import 'package:r_crypto_example/hash.dart';
import 'package:r_crypto_example/profile.dart';

void main() {
  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DemoScreen(),
    );
  }
}

class DemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('rCrypto Demo'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: Text('Hash'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => HashListScreen()));
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProfileListScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}

var list = [
  ProfileData(
    'MD5',
    rustFunc: (input) => rHash.hashString(HashType.MD5, input),
    dartFunc: (input) => crypto.md5.executeDart(input),
  ),
  ProfileData(
    'SHA1',
    rustFunc: (input) => rHash.hashString(HashType.SHA1, input),
    dartFunc: (input) => crypto.sha1.executeDart(input),
  ),
  ProfileData(
    'SHA256',
    rustFunc: (input) => rHash.hashString(HashType.SHA256, input),
    dartFunc: (input) => crypto.sha256.executeDart(input),
  ),
  ProfileData(
    'SHA384',
    rustFunc: (input) => rHash.hashString(HashType.SHA384, input),
    dartFunc: (input) => crypto.sha384.executeDart(input),
  ),
  ProfileData(
    'SHA512',
    rustFunc: (input) => rHash.hashString(HashType.SHA512, input),
    dartFunc: (input) => crypto.sha512.executeDart(input),
  ),
  ProfileData(
    'SHA512_TRUNC224',
    rustFunc: (input) => rHash.hashString(HashType.SHA512_TRUNC224, input),
  ),
  ProfileData(
    'SHA512_TRUNC256',
    rustFunc: (input) => rHash.hashString(HashType.SHA512_TRUNC256, input),
  ),
];

class HashListScreen extends StatefulWidget {
  @override
  _HashListScreenState createState() => _HashListScreenState();
}

class _HashListScreenState extends State<HashListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('rCrypto hash'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) =>
            HashItemWidget(profileData: list[index]),
        itemCount: list.length,
      ),
    );
  }
}

class ProfileListScreen extends StatefulWidget {
  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RCrypto profile'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => ProfileItemWidget(list[index]),
        itemCount: list.length,
      ),
    );
  }
}

extension HashExt on crypto.Hash {
  List<int> executeDart(String input) => this.convert(utf8.encode(input)).bytes;
}

extension ListExt on List<int> {
  String toHex() => hex.encode(this);
}
