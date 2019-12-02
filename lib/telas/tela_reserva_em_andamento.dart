import 'dart:async';

import 'package:aplicativo_shareon/telas/tela_validacao.dart';
import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaEmAndamento extends StatefulWidget {
  final String userId;
  final String solicitationID;

  TelaEmAndamento({@required this.userId, @required this.solicitationID});

  @override
  _TelaEmAndamentoState createState() => _TelaEmAndamentoState();
}

class _TelaEmAndamentoState extends State<TelaEmAndamento> {
  final databaseReference = Firestore.instance;
  String productIMG;
  String productName;
  String productID;
  String ownerID;
  String solicitationStatus = "";
  bool loading = false;
  String ownerName;
  String productAddress = "";
  Timestamp finalStartDate;
  Timestamp programedEndDate;
  String convertedFinalStartDate;
  String convertedEstimatedEndDate;
  String convertedEstimatedPrice;
  double actualPrice;
  int duracao = 0;
  String strgDuracao = "";
  double productPrice;
  String productMainIMG = "";

  @override
  void initState() {
    getSolicitationData();
    Timer.periodic(Duration(seconds: 30), (Timer t) => _duracaoAtual());
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
        finalStartDate = solicitationData["finalStartDate"];
        solicitationStatus = solicitationData["status"];

        int convertedStartDay = finalStartDate.toDate().day;
        int convertedStartMonth = finalStartDate.toDate().month;
        int convertedStartYear = finalStartDate.toDate().year;

        int convertedStartHour = finalStartDate.toDate().hour;
        int convertedStartMinute = finalStartDate.toDate().minute;
        convertedFinalStartDate =
            "${convertedStartDay.toString().padLeft(2, "0")}/${convertedStartMonth.toString().padLeft(2, "0")}/${convertedStartYear.toString()} às "
            "${convertedStartHour.toString().padLeft(2, "0")}:${convertedStartMinute.toString().padLeft(2, "0")}";

        programedEndDate = solicitationData["programedEndDate"];

        int convertedEndDay = finalStartDate.toDate().day;
        int convertedEndMonth = finalStartDate.toDate().month;
        int convertedEndYear = finalStartDate.toDate().year;

        int convertedEndHour = programedEndDate.toDate().hour;
        int convertedEndMinute = programedEndDate.toDate().minute;
        convertedEstimatedEndDate =
            "${convertedEndDay.toString().padLeft(2, "0")}/${convertedEndMonth.toString().padLeft(2, "0")}/${convertedEndYear.toString()} às "
            "${convertedEndHour.toString().padLeft(2, "0")}:${convertedEndMinute.toString().padLeft(2, "0")}";

        var aux = solicitationData["estimatedEndPrice"];
        actualPrice = aux.toDouble();
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
                      margin: EdgeInsets.only(top: 16),
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
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: _text("Retirada: $convertedFinalStartDate"),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          _text("Devolução: "),
                          _textDevolucao(),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: _text("Duração: $strgDuracao"),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: _text(
                          "Valor atual: R\$${actualPrice.toStringAsFixed(2)}"),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 70,
                        ),
                        child: _text(productAddress),
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
        var aux = productData["price"];
        productPrice = aux.toDouble();
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
          _duracaoAtual();
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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return TelaValidacao(
                        userId: widget.userId,
                        solicitationId: widget.solicitationID,
                        productPrice: productPrice,
                      );
                    }),
                  );
                },
                child: _text("Validar devolução", resumo: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _duracaoAtual() {
    DateTime retirada = DateTime.fromMillisecondsSinceEpoch(
        finalStartDate.millisecondsSinceEpoch);
    DateTime horaAtual = DateTime.now();
    duracao = (horaAtual.difference(retirada).inMinutes);

    double totalOfMins = duracao.toDouble();
    double dias = totalOfMins / 1440;
    double horas = (totalOfMins % 1440) / 60;
    double min = totalOfMins % 60;

    var aux = productPrice / (60);

    actualPrice = duracao.toDouble() * aux;

    strgDuracao = "${_strgDia(dias.toInt(), horas.toInt(), min.toInt())}"
        "${_strgHora(horas.toInt(), min.toInt())}"
        "${_strgMin(min.toInt())}";

    setState(() {});
  }

  _strgDia(int dia, int hora, int min) {
    if (dia > 0 && hora == 0) {
      if (dia == 0) {
        return "";
      } else if (dia == 1) {
        return "$dia Dia e ";
      } else if (dia > 1) {
        return "$dia Dias e ";
      }
    } else {
      if (dia == 0) {
        return "";
      } else if (dia == 1) {
        return "$dia Dia ";
      } else if (dia > 1) {
        return "$dia Dias ";
      }
    }
  }

  _strgHora(int hora, int min) {
    if (min > 0) {
      if (hora == 0) {
        return "";
      } else if (hora == 1) {
        return "$hora Hora e ";
      } else if (hora > 1) {
        return "$hora Horas e ";
      }
    } else {
      if (hora == 0) {
        return "";
      } else if (hora == 1) {
        return "$hora Hora";
      } else if (hora > 1) {
        return "$hora Horas";
      }
    }
  }

  _strgMin(int min) {
    if (min == 0) {
      return "";
    } else if (min == 1) {
      return "$min minuto";
    } else if (min > 1) {
      return "$min minutos";
    }
  }

  _textDevolucao() {
    DateTime aux = DateTime.fromMillisecondsSinceEpoch(
        programedEndDate.millisecondsSinceEpoch);
    if (aux.isBefore(DateTime.now())) {
      return Text(
        convertedEstimatedEndDate,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
          fontSize: 20,
        ),
      );
    } else {
      return _text("$convertedEstimatedEndDate");
    }
  }
}
