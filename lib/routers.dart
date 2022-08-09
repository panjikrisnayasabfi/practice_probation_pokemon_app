import 'package:flutter/material.dart';
import 'package:practice_probation_pokemon_app/feature/pokemon_deck/presentation/screen/pokemon_deck_screen.dart';

import 'app_constants.dart';
import 'feature/home/presentation/home_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (_, __, ___) => HomeScreen(),
          settings: RouteSettings(name: settings.name),
          transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
              FadeTransition(opacity: a, child: c),
        );
      case Routes.pokemonDeckScreen:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (_, __, ___) => PokemonDeckScreen(),
          settings: RouteSettings(name: settings.name),
          transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
              FadeTransition(opacity: a, child: c),
        );
      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          ),
        );
    }
  }
}
