import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

// https://medium.com/flutter-jp/transition-9c57528c84b8
class BokashiPage extends StatefulWidget {
  @override
  _BokashiPageState createState() => _BokashiPageState();
}

class _BokashiPageState extends State<BokashiPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  var _isScaledUp = false;
  static double _accelmaxX = 0;
  static double _accelmaxY = 0;
  static double _accelmaxZ = 0;
  static double _countup_accel = 0;
  List<double> _accelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isScaledUp) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
          _isScaledUp = !_isScaledUp;
        },
        child: const Icon(Icons.refresh),
      ),
      body: Column(
        children: [
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Accelerometer: $accelerometer'),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
          ),
          Center(
            child: SizeTransition(
              axis: Axis.vertical, // default
              axisAlignment: 0,
              sizeFactor: _animationController
                  .drive(
                CurveTween(curve: Curves.fastOutSlowIn),
              )
                  .drive(
                Tween<double>(
                  begin: 0.01,
                  end: _countup_accel*0.001,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Image.network(
                          "https://avatars0.githubusercontent.com/u/55534054?s=460&u=402783902455ae84995129488dd3a12d0699fd84&v=4"),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.black.withOpacity(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
