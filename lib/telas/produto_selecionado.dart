import 'dart:async';
import 'dart:convert';

import 'package:aplicativo_shareon/models/usuario_model.dart';
import 'package:aplicativo_shareon/telas/editar_produto.dart';
import 'package:aplicativo_shareon/telas/reservar_produto.dart';
import 'package:aplicativo_shareon/telas/validacao.dart';
import 'package:aplicativo_shareon/telas/ver_perfil.dart';
import 'package:aplicativo_shareon/telas/verificar_reserva.dart';
import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:toast/toast.dart';

import '../main.dart';
import 'avaliacoes_produtos.dart';
import 'home.dart';

class ProdutoSelecionado extends StatefulWidget {
  final String productID;
  final int caller;

  ProdutoSelecionado({@required this.productID, this.caller});

  @override
  _ProdutoSelecionadoState createState() => _ProdutoSelecionadoState();
}

class _ReservaProxima {
  String solicitationID;
  Timestamp programedInitDate;

  _ReservaProxima(this.solicitationID, this.programedInitDate);
}

class _ProdutoSelecionadoState extends State<ProdutoSelecionado> {
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  UserModel model = new UserModel();
  final databaseReference = Firestore.instance;
  bool productInFavorites = false;
  bool myProduct = false;
  String favoriteController = "";
  String productName = "";
  String productMedia = "";
  var productPrice;
  String productOwner = "";
  String productOwnerID = "";
  String productDescription = "";
  String productIMG = "";
  String productType = "";
  String userID = "";
  String userMail = "";
  String solicitationStatus = "";
  String solicitationID = "";
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
  String actualPass = "";
  List listaIMGS = [];
  Map mapListaIMGS = {};
  int counter = 0;
  List<_ReservaProxima> reservaAprovada = [];
  List<_ReservaProxima> reservaEmAndamento = [];
  bool emailVerified;
  bool loading = false;

