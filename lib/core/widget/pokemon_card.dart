import 'package:flutter/material.dart';
import 'package:practice_probation_pokemon_app/app_constants.dart';

class PokemonCard extends StatelessWidget {
  final String pokemonName;
  final Function onTapButton;
  final String action;

  const PokemonCard(
      {Key key, @required this.pokemonName, this.onTapButton, this.action})
      : super(key: key);

  String getActionName(String action) {
    switch (action) {
      case PokemonListActions.add:
        return 'ADD';
        break;
      case PokemonListActions.remove:
        return 'REMOVE';
        break;
      default:
        return 'ADD';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Text(pokemonName.toUpperCase()),
            Spacer(),
            TextButton(
              onPressed: () => onTapButton(),
              child: Text(getActionName(action)),
            )
          ],
        ),
      ),
    );
  }
}
