import 'package:flutter/widgets.dart';

enum Flavor {
  DEV,
  TES,
  PROD,
}

class FlavorValues {
  final String baseUrl;
  final String usernameConfig;
  final String passwordConfig;

  const FlavorValues({
    @required this.baseUrl,
    @required this.usernameConfig,
    @required this.passwordConfig,
  });
}

class FlavorConfig {
  final String appTitle;
  final Flavor flavor;
  final FlavorValues values;
  final Color appBarColor;
  static FlavorConfig _instance;

  factory FlavorConfig({
    @required appTitle,
    @required flavor,
    @required appBarColor,
    @required values
  }) {
    _instance ??= FlavorConfig._internal(
        appTitle, flavor, appBarColor, values);
    return _instance;
  }

  const FlavorConfig._internal(this.appTitle, this.flavor, this.appBarColor, this.values);

  static FlavorConfig get instance {
    return _instance;
  }
}