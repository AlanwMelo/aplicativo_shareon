import 'package:aplicativo_shareon/item_listas/lista_avaliacoes.dart';
import 'package:aplicativo_shareon/telas/tela_produto_selecionado.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

listaAvaliacoesBuilder() {
  List<Widget> _listaAvaliacoes = [
    listaAvaliacoes(),
    listaAvaliacoes(),
    listaAvaliacoes(),
  ];

  // position()
   {
    final listMap = _listaAvaliacoes.asMap();
    listMap.hashCode;
  }

  return ListView.builder(
    itemCount: _listaAvaliacoes.length,
    itemExtent: 10,
    itemBuilder: (BuildContext context, int index) {
      return GestureDetector(
        onTap: () => _onClick(context),
        child: Text("AAAAAAAAAAAAAAAAAAAAA"),
      );
    },
  );
}

_onClick(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return ProdutoSelecionado(productID: null,);
  }));
}
