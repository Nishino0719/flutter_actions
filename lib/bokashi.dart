import 'dart:ui';

import 'package:flutter/material.dart';

// class BokashiPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: new Scaffold(
//         appBar: AppBar(
//           title: Text('BackdropFilter example'),
//         ),
//         body: new Stack(
//           children: <Widget>[
//             Image.network(
//                 "https://avatars0.githubusercontent.com/u/55534054?s=460&u=402783902455ae84995129488dd3a12d0699fd84&v=4"),
//             Positioned.fill(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                 child: Container(
//                   color: Colors.black.withOpacity(0),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BokashiPage extends StatefulWidget {
  
  @override
  _BokashiPageState createState() => _BokashiPageState();
}

class _BokashiPageState extends State<BokashiPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  var _isScaledUp = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(child:SizeTransition(
        axis: Axis.vertical, // default
        axisAlignment: 0,
        sizeFactor: _animationController
            .drive(
              CurveTween(curve: Curves.fastOutSlowIn),
            )
            .drive(
              Tween<double>(
                begin: 0.01,
                end: 1,
              ),
            ),
        child:Column(
          children: [
            Row(children: <Widget>[
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
    );
  }
}

