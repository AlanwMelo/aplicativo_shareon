import 'package:aplicativo_shareon/telas/produto_selecionado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListaMainBuilder extends StatefulWidget {
  @override
  _ListaMainBuilderState createState() => _ListaMainBuilderState();
}

class _ListaMainBuilderState extends State<ListaMainBuilder> {
  final databaseReference = Firestore.instance;
  Map productsInDB = {};
  String id;
  int counter = 0;

  @override
  void initState() {
    databaseReference
        .collection("products")
        .where("ID")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        id = productData["ID"];
        productsInDB[counter] = id;
        counter++;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List _lista_main = [];
    _lista_main = productsInDB.values.toList();

    return listGen(_lista_main);
  }

  _OnClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ProdutoSelecionado();
    }));
  }

//objetos

  _img(String idx) {
    String productMainIMG = "";

    return FutureBuilder(
      future: databaseReference
          .collection("products")
          .where("ID", isEqualTo: idx)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          Map productData = f.data;
          productMainIMG = productData["imgs"];
        });
      }),
      builder: (context, snapshot) {

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.zero,
          bottomRight: Radius.zero,
          bottomLeft: Radius.circular(16)),
      child: Container(
        child: Image.network(
          productMainIMG,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  },
  );
  }

  _textNome(String idx) {
    String productName = "";

    return FutureBuilder(
      future: databaseReference
          .collection("products")
          .where("ID", isEqualTo: idx)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          Map productData = f.data;
          productName = productData["name"];
        });
      }),
      builder: (context, snapshot) {
        return Text(
          productName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.indigo,
          ),
        );
      },
    );
  }

  _textMedia(String idx) {
    String productMedia = "";

    return FutureBuilder(
      future: databaseReference
          .collection("products")
          .where("ID", isEqualTo: idx)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          Map productData = f.data;
          productMedia = productData["media"];
        });
      }),
      builder: (context, snapshot) {
        return Text(
          productMedia,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        );
      },
    );
  }

  _textDistancia() {
    return Text(
      "400m",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  _textPreco(String idx) {
    String productPrice = "";

    return FutureBuilder(
      future: databaseReference
          .collection("products")
          .where("ID", isEqualTo: idx)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          Map productData = f.data;
          productPrice = productData["price"];
        });
      }),
      builder: (context, snapshot) {

    return Text(
      "R\$ $productPrice",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  },
  );

  }

  _iconEstrela() {
    return Icon(
      Icons.star,
      color: Colors.black,
      size: 20.0,
    );
  }

  Widget listGen(List _lista_main) {
    return ListView.builder(
      itemCount: _lista_main.length,
      itemExtent: 150,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _OnClick(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            margin: EdgeInsets.all(6),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _img(_lista_main[index]),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _textNome(_lista_main[index]),
                        Row(
                          children: <Widget>[
                            _textMedia(_lista_main[index]),
                            _iconEstrela(),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            _textDistancia(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _textPreco(_lista_main[index]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
