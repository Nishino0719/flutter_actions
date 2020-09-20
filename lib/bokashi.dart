import 'dart:ui';

import 'package:flutter/material.dart';


class BokashiPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: AppBar(
          title: Text('BackdropFilter example'),
        ),
        body: new Stack(
          children: <Widget>[
            Text(
              'Hello World',
              style: TextStyle(
                fontSize: 100,
              ),
            ),
            new ClipRect(
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: const Color(0).withOpacity(0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}