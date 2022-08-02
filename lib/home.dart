import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key, this.appBarTitle}) : super(key: key);

  final String appBarTitle;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is home screen',
            ),
          ],
        ),
      ),
    );
  }
}