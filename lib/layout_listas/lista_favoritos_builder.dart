import 'package:aplicativo_shareon/telas/tela_produto_selecionado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ListaFavoritosBuilder extends StatefulWidget {
  @override
  _ListaFavoritosBuilderState createState() => _ListaFavoritosBuilderState();
}

class _ListaFavoritosBuilderState extends State<ListaFavoritosBuilder> {
  SharedPreferencesController sharedPreferencesController =
  new SharedPreferencesController();
  final databaseReference = Firestore.instance;
  Map productsInDB = {};
  String id;
  String userID = "";
  int counter = 0;

  @override
  void initState() {
    if (userID == "") {
      sharedPreferencesController.getID().then(_setID);
    }
    super.initState();
  }

  getData() async {
    await databaseReference
        .collection("favoriteProducts")
        .where("userID", isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        id = productData["productID"];
          setState(() {
            productsInDB[counter] = id;
          });
        counter++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List _lista_fav = [];
    return listGen(_lista_fav);
  }

  _OnClick(BuildContext context, String idx) {
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
            fontSize: 26,
            color: Colors.indigo,
          ),
        );
      },
    );
  }

  _textData(String idx) {
    Timestamp insertionDateRecieved;
    String insertionDate = "";

    return FutureBuilder(
      future: databaseReference
          .collection("products")
          .where("ID", isEqualTo: idx)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          Map productData = f.data;
          insertionDateRecieved = productData["insertionDate"];
          String day =
          ("${insertionDateRecieved.toDate().day}").padLeft(2, "0");
          String month =
          ("${insertionDateRecieved.toDate().month}").padLeft(2, "0");
          String year = ("${insertionDateRecieved.toDate().year}");
          insertionDate = ("$day/$month/$year");
        });
      }),
      builder: (context, snapshot) {
        return Text(
          insertionDate,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
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

  _icFavoritos() {
    return Icon(
      Icons.star,
      color: Colors.orange,
      size: 35.0,
    );
  }

  Widget listGen(List _lista_main) {
    return ListView.builder(
      itemCount: _lista_main.length,
      itemExtent: 150,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _OnClick(context, _lista_main[index]),
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
                            _textPreco(_lista_main[index]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _icFavoritos(),

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

  void _setID(String value) {
    setState(() {
      userID = value;
      getData();
    });
  }
}
