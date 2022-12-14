import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:practice_probation_pokemon_app/core/model/pokemon_list_model.dart';

class PokemonDeckProvider with ChangeNotifier {
  List<Result> _pokemonDeck = [];
  String _deckName = 'Untitled Deck';
  CroppedFile _deckImage;
  FilePickerResult _attachedFile;

  List<Result> get pokemonDeck => _pokemonDeck;
  int get count => _pokemonDeck.length;
  String get deckName => _deckName;
  String get deckImagePath => _deckImage != null ? _deckImage.path : null;
  String get attachedFilePath =>
      _attachedFile != null ? _attachedFile.files.single.path : null;
  String get attachedFileExtension =>
      _attachedFile != null ? _attachedFile.files.single.extension : null;
  String get attachedFileName =>
      _attachedFile != null ? _attachedFile.files.single.name : null;

  void addPokemon(Result pokemon) {
    _pokemonDeck.add(pokemon);
    notifyListeners();
  }

  void removePokemon(Result pokemon) {
    _pokemonDeck.remove(pokemon);
    notifyListeners();
  }

  void setDeckName(String deckName) {
    _deckName = deckName;
    notifyListeners();
  }

  void setDeckImage(CroppedFile deckImage) {
    _deckImage = deckImage;
    notifyListeners();
  }

  void setAttachedFile(FilePickerResult attachedFile) {
    _attachedFile = attachedFile;
    notifyListeners();
  }
}
