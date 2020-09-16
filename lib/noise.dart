import 'package:flutter/material.dart';

class NoisePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar:AppBar (
      title: new Text('Noiseのページ')
      ),
      body: Container(
        height: double.infinity,
        color: Colors.red,
      ),
    );
  }
}