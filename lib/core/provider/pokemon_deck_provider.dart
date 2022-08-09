import 'package:flutter/material.dart';
import 'package:practice_probation_pokemon_app/core/model/pokemon_list_model.dart';

class PokemonDeckProvider with ChangeNotifier {
  List<Result> _pokemonDeck = [];

  List<Result> get pokemonDeck => _pokemonDeck;
  int get count => _pokemonDeck.length;

  void addPokemon(Result pokemon) {
    _pokemonDeck.add(pokemon);
    notifyListeners();
  }

  void removePokemon(Result pokemon) {
    _pokemonDeck.remove(pokemon);
    notifyListeners();
  }
}
