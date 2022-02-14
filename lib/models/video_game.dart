import 'dart:convert';
import 'package:http/http.dart' as http;

class Game {
  String name;
  String desc;
  String? release;
  List genre;
  List dev;
  List platform;
  int? votes;
  double? valoracion;
  String? url;

  Game({
    required this.name,
    required this.desc,
    required this.release,
    required this.genre,
    required this.dev,
    required this.platform,
    required this.valoracion,
    required this.votes,
    required this.url,
  });
  Game.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'],
          desc: json['desc'],
          release: json['release'],
          genre: json['genre'],
          dev: json['dev'],
          platform: json['platform'],
          valoracion: json['valoracion'],
          votes: json['votes'],
          url: json['url'],
        );
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'desc': desc,
      'release': release,
      'genre': genre,
      'dev': dev,
      'platform': platform,
      'valoracion': valoracion,
      'votes': votes,
      'url': url,
    };
  }

  static Game fromAPI(Map<String, dynamic> json, Map<String, dynamic> detalle) {
    List<String> lista_genero = [];
    List<String> lista_plataforma = [];
    List<String> lista_devs = [];
    for (var e in detalle['genres']) {
      lista_genero.add(e['name']);
    }
    for (var e in detalle['developers']) {
      lista_devs.add(e['name']);
    }
    for (var e in detalle['platforms']) {
      lista_plataforma.add(e['platform']['name']);
    }
    return Game(
      name: json['name'],
      desc: detalle['description'],
      release: json['released'],
      genre: lista_genero,
      dev: lista_devs,
      platform: lista_plataforma,
      valoracion: 0,
      votes: 0,
      url: json['background_image'],
    );
  }

  String toString() =>
      '$name\nDescripcion: $desc\n Release: $release\n Genre: $genre\nPlatforms: $platform\n Valoracion: $valoracion     Votos: $votes\n url: $url'; //\nDevelopers: $dev';
}

String jsonGame = '''
{
          "name": "Quake",
          "desc": "In the game, players must find their way through various maze-like, medieval environments while battling a variety of monsters using an array of weaponry. The overall atmosphere is dark and gritty, with many stone textures and a rusty, capitalized font. Quake also takes heavy inspiration from gothic fiction and the works of H.P. Lovecraft. ",
          "phrase": "Nightmares ahead.",
          "release": "June 22, 1996",
          "genre": "First-person shooter",
          "dev": "id Software",
          "opinion": "A game that grips you and doesn't let go till the end.",
          "platform": "PC",
          "playing": "828",
          "wishlist": "345",
          "reviews": "123",
          "valoracion": 4.11,
          "autor": "timM",
          "puesto": "Student at UPC",
          "votes": 167,
          "likes": 269,
          "url": "https://images7.alphacoders.com/718/718707.jpg",
          "url2": "https://www.pngarts.com/files/5/Avatar-Face-PNG-Image-Background.png",
          "url3": "https://www.jovenesenred.es/wp-content/uploads/2018/01/dominios-internet-696x441.jpg"

}
  ''';

Game getGame() {
  return Game.fromJson(jsonDecode(jsonGame));
}

List<Game> getListaGames() {
  List<Game> lista = [
    for (int i = 1; i <= 100; i++) getGame(),
  ];
  return lista;
}

/*Future<List<Game>> getJocsAPI() async {
  Uri uri = Uri.https('api.rawg.io', '/api/games', {
    'key': '5354e3ccdef34ccbbca42b7ae6b9c717',
    // 'dates': '2019-09-01,2019-09-30',
    //'platforms': '18,1,7'
  });
  http.Response response = await http.get(uri);
  List r = jsonDecode(response.body)['results'];
  List<Game> lista = [];
  for (var e in r) {
    Game g = await toGame(e);
    //print(g);
    lista.add(g);
  }
  //print(lista);
  //print(lista.map((e) => (e.toJson())));
  return lista;
}

Future<Game> toGame(e) async {
  int id_juego = e['id'];
  //print(id_juego);
  Uri uri_juego = Uri.parse(
      'https://api.rawg.io/api/games/$id_juego?key=5354e3ccdef34ccbbca42b7ae6b9c717');
  http.Response response_juego = await http.get(uri_juego);
  Map<String, dynamic> detall = jsonDecode(response_juego.body);
  //print(detall);
  return Game.fromAPI(e, detall);
}*/
