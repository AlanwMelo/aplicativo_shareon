import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaDicas extends StatefulWidget {
  @override
  _TelaDicasState createState() => _TelaDicasState();
}

class _TelaDicasState extends State<TelaDicas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeDicas(),
    );
  }
}

homeDicas() {
  return Scaffold(
    body: Container(
      color: Colors.grey[300],
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                topLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
                bottomLeft: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _textTitulo(),
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  child: _textDicas(),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

_textTitulo() {
  return Text(
    "Dicas de Segurança",
    style: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.black45,
    ),
  );
}

_textDicas() {
  return Text(
    "Evite utilizar redes Wifi públicas. Redes privadas e protegidas com senha podem proteger melhor seus dados."
        "\n\n"
        "Se atente a avaliação das pessoas com quem for fechar negócio."
        "\n\n"
        "Mantenha sempre seus dados atualizados."
        "\n\n"
        "Nunca forneça nenhuma informação além das solicitadas pelo APP."
        "\n\n"
        "Nunca forneça sua senha, PIN, ou quaisquer outros códigos de segurança a outros usuários.",
    style: TextStyle(
      fontStyle: FontStyle.italic,
    ),
  );
}
