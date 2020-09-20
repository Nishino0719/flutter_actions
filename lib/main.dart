// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_actions/noise.dart';
import 'package:sensors/sensors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();
    if (_countup_accel < 20) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sensor Example'),
        ),
        body: Column(
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
          ],
        ),
      );
    } else {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NoisePage()));
          },
          child: new Icon(Icons.favorite),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: const Text('アクションを検知しました〜〜'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [],
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
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
}
