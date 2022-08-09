import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  final String pokemonName;

  const PokemonCard({Key key, @required this.pokemonName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pokemonName),
      ),
    );
  }
}
