import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PantallaSplash extends StatefulWidget {
  const PantallaSplash({Key? key}) : super(key: key);

  @override
  _PantallaSplashState createState() => _PantallaSplashState();
}

class _PantallaSplashState extends State<PantallaSplash> {
  @override
  void initState() {
    Firebase.initializeApp().then(_onValue, onError: _onError);
    super.initState();
  }

  FutureOr<Null> _onValue(value) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      Navigator.of(context).pushReplacementNamed('/login');
    else {
      Navigator.of(context).pushReplacementNamed('/lista');
    }
  }

  void _onError(Object error) {
    error as FirebaseException;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ERROR'),
        content: Text((error.message != null
                ? 'Error message: ${error.message!}\n'
                : '') +
            'Error code: ${error.code}\n\n' +
            'Contacta amb els devs'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'))
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }
}
