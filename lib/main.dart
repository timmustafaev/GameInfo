import 'package:flutter/material.dart';
import 'package:project_app/widgets/PantallaAnadirJuego.dart';
import 'package:project_app/widgets/PantallaFavs.dart';
import 'package:project_app/widgets/PantallaLista.dart';
import 'package:project_app/widgets/PantallaRegistro.dart';
import 'package:project_app/widgets/pantalla_inicial.dart';
import 'package:project_app/widgets/splash.dart';

import 'dart:core';

import 'widgets/video_game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Videogames',
      theme: ThemeData(scaffoldBackgroundColor: Colors.grey[700]),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => PantallaSplash(),
        '/login': (context) => PantallaInicial(),
        '/register': (context) => PantallaRegistro(),
        '/lista': (context) => PantallaListaJuegos(),
        '/favs': (context) => PantallaFavs(),
        '/videogame': (context) => VideogameScreen(),
        '/añadir': (context) => AddGame(),
      },
    );
  }
}
