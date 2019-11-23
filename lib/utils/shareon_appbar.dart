import 'package:aplicativo_shareon/telas/home.dart';
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

shareonAppbar(BuildContext context, String text) {
  return AppBar(
    actions: <Widget>[
      _texto(context, text),
    ],
    title: Text("Share On"),
  );
}

_texto(BuildContext context, String text) {
  if (text != "") {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Home(optionalControllerPointer: 3)));
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
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  } else {
    return Container();
  }
}
