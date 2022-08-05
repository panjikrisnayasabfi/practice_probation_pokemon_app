import 'package:flutter/material.dart';
import 'app_constants.dart';
import 'core/config/flavor_config.dart';
import 'main.dart';

void main() async {
  FlavorConfig(
      appTitle: appTitleTes,
      appBarColor: Colors.blue,
      flavor: Flavor.DEV,
      values: FlavorValues(
          baseUrl: 'https://pokeapi.co/api/v2/',
          passwordConfig: '',
          usernameConfig: ''));
  runApp(MyApp());
}
