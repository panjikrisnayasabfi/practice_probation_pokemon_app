import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:practice_probation_pokemon_app/core/bloc/get_pokemon_list/get_pokemon_list_bloc.dart';
import 'package:practice_probation_pokemon_app/core/config/flavor_config.dart';
import 'package:practice_probation_pokemon_app/core/domain/repositories/get_pokemon_list_repo.dart';
import 'package:practice_probation_pokemon_app/core/model/pokemon_list_model.dart';
import 'package:practice_probation_pokemon_app/core/widget/pokemon_card.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pagingController = PagingController(firstPageKey: 0);
  final int _pageLimit = 20;
  int _pageKey = 0;
  List<Result> _result = [];

  GetPokemonListBloc _getPokemonListBloc =
      GetPokemonListBloc(getPokemonListRepo: GetPokemonListRepo());

  @override
  void initState() {
    _getPokemonListBloc.add(GetPokemonList(_pageLimit, _pageKey));
    _pagingController.addPageRequestListener((pageKey) async {
      _pageKey = pageKey;
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _getPokemonListBloc.close();
    super.dispose();
  }

  void _fetchPage(int pageKey) {
    try {
      final newItems = _result;

      final isLastPage = newItems.length < _pageLimit;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlavorConfig.instance.appTitle),
        backgroundColor: FlavorConfig.instance.appBarColor,
      ),
      body: BlocListener<GetPokemonListBloc, GetPokemonListState>(
        cubit: _getPokemonListBloc,
        listener: (BuildContext context, GetPokemonListState state) {
          if (state is GetPokemonListLoading) {}
          if (state is GetPokemonListLoaded) {
            _result = state.pokemonListModel.results;
          }
          if (state is GetPokemonListError) {}
        },
        child: BlocBuilder<GetPokemonListBloc, GetPokemonListState>(
          cubit: _getPokemonListBloc,
          builder: (context, GetPokemonListState state) {
            if (state is GetPokemonListLoading) {}
            if (state is GetPokemonListLoaded) {
              return mainContent();
            }
            if (state is GetPokemonListError) {}
            return Container();
          },
        ),
      ),
    );
  }

  Widget mainContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Pokemon List'),
          const SizedBox(height: 8),
          Expanded(
            child: PagedListView(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, pokemon, index) =>
                    PokemonCard(pokemonName: pokemon.name),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
