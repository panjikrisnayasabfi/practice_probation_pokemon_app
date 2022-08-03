import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_pokemon_list_event.dart';
part 'get_pokemon_list_state.dart';

class GetPokemonListBloc extends Bloc<GetPokemonListEvent, GetPokemonListState> {
  GetPokemonListBloc() : super(GetPokemonListInitial()) {
    on<GetPokemonListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