  @override
  void initState() {
    getProductData();
    getFavoriteStatus();
    getIsMyProduct();
    if (userID == "") {
      sharedPreferencesController.getID().then(_setID);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    listaIMGS = mapListaIMGS.values.toList();
    generaPGViewer();
    if (userID != "" && userMail != "") {
      if (emailVerified == null) {
        sharedPreferencesController.getEmailAuth().then(_verifyAuth);
      }
    }
    if (productInFavorites == false) {
      favoriteController = "Adicionar aos Favoritos";
    } else if (productInFavorites == true) {
      favoriteController = "Remover dos Favoritos";
    }
    return loading == false
        ? _produtoSelecionado(context)
        : Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
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

  _produtoSelecionado(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.caller != null) {
          return Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return Home(optionalControllerPointer: widget.caller);
          }));
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: shareonAppbar(context, ""),
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
                          color: Colors.white,
                          child: PageIndicatorContainer(
                            length: listaIMGS.length,
                            indicatorSpace: 10.0,
                            padding: const EdgeInsets.all(10),
                            indicatorColor: Colors.white.withOpacity(0.7),
                            indicatorSelectorColor: Colors.blue,
                            shape: IndicatorShape.circle(size: 10),
                            child: exibePGV(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: _text(productName, titulo: true),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return VerPerfil(userID: productOwnerID);
                            }));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                            child: _text("Produto de: $productOwner"),
                          ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              child: Container(
                                color: Colors.white,
                                width: 1000,
                                padding: EdgeInsets.all(8),
                                child: _text(productDescription, resumo: true),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              child: RaisedButton(
                                color: Colors.white,
                                onPressed: () {
                                  _setFavoriteState();
                                },
                                child: _text(favoriteController, resumo: true),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                  return AvaliacoesProdutos(id: widget.productID);
                                }));
                              },
                              child: Text(
                                "Ver avaliações",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'RobotoMono',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 400,
                          margin:
                              EdgeInsets.only(bottom: 16, right: 8, left: 8),
                          child: prodDestination(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
    if (listaIMGS.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
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

  getFavoriteStatus() async {
    await databaseReference
        .collection("favoriteProducts")
        .where("productID", isEqualTo: (widget.productID))
        .where("userID", isEqualTo: userID)
        .getDocuments()
        .then(
      (QuerySnapshot snapshot) {
        snapshot.documents.forEach(
          (f) {
            if (f.data.isNotEmpty) {
              setState(() {
                productInFavorites = true;
              });
            }
          },
        );
      },
    );
  }

  _setID(String value) {
    setState(() {
      userID = value;
      getFavoriteStatus();
      getIsMyProduct();
      getSolicitationStatus();
    });
  }

  _setFavoriteState() async {
    Timestamp addDate = Timestamp.now();
    Map<String, dynamic> favData = {
      "productID": (widget.productID),
      "userID": userID,
      "addDate": addDate,
    };

    if (productInFavorites == false) {
      final newFav =
          await databaseReference.collection("favoriteProducts").add(favData);
      String favIDWriter = newFav.documentID;
      Map<String, dynamic> setID = {
        "favID": favIDWriter,
      };
      await databaseReference
          .collection("favoriteProducts")
          .document(favIDWriter)
          .updateData(setID);
      setState(() {
        _toast("Adicionado aos favoritos", context);
        getFavoriteStatus();
      });
    } else if (productInFavorites == true) {
      databaseReference
          .collection("favoriteProducts")
          .where("productID", isEqualTo: widget.productID)
          .where("userID", isEqualTo: userID)
          .getDocuments()
          .then(
        (QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) async {
            Map productData = f.data;
            String favDel = productData["favID"];
            _deleter(favDel);
          });
        },
      );
    }
  }

  _deleter(String favDel) async {
    await databaseReference
        .collection("favoriteProducts")
        .document(favDel)
        .delete();

    setState(() {
      productInFavorites = false;
      getFavoriteStatus();
      _toast("Removido dos favoritos", context);
    });
  }

  prodDestination() {
    if (reservaEmAndamento.length > 0) {
      return RaisedButton(
        color: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return TelaValidacao(
                userId: userID,
                solicitationId: reservaEmAndamento[0].solicitationID,
              );
            }),
          );
        },
        child: _text("Validar devolução", resumo: true),
      );
    } else if (reservaAprovada.length > 0) {
      int timeNow = Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch;
      int nearestTime =
          reservaAprovada[0].programedInitDate.millisecondsSinceEpoch;

      if ((nearestTime - timeNow) <= 3600000) {
        return RaisedButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return TelaVerificaReserva(
                  userId: userID,
                  solicitationID: solicitationID,
                );
              }),
            );
          },
          child: _text("Validar retirada", resumo: true),
        );
      } else {
        return RaisedButton(
          color: Colors.white,
          onPressed: () {
            _alertCancelamento(context);
          },
          child: _text("Cancelar reserva", resumo: true),
        );
      }
    } else if (myProduct == null) {
      return Container();
    } else if (myProduct == true) {
      return RaisedButton(
        color: Colors.white,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return EditaProduto(
              userID: userID,
              productID: widget.productID,
            );
          }));
        },
        child: _text("Editar", resumo: true),
      );
    } else if (myProduct == false) {
      return RaisedButton(
        color: Colors.white,
        onPressed: () {
          if (emailVerified == false) {
            sharedPreferencesController
                .getEmailAuth()
                .then((value) => _verifyAuth(value, caller: 1));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return TelaReservar(
                    productID: widget.productID, productPrice: productPrice);
              }),
            );
          }
        },
        child: _text("Reservar", resumo: true),
      );
    }
  }

  getIsMyProduct() async {
    await databaseReference
        .collection("products")
        .where("ID", isEqualTo: (widget.productID))
        .where("ownerID", isEqualTo: userID)
        .getDocuments()
        .then(
      (QuerySnapshot snapshot) {
        snapshot.documents.forEach(
          (f) {
            if (f.data.isNotEmpty) {
              setState(() {
                myProduct = true;
              });
            }
          },
        );
      },
    );
  }

  getSolicitationStatus() async {
    await databaseReference
        .collection("solicitations")
        .where("requesterID", isEqualTo: userID)
        .where("productID", isEqualTo: widget.productID)
        .getDocuments()
        .then(
      (QuerySnapshot snapshot) {
        snapshot.documents.forEach(
          (f) {
            Map productData = f.data;
            if (productData["status"] == "aprovada") {
              setState(() {
                reservaAprovada.add(new _ReservaProxima(
                    productData["solicitationID"],
                    productData["programedInitDate"]));
                reservaAprovada.sort((a, b) =>
                    a.programedInitDate.compareTo(b.programedInitDate));
              });
            }
            if (productData["status"] == "em andamento") {
              reservaEmAndamento.add(new _ReservaProxima(
                  productData["solicitationID"],
                  productData["programedInitDate"]));
            }
          },
        );
      },
    );
    if (reservaAprovada.length > 0) {
      solicitationID = reservaAprovada[0].solicitationID;
    }
  }

  _toast(String texto, BuildContext context) {
    Toast.show("$texto", context,
        duration: 3,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.8));
  }

  Future<FutureOr> _verifyAuth(bool value, {int caller}) async {
    await databaseReference
        .collection("users")
        .where("userID", isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map userData = f.data;
        var base64Str = base64.decode(userData["password"]);
        var passDecode = utf8.decode(base64Str);

        actualPass = passDecode;
      });
    });

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userAuth =
        EmailAuthProvider.getCredential(email: userMail, password: actualPass);
    await user.reauthenticateWithCredential(userAuth).then((onValue) async {
      emailVerified = await model
          .isAuthenticated(await FirebaseAuth.instance.currentUser());

      if (caller == 1 && emailVerified == false) {
        _alertEmail();
      }
    });
  }

  _alertEmail() {
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
                    height: 310,
                    width: 300,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "Email ainda não confirmado !",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 3,
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: _textConfirmacao(
                                "Somente usuários com email confirmado podem realizar empréstimos.\n\n "
                                "Se você não recebeu o email de verificação você pode reenvia-lo "
                                "atravéz do botão abaixo.",
                                center: true),
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
                                  Expanded(
                                    child: Container(
                                      height: 100,
                                      child: RaisedButton(
                                        color: Colors.indigoAccent,
                                        onPressed: () async {
                                          FirebaseUser user = await FirebaseAuth
                                              .instance
                                              .currentUser();
                                          user.sendEmailVerification();
                                          _toast("Email de verificação enviado",
                                              context);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Reenviar",
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
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: 16,
          decoration: TextDecoration.none,
        ),
      );
    }
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
        .document(solicitationID)
        .updateData(cancelamento);

    setState(() {
      loading = false;
    });

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return Home(optionalControllerPointer: 3);
    }));
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
}
