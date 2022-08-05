import 'package:dio/dio.dart';
import 'package:practice_probation_pokemon_app/core/config/flavor_config.dart';
import 'package:practice_probation_pokemon_app/core/model/pokemon_list_model.dart';

class GetPokemonListApi {
  PokemonListModel pokemonListModel = PokemonListModel();
  Dio dio = Dio();

  BaseOptions options = new BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: 10 * 1000,
    receiveTimeout: 10 * 1000,
  );

  Future<PokemonListModel> getPokemonList(int limit, int offset) async {
    dio = Dio(options);

    try {
      return await dio
          .get(FlavorConfig.instance.values.baseUrl +
              'pokemon?limit=$limit&offset=$offset')
          .then((result) {
        return PokemonListModel.fromJson(result.data);
      });
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw Exception("Connection Timeout Exception");
      }
      throw Exception(exception.message);
    }
  }
}
