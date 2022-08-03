import 'package:flutter/material.dart';
import 'package:practice_probation_pokemon_app/app_constants.dart';

import 'feature/home/presentation/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitleProd,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(appBarTitle: appTitleProd),
    );
  }
}
