import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:noise_meter/noise_meter.dart';
import 'dart:async';
import 'package:flutter_actions/bokashi.dart';

double _noiseread;
double _maxDeci = 0;

class MixturePage extends StatefulWidget {
  @override
  _MixturePageState createState() => new _MixturePageState();
}

class _MixturePageState extends State<MixturePage> {
  static double _accelmaxX = 0;
  static double _accelmaxY = 0;
  static double _accelmaxZ = 0;
  static double _countup_accel = 0;
  static double _useraccelmaxX = 0;
  static double _useraccelmaxY = 0;
  static double _useraccelmaxZ = 0;
  static double _gyromaxX = 0;
  static double _gyromaxY = 0;
  static double _gyromaxZ = 0;

  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];


  bool _isRecording = false;
  bool _isButtonDisabled;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = new NoiseMeter();

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.x > _accelmaxX) {
        _accelmaxX = event.x;
      } else if (event.y > _accelmaxY) {
        _accelmaxY = event.y;
      } else if (event.z > _accelmaxZ) {
        _accelmaxZ = event.z;
      }

      if (event.x > 50) {
        _countup_accel++;
      }
      setState(() {
        _accelerometerValues = <double>[
          _accelmaxX,
          _accelmaxY,
          _accelmaxZ,
          _countup_accel
        ];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      if (event.x > _gyromaxX) {
        _gyromaxX = event.x;
      } else if (event.y > _gyromaxY) {
        _gyromaxY = event.y;
      } else if (event.z > _gyromaxZ) {
        _gyromaxZ = event.z;
      }
      setState(() {
        _gyroscopeValues = <double>[_gyromaxX, _gyromaxY, _gyromaxZ];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (event.x > _useraccelmaxX) {
        _useraccelmaxX = event.x;
      } else if (event.y > _useraccelmaxY) {
        _useraccelmaxY = event.y;
      } else if (event.z > _useraccelmaxZ) {
        _useraccelmaxZ = event.z;
      }
      setState(() {
        _userAccelerometerValues = <double>[
          _useraccelmaxX,
          _useraccelmaxY,
          _useraccelmaxZ
        ];
      });
    }));
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
    if (_maxDeci < noiseReading.maxDecibel) {
      _maxDeci = noiseReading.maxDecibel;
      if (_maxDeci > 80) {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_isRecording ? "現在の過去最大デシベルは" + _maxDeci.toString() : ""),
                    ],
              ))
              ,
              _buildCounterButton(),
            ])),
      ];

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();
    return MaterialApp(
      home: Scaffold(
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black38),
                ),
              ),
            ),
            Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Accelerometer: $accelerometer'),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
            ),
            Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('UserAccelerometer: $userAccelerometer'),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
            ),
            Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Gyroscope: $gyroscope'),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
            ),
            Padding(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getContent(),
              ),
              padding: const EdgeInsets.all(16.0),
            )
          ],
        ),
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
          _isButtonDisabled && _countup_accel > 20 ? "おめでとう、アクション成功だ" : "でし>80とcount>20"),
      onPressed: _toLastPage,
    );
  }

  Function _toLastPage() {
    if (_isButtonDisabled) {
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
          context, MaterialPageRoute(builder: (context) => BokashiPage()));
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
}
