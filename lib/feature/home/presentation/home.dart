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
  final _filterController = TextEditingController();

  GetPokemonListBloc _getPokemonListBloc =
      GetPokemonListBloc(getPokemonListRepo: GetPokemonListRepo());
  PokemonListModel _pokemonListModel;
  int _pageLimit = 20;
  int _pageKey = 0;

  @override
  void initState() {
    _getPokemonListBloc.add(GetPokemonList(_pageLimit, _pageKey));

    _filterController.addListener(() {
      if (_filterController.text.isEmpty) {
        _pagingController.itemList = null;
        _getPokemonListBloc.add(GetPokemonList(_pageLimit, _pageKey));
      } else {
        _getPokemonListBloc.add(FilterPokemonList(_filterController.text));
      }
    });

    _pagingController.addPageRequestListener((pageKey) {
      if (_filterController.text.isEmpty) {
        _pageKey = pageKey;
        _getPokemonListBloc.add(GetPokemonList(_pageLimit, _pageKey));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _getPokemonListBloc.close();
    super.dispose();
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
          if (state is GetPokemonListInitial) {}
          if (state is GetPokemonListLoading) {}
          if (state is GetPokemonListLoaded) {
            _pokemonListModel = state.pokemonListModel;

            final isLastPage = _pokemonListModel.results.length < _pageLimit;
            if (isLastPage) {
              _pagingController.appendLastPage(_pokemonListModel.results);
            } else {
              final nextPageKey = _pageKey + _pokemonListModel.results.length;
              _pagingController.appendPage(
                  _pokemonListModel.results, nextPageKey);
            }
          }
          if (state is FilterPokemonListLoaded) {
            _pokemonListModel = state.pokemonListModel;
            _pagingController.itemList = null;
            _pagingController.appendLastPage(_pokemonListModel.results);
          }
          if (state is GetPokemonListError) {}
        },
        child: BlocBuilder<GetPokemonListBloc, GetPokemonListState>(
          cubit: _getPokemonListBloc,
          builder: (context, GetPokemonListState state) {
            if (state is GetPokemonListInitial) {}
            if (state is GetPokemonListLoading) {}
            if (state is GetPokemonListLoaded) {}
            if (state is FilterPokemonListLoaded) {}
            if (state is GetPokemonListError) {}
            return mainContent(state);
          },
        ),
      ),
    );
  }

  Widget mainContent(GetPokemonListState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Pokemon List'),
          const SizedBox(height: 10),
          TextField(
            controller: _filterController,
            decoration: new InputDecoration(hintText: 'Search pokemon'),
          ),
          const SizedBox(height: 30),
          (state is GetPokemonListError)
              ? Text(state.error)
              : Expanded(
                  child: PagedListView(
                    pagingController: _pagingController,
                    padding: const EdgeInsets.only(bottom: 20),
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
