import 'package:aplicativo_shareon/telas/tela_produto_selecionado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ListaMeusProdutosBuilder extends StatefulWidget {
  @override
  _ListaMeusProdutosBuilderState createState() =>
      _ListaMeusProdutosBuilderState();
}

class _MyProducts {
  String productID;
  String name;
  var preco;
  String media;
  Timestamp addDate;

  _MyProducts(this.productID, this.name, this.preco, this.media, this.addDate);
}

class _ListaMeusProdutosBuilderState extends State<ListaMeusProdutosBuilder> {
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  final databaseReference = Firestore.instance;
  List<_MyProducts> _listaMeusProdutos = [];
  String id;
  String userID = "";
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
        .collection("products")
        .where("ownerID", isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (snapshot.documents.length == 0) {
        setState(() {
          listIsEmpty = true;
        });
      }
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        if (productData["adStatus"] != "deletado") {
          setState(() {
            _listaMeusProdutos.add(new _MyProducts(
                productData["ID"],
                productData["name"],
                productData["price"],
                productData["media"],
                productData["insertionDate"]));
            _listaMeusProdutos.sort((b, a) => a.addDate.compareTo(b.addDate));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _listaMeusProdutos.length == 0 && listIsEmpty == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : listIsEmpty == true
            ? Center(
                child: Text(
                  "Você ainda não possui nenhum produto",
                  style: TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : listGen(_listaMeusProdutos);
  }

  _onClick(BuildContext context, String idx) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ProdutoSelecionado(productID: idx);
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

  Widget listGen(List<_MyProducts> _listaMeusProdutos) {
    return ListView.builder(
      itemCount: _listaMeusProdutos.length,
      itemExtent: 150,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _onClick(context, _listaMeusProdutos[index].productID),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            margin: EdgeInsets.all(6),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _img(_listaMeusProdutos[index].productID),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _textNome(_listaMeusProdutos[index].name),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            children: <Widget>[
                              _textMedia(_listaMeusProdutos[index].media),
                              _iconEstrela(),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            _textPreco(_listaMeusProdutos[index].preco),
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

  void _setID(String value) {
    setState(() {
      userID = value;
      getData();
    });
  }
}
