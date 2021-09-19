import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r_crypto_example/data.dart';
import 'package:r_crypto_example/file.dart';
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
            ),
            ListTile(
              title: Text('File'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => FileListScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

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

class FileListScreen extends StatefulWidget {
  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RCrypto file'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => FileItemWidget(
          profileData: fileList[index],
        ),
        itemCount: fileList.length,
      ),
    );
  }
}

extension ListExt on List<int> {
  String toHex() => hex.encode(this);
}
