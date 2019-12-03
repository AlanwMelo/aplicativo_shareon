import 'package:aplicativo_shareon/layout_listas/lista_historico.dart';
import 'package:aplicativo_shareon/layout_listas/lista_historico_meus_produtos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaHistorico extends StatefulWidget {
  @override
  _TelaHistoricoState createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  bool historicoMeusProdutos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeHistorico(),
    );
  }

  homeHistorico() {
    return Scaffold(
      body: Container(
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
                        historicoMeusProdutos == false
                            ? _text(" Meu histórico")
                            : _text(" Histórico dos meus produtos"),
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
            historicoMeusProdutos == false
                ? Expanded(
                    child: Container(
                        color: Colors.white, child: ListaHistoricoBuilder()),
                  )
                : Expanded(
                    child: Container(
                        color: Colors.white,
                        child: ListaHistoricoMeusProdutosBuilder())),
          ],
        ),
      ),
    );
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

  _icSwitch() {
    return GestureDetector(
      onTap: () => setState(() {
        historicoMeusProdutos = !historicoMeusProdutos;
      }),
      child: Icon(
        Icons.compare_arrows,
        color: Colors.white,
        size: 30.0,
      ),
    );
  }
}
