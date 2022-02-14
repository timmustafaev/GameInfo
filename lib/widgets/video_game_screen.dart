import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_app/models/icono.dart';
import '../models/video_game.dart';

class VideogameScreen extends StatelessWidget {
  const VideogameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WidgetGame(
      game: ModalRoute.of(context)!.settings.arguments as Game,
    ));
  }
}

class WidgetGame extends StatefulWidget {
  final Game game;

  WidgetGame({Key? key, required this.game}) : super(key: key);

  @override
  _WidgetGameState createState() => _WidgetGameState();
}

class _WidgetGameState extends State<WidgetGame> {
  late num votos, valoracion;
  late List<IconButton> stars;
  late bool isFav;
  late IconButton add;
  late final CollectionReference<Map<String, dynamic>> _games;
  var user = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  void initState() {
    isFav = false;
    initLista();
    _games = FirebaseFirestore.instance.collection('games');
    user.get().then((value) {
      List<dynamic> juegos = value.data()!['fav_list'] as List;
      setState(() {
        isFav = juegos.contains(widget.game.name);
      });
    });
    stars = List.empty(growable: true);
    for (int i = 0; i < 5; i++) {
      stars.add(
        new IconButton(
          icon: Icon(Icons.star, color: Colors.white, size: 16),
          onPressed: () {},
        ),
      );
    }
    super.initState();
  }

  void initLista() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _getBackground(),
          _getDesc(),
        ],
      ),
    );
  }

  Widget _getBackground() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      width: double.infinity,
      height: 300,
      child: _getPantallaPrincipal(),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(widget.game.url!), fit: BoxFit.fill),
      ),
    );
  }

  Widget _getDesc() {
    final ScrollController _fistController = ScrollController();
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 300,
            width: 400,
            child: SingleChildScrollView(
              child: Text(widget.game.desc,
                  style: TextStyle(color: Colors.white60, fontSize: 14)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Release',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      '${widget.game.release}',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Genre',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      widget.game.genre.join(', '),
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Developer',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      widget.game.dev.join(', '),
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getPantallaPrincipal() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'GameInfo',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Games',
                style: TextStyle(color: Colors.white60, fontSize: 10),
              ),
            ),
            Expanded(
              child: Container(),
              flex: 1,
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < widget.game.platform.length; i++)
                Row(
                  children: [
                    Container(
                      color: i == 0
                          ? Colors.grey
                          : (i == 1 ? Colors.blue : Colors.green),
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Text(
                          widget.game.platform[i],
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
            ],
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: 300,
                child: Text(
                  widget.game.name,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              widget.game.genre.join(', '),
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Container(
              height: 40,
              width: 70,
              color: Colors.black.withOpacity(0.5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AddButton(),
                ],
              ),
            ),
            Expanded(child: Container(), flex: 1),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ],
    );
  }

  Widget _AddButton() {
    if (isFav) {
      return IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Borrar favorito'),
                    content: Text(
                        '¿Quieres borrar ${widget.game.name} de la lista de favoritos?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          user.get().then((value) {
                            List<dynamic> juegos =
                                value.data()!['fav_list'] as List;
                            juegos.remove(widget.game.name);
                            user.update({"fav_list": juegos});
                            Navigator.of(context).pop(true);
                            setState(() {
                              isFav = false;
                            });
                          });
                        },
                        child: Text('Sí'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('No'),
                      ),
                    ],
                  );
                });
          },
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 20,
          ));
    }
    return IconButton(
        onPressed: () {
          setState(() {
            user.get().then((value) {
              List<dynamic> juegos = value.data()!['fav_list'] as List;
              if (!juegos.contains(widget.game.name)) {
                juegos.add(widget.game.name);
                user.update({"fav_list": juegos});
              }
            });
            isFav = true;
          });
        },
        icon: Icon(
          Icons.favorite,
          color: Colors.white,
          size: 20,
        ));
  }
}
