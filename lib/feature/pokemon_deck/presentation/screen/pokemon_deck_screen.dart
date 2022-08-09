import 'package:flutter/material.dart';
import 'package:practice_probation_pokemon_app/app_constants.dart';
import 'package:practice_probation_pokemon_app/core/model/pokemon_list_model.dart';
import 'package:practice_probation_pokemon_app/core/provider/pokemon_deck_provider.dart';
import 'package:practice_probation_pokemon_app/core/widget/pokemon_card.dart';
import 'package:provider/provider.dart';

class PokemonDeckScreen extends StatefulWidget {
  const PokemonDeckScreen({Key key}) : super(key: key);

  @override
  State<PokemonDeckScreen> createState() => _PokemonDeckScreenState();
}

class _PokemonDeckScreenState extends State<PokemonDeckScreen> {
  void _onRemovePokemon(Result pokemon) {
    Provider.of<PokemonDeckProvider>(context, listen: false)
        .removePokemon(pokemon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon Deck'),
        backgroundColor: Colors.red,
      ),
      body: Consumer<PokemonDeckProvider>(
        builder: (context, provider, widget) => Column(
          children: [
            if (provider.count <= 0)
              Expanded(child: Center(child: Text('No pokemon found')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.count,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  itemBuilder: (context, index) => PokemonCard(
                    pokemonName: provider.pokemonDeck[index].name,
                    onTapButton: () =>
                        _onRemovePokemon(provider.pokemonDeck[index]),
                    action: PokemonListActions.remove,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
