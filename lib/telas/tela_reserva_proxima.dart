import 'package:aplicativo_shareon/telas/tela_validacao.dart';
import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tela_Reserva_Proxima extends StatefulWidget {
  @override
  _Tela_Reserva_ProximaState createState() => _Tela_Reserva_ProximaState();
}

class _Tela_Reserva_ProximaState extends State<Tela_Reserva_Proxima> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: shareon_appbar(context),
      body: homeReservaProxima(context),
      backgroundColor: Colors.indigo,
    );
  }
}

homeReservaProxima(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      margin: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: _text("Você possui uma reserva em breve"),
          ),
          Container(
            height: 300,
            margin: EdgeInsets.only(top: 8),
            child: Center(
              child: _img(
                  "https://i.pinimg.com/originals/50/8d/1d/508d1d2a8f9bc715aedfd3ca17d10c2b.jpg"),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 16),
              child: _text("Nome do Produto", Titulo: true),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 250,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: _text("Dono: Luciano"),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: _text("Retirada: 13:00"),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: _text("Devolução: 17:00"),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: _text("Valor estimado: R\$75,00"),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 70,
                      ),
                      child: _text("Endereço do produto."),
                    ),
                  ),
                ],),
            ),
          ),
             Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 400,
                    margin: EdgeInsets.only(bottom: 20),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return Tela_Validacao();
                            }));
                      },
                      child: Text(
                        "Validar retirada",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

        ],
      ),
    ),
  );
}

_text(String texto, {bool Titulo = false, bool Resumo = false}) {
  if (Titulo == true) {
    return Text(
      "$texto",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 30,
      ),
    );
  } else if (Resumo == true) {
    return Text(
      "$texto",
      style: TextStyle(
        fontSize: 16,
      ),
    );
  } else {
    return Text(
      "$texto",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}

_img(String url) {
  return Container(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 250,
        minHeight: 250,
        maxHeight: 250,
        maxWidth: 250,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(180),
        ),
        child: Container(
          child: Image.network(
            "$url",
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}
