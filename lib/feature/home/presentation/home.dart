import 'package:flutter/material.dart';
import 'package:practice_probation_pokemon_app/core/flavor_config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlavorConfig.instance.appTitle),
        backgroundColor: FlavorConfig.instance.appBarColor,
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