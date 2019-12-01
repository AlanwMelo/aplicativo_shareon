import 'dart:async';

import 'package:aplicativo_shareon/telas/tela_validacao.dart';
import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaReservaMeusProdutos extends StatefulWidget {
  final String userId;
  final String solicitationID;

  TelaReservaMeusProdutos(
      {@required this.userId, @required this.solicitationID});

  @override
  _TelaReservaMeusProdutosState createState() =>
      _TelaReservaMeusProdutosState();
}

class _TelaReservaMeusProdutosState extends State<TelaReservaMeusProdutos> {
  final databaseReference = Firestore.instance;
  String productIMG;
  String productName;
  String productID;
  String tomadorID;
  String tomadorName;
  String solicitationStatus;
  Timestamp estimatedStartDate;
  Timestamp estimatedEndDate;
  String convertedEstimatedStartDate;
  String convertedEstimatedEndDate;

  String convertedEstimatedPrice;

  double estimatedPrice;

  @override
  void initState() {
    getSolicitationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: shareonAppbar(context, ""),
      body: loadData(context),
      backgroundColor: Colors.indigoAccent,
    );
  }

  Future getSolicitationData() async {
    await databaseReference
        .collection("solicitations")
        .where("solicitationID", isEqualTo: widget.solicitationID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map solicitationData = f.data;
        productID = solicitationData["productID"];
        solicitationStatus = solicitationData["status"];
        estimatedStartDate = solicitationData["programedInitDate"];

        int convertedStartDay = estimatedStartDate.toDate().day;
        int convertedStartMonth = estimatedStartDate.toDate().month;
        int convertedStartYear = estimatedStartDate.toDate().year;

        int convertedStartHour = estimatedStartDate.toDate().hour;
        int convertedStartMinute = estimatedStartDate.toDate().minute;
        convertedEstimatedStartDate =
            "${convertedStartDay.toString().padLeft(2, "0")}/${convertedStartMonth.toString().padLeft(2, "0")}/${convertedStartYear.toString()} às "
            "${convertedStartHour.toString().padLeft(2, "0")}:${convertedStartMinute.toString().padLeft(2, "0")}";

        estimatedEndDate = solicitationData["programedEndDate"];

        int convertedEndDay = estimatedStartDate.toDate().day;
        int convertedEndMonth = estimatedStartDate.toDate().month;
        int convertedEndYear = estimatedStartDate.toDate().year;

        int convertedEndHour = estimatedEndDate.toDate().hour;
        int convertedEndMinute = estimatedEndDate.toDate().minute;
        convertedEstimatedEndDate =
            "${convertedEndDay.toString().padLeft(2, "0")}/${convertedEndMonth.toString().padLeft(2, "0")}/${convertedEndYear.toString()} às "
            "${convertedEndHour.toString().padLeft(2, "0")}:${convertedEndMinute.toString().padLeft(2, "0")}";

        var aux = solicitationData["estimatedEndPrice"];
        estimatedPrice = aux.toDouble();
        tomadorID = solicitationData["requesterID"];
        getTomadorData(tomadorID);
        getProductData(productID);
      });
    });
  }

  homeReservaProxima(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 300,
              margin: EdgeInsets.only(top: 8),
              child: Center(
                child: _img(productID),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 16),
                child: _text(productName, titulo: true),
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
                      child: Row(
                        children: <Widget>[
                          _text("Tomador: "),
                          Text(
                            tomadorName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child:
                                _text("Retirada: $convertedEstimatedStartDate"),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: _text("Devolução: $convertedEstimatedEndDate"),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: _text(
                          "Valor estimado: R\$${estimatedPrice.toStringAsFixed(2)}"),
                    ),
                  ],
                ),
              ),
            ),
            solicitationStatus == null ? Container() : _containerBotoes(),
          ],
        ),
      ),
    );
  }

  _text(String texto, {bool titulo = false, bool resumo = false}) {
    if (titulo == true) {
      return Text(
        "$texto",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 30,
        ),
      );
    } else if (resumo == true) {
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

  _img(String productID) {
    String productMainIMG = "";

    return FutureBuilder(
      future: databaseReference
          .collection("productIMGs")
          .where("productID", isEqualTo: productID)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          Map productData = f.data;
          productMainIMG = productData["productMainIMG"];
        });
      }),
      builder: (context, snapshot) {
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
                  productMainIMG,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  getProductData(String productID) async {
    await databaseReference
        .collection("products")
        .where("ID", isEqualTo: productID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        productName = productData["name"];
      });
    });
  }

  getTomadorData(String tomadorID) async {
    await databaseReference
        .collection("users")
        .where("userID", isEqualTo: tomadorID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        setState(() {
          tomadorName = productData["nome"];
        });
      });
    });
  }

  loadData(BuildContext context) {
    if (productID == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    } else {
      return homeReservaProxima(context);
    }
  }

  _containerBotoes() {
    if (solicitationStatus == "aprovada") {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 400,
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 130,
                    child: RaisedButton(
                      color: Colors.red,
                      onPressed: () {},
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 130,
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return TelaValidacao(
                              userId: widget.userId,
                              solicitationId: widget.solicitationID);
                        }));
                      },
                      child: Text(
                        "Validar retirada",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    } else if (solicitationStatus == "pendente") {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 400,
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 130,
                    child: RaisedButton(
                      color: Colors.red,
                      onPressed: () {},
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 130,
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {},
                      child: Text(
                        "Aprovar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}
