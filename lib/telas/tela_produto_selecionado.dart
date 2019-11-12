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
  String imgID = "";
  String mainIMG = "";
  String pgvimg1 = "";
  String pgvimg2 = "";
  String pgvimg3 = "";
  String pgvimg4 = "";
  String pgvimg5 = "";
  int mainIMGcontroller = 0;
  int img2Controller = 0;
  int img3Controller = 0;
  int img4Controller = 0;
  int img5Controller = 0;
  String img2 = "";
  String img3 = "";
  String img4 = "";
  String img5 = "";
  List listaIMGS = [];
  Map mapListaIMGS = {};
  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    getProductData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    listaIMGS = mapListaIMGS.values.toList();
    generaPGViewer();
    return _produto_selecionado(context);
  }

  getProductData() async {
    await databaseReference
        .collection("products")
        .where("ID", isEqualTo: (widget.productID))
        .getDocuments()
        .then(
      (QuerySnapshot snapshot) {
        snapshot.documents.forEach(
          (f) {
            Map productData = f.data;
            setState(() {
              productIMG = productData["imgs"];
              productPrice = productData["price"];
              productName = productData["name"];
              productDescription = productData["description"];
              productMedia = productData["media"];
              productOwnerID = productData["ownerID"];
              productType = productData["type"];
              getProductIMGs();
              getUserData();
            });
          },
        );
      },
    );
  }

  getProductIMGs() async {
    listaIMGS.clear();
    await databaseReference
        .collection("productIMGs")
        .where("productID", isEqualTo: (widget.productID))
        .getDocuments()
        .then(
      (QuerySnapshot snapshot) {
        snapshot.documents.forEach(
          (f) {
            Map productIMG = f.data;
            imgID = productIMG["productMainIMG"];
            if (imgID != "") {
              setState(() {
                mainIMG = imgID;
                mapListaIMGS[counter] = imgID;
              });
            }
            imgID = "";
            imgID = productIMG["productIMG2"];
            if (imgID != "") {
              setState(() {
                counter++;
                img2 = imgID;
                mapListaIMGS[counter] = imgID;
              });
            }
            imgID = "";
            imgID = productIMG["productIMG3"];
            if (imgID != "") {
              setState(() {
                counter++;
                img3 = imgID;
                mapListaIMGS[counter] = imgID;
              });
            }
            imgID = "";
            imgID = productIMG["productIMG4"];
            if (imgID != "") {
              setState(() {
                counter++;
                img4 = imgID;
                mapListaIMGS[counter] = imgID;
              });
            }
            imgID = "";
            imgID = productIMG["productIMG5"];
            if (imgID != "") {
              setState(() {
                counter++;
                img5 = imgID;
                mapListaIMGS[counter] = imgID;
              });
            }
          },
        );
      },
    );
  }

  getUserData() async {
    await databaseReference
        .collection("users")
        .where("userID", isEqualTo: productOwnerID)
        .getDocuments()
        .then(
      (QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          Map userData = f.data;
          setState(() {
            productOwner = userData["nome"];
          });
        });
      },
    );
  }

  _produto_selecionado(BuildContext context) {
    return Scaffold(
      appBar: shareon_appbar(context),
      body: SizedBox.expand(
        child: Container(
          color: Colors.indigoAccent,
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 300,
                        child: PageIndicatorContainer(
                          length: listaIMGS.length,
                          indicatorSpace: 10.0,
                          padding: const EdgeInsets.all(10),
                          indicatorColor: Colors.white.withOpacity(0.7),
                          indicatorSelectorColor: Colors.blue,
                          shape: IndicatorShape.circle(size: 10),
                          child:  exibePGV(),
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
                          minHeight: 180,
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
                          onPressed: () {},
                          child: _text("Adcionar aos Favoritos", Resumo: true),
                        ),
                      ),
                      Container(
                        width: 400,
                        margin: EdgeInsets.only(bottom: 8, right: 8, left: 8),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return Tela_Reservar(
                                    productID: widget.productID,
                                    productPrice: double.parse(productPrice));
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

  generaPGViewer() {
    if (pgvimg1 == "") {
      if (mainIMG != "" && mainIMGcontroller == 0) {
        pgvimg1 = mainIMG;
        mainIMGcontroller = 1;
        generaPGViewer();
      } else if (img2 != "" && img2Controller == 0) {
        pgvimg1 = img2;
        img2Controller = 1;
        generaPGViewer();
      } else if (img3 != "" && img3Controller == 0) {
        pgvimg1 = img3;
        img3Controller = 1;
        generaPGViewer();
      } else if (img4 != "" && img4Controller == 0) {
        pgvimg1 = img4;
        img4Controller = 1;
        generaPGViewer();
      } else if (img5 != "" && img5Controller == 0) {
        pgvimg1 = img5;
        img5Controller = 1;
        generaPGViewer();
      }
    }
    if (pgvimg2 == "") {
      if (mainIMG != "" && mainIMGcontroller == 0) {
        pgvimg2 = mainIMG;
        mainIMGcontroller = 1;
        generaPGViewer();
      } else if (img2 != "" && img2Controller == 0) {
        pgvimg2 = img2;
        img2Controller = 1;
        generaPGViewer();
      } else if (img3 != "" && img3Controller == 0) {
        pgvimg2 = img3;
        img3Controller = 1;
        generaPGViewer();
      } else if (img4 != "" && img4Controller == 0) {
        pgvimg2 = img4;
        img4Controller = 1;
        generaPGViewer();
      } else if (img5 != "" && img5Controller == 0) {
        pgvimg2 = img5;
        img5Controller = 1;
        generaPGViewer();
      }
    }
    if (pgvimg3 == "") {
      if (mainIMG != "" && mainIMGcontroller == 0) {
        pgvimg3 = mainIMG;
        mainIMGcontroller = 1;
        generaPGViewer();
      } else if (img2 != "" && img2Controller == 0) {
        pgvimg3 = img2;
        img2Controller = 1;
        generaPGViewer();
      } else if (img3 != "" && img3Controller == 0) {
        pgvimg3 = img3;
        img3Controller = 1;
        generaPGViewer();
      } else if (img4 != "" && img4Controller == 0) {
        pgvimg3 = img4;
        img4Controller = 1;
        generaPGViewer();
      } else if (img5 != "" && img5Controller == 0) {
        pgvimg3 = img5;
        img5Controller = 1;
        generaPGViewer();
      }
    }
    if (pgvimg4 == "") {
      if (mainIMG != "" && mainIMGcontroller == 0) {
        pgvimg4 = mainIMG;
        mainIMGcontroller = 1;
        generaPGViewer();
      } else if (img2 != "" && img2Controller == 0) {
        pgvimg4 = img2;
        img2Controller = 1;
        generaPGViewer();
      } else if (img3 != "" && img3Controller == 0) {
        pgvimg4 = img3;
        img3Controller = 1;
        generaPGViewer();
      } else if (img4 != "" && img4Controller == 0) {
        pgvimg4 = img4;
        img4Controller = 1;
        generaPGViewer();
      } else if (img5 != "" && img5Controller == 0) {
        pgvimg4 = img5;
        img5Controller = 1;
        generaPGViewer();
      }
    }
    if (pgvimg5 == "") {
      if (mainIMG != "" && mainIMGcontroller == 0) {
        pgvimg5 = mainIMG;
        mainIMGcontroller = 1;
        generaPGViewer();
      } else if (img2 != "" && img2Controller == 0) {
        pgvimg5 = img2;
        img2Controller = 1;
        generaPGViewer();
      } else if (img3 != "" && img3Controller == 0) {
        pgvimg5 = img3;
        img3Controller = 1;
        generaPGViewer();
      } else if (img4 != "" && img4Controller == 0) {
        pgvimg5 = img4;
        img4Controller = 1;
        generaPGViewer();
      } else if (img5 != "" && img5Controller == 0) {
        pgvimg5 = img5;
        img5Controller = 1;
        generaPGViewer();
      }
    }
  }

  exibePGV() {
    if (listaIMGS.length == 1) {
      return PageView(
        children: <Widget>[
          _img(pgvimg1),
        ],
      );
    } else if (listaIMGS.length == 2) {
      return PageView(
        children: <Widget>[
          _img(pgvimg1),
          _img(pgvimg2),
        ],
      );
    } else if (listaIMGS.length == 3) {
      return PageView(
        children: <Widget>[
          _img(pgvimg1),
          _img(pgvimg2),
          _img(pgvimg3),
        ],
      );
    } else if (listaIMGS.length == 4) {
      return PageView(
        children: <Widget>[
          _img(pgvimg1),
          _img(pgvimg2),
          _img(pgvimg3),
          _img(pgvimg4),
        ],
      );
    } else if (listaIMGS.length == 5) {
      return PageView(
        children: <Widget>[
          _img(pgvimg1),
          _img(pgvimg2),
          _img(pgvimg3),
          _img(pgvimg4),
          _img(pgvimg5),
        ],
      );
    }
  }
}
