import 'package:flutter/material.dart';
import 'package:practice_probation_pokemon_app/app_constants.dart';
import 'package:practice_probation_pokemon_app/core/provider/pokemon_deck_provider.dart';
import 'package:practice_probation_pokemon_app/routers.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PokemonDeckProvider())
      ],
      child: MaterialApp(
        title: 'Pokemon App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: Routers.generateRoute,
        initialRoute: Routes.homeScreen,
      ),
    );
  }
}
