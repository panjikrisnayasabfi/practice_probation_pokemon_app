import 'package:flutter/material.dart';
import 'app_constants.dart';
import 'core/flavor_config.dart';
import 'main.dart';

void main() async {
  FlavorConfig(appTitle: appTitleTes, appBarColor: Colors.blue, flavor: Flavor.DEV, values: FlavorValues(baseUrl: '', passwordConfig: '', usernameConfig: ''));
  runApp(MyApp());
}
