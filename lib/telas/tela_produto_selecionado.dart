import 'package:aplicativo_shareon/telas/tela_reservar.dart';
import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';

class ProdutoSelecionado extends StatefulWidget {
  String productID;
  ProdutoSelecionado({@required this.productID});

  @override
  _ProdutoSelecionadoState createState() => _ProdutoSelecionadoState();
}

class _ProdutoSelecionadoState extends State<ProdutoSelecionado> {
  final databaseReference = Firestore.instance;
  String productName = "";
  String productMedia = "";
  String productPrice = "";
  String productOwner = "";
  String productOwnerID = "";
  String productDescription = "";
  String productIMG = "";
  String productType = "";

  @override
  Widget build(BuildContext context) {
    return getProductData();
  }

  Widget getProductData() {
    return FutureBuilder(
        future: databaseReference
            .collection("products")
            .where("ID", isEqualTo: (widget.productID))
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            Map productData = f.data;
            productIMG = productData["imgs"];
            productPrice = productData["price"];
            productName = productData["name"];
            productDescription = productData["description"];
            productMedia = productData["media"];
            productOwnerID = productData["ownerID"];
            productType = productData["type"];
          });
        }),
        builder: (context, snapshot) {
          return getUserData();
        });
  }

  Widget getUserData() {
    return FutureBuilder(
        future: databaseReference
            .collection("users")
            .where("userID", isEqualTo: productOwnerID)
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            Map userData = f.data;

            productOwner = userData["nome"];
          });
        }),
        builder: (context, snapshot) {
          return _produto_selecionado(context);
        });
  }

  _produto_selecionado(BuildContext context) {
    return Scaffold(
      appBar: shareon_appbar(context),
      body: SizedBox.expand(
        child: Container(
          color: Colors.indigo,
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 300,
                        child: PageIndicatorContainer(
                          length: 3,
                          indicatorSpace: 10.0,
                          padding: const EdgeInsets.all(10),
                          indicatorColor: Colors.white.withOpacity(0.7),
                          indicatorSelectorColor: Colors.blue,
                          shape: IndicatorShape.circle(size: 10),
                          child: PageView(
                            children: <Widget>[
                              _img(productIMG),
                              _img(
                                  "https://jotacortizo.files.wordpress.com/2016/11/casas-de-hogwarts.jpg"),
                              _img(
                                  "https://i.pinimg.com/originals/64/82/0f/64820fd9ad5cce4b795ccf059e382f84.jpg"),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: _text(productName, Titulo: true),
                      ),
                      Container(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _text(productMedia),
                              _iconEstrela(),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: _text("Produto de: $productOwner"),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        child: _text("Descrição:"),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 235,
                        ),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: Container(
                              color: Colors.white,
                              width: 1000,
                              padding: EdgeInsets.all(8),
                              child: _text(productDescription, Resumo: true),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return Tela_Reservar(productID: widget.productID, productPrice: double.parse(productPrice));
                              }),
                            );
                          },
                          child: _text("Reservar", Resumo: true),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
      child: Image.network(
        "$url",
        fit: BoxFit.cover,
      ),
    );
  }

  _iconEstrela() {
    return Icon(
      Icons.star,
      color: Colors.white,
      size: 20.0,
    );
  }
}
