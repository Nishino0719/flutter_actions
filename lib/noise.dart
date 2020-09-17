import 'package:noise_meter/noise_meter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_actions/mixture.dart';
double _noiseread;
double _maxDeci = 0;


class NoisePage extends StatefulWidget {
  @override
  _NoisePageState createState() => new _NoisePageState();

}

class _NoisePageState extends State<NoisePage>{
  bool _isRecording = false;
  bool _isButtonDisabled;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = new NoiseMeter();
  @override
  void initState(){
    super.initState();
    _isButtonDisabled = false;
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
    if(_maxDeci < noiseReading.maxDecibel){
      _maxDeci = noiseReading.maxDecibel;
      if(_maxDeci > 80){
        setState(() {
          _isButtonDisabled = true;
        });
      }
    }
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
          ),
          Container(
            child: Text(_isRecording ? "現在の過去最大デシベルは"+_maxDeci.toString() : ""),
          ),
          _buildCounterButton(),
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
  Widget _buildCounterButton() {
    return new RaisedButton(
      child: new Text(
          _isButtonDisabled ? "おめでとう、アクション成功だ" : "過去最大デシベルを80より大きくしてね"
      ),
      onPressed:  _toLastPage,
    );
  }
  Function _toLastPage(){
    if(_isButtonDisabled){
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MixturePage()));
    }else{

    }
  }
}
