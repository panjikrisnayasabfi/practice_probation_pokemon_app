import 'package:flutter/material.dart';
import 'package:practice_probation_pokemon_app/app_constants.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitleTes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(appBarTitle: appTitleTes),
    );
  }
}
