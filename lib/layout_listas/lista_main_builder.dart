import 'dart:async';
import 'dart:math';

import 'package:aplicativo_shareon/telas/tela_produto_selecionado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ListaMainBuilder extends StatefulWidget {
  @override
  _ListaMainBuilderState createState() => _ListaMainBuilderState();
}

class _Products {
  String productID;
  String name;
  String media;
  String preco;
  double distance;

  _Products(this.productID, this.name, this.preco, this.media, this.distance);
}

class _ListaMainBuilderState extends State<ListaMainBuilder> {
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  final databaseReference = Firestore.instance;
  Map productsInDB = {};
  String productID;
  String userID = "";
  int counter = 0;
  List<_Products> _listaMain = [];
  GeoPoint userLocation;
  ScrollController _controller;

  @override
  initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    if (userID == "") {
      sharedPreferencesController.getGeo().then(_setLocation);
    }
    super.initState();
  }

  _scrollListener() {
    /*   if (_controller.offset <= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("cheguei ao topo");
    }
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("voltei ao fim");
    }*/
  }

  getData() async {
    await databaseReference
        .collection("products")
        .where("ID")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        if (productData["ownerID"] != userID) {
          setState(() {
            GeoPoint aux = productData["location"];
            _listaMain.add(new _Products(
              productData["ID"],
              productData["name"],
              productData["price"],
              productData["media"],
              _calcDist(userLocation.latitude, userLocation.longitude,
                  aux.latitude, aux.longitude),
            ));
            _listaMain.sort((a, b) => a.distance.compareTo(b.distance));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return listGen(_listaMain);
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
    return Text(
      idx,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Colors.indigoAccent,
      ),
    );
  }

  _textMedia(String idx) {
    return Text(
      idx,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black54,
      ),
    );
  }

  _textDistancia(double distancia) {
    if (distancia > 0) {
      return Text(
        "${distancia.toInt()} km",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black38),
      );
    } else if (distancia < 0) {
      return Text(
        "${distancia.toInt()}m",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black38),
      );
    } else if (distancia == 0) {
      return Text(
        "1 km",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black38),
      );
    }
  }

  _textPreco(String idx) {
    return Text(
      "R\$ $idx",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  _iconEstrela() {
    return Icon(
      Icons.star,
      color: Colors.black54,
      size: 20.0,
    );
  }

  Widget listGen(List<_Products> _listaMain) {
    return ListView.builder(
      controller: _controller,
      itemCount: _listaMain.length,
      itemExtent: 150,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _onClick(context, _listaMain[index].productID),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            margin: EdgeInsets.all(6),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _img(_listaMain[index].productID),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _textNome(_listaMain[index].name),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            children: <Widget>[
                              _textMedia(_listaMain[index].media),
                              _iconEstrela(),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            _textDistancia(_listaMain[index].distance),
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    _textPreco(_listaMain[index].preco),
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

  _calcDist(double userLat, double userLong, double prodLat, double prodLong) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((prodLat - userLat) * p) / 2 +
        c(userLat * p) *
            c(prodLat * p) *
            (1 - c((prodLong - userLong) * p)) /
            2;

    return 12742 * asin(sqrt(a));
  }

  FutureOr _setLocation(GeoPoint value) {
    setState(() {
      userLocation = GeoPoint(value.latitude, value.longitude);
      sharedPreferencesController.getID().then(_setUserID);
    });
  }
}
