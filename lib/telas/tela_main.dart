
import 'package:aplicativo_shareon/layout_listas/lista_main_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class TelaMain extends StatefulWidget {
  @override
  _TelaMainState createState() => _TelaMainState();
}

class _TelaMainState extends State<TelaMain> {
  int mainControllerPointer = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeMain(context),
    );
  }
}

homeMain(BuildContext context) {
  return Container(
    color: Colors.white,
    child: Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            height: 50,
            color: Colors.indigo,
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

Future<Null> _selecionaLocalizacao(BuildContext context) async {
  LocationResult result = await LocationPicker.pickLocation(
      context, "AIzaSyDAVrOzCfJOoak50Fke6jDdW945_s6rv4U");

  var map = result.latLng.toString();
  print(map);
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
