import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:practice_probation_pokemon_app/app_constants.dart';
import 'package:practice_probation_pokemon_app/core/bloc/get_pokemon_list/get_pokemon_list_bloc.dart';
import 'package:practice_probation_pokemon_app/core/config/flavor_config.dart';
import 'package:practice_probation_pokemon_app/core/domain/repositories/get_pokemon_list_repo.dart';
import 'package:practice_probation_pokemon_app/core/model/pokemon_list_model.dart';
import 'package:practice_probation_pokemon_app/core/provider/pokemon_deck_provider.dart';
import 'package:practice_probation_pokemon_app/core/widget/filter_card.dart';
import 'package:practice_probation_pokemon_app/core/widget/pokemon_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pagingController = PagingController(firstPageKey: 0);
  final _searchController = TextEditingController();
  final List<String> _filterByAlphabet = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  final int _pageLimit = 20;

  GetPokemonListBloc _getPokemonListBloc =
      GetPokemonListBloc(getPokemonListRepo: GetPokemonListRepo());
  PokemonListModel _pokemonListModel;
  int _pageKey = 0;
  List<String> _selectedFilter = [];
  List<Result> _filteredPokemonListMaster = [];

  void _onFilterTap(String filterName) {
    if (_selectedFilter.contains(filterName)) {
      _selectedFilter.remove(filterName);
      _getPokemonListBloc
          .add(FilterPokemonListRemove(filterName, _pokemonListModel));
    } else {
      _selectedFilter.add(filterName);
      _getPokemonListBloc.add(FilterPokemonListAdd(filterName));
    }
  }

  void _onAddPokemon(Result pokemon) {
    Provider.of<PokemonDeckProvider>(context, listen: false)
        .addPokemon(pokemon);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${pokemon.name.toUpperCase()} added to deck'),
      duration: Duration(milliseconds: 700),
    ));
  }

  void _appendList(List<Result> pokemonList) {
    final isLastPage = pokemonList.length < _pageLimit;
    if (isLastPage) {
      _pagingController.appendLastPage(pokemonList);
    } else {
      final nextPageKey = _pageKey + pokemonList.length;
      _pagingController.appendPage(pokemonList, nextPageKey);
    }
  }

  @override
  void initState() {
    // dummy code to show notification instantly
    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: 0,
    //     channelKey: 'high_importance_channel',
    //     title: 'Incoming Call',
    //     body: 'Call from Panji',
    //     wakeUpScreen: true,
    //     locked: true,
    //     autoDismissible: false,
    //     category: NotificationCategory.Call,
    //     displayOnForeground: true,
    //     displayOnBackground: true,
    //     fullScreenIntent: true, // lock the notification
    //   ),
    //   actionButtons: [
    //     NotificationActionButton(
    //       key: 'reject',
    //       label: 'Reject',
    //       color: ColorName.red,
    //       icon:
    //           'resource://drawable/res_reject', // TODO: unable to show the icon
    //     ),
    //     NotificationActionButton(
    //       key: 'pickup',
    //       label: 'Pickup',
    //       color: ColorName.green,
    //       icon:
    //           'resource://drawable/res_pickup', // TODO: unable to show the icon
    //     ),
    //   ],
    // );

    _getPokemonListBloc.add(GetPokemonList(_pageLimit, _pageKey));

    _searchController.addListener(() {
      if (_filteredPokemonListMaster.length != 0) {
        _pokemonListModel.results = _filteredPokemonListMaster;
      }
      _getPokemonListBloc.add(SearchPokemon(_searchController.text,
          _selectedFilter.length <= 0 ? null : _pokemonListModel));
    });

    _pagingController.addPageRequestListener((pageKey) {
      if (_searchController.text.isEmpty && _selectedFilter.length == 0) {
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
    AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      print('Action stream $receivedNotification');
      if (receivedNotification.buttonKeyPressed == 'pickup') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.pokemonDeckScreen,
          (route) => route.isFirst,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(FlavorConfig.instance.appTitle),
        backgroundColor: FlavorConfig.instance.appBarColor,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, top: 15, bottom: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.pokemonDeckScreen);
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6, bottom: 2),
                    child: Image.asset('assets/icons/poke_ball.png'),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      width: 12,
                      height: 12,
                      child: Center(
                        child: Text(
                          Provider.of<PokemonDeckProvider>(
                            context,
                            listen: true,
                          ).count.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<GetPokemonListBloc, GetPokemonListState>(
        cubit: _getPokemonListBloc,
        listener: (BuildContext context, GetPokemonListState state) {
          if (state is GetPokemonListLoaded) {
            if (_searchController.text.isNotEmpty) {
              _getPokemonListBloc
                  .add(SearchPokemon(_searchController.text, null));
            } else {
              _pokemonListModel = state.pokemonListModel;
              _appendList(_pokemonListModel.results);
            }
          }
          if (state is SearchPokemonLoaded) {
            _pokemonListModel = state.pokemonListModel;
            _pagingController.itemList = null;
            _pagingController.appendLastPage(_pokemonListModel.results);
          }
          if (state is FilterPokemonListAddLoaded) {
            if (_selectedFilter.length == 1) {
              _pagingController.itemList = [];
              _filteredPokemonListMaster = [];
              _pokemonListModel = state.pokemonListModel;
              _filteredPokemonListMaster = state.pokemonListModel.results;
            } else {
              _pokemonListModel.results += state.pokemonListModel.results;
              _filteredPokemonListMaster += state.pokemonListModel.results;
            }
            if (_searchController.text.isNotEmpty) {
              _getPokemonListBloc.add(
                  SearchPokemon(_searchController.text, _pokemonListModel));
            }
            _pagingController.appendLastPage(state.pokemonListModel.results);
          }
          if (state is FilterPokemonListRemoveLoaded) {
            _pagingController.itemList = null;
            _pokemonListModel = state.pokemonListModel;
            _filteredPokemonListMaster = state.pokemonListModel.results;
            if (state.pokemonListModel.results.length == 0) {
              _getPokemonListBloc.add(GetPokemonList(_pageLimit, 0));
            } else {
              _pagingController.appendLastPage(_pokemonListModel.results);
            }
          }
        },
        child: BlocBuilder<GetPokemonListBloc, GetPokemonListState>(
          cubit: _getPokemonListBloc,
          builder: (context, GetPokemonListState state) {
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
          Text(
            'Pokemon List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            decoration: new InputDecoration(hintText: 'Search pokemon'),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView.builder(
              itemCount: _filterByAlphabet.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => FilterCard(
                filterName: _filterByAlphabet[index],
                onTap: () => _onFilterTap(_filterByAlphabet[index]),
                isSelected: _selectedFilter.contains(_filterByAlphabet[index]),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (state is GetPokemonListError)
            Text(state.error)
          else
            Expanded(
              child: PagedListView(
                pagingController: _pagingController,
                padding: const EdgeInsets.only(bottom: 20),
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, pokemon, index) => PokemonCard(
                    pokemonName: pokemon.name,
                    onTapButton: () => _onAddPokemon(pokemon),
                    action: PokemonListActions.add,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
