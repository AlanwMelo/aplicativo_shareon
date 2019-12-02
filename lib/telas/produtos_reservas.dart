import 'package:aplicativo_shareon/layout_listas/lista_reservas.dart';
import 'package:aplicativo_shareon/layout_listas/lista_reservas_meus_produtos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaReservas extends StatefulWidget {
  @override
  _TelaReservasState createState() => _TelaReservasState();
}

class _TelaReservasState extends State<TelaReservas> {
  bool reservasMeusProdutos = false;

  @override
  Widget build(BuildContext context) {
    return homeReservas();
  }

  homeReservas() {
    return Scaffold(
      body: Container(
        color: Colors.indigoAccent,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              height: 50,
              color: Colors.indigoAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        reservasMeusProdutos == false
                            ? _text(" Minhas reservas")
                            : _text(" Reservas dos meus produtos"),
                      ],
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          _icSwitch(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: _icSquare(Colors.lightBlueAccent),
                              ),
                              Container(
                                child: _textLegenda("Aprovado"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: _icSquare(Colors.green),
                              ),
                              Container(
                                child: _textLegenda("Em andamento"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: _icSquare(Colors.orange),
                              ),
                              Container(
                                child: _textLegenda("Pendente"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            reservasMeusProdutos == false
                ? Expanded(
                    child: Container(
                        color: Colors.white, child: ListaReservasBuilder()),
                  )
                : Expanded(
                    child: Container(
                        color: Colors.white,
                        child: ListaReservasMeuProdutosBuilder())),
          ],
        ),
      ),
    );
  }

  _icSquare(Color color) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 18,
        minHeight: 18,
        maxHeight: 18,
        maxWidth: 18,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(180),
        ),
        child: Container(
          color: color,
        ),
      ),
    );
  }

  _icSwitch() {
    return GestureDetector(
      onTap: () => setState(() {
        reservasMeusProdutos = !reservasMeusProdutos;
      }),
      child: Icon(
        Icons.compare_arrows,
        color: Colors.white,
        size: 30.0,
      ),
    );
  }

  _text(String x) {
    return Text(
      x,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _textLegenda(String x) {
    return Text(
      x,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
