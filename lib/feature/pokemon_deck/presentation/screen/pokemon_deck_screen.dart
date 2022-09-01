import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice_probation_pokemon_app/app_constants.dart';
import 'package:practice_probation_pokemon_app/core/provider/pokemon_deck_provider.dart';
import 'package:practice_probation_pokemon_app/core/widget/pokemon_card.dart';
import 'package:provider/provider.dart';

class PokemonDeckScreen extends StatefulWidget {
  const PokemonDeckScreen({Key key}) : super(key: key);

  @override
  State<PokemonDeckScreen> createState() => _PokemonDeckScreenState();
}

class _PokemonDeckScreenState extends State<PokemonDeckScreen> {
  final TextEditingController _deckNameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isEditDeckName = false;

  void _pickImage(ImageSource pickSource, PokemonDeckProvider provider) async {
    Navigator.pop(context);
    var pickedImage = await _imagePicker.pickImage(source: pickSource);

    var croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      cropStyle: CropStyle.circle,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Deck Image',
          toolbarColor: Colors.redAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );

    provider.setDeckImage(croppedFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon Deck'),
        backgroundColor: Colors.red,
      ),
      body: Consumer<PokemonDeckProvider>(
        builder: (context, provider, widget) => Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _deckImageWidget(provider),
                        const SizedBox(height: 16),
                        if (_isEditDeckName == false)
                          _deckTitleWidget(provider),
                        if (_isEditDeckName == true)
                          _editDeckTitleWidget(provider),
                        const SizedBox(height: 24),
                        _deckAttachmentWidget(provider),
                      ],
                    ),
                  ),
                  if (provider.count <= 0)
                    Expanded(child: Center(child: Text('No pokemon found')))
                  else
                    _listPokemonDeckWidget(provider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deckImageWidget(PokemonDeckProvider provider) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return _pickImageModalWidget(context, provider);
          },
        );
      },
      child: CircleAvatar(
        radius: 56,
        backgroundColor: Colors.grey,
        backgroundImage: provider.deckImagePath == null
            ? AssetImage('assets/icons/poke_ball.png')
            : Image.file(File(provider.deckImagePath)).image,
      ),
    );
  }

  Widget _pickImageModalWidget(
      BuildContext context, PokemonDeckProvider provider) {
    return Container(
      child: Wrap(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change Deck Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    _pickImage(ImageSource.camera, provider);
                  },
                  child: Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Camera',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    _pickImage(ImageSource.gallery, provider);
                  },
                  child: Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Pick Image from Gallery',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deckTitleWidget(PokemonDeckProvider provider) {
    return Row(
      children: [
        Text(
          provider.deckName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
            onTap: () {
              setState(() {
                _isEditDeckName = true;
              });
            },
            child: Icon(
              Icons.edit,
              size: 20,
              color: Colors.grey,
            )),
      ],
    );
  }

  Widget _editDeckTitleWidget(PokemonDeckProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _deckNameController,
          decoration: InputDecoration(hintText: 'Input deck name here'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditDeckName = false;
                });
              },
              child: Text('CANCEL'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditDeckName = false;
                  provider.setDeckName(_deckNameController.text);
                });
              },
              child: Text('UPDATE'),
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _deckAttachmentWidget(PokemonDeckProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deck Attachment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (provider.attachedFilePath == null)
              Flexible(
                child: Text('No attachment'),
              ),
            if (provider.attachedFilePath != null)
              Flexible(
                  child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.grey[350],
                child: Column(
                  children: [
                    if (provider.attachedFileExtension == 'jpg' ||
                        provider.attachedFileExtension == 'jpeg' ||
                        provider.attachedFileExtension == 'png')
                      Icon(Icons.image),
                    if (provider.attachedFileExtension == 'mp4')
                      Icon(Icons.video_file),
                    if (provider.attachedFileExtension == 'm4a' ||
                        provider.attachedFileExtension == 'mp3')
                      Icon(Icons.audio_file),
                    if (provider.attachedFileExtension == 'pdf' ||
                        provider.attachedFileExtension == 'doc' ||
                        provider.attachedFileExtension == 'docx' ||
                        provider.attachedFileExtension == 'ppt' ||
                        provider.attachedFileExtension == 'pptx' ||
                        provider.attachedFileExtension == 'xls' ||
                        provider.attachedFileExtension == 'xlsx')
                      Icon(Icons.insert_drive_file),
                    const SizedBox(height: 8),
                    Text(provider.attachedFileName),
                  ],
                ),
              )),
            const SizedBox(width: 16),
            InkWell(
                onTap: () async {
                  var pickedFile =
                      await FilePicker.platform.pickFiles(allowedExtensions: [
                    'jpg',
                    'jpeg',
                    'png',
                    'mp4',
                    'm4a',
                    'mp3',
                    'pdf',
                    'doc',
                    'docx',
                    'ppt',
                    'pptx',
                    'xls',
                    'xlsx',
                  ], type: FileType.custom);
                  print('picked file: $pickedFile');

                  if (pickedFile == null) {
                    return;
                  }

                  // if file size is more than 5 MB, then show 'unable to upload file'
                  if (pickedFile.files.single.size > 5000000) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Unable to upload file more than 5 MB"),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  if (pickedFile.files.single.path != null) {
                    provider.setAttachedFile(pickedFile);
                  }
                },
                child: Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.grey,
                )),
            const SizedBox(width: 16),
            if (provider.attachedFilePath != null)
              InkWell(
                  onTap: () {
                    provider.setAttachedFile(null);
                  },
                  child: Icon(
                    Icons.delete,
                    size: 16,
                    color: Colors.grey,
                  )),
          ],
        ),
      ],
    );
  }

  Widget _listPokemonDeckWidget(PokemonDeckProvider provider) {
    return Expanded(
      child: ListView.builder(
        itemCount: provider.count,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
        itemBuilder: (context, index) => PokemonCard(
          pokemonName: provider.pokemonDeck[index].name,
          onTapButton: () =>
              provider.removePokemon(provider.pokemonDeck[index]),
          action: PokemonListActions.remove,
        ),
      ),
    );
  }
}
