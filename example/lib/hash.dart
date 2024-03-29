import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:r_crypto_example/data.dart';

class HashItemWidget extends StatelessWidget {
  final ProfileData profileData;

  const HashItemWidget({Key? key, required this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => HashDataScreen(profileData: profileData)));
      },
      child: ListTile(
        title: Text(profileData.name),
      ),
    );
  }
}

class HashDataScreen extends StatefulWidget {
  final ProfileData profileData;

  const HashDataScreen({Key? key, required this.profileData}) : super(key: key);

  @override
  _HashDataScreenState createState() => _HashDataScreenState();
}

class _HashDataScreenState extends State<HashDataScreen> {
  String _result = "";
  HashMode _mode = HashMode.hex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: Key('appBar'),
        title: Text(widget.profileData.name),
      ),
      body: ListView(
        children: [
          buildRadioGroup(),
          TextField(
            key: Key('input'),
            onChanged: (s) {
              List<int> tmp = widget.profileData.rustFunc?.call(s) ?? [];
              if (_mode == HashMode.hex) {
                _result = hex.encode(tmp);
              } else {
                _result = tmp.toString();
              }
              setState(() {});
            },
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SelectableText(
              _result,
              key: Key('result'),
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  buildRadioGroup() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: const Text('hex'),
            leading: Radio(
              value: HashMode.hex,
              groupValue: _mode,
              onChanged: (HashMode? value) {
                setState(() {
                  _mode = value!;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('list'),
            leading: Radio(
              value: HashMode.list,
              groupValue: _mode,
              onChanged: (HashMode? value) {
                setState(() {
                  _mode = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

enum HashMode { hex, list }
