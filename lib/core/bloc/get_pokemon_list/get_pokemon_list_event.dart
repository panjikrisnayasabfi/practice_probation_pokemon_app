part of 'get_pokemon_list_bloc.dart';

abstract class GetPokemonListEvent extends Equatable {}

class GetPokemonList extends GetPokemonListEvent {
  final int limit;
  final int offset;

  GetPokemonList(this.limit, this.offset);

  @override
  List<Object> get props => [];
}
