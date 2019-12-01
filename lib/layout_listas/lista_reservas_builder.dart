import 'package:aplicativo_shareon/telas/tela_verifica_reserva.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ListaReservasBuilder extends StatefulWidget {
  @override
  _ListaReservasBuilderState createState() => _ListaReservasBuilderState();
}

class _Reservas {
  String productID;
  String name;
  String media;
  var preco;
  String status;
  String solicitationID;
  Timestamp programedInitDate;

  _Reservas(this.productID, this.name, this.preco, this.media, this.status,
      this.solicitationID, this.programedInitDate);
}

class _ListaReservasBuilderState extends State<ListaReservasBuilder> {
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  final databaseReference = Firestore.instance;
  String productID;
  String status;
  String userID = "";
  int counter = 0;
  List<_Reservas> _listaReservas = [];
  bool listIsEmpty = false;

  @override
  void initState() {
    if (userID == "") {
      sharedPreferencesController.getID().then(_setUserID);
    }
    super.initState();
  }

  getData() async {
    // String helper;
    await databaseReference
        .collection("solicitations")
        .where("requesterID", isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (snapshot.documents.length == 0) {
        setState(() {
          listIsEmpty = true;
        });
      }
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        if (productData["status"] == "em andamento" ||
            productData["status"] == "pendente" ||
            productData["status"] == "aprovada") {
          listHelper(
              productData["productID"],
              productData["status"],
              productData["programedInitDate"],
              productData["solicitationID"],
              productData["estimatedEndPrice"]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _listaReservas.length == 0 && listIsEmpty == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : listIsEmpty == true
            ? Center(
                child: Text(
                  "Você ainda não possui nenhuma reserva",
                  style: TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : listGen(_listaReservas);
  }

  _onClick(BuildContext context, String idx) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return TelaVerificaReserva(userId: userID, solicitationID: idx);
    }));
  }

//objetos

  _img(String idx) {
    String productMainIMG;

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
            height: 150,
            width: 150,
            child: productMainIMG == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Image.network(
                    productMainIMG,
                    fit: BoxFit.cover,
                  ),
          ),
        );
      },
    );
  }

  _textNome(String idx, String status) {
    Color color;
    if (status == "pendente") {
      color = Colors.orange;
    }
    if (status == "em andamento") {
      color = Colors.green;
    }
    if (status == "aprovada") {
      color = Colors.indigoAccent;
    }
    return Expanded(
      child: Text(
        idx,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: color,
        ),
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

  _textData(Timestamp idx) {
    Color color = Colors.black38;
    int timeNow = Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch;
    int reservedTime = idx.millisecondsSinceEpoch;
    if ((reservedTime - timeNow) <= 3600000) {
      color = Colors.orange;
    }

    int convertedDay = idx.toDate().day;
    int convertedMonth = idx.toDate().month;
    int convertedYear = idx.toDate().year;
    String convertedTS =
        "Dia ${convertedDay.toString().padLeft(2, "0")}/${convertedMonth.toString().padLeft(2, "0")}/$convertedYear";

    return Text(
      convertedTS,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
    );
  }

  _textTime(Timestamp idx) {
    Color color = Colors.black38;
    int timeNow = Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch;
    int reservedTime = idx.millisecondsSinceEpoch;
    if ((reservedTime - timeNow) <= 3600000) {
      color = Colors.orange;
    }
    int convertedHour = idx.toDate().hour;
    int convertedMinute = idx.toDate().minute;
    String convertedTS =
        "às ${convertedHour.toString().padLeft(2, "0")}:${convertedMinute.toString().padLeft(2, "0")}";

    return Text(
      convertedTS,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
    );
  }

  _textPreco(var idx) {
    return Text(
      "R\$ ${idx.toString()}",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
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

  Widget listGen(List<_Reservas> _listaReservas) {
    return ListView.builder(
      itemCount: _listaReservas.length,
      itemExtent: 150,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _onClick(context, _listaReservas[index].solicitationID),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            margin: EdgeInsets.all(6),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _img(_listaReservas[index].productID),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _textNome(_listaReservas[index].name,
                            _listaReservas[index].status),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            children: <Widget>[
                              _textMedia(_listaReservas[index].media),
                              _iconEstrela(),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                _textData(
                                    _listaReservas[index].programedInitDate),
                                _textTime(
                                    _listaReservas[index].programedInitDate),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    _textPreco(_listaReservas[index].preco),
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

  listHelper(String id, String status, Timestamp initDate,
      String solicitationID, var estimatedEndPrice) {
    databaseReference
        .collection("products")
        .where("ID", isEqualTo: id)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        setState(() {
          _listaReservas.add(new _Reservas(
              id,
              productData["name"],
              estimatedEndPrice,
              productData["media"],
              status,
              solicitationID,
              initDate));
          _listaReservas.sort(
              (a, b) => a.programedInitDate.compareTo(b.programedInitDate));
        });
      });
    });
  }
}
