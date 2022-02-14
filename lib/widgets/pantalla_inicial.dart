import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PantallaInicial extends StatefulWidget {
  const PantallaInicial({Key? key}) : super(key: key);

  @override
  _PantallaInicialState createState() => _PantallaInicialState();
}

class _PantallaInicialState extends State<PantallaInicial> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late TextEditingController _emailControler, _passwordController;

  @override
  void initState() {
    _emailControler = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Builder(builder: _buildBody),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email*',
                  hintText: 'myname@upc.edu',
                ),
                controller: _emailControler,
                keyboardType: TextInputType.emailAddress,
                validator: _emailValidator,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password*',
                  hintText: '*******',
                ),
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: _passwordValidator,
                obscureText: true,
              ),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () {
                  _login();
                },
              ),
              Text("Don't have an account yet?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: Text('Register here!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value != null && !regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String? _passwordValidator(String? value) {
    if (value != null && value.length >= 6) return null;
    return 'Password must be longer than 6 characters';
  }

  void _login() {
    if (_loginFormKey.currentState!.validate()) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailControler.text, password: _passwordController.text)
          .then(_onValue, onError: _onError);
    }
  }

  _onError(Object error) {
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

  FutureOr _onValue(UserCredential userCredential) {
    User? user = userCredential.user;
    if (user != null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/lista', (route) => false);
    }
  }
}
