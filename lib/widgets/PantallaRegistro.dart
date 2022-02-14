import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_app/models/dev_code.dart';

class PantallaRegistro extends StatefulWidget {
  @override
  _PantallaRegistroState createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  late bool isdev;
  late final CollectionReference<Map<String, dynamic>> _devcode;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  late TextEditingController _emailController,
      _passwordController,
      _nameController,
      _devController;

  @override
  void initState() {
    isdev = false;
    _devcode = FirebaseFirestore.instance.collection('DevCode');
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _devController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        centerTitle: true,
      ),
      body: _buildBody(),
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

  String? _nameValidator(String? value) {
    if (value != null && value.length >= 3) return null;
    return 'Name must be longer than 3 characters';
  }

  String? _devValidator(String? value) {
    return null;
  }

  void _checkDev() {
    _devcode.where('code', isEqualTo: _devController.text).get().then((value) {
      if (value.docs.isEmpty) {
        return "Invalid code";
      } else {
        if (value.docs[0].data()['isFree']) {
          value.docs[0].reference.update({'isFree': false});
          isdev = true;
          _register();
        } else {
          return "Invalid code";
        }
      }
    });
  }

  void _register() {
    if (_registerFormKey.currentState!.validate()) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then(_onValue, onError: _onError);
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

  FutureOr _onValue(UserCredential userCredential) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'name': _nameController.text,
      'mail': _emailController.text,
      'dev_code': _devController.text,
      'dev': isdev,
      'fav_list': []
    });
    Navigator.of(context).pushNamedAndRemoveUntil('/lista', (route) => false);
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _registerFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'User Name*',
                  hintText: 'AtomicBlast',
                ),
                controller: _nameController,
                keyboardType: TextInputType.name,
                validator: _nameValidator,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email*',
                  hintText: 'myname@upc.edu',
                ),
                controller: _emailController,
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Administrator Code*',
                  hintText: '1A2B3C4D',
                ),
                controller: _devController,
                keyboardType: TextInputType.visiblePassword,
                validator: _devValidator,
              ),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () {
                  if (_devController.text.isEmpty) {
                    _register();
                  } else {
                    _checkDev();
                  }
                },
              ),
              Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop;
                },
                child: Text('Login here!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
