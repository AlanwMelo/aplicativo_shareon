import 'dart:async';

import 'package:aplicativo_shareon/telas/tela_produto_selecionado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ListaMainBuilder extends StatefulWidget {
  @override
  _ListaMainBuilderState createState() => _ListaMainBuilderState();
}

class _ListaMainBuilderState extends State<ListaMainBuilder> {
  SharedPreferencesController sharedPreferencesController = new SharedPreferencesController();
  final databaseReference = Firestore.instance;
  Map productsInDB = {};
  String productID;
  String userID = "";
  int counter = 0;
  List listaMain = [];

  @override
  void initState() {
    if (userID == "") {
      sharedPreferencesController.getID().then(_setUserID);
    }

    super.initState();
  }

  getData() async {
    await databaseReference
        .collection("products")
        .where("ID")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        productID = productData["ID"];
        String aux = productData["ownerID"];
        if (aux != userID){
          setState(() {
            productsInDB[counter] = productID;
          });
          counter++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    listaMain = productsInDB.values.toList();
    return listGen(listaMain);
  }

  _onClick(BuildContext context, String idx) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ProdutoSelecionado(productID: idx);
    }));
  }

//objetos

  _img(String idx) {
    String productMainIMG = "";

    return FutureBuilder(
      future: databaseReference
          .collection("productIMGs")
          .where("productID", isEqualTo: idx)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          Map productData = f.data;
          productMainIMG = productData["productMainIMG"];
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
            fontSize: 24,
            color: Colors.indigoAccent,
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
            fontSize: 16,
            color: Colors.black54,
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
        fontSize: 16,
        color: Colors.black38
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
            fontSize: 16,
          ),
        );
      },
    );
  }

  _iconEstrela() {
    return Icon(
      Icons.star,
      color: Colors.black54,
      size: 20.0,
    );
  }

  Widget listGen(List _lista_main) {
    return ListView.builder(
      itemCount: _lista_main.length,
      itemExtent: 150,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _onClick(context, _lista_main[index]),
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
                        Row(
                          children: <Widget>[
                            _textNome(_lista_main[index]),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            children: <Widget>[
                              _textMedia(_lista_main[index]),
                              _iconEstrela(),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            _textDistancia(),
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    _textPreco(_lista_main[index]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

   _setUserID(String value) {
     setState(() {
       userID = value;
       getData();
     });
  }
}
