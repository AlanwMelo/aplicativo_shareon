import 'dart:async';

import 'package:aplicativo_shareon/layout_listas/lista_main_builder.dart';
import 'package:aplicativo_shareon/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class TelaMain extends StatefulWidget {
  @override
  _TelaMainState createState() => _TelaMainState();
}

class _TelaMainState extends State<TelaMain> {
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  int mainControllerPointer = 0;
  GeoPoint userLocation;

  @override
  void initState() {
    if (userLocation == null) {
      sharedPreferencesController.getGeo().then(_setLocation);
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == GeoPoint(0.0, 0.0)) {
      return Scaffold(
        body: undefinedLocation(context),
      );
    } else {
      return Scaffold(
        body: homeMain(context),
      );
    }
  }

  FutureOr _setLocation(GeoPoint value) {
    setState(() {
      userLocation = GeoPoint(value.latitude, value.longitude);
    });
  }

  Future<Null> _selecionaLocalizacao(BuildContext context) async {
    SharedPreferencesController sharedPreferencesController =
        new SharedPreferencesController();

    LocationResult result = await LocationPicker.pickLocation(
        context, "AIzaSyDAVrOzCfJOoak50Fke6jDdW945_s6rv4U");

    GeoPoint selected =
        new GeoPoint(result.latLng.latitude, result.latLng.longitude);

    sharedPreferencesController.setGeo(
        result.latLng.latitude, result.latLng.longitude);

    _setLocation(selected);
  }

  undefinedLocation(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: 300,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 32, left: 8, right: 8),
                child: _text(
                    "Para vizualizar nossa lista de produtos precisamos saber sua localização."
                    " Clique no ícone abaixo para seleciona-la."),
              ),
              GestureDetector(
                onTap: () {
                  _selecionaLocalizacao(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 16, left: 8, right: 8),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 50.0,
                    semanticLabel: 'Set Location',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 32, left: 8, right: 8),
                child: Text(
                  "Salvaremos sua localização. Quando quiser alterá-la basta clicar no ícone novamente.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.yellowAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  homeMain(BuildContext context) {
    return Container(
      color: Colors.white60,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              height: 50,
              color: Colors.indigoAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _icPesquisar(),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selecionaLocalizacao(context),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _icGPS(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          _icFiltros(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Expanded(
                child: ListaMainBuilder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_icFiltros() {
  return Icon(
    Icons.filter_list,
    color: Colors.white,
    size: 30.0,
  );
}

_icPesquisar() {
  return Icon(
    Icons.search,
    color: Colors.white,
    size: 30.0,
    semanticLabel: 'Set Location',
  );
}

_icGPS() {
  return Icon(
    Icons.location_on,
    color: Colors.white,
    size: 30.0,
    semanticLabel: 'Set Location',
  );
}

_text(String s) {
  return Text(
    s,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}
