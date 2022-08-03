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
      body: Padding(
        padding: const EdgeInsets.only(top: 32, right: 16, left: 16),
        child: Column(
          children: <Widget>[
            Text('Pokemon List'),
            const SizedBox(height: 8),
            
          ],
        ),
      ),
    );
  }
}