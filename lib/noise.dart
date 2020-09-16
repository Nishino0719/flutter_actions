import 'package:noise_meter/noise_meter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
double _noiseread;


class NoisePage extends StatefulWidget {
  @override
  _NoisePageState createState() => new _NoisePageState();

}

class _NoisePageState extends State<NoisePage>{
  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = new NoiseMeter();
  @override
  void initState(){
    super.initState();
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
    _noiseread = noiseReading.maxDecibel;
    print(noiseReading.toString());
  }

  void start() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (err) {
      print(err);
    }
  }

  void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  List<Widget> getContent() => <Widget>[
    Container(
        margin: EdgeInsets.all(25),
        child: Column(children: [
          Container(
            child: Text(_isRecording ? _noiseread.toString() : "Mic: OFF",
                style: TextStyle(fontSize: 25, color: Colors.blue)),
            margin: EdgeInsets.only(top: 20),
          )
        ])),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getContent())),
        floatingActionButton: FloatingActionButton(
            backgroundColor: _isRecording ? Colors.red : Colors.green,
            onPressed: _isRecording ? stop : start,
            child: _isRecording ? Icon(Icons.stop) : Icon(Icons.mic)),
      ),
    );
  }
}