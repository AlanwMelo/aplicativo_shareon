import 'package:aplicativo_shareon/telas/tela_de_testes.dart';
import 'package:flutter/material.dart';

class ShareOnAppBar extends StatefulWidget {
  @override
  _ShareOnAppBarState createState() => _ShareOnAppBarState();
}

class _ShareOnAppBarState extends State<ShareOnAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

shareonAppbar(BuildContext context) {
  return AppBar(
    actions: <Widget>[
      _texto(context),
    ],
    title: Text("Share On"),
  );
}

_texto(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return tela_testes();
      }));
    },
    child: Container(
      color: Colors.indigoAccent,
      padding: EdgeInsets.only(right: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 150,
          minHeight: 40,
        ),
        child: Center(
          child: Text(
            "TESTES",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  );
}
