import 'package:convert/convert.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:r_crypto_example/data.dart';

class FileItemWidget extends StatelessWidget {
  final ProfileData profileData;

  const FileItemWidget({Key? key, required this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => FileScreen(profileData: profileData)));
      },
      child: ListTile(
        title: Text(profileData.name),
      ),
    );
  }
}

class FileScreen extends StatefulWidget {
  final ProfileData profileData;

  const FileScreen({Key? key, required this.profileData}) : super(key: key);

  @override
  _FileScreenState createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  String _result = "";
  String _time = "";
  String _file = "";
  HashMode _mode = HashMode.hex;

  int _length = 0;
  String _key = "";

  @override
  void initState() {
    _length = widget.profileData.rustExt?.min ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var min = widget.profileData.rustExt?.min ?? 0;
    var max = widget.profileData.rustExt?.max ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profileData.name),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          buildRadioGroup(),
          ElevatedButton(
            onPressed: () async {
              final picker = await openFile();
              if (picker != null) {
                updateResult(picker.path);
              } else {
                _result = "";
                _time = "";
                _file = "";
              }
              setState(() {});
            },
            child: Text('Choose File'),
          ),
          if (widget.profileData.rustExt != null)
            TextFormField(
              initialValue: '$min',
              autocorrect: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RangeTextInputFormatter(min, max),
              ],
              onChanged: (value) => _length = int.parse(value),
              decoration: InputDecoration(
                  labelText: 'Enter the output length in range [$min, $max]'),
            ),
          if (widget.profileData.rustExt != null &&
              widget.profileData.keyLength > 1)
            TextField(
              autocorrect: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: widget.profileData.keyLength,
              onChanged: (value) => _key = value,
              decoration: InputDecoration(
                  labelText:
                      'Key with length ${widget.profileData.keyLength} (Optional)'),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SelectableText(
              'Result: $_result',
              toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SelectableText(
              'Path: $_file',
              toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SelectableText(
              'Time Consumed: $_time',
              toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  updateResult(String path) {
    List<int> actualKey = _key.split('').map((e) => int.parse(e)).toList();
    debugPrint('path: $path\nlength: $_length\nkey: $actualKey');
    final stopwatch = Stopwatch()..start();
    List<int> tmp;
    if (widget.profileData.rustFunc != null) {
      tmp = widget.profileData.rustFunc!(path);
    } else {
      tmp = widget.profileData.rustExt?.rustExtFunc(path, _length, actualKey) ??
          [];
    }
    _time = "${stopwatch.elapsedMilliseconds} mills";
    stopwatch.stop();
    if (_mode == HashMode.hex) {
      _result = hex.encode(tmp);
    } else {
      _result = tmp.toString();
    }
    _file = path;
  }

  buildRadioGroup() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('hex'),
              Radio(
                value: HashMode.hex,
                groupValue: _mode,
                onChanged: (HashMode? value) {
                  setState(() {
                    _mode = value!;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('list'),
              Radio(
                value: HashMode.list,
                groupValue: _mode,
                onChanged: (HashMode? value) {
                  setState(() {
                    _mode = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum HashMode { hex, list }

class RangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  RangeTextInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return TextEditingValue(
        text: min.toString(),
        selection: TextSelection.collapsed(offset: min.toString().length),
      );
    } else if (int.parse(newValue.text) < min) {
      return TextEditingValue(
        text: min.toString(),
        selection: TextSelection.collapsed(offset: min.toString().length),
      );
    } else if (int.parse(newValue.text) > max) {
      return TextEditingValue(
        text: max.toString(),
        selection: TextSelection.collapsed(offset: max.toString().length),
      );
    } else {
      return newValue;
    }
  }
}
