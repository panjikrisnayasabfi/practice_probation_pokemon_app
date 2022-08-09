part of 'get_pokemon_list_bloc.dart';

abstract class GetPokemonListState extends Equatable {
  const GetPokemonListState();

  @override
  List<Object> get props => [];
}

class GetPokemonListInitial extends GetPokemonListState {}

class GetPokemonListLoading extends GetPokemonListState {}

class GetPokemonListLoaded extends GetPokemonListState {
  final PokemonListModel pokemonListModel;

  const GetPokemonListLoaded({this.pokemonListModel});

  @override
  List<Object> get props => [pokemonListModel];
}

class SearchPokemonLoaded extends GetPokemonListState {
  final PokemonListModel pokemonListModel;

  const SearchPokemonLoaded({this.pokemonListModel});

  @override
  List<Object> get props => [pokemonListModel];
}

class FilterPokemonListAddLoaded extends GetPokemonListState {
  final PokemonListModel pokemonListModel;

  const FilterPokemonListAddLoaded({this.pokemonListModel});

  @override
  List<Object> get props => [pokemonListModel];
}

class FilterPokemonListRemoveLoaded extends GetPokemonListState {
  final PokemonListModel pokemonListModel;

  const FilterPokemonListRemoveLoaded({this.pokemonListModel});

  @override
  List<Object> get props => [pokemonListModel];
}

class GetPokemonListError extends GetPokemonListState {
  final String error;

  const GetPokemonListError(this.error) : assert(error != null);

  @override
  List<Object> get props => [error];
}
