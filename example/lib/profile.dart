import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:r_crypto_example/data.dart';

const String input = '1234567890zxcvbnmasdfghjklqwertyuiop';

class ProfileItemWidget extends StatelessWidget {
  final ProfileData profileData;

  ProfileItemWidget(this.profileData);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProfileDetailScreen(profileData: profileData)));
      },
      child: ListTile(
        title: Text(profileData.name),
      ),
    );
  }
}

class ProfileDetailScreen extends StatefulWidget {
  final ProfileData profileData;

  const ProfileDetailScreen({Key key, @required this.profileData})
      : super(key: key);

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

enum LoadState {
  NOT_STARTED,
  LOADING,
  DONE,
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  String _rustTime;
  String _dartTime;
  double _sliderValue = 100000;
  LoadState _loading = LoadState.NOT_STARTED;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profileData.name),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('Loop time'),
            ),
            Slider.adaptive(
              min: 10000,
              max: 100000,
              label: _sliderValue.round().toString(),
              divisions: 9,
              onChanged: (double value) {
                if (_loading != LoadState.LOADING) {
                  setState(() {
                    _sliderValue = value;
                  });
                }
              },
              value: _sliderValue,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                _text(_loading),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.whatshot),
        onPressed: _loading != LoadState.LOADING ? _run : null,
      ),
    );
  }

  String _text(LoadState state) {
    switch (state) {
      case LoadState.NOT_STARTED:
        return 'Make sure you run it in profile mode';
      case LoadState.LOADING:
        return "Loading";
      case LoadState.DONE:
        return "$_rustTime\n\n$_dartTime";
      default:
        return "";
    }
  }

  Future<void> _run() async {
    setState(() {
      _loading = LoadState.LOADING;
    });
    // To make sure setState works, no idea of the reason why the below line could make setState works.
    await Future.delayed(const Duration(milliseconds: 100));
    if (widget.profileData.rustFunc != null) {
      int time = await _watchTime(widget.profileData.rustFunc);
      _rustTime = "Rust:$time milliseconds";
    } else {
      _rustTime = "Rust:None";
    }
    if (widget.profileData.dartFunc != null) {
      int time = await _watchTime(widget.profileData.dartFunc);
      _dartTime = "Dart:$time milliseconds";
    } else {
      _dartTime = "Dart:None";
    }
    setState(() {
      _loading = LoadState.DONE;
    });
  }

  Future<int> _watchTime(Function(String) function) async {
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < _sliderValue; i++) {
      function("$input$i");
    }
    return stopwatch.elapsed.inMilliseconds;
  }
}
