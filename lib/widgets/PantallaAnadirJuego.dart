// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project_app/models/video_game.dart';

class AddGame extends StatefulWidget {
  const AddGame({Key? key}) : super(key: key);

  @override
  _AddGameState createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {
  late List<TextEditingController> _controllers;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<String> fields;
  //Game? game;
  void initState() {
    _controllers = List.empty(growable: true);
    fields = [
      'Title',
      'Description',
      'Release',
      'Genre',
      'Developer',
      'Platforms',
      'Url Image'
    ];
    for (int i = 0; i < 9; i++) {
      _controllers.add(TextEditingController());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new game'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _addGame(context),
          ),
          Expanded(flex: 1, child: _addButtons(context)),
        ],
      ),
    );
  }

  Widget _addGame(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < 7; i++)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _controllers[i],
                          decoration: InputDecoration(
                            labelText: fields[i],
                            hintText: 'Enter the ${fields[i]}',
                            hintStyle: TextStyle(fontSize: 13),
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty)
                              return 'Required field';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          )),
    );
  }

  Widget _addButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancelar")),
      ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Game g = Game(
                  name: _controllers[0].text,
                  desc: _controllers[1].text,
                  release: _controllers[2].text,
                  genre: _controllers[3].text.split(','),
                  dev: _controllers[4].text.split(','),
                  platform: _controllers[5].text.split(','),
                  valoracion: 0,
                  votes: 0,
                  url: _controllers[6].text);
              Navigator.of(context).pop(g);
            }
          },
          child: Text("Aceptar")),
    ]);
  }
}
