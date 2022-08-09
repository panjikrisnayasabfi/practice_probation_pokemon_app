part of 'get_pokemon_list_bloc.dart';

abstract class GetPokemonListEvent extends Equatable {}

class GetPokemonList extends GetPokemonListEvent {
  final int limit;
  final int offset;

  GetPokemonList(this.limit, this.offset);

  @override
  List<Object> get props => [];
}

class SearchPokemon extends GetPokemonListEvent {
  final String pokemonName;
  final PokemonListModel pokemonListModel;

  SearchPokemon(this.pokemonName, this.pokemonListModel);

  @override
  List<Object> get props => [];
}

class FilterPokemonListAdd extends GetPokemonListEvent {
  final String filterName;

  FilterPokemonListAdd(this.filterName);

  @override
  List<Object> get props => [];
}

class FilterPokemonListRemove extends GetPokemonListEvent {
  final String filterName;
  final PokemonListModel pokemonListModel;

  FilterPokemonListRemove(this.filterName, this.pokemonListModel);

  @override
  List<Object> get props => [];
}
