import 'package:flutter/material.dart';

class MixturePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar:AppBar (
          title: new Text('全てのテストをするページ')
      ),
      body: Container(
        height: double.infinity,
        color: Colors.red,
      ),
    );
  }
}