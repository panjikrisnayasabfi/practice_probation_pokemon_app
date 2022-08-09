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
    if (event is SearchPokemon) {
      yield GetPokemonListLoading();
      try {
        pokemonListModel = event.pokemonListModel == null
            ? await getPokemonListRepo.getPokemonList(9999, 0)
            : event.pokemonListModel;
        var tempPokemonList = pokemonListModel.results.where((pokemon) {
          var pokemonName = pokemon.name.toLowerCase();
          var inputName = event.pokemonName.toLowerCase();
          return pokemonName.contains(inputName);
        }).toList();
        pokemonListModel.results = tempPokemonList;
        if (pokemonListModel.results.length != 0) {
          yield SearchPokemonLoaded(pokemonListModel: pokemonListModel);
        } else {
          yield GetPokemonListError('Pokemon not found');
        }
      } catch (e) {
        yield GetPokemonListError(e.toString());
      }
    }
    if (event is FilterPokemonListAdd) {
      yield GetPokemonListLoading();
      try {
        pokemonListModel = await getPokemonListRepo.getPokemonList(9999, 0);
        var tempPokemonList = pokemonListModel.results.where((pokemon) {
          var pokemonName = pokemon.name.toLowerCase();
          var filterName = event.filterName.toLowerCase();
          return pokemonName.startsWith(filterName);
        }).toList();
        pokemonListModel.results = tempPokemonList;
        if (pokemonListModel.results.length != 0) {
          yield FilterPokemonListAddLoaded(pokemonListModel: pokemonListModel);
        } else {
          yield GetPokemonListError('Pokemon not found');
        }
      } catch (e) {
        yield GetPokemonListError(e.toString());
      }
    }
    if (event is FilterPokemonListRemove) {
      yield GetPokemonListLoading();
      try {
        pokemonListModel = event.pokemonListModel;
        pokemonListModel.results.removeWhere((pokemon) {
          var pokemonName = pokemon.name.toLowerCase();
          var filterName = event.filterName.toLowerCase();
          return pokemonName.startsWith(filterName);
        });
        yield FilterPokemonListRemoveLoaded(pokemonListModel: pokemonListModel);
      } catch (e) {
        yield GetPokemonListError(e.toString());
      }
    }
  }
}
