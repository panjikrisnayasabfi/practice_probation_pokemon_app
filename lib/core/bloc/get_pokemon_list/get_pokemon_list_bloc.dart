import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_probation_pokemon_app/core/domain/repositories/get_pokemon_list_repo.dart';
import 'package:practice_probation_pokemon_app/core/model/pokemon_list_model.dart';

part 'get_pokemon_list_event.dart';
part 'get_pokemon_list_state.dart';

class GetPokemonListBloc
    extends Bloc<GetPokemonListEvent, GetPokemonListState> {
  final GetPokemonListRepo getPokemonListRepo;
  PokemonListModel pokemonListModel;

  GetPokemonListState get initialState => GetPokemonListInitial();

  GetPokemonListBloc({@required this.getPokemonListRepo})
      : assert(getPokemonListRepo != null),
        super(GetPokemonListInitial());

  Stream<GetPokemonListState> mapEventToState(
    GetPokemonListEvent event,
  ) async* {
    if (event is GetPokemonList) {
      yield GetPokemonListLoading();
      try {
        pokemonListModel =
            await getPokemonListRepo.getPokemonList(event.limit, event.offset);
        if (pokemonListModel.results.length != 0) {
          yield GetPokemonListLoaded(pokemonListModel: pokemonListModel);
        } else {
          yield GetPokemonListError('No Data');
        }
      } catch (e) {
        yield GetPokemonListError(e.toString());
      }
    }
  }
}
