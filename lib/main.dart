import 'dart:async';

import 'package:aplicativo_shareon/telas/home.dart';
import 'package:aplicativo_shareon/telas/tela_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  final String name = "";
  final String email = "";
  final String logedState = "0";
  final String ultimaLocalizacao = "";
  final String userID = "";
  final String urlImgPerfil = "";
  final double lat = 0;
  final double lng = 0;

  //GETTERS
  Future<GeoPoint> getGeo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lastLat = prefs.get("lat") ?? lat;
    var lastLng = prefs.get("lng") ?? lng;
    GeoPoint userLastLocation = new GeoPoint(lastLat, lastLng);
    return userLastLocation;
  }

  Future <String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString("name") ?? name;
    return result;
  }
  Future <String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString("userID") ?? userID;
    return result;
  }
  Future <String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email") ?? email;
  }
  Future<String> getlogedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString("logedState") ?? logedState;
    return result;
  }
  Future<String> getURLImg() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString("urlImgPerfil") ?? urlImgPerfil;
    return result;
  }

  //SETTERS
  Future<bool> setGeo(double lat, double lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("lat", lat);
    prefs.setDouble("lng", lng);
    return true;
  }

  Future<bool> setID(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("userID", value);
  }

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
  Future<bool> setURLImg(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("urlImgPerfil", value);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Conf Dispositivo para FCM
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var showform = false;
  String loginOk = "";

  @override
  void initState() {
    // TODO: implement initState
    SharedPreferencesController sharedPreferencesController =
        new SharedPreferencesController();
    sharedPreferencesController.getlogedState().then(_logedVerifier);
    super.initState();
  }

  void _initFCM(){
  }

  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
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
            theme: ThemeData(primaryColor: Colors.indigoAccent,), 
            debugShowCheckedModeBanner: false,
            home: _logedController(context),
          );
        return ScopedModel<UserModel>(
          model: UserModel(),
          child: materialApp,
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
