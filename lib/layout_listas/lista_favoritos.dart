import 'package:aplicativo_shareon/telas/produto_selecionado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ListaFavoritosBuilder extends StatefulWidget {
  @override
  _ListaFavoritosBuilderState createState() => _ListaFavoritosBuilderState();
}

class _FavoritesData {
  String productID;
  String name;
  String media;
  var preco;
  Timestamp addDate;
  String productMAINimg;

  _FavoritesData(this.productID, this.name, this.preco, this.media,
      this.addDate, this.productMAINimg);
}

class _ListaFavoritosBuilderState extends State<ListaFavoritosBuilder> {
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  final databaseReference = Firestore.instance;
  String userID = "";
  int counter = 0;
  List<_FavoritesData> _listaFav = [];
  bool listIsEmpty = false;

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
      if (snapshot.documents.length == 0) {
        setState(() {
          listIsEmpty = true;
        });
      }
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        listHelper(productData["productID"], productData["addDate"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _listaFav.length == 0 && listIsEmpty == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : listIsEmpty == true
            ? Center(
                child: Text(
                  "Você não possui nenhum favorito",
                  style: TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : listGen(_listaFav);
  }

  _onClick(BuildContext context, String idx) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ProdutoSelecionado(productID: idx, caller: 2);
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

  _textNome(String idx) {
    return Expanded(
      child: Text(
        idx,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.indigoAccent,
        ),
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
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }

  _textMedia(String idx) {
    return Text(
      idx,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black54,
      ),
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

   listGen(List<_FavoritesData> _listaFav) {
    return ListView.builder(
      itemCount: _listaFav.length,
      itemExtent: 150,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: GestureDetector(
            onLongPress: () {
              _alertFavDel(context, index);
            },
            onTap: () => _onClick(context, _listaFav[index].productID),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              margin: EdgeInsets.all(6),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _img(_listaFav[index].productMAINimg),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _textNome(_listaFav[index].name),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              children: <Widget>[
                                _textMedia(_listaFav[index].media),
                                GestureDetector(
                                  child: _iconEstrela(),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              _textPreco(_listaFav[index].preco),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              _textData(_listaFav[index].addDate),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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

  listHelper(String id, Timestamp addDate) {
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

            _listaFav.add(new _FavoritesData(
                id,
                productData["name"],
                productData["price"],
                productData["media"],
                addDate,
                productIMG["productMainIMG"]));
            _listaFav.sort((a, b) => b.addDate.compareTo(a.addDate));
            setState(() {});
          });
        });
      });
    });
  }

  _alertFavDel(BuildContext context, int index) {
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
                    height: 270,
                    width: 350,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "Remover",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 3,
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.all(8),
                                child: _textConfirmacao(
                                    "Deseja mesmo remover \"${_listaFav[index].name}\" dos seus favoritos?",
                                    center: true),
                              ),
                            ),
                          ),
                          Container(
                            height: 70,
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
                                      onPressed: () async {
                                        await databaseReference
                                            .collection("favoriteProducts")
                                            .where("productID",
                                                isEqualTo:
                                                    _listaFav[index].productID)
                                            .where("userID", isEqualTo: userID)
                                            .getDocuments()
                                            .then(
                                          (QuerySnapshot snapshot) {
                                            snapshot.documents
                                                .forEach((f) async {
                                              Map productData = f.data;
                                              String favDel =
                                                  productData["favID"];

                                              await databaseReference
                                                  .collection(
                                                      "favoriteProducts")
                                                  .document(favDel)
                                                  .delete();
                                            });
                                          },
                                        );
                                        setState(() {
                                          _listaFav.removeAt(index);
                                          getData();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Confirmar",
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
                                        "Cancelar",
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

  _textConfirmacao(String texto, {bool titulo = false, bool center = false}) {
    if (titulo) {
      return Text(
        "$texto",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
          fontSize: 16,
          decoration: TextDecoration.none,
        ),
      );
    } else if (center == true) {
      return Text(
        "$texto",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: 16,
          decoration: TextDecoration.none,
        ),
      );
    } else {
      return Text(
        "$texto",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16,
          decoration: TextDecoration.none,
        ),
      );
    }
  }
}
