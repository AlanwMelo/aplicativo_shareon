import 'package:aplicativo_shareon/telas/produto_selecionado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ListaHistoricoBuilder extends StatefulWidget {
  @override
  _ListaHistoricoBuilderState createState() => _ListaHistoricoBuilderState();
}

class _ProductsHist {
  String productID;
  String name;
  String media;
  var preco;
  String status;
  Timestamp endDate;
  String mainIMG;

  _ProductsHist(this.productID, this.name, this.preco, this.media, this.status,
      this.endDate, this.mainIMG);
}

class _ListaHistoricoBuilderState extends State<ListaHistoricoBuilder> {
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  final databaseReference = Firestore.instance;
  String productID;
  String status;
  String userID = "";
  int counter = 0;
  List<_ProductsHist> _listaHistorico = [];
  bool listIsEmpty = false;

  @override
  void initState() {
    if (userID == "") {
      sharedPreferencesController.getID().then(_setUserID);
    }
    super.initState();
  }

  getData() async {
    await databaseReference
        .collection("solicitations")
        .where("requesterID", isEqualTo: userID)
        .where("status", isEqualTo: "concluido")
        .where("status", isEqualTo: "cancelada")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (snapshot.documents.length == 0) {
        setState(() {
          listIsEmpty = true;
        });
      }
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        if (productData["status"] == "concluido" ||
            productData["status"] == "cancelada") {
          listHelper(productData["productID"], productData["status"],
              productData["finalEndDate"]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _listaHistorico.length == 0 && listIsEmpty == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : listIsEmpty == true
            ? Center(
                child: Text(
                  "Você ainda não fez nenhuma transação",
                  style: TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : listGen(_listaHistorico);
  }

  _onClick(BuildContext context, String idx) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ProdutoSelecionado(productID: idx);
    }));
  }

//objetos

  _img(String idx) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.zero,
          bottomRight: Radius.zero,
          bottomLeft: Radius.circular(16)),
      child: Container(
        height: 150,
        width: 150,
        child: idx == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Image.network(
                idx,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  _textNome(String idx, String status) {
    Color color;
    if (status == "concluido") {
      color = Colors.indigoAccent;
    } else {
      color = Colors.redAccent;
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
    int convertedDay = idx.toDate().day;
    int convertedMonth = idx.toDate().month;
    int convertedYear = idx.toDate().year;
    String convertedTS =
        "${convertedDay.toString().padLeft(2, "0")}/${convertedMonth.toString().padLeft(2, "0")}/$convertedYear";

    return Text(
      convertedTS,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black38),
    );
  }

  _textPreco(var idx) {
    return Text(
      "R\$ $idx",
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

  Widget listGen(List<_ProductsHist> _listaHist) {
    return ListView.builder(
      itemCount: _listaHist.length,
      itemExtent: 150,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _onClick(context, _listaHist[index].productID),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            margin: EdgeInsets.all(6),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _img(_listaHist[index].mainIMG),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _textNome(
                            _listaHist[index].name, _listaHist[index].status),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            children: <Widget>[
                              _textMedia(_listaHist[index].media),
                              _iconEstrela(),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            _textData(_listaHist[index].endDate),
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    _textPreco(_listaHist[index].preco),
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

  listHelper(String id, String status, Timestamp endDate) {
    databaseReference
        .collection("products")
        .where("ID", isEqualTo: id)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) async {
        Map productData = f.data;

        await databaseReference
            .collection("productIMGs")
            .where("productID", isEqualTo: productData["ID"])
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            Map productIMG = f.data;

            _listaHistorico.add(new _ProductsHist(
                id,
                productData["name"],
                productData["price"],
                productData["media"],
                status,
                endDate,
                productIMG["productMainIMG"]));
            _listaHistorico.sort((a, b) => a.endDate.compareTo(b.endDate));
            setState(() {});
          });
        });
      });
    });
  }
}
