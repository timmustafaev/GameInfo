import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_app/models/video_game.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PantallaListaJuegos extends StatefulWidget {
  const PantallaListaJuegos({Key? key}) : super(key: key);

  @override
  _PantallaListaJuegosState createState() => _PantallaListaJuegosState();
}

class _PantallaListaJuegosState extends State<PantallaListaJuegos> {
  bool ordenado = false;
  bool ascendente = true;
  bool isSearching = false;
  bool isDev = false;
  bool _dev = false;
  late List<dynamic> lista;
  late TextEditingController _searchController;
  final _formKey = GlobalKey<FormState>();
  late final CollectionReference<Map<String, dynamic>> _games;
  late final CollectionReference<Map<String, dynamic>> _users;
  String dropdownValue = 'Filter';
  var user = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  @override
  void initState() {
    _searchController = TextEditingController();
    _games = FirebaseFirestore.instance.collection('games');
    _users = FirebaseFirestore.instance.collection('users');
    user.get().then((value) {
      lista = value.data()!['fav_list'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Sign-Out'),
                          content: Text('¿Quieres cerrar sesión?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login', (route) => false);
                              },
                              child: Text('Sí'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('No'),
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.logout_outlined)),
            Expanded(child: Center(child: Text('Videogames'))),
            IconButton(
                onPressed: () {
                  if (lista.isEmpty) {
                  } else {
                    Navigator.of(context).pushNamed('/favs');
                  }
                },
                icon: Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ))
          ],
        ),
      ),
      body: StreamBuilder(stream: _getStream(), builder: _buildWidget),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: Icon(Icons.search)),
            Expanded(child: SizedBox()),
            DropdownButton<String>(
              dropdownColor: Colors.black,
              value: dropdownValue,
              icon: const Icon(Icons.filter_list_rounded),
              style: const TextStyle(color: Colors.white),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Filter', 'Genre', 'A-Z', 'Z-A']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? _getStream() {
    if (dropdownValue == 'A-Z') {
      return _games.orderBy('name', descending: !ascendente).snapshots();
    }
    if (dropdownValue == 'Z-A') {
      return _games.orderBy('name', descending: ascendente).snapshots();
    }
    if (dropdownValue == 'Genre') {
      return _games.orderBy('genre', descending: !ascendente).snapshots();
    }
    return _games.snapshots();
  }

  Widget _buildAddButton() {
    var _email = FirebaseAuth.instance.currentUser?.email;
    _users.where('mail', isEqualTo: _email).get().then((value) {
      if (value.docs[0].data()['dev']) {
        setState(() {
          _dev = true;
        });
      }
    });
    if (_dev == true) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/añadir').then((value) {
            if (value != null) {
              setState(() {
                _games.add((value as Game).toJson());
              });
            }
          });
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildWidget(BuildContext context,
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.hasData) {
      List jocs = snapshot.data!.docs;
      if (isSearching) {
        jocs = jocs.where((json) {
          Game g = Game.fromJson(json.data());
          return g.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
        }).toList();
      }
      return Column(
        children: [
          if (isSearching)
            TextField(
              onChanged: (text) => setState(() {}),
              key: _formKey,
              controller: _searchController,
            ),
          Expanded(
            child: ListView.builder(
                itemCount: jocs.length,
                itemBuilder: (context, index) =>
                    _buildItem(context, jocs[index])),
          ),
        ],
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildItem(BuildContext context,
      QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot) {
    Game g = Game.fromJson(docSnapshot.data());
    return Card(
        child: ListTile(
      isThreeLine: true,
      onLongPress: () {
        var _email = FirebaseAuth.instance.currentUser?.email;
        _users.where('mail', isEqualTo: _email).get().then((value) {
          if (value.docs[0].data()['dev']) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Borrar juego'),
                  content: Text('¿Quieres borrar el juego ${g.name}'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Sí'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('No'),
                    ),
                  ],
                );
              },
            ).then((value) {
              if (value) {
                setState(() {
                  docSnapshot.reference.delete();
                });
              }
            });
          }
        });
      },
      onTap: () {
        Navigator.of(context).pushNamed('/videogame', arguments: g);
      },
      leading: _buildImage(g.url),
      title: Text(g.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(g.platform.length > 4
              ? g.platform.sublist(0, 4).join(', ') + '...'
              : g.platform.join(', ')),
          Text(g.genre.length > 3
              ? g.genre.sublist(0, 2).join(', ') + '...'
              : g.genre.join(', ')),
        ],
      ),
    ));
  }

  _buildImage(String? url) {
    if (url != null) {
      return Image.network(
        url,
        height: 60,
        width: 60,
        fit: BoxFit.cover,
      );
    }
    return Icon(
      Icons.broken_image_outlined,
      size: 40,
    );
  }
}
