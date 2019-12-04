import 'dart:async';

import 'package:aplicativo_shareon/telas/home.dart';
import 'package:aplicativo_shareon/telas/validacao.dart';
import 'package:aplicativo_shareon/telas/perfil_outro_usuario.dart';
import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaVerificaReserva extends StatefulWidget {
  final String userId;
  final String solicitationID;

  TelaVerificaReserva({@required this.userId, @required this.solicitationID});

  @override
  _TelaVerificaReservaState createState() => _TelaVerificaReservaState();
}

class _TelaVerificaReservaState extends State<TelaVerificaReserva> {
  final databaseReference = Firestore.instance;
  String productIMG;
  String productName;
  String productID;
  String ownerID;
  String solicitationStatus = "";
  bool loading = false;
  String ownerName;
  String productAddress = "";
  Timestamp programedStartDate;
  Timestamp programedEndDate;
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
      body: loading == false
          ? loadData(context)
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
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
        programedStartDate = solicitationData["programedInitDate"];
        solicitationStatus = solicitationData["status"];

        int convertedStartDay = programedStartDate.toDate().day;
        int convertedStartMonth = programedStartDate.toDate().month;
        int convertedStartYear = programedStartDate.toDate().year;

        int convertedStartHour = programedStartDate.toDate().hour;
        int convertedStartMinute = programedStartDate.toDate().minute;
        convertedEstimatedStartDate =
            "${convertedStartDay.toString().padLeft(2, "0")}/${convertedStartMonth.toString().padLeft(2, "0")}/${convertedStartYear.toString()} às "
            "${convertedStartHour.toString().padLeft(2, "0")}:${convertedStartMinute.toString().padLeft(2, "0")}";

        programedEndDate = solicitationData["programedEndDate"];

        int convertedEndDay = programedStartDate.toDate().day;
        int convertedEndMonth = programedStartDate.toDate().month;
        int convertedEndYear = programedStartDate.toDate().year;

        int convertedEndHour = programedEndDate.toDate().hour;
        int convertedEndMinute = programedEndDate.toDate().minute;
        convertedEstimatedEndDate =
            "${convertedEndDay.toString().padLeft(2, "0")}/${convertedEndMonth.toString().padLeft(2, "0")}/${convertedEndYear.toString()} às "
            "${convertedEndHour.toString().padLeft(2, "0")}:${convertedEndMinute.toString().padLeft(2, "0")}";

        var aux = solicitationData["estimatedEndPrice"];
        estimatedPrice = aux.toDouble();
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) {
                              return VerPerfil(userID: ownerID);
                            }));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Row(
                          children: <Widget>[
                            _text("Dono: "),
                            Text(
                              ownerName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: _text("Retirada: $convertedEstimatedStartDate"),
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
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 70,
                        ),
                        child: _text("Endereço: $productAddress"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _containerBotoes(),
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
          fontSize: 14,
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
        productAddress = productData["productAddress"];
        productName = productData["name"];
        ownerID = productData["ownerID"];
        getOwnerData(ownerID);
      });
    });
  }

  getOwnerData(String ownerID) async {
    await databaseReference
        .collection("users")
        .where("userID", isEqualTo: ownerID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        setState(() {
          ownerName = productData["nome"];
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
    int timeNow = Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch;
    int startTime = programedStartDate.millisecondsSinceEpoch;

    if (solicitationStatus == "em andamento") {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 350,
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return TelaValidacao(
                        userId: widget.userId,
                        solicitationId: widget.solicitationID,
                      );
                    }),
                  );
                },
                child: _text("Validar devolução", resumo: true),
              ),
            ),
          ],
        ),
      );
    } else if ((startTime - timeNow) <= 3600000 && solicitationStatus == "aprovada") {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 130,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () {
                  _alertCancelamento(context);
                },
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return TelaValidacao(
                        userId: widget.userId,
                        solicitationId: widget.solicitationID,
                      );
                    }),
                  );
                },
                child: _text("Validar retirada", resumo: true),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Container(
          width: 130,
          child: RaisedButton(
            color: Colors.red,
            onPressed: () {
              _alertCancelamento(context);
            },
            child: Text(
              "Cancelar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  _alertCancelamento(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: GestureDetector(
                  onTap: () => null,
                  child: Container(
                    color: Colors.white,
                    height: 120,
                    width: 300,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "Cancelar reserva",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            "Deseja mesmo cancelar esta reserva?",
                            style: TextStyle(
                              fontFamily: 'RobotoMono',
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.indigoAccent,
                              margin: EdgeInsets.only(
                                top: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 100,
                                      child: RaisedButton(
                                        color: Colors.indigoAccent,
                                        onPressed: () {
                                          setState(() {
                                            _cancelarReserva();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          "Cancelar",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 100,
                                      child: RaisedButton(
                                        color: Colors.indigoAccent,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Voltar",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _cancelarReserva() async {
    setState(() {
      loading = true;
    });

    Map<String, dynamic> cancelamento = {
      "finalEndDate": Timestamp.fromDate(DateTime.now()),
      "status": "cancelada",
      "motivoStatus": "cancelada pelo tomador",
    };

    await databaseReference
        .collection("solicitations")
        .document(widget.solicitationID)
        .updateData(cancelamento);

    setState(() {
      loading = false;
    });

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return Home(optionalControllerPointer: 3);
    }));
  }
}
