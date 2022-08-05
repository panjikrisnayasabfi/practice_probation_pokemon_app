import 'package:practice_probation_pokemon_app/core/domain/api/get_pokemon_list_api.dart';
import 'package:practice_probation_pokemon_app/core/model/pokemon_list_model.dart';

class GetPokemonListRepo {
  GetPokemonListApi getPokemonListApi = GetPokemonListApi();

  Future<PokemonListModel> getPokemonList(int limit, int offset) =>
      getPokemonListApi.getPokemonList(limit, offset);
}
