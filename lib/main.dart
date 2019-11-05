import 'dart:async';

import 'package:aplicativo_shareon/telas/home.dart';
import 'package:aplicativo_shareon/telas/tela_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
    as location_picker;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/usuario_model.dart';

void main() {
  runApp(MyApp());
}

class SharedPreferencesController {
  String name = "sortOrder";
  String email = "sortOrder";
  String logedState = "0";

  //GETTERS

  Future <String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString("name") ?? "Default";
    return result;
  }
  Future <String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email") ?? "Default";
  }
  Future<String> getlogedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString("logedState") ?? "0";
    return result;
  }

  //SETTERS

  Future<bool> setName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("name", value);

  }

  Future<bool> setEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("email", value);
  }

  Future<bool> setlogedState(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("logedState", value);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String loginOk = "";

  @override
  void initState() {
    // TODO: implement initState
    SharedPreferencesController sharedPreferencesController =
        new SharedPreferencesController();
    sharedPreferencesController.getlogedState().then(_logedVerifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
        localizationsDelegates: const [
          location_picker.S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('pt', ''),
          Locale('en', ''),
        ],
        title: "Share On",
        theme: ThemeData(primaryColor: Colors.indigo),
        debugShowCheckedModeBanner: false,
        home: _logedController(context),
      ),
    );
  }

  void _logedVerifier(String logedState) {
    setState(() {
      loginOk = logedState;
    });
  }

  _logedController(BuildContext context) {
    if (loginOk == "1") {
      return Home();
    } else {
      return Login();
    }
  }
}
