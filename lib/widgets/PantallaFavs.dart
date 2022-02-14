import 'package:flutter/material.dart';
import 'package:project_app/models/video_game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PantallaFavs extends StatefulWidget {
  const PantallaFavs({Key? key}) : super(key: key);

  @override
  _PantallaFavsState createState() => _PantallaFavsState();
}

class _PantallaFavsState extends State<PantallaFavs> {
  late List<dynamic> lista;
  String dropdownValue = 'Filter';
  var user = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  @override
  void initState() {
    user.get().then((value) {
      lista = value.data()!['fav_list'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: [
              Expanded(child: Center(child: Text('Favourites'))),
            ],
          ),
        ),
        body: getFavs());
  }

  FutureBuilder<dynamic> getFavs() {
    return FutureBuilder(
      future: user.get().then((value) => value.data()!['fav_list']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(color: Colors.transparent),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data.toString().split(",").length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(title: Text((snapshot.data as List)[index])),
                ),
              );
            });
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Card(
      child: ListTile(
        isThreeLine: true,
        onLongPress: () {
          null;
        },
        onTap: () {
          null;
        },
        title: Text(lista[index]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}
