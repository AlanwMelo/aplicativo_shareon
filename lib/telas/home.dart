import 'dart:async';
import 'dart:io';

import 'package:aplicativo_shareon/models/usuario_model.dart';
import 'package:aplicativo_shareon/telas/cadastro_produto.dart';
import 'package:aplicativo_shareon/telas/creditos.dart';
import 'package:aplicativo_shareon/telas/faq.dart';
import 'package:aplicativo_shareon/telas/favoritos.dart';
import 'package:aplicativo_shareon/telas/historico.dart';
import 'package:aplicativo_shareon/telas/main.dart';
import 'package:aplicativo_shareon/telas/meus_produtos.dart';
import 'package:aplicativo_shareon/telas/produtos_reservas.dart';
import 'package:aplicativo_shareon/telas/suporte.dart';
import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:aplicativo_shareon/utils/timer_reserva.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'funcoes_master.dart';
import 'perfil_usuario.dart';

class Home extends StatefulWidget {
  final int optionalControllerPointer;

  Home({this.optionalControllerPointer});

  @override
  _HomeState createState() => _HomeState();
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.suspendingCallBack});

  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        await suspendingCallBack();
        break;
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
    }
  }
}

class _HomeState extends State<Home> {
  String userName = "?";
  int controllerPointer;
  String userMail = "?";
  String userID = "";
  String urlImgPerfil;
  String timer = "";
  String appBarText = "";
  String userAddress = "";
  bool emailVerified;
  bool masterUser = false;
  final databaseReference = Firestore.instance;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  UserModel model = new UserModel();

  @override
  void initState() {
    if (widget.optionalControllerPointer != null) {
      controllerPointer = widget.optionalControllerPointer;
    } else {
      controllerPointer = 1;
    }
    Timer.periodic(Duration(minutes: 5), (Timer t) => timerReserva());
    sharedPreferencesController.getID().then(_setUserID);
    super.initState();

    WidgetsBinding.instance.addObserver(new LifecycleEventHandler());
  }

  @override
  Widget build(BuildContext context) {
    if (userMail == "" ||
        userMail == "?" ||
        userID == "" ||
        urlImgPerfil == null ||
        emailVerified == null ||
        userAddress == null) {
      sharedPreferencesController.getEmail().then(_setMail);
      sharedPreferencesController.getName().then(_setName);
      sharedPreferencesController.getID().then(_setUserID);
      sharedPreferencesController.getlogedState().then(_logedVerifier);
      sharedPreferencesController.getURLImg().then(_setIMG);
      sharedPreferencesController.getAddress().then(setAddress);
    }
    return Scaffold(
      drawer: _drawer(),
      key: _drawerKey,
      appBar: shareonAppbar(context, appBarText),
      body: homeController(),
    );
  }

  homeController() {
    return WillPopScope(
      onWillPop: () async {
        if (_drawerKey.currentState.isDrawerOpen) {
          Navigator.pop(context);
        } else if (controllerPointer != 1) {
          setState(() {
            controllerPointer = 1;
          });
        } else if (controllerPointer == 1) {
          return alertExit(context);
        }
        return homeController1();
      },
      child: homeController1(),
    );
  }

  homeController1() {
    if (controllerPointer == 1) {
      return TelaMain();
    } else if (controllerPointer == 2) {
      return homeFavoritos();
    } else if (controllerPointer == 3) {
      return TelaReservas();
    } else if (controllerPointer == 4) {
      return TelaHistorico();
    } else if (controllerPointer == 5) {
      return homeMeusProdutos();
    } else if (controllerPointer == 6) {
      return homeSuporte();
    }
    /*else if (controllerPointer == 7) {
      return homeConfiguracoes();
    } */
    else if (controllerPointer == 8) {
      return homeFAQ();
    } else if (controllerPointer == 9) {
      return Creditos();
    }
  }

  _drawer() {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _cabecalho(context),
              Container(
                child: Column(
                  children: <Widget>[
                    _corpo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  alertExit(BuildContext context) {
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
                              "Sair",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            "Deseja mesmo sair do app?",
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
                                            Navigator.pop(context);
                                            exit(0);
                                          });
                                        },
                                        child: Text(
                                          "Sair",
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

  _corpo() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          masterUser == false
              ? Container()
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                        return Master();
                      }));
                    });
                  },
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10, bottom: 3),
                            child: _iconMaster(),
                          ),
                          SizedBox(
                            width: 270,
                            child: Container(
                              margin: EdgeInsets.only(left: 14),
                              child: _text("Master"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                controllerPointer = 9;
              });
            },
            child: Container(
              height: 50,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 3),
                      child: _iconCreditos(),
                    ),
                    SizedBox(
                      width: 270,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 14,
                        ),
                        child: _text("Meus créditos"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return CadastroProduto(userID);
              }));
            },
            child: Container(
              height: 50,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 3),
                      child: _iconCamera(),
                    ),
                    SizedBox(
                      width: 270,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 14,
                        ),
                        child: _text("Adicionar anúncio"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                controllerPointer = 1;
              });
            },
            child: Container(
              height: 50,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 3),
                      child: _iconAnuncios(),
                    ),
                    SizedBox(
                      width: 270,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 14,
                        ),
                        child: _text("Anúncios"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                controllerPointer = 2;
              });
            },
            child: Container(
              height: 50,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 3),
                      child: _iconFavoritos(),
                    ),
                    SizedBox(
                      width: 270,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 14,
                        ),
                        child: _text("Favoritos"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                controllerPointer = 3;
              });
            },
            child: Container(
              height: 50,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 3),
                      child: _iconReservas(),
                    ),
                    SizedBox(
                      width: 270,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 14,
                        ),
                        child: _text("Reservas"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                controllerPointer = 4;
              });
            },
            child: Container(
              height: 50,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 3),
                      child: _iconHistorico(),
                    ),
                    SizedBox(
                      width: 270,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 14,
                        ),
                        child: _text("Histórico"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                controllerPointer = 5;
              });
            },
            child: Container(
              height: 50,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 3),
                      child: _iconMeusProdutos(),
                    ),
                    SizedBox(
                      width: 270,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 14,
                        ),
                        child: _text("Meus Produtos"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /* GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                controllerPointer = 6;
              });
            },
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  child: _iconChat(),
                ),
                SizedBox(
                  width: 270,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 15,
                    ),
                    child: _text("Chat"),
                  ),
                ),
              ],
            ),
          ),*/
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                controllerPointer = 6;
              });
            },
            child: Container(
              height: 50,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 3),
                      child: _iconSuporte(),
                    ),
                    SizedBox(
                      width: 270,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 14,
                        ),
                        child: _text("Suporte"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                controllerPointer = 7;
              });
            },
            child: Container(
              height: 50,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 3),
                      child: _iconConfig(),
                    ),
                    SizedBox(
                      width: 270,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 14,
                        ),
                        child: _text("Configurações"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),*/
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                controllerPointer = 8;
              });
            },
            child: Container(
              height: 50,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 3),
                      child: _iconFAQ(),
                    ),
                    SizedBox(
                      width: 270,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 14,
                        ),
                        child: _text("FAQ"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
                alertExit(context);
              });
            },
            child: Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 3),
                    child: _iconExit(),
                  ),
                  SizedBox(
                    width: 270,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 14,
                      ),
                      child: _text("Sair"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _img() {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 200,
          minHeight: 200,
          maxHeight: 200,
          maxWidth: 200,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(180),
          ),
          child: Container(
            color: Colors.white,
            child: urlImgPerfil == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Image.network(
                    urlImgPerfil,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  _textnome() {
    return Text(
      userName,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _textemail() {
    return Text(
      userMail,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  _cabecalho(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _onClick(context);
      },
      child: Container(
        color: Colors.indigoAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                height: 150,
                width: 150,
                margin: EdgeInsets.only(
                  top: 40,
                  bottom: 5,
                ),
                child: _img(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10,
                bottom: 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _textnome(),
                  _textemail(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _text(String x) {
    return Text(
      x,
      style: TextStyle(
        color: Colors.black54,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _iconAnuncios() {
    return Icon(
      Icons.grid_on,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconMaster() {
    return Icon(
      Icons.error,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconCreditos() {
    return Icon(
      Icons.monetization_on,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconCamera() {
    return Icon(
      Icons.camera_alt,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconFavoritos() {
    return Icon(
      Icons.star,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconReservas() {
    return Icon(
      Icons.playlist_add_check,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconHistorico() {
    return Icon(
      Icons.history,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconMeusProdutos() {
    return Icon(
      Icons.assignment,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconSuporte() {
    return Icon(
      Icons.assistant,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconFAQ() {
    return Icon(
      Icons.help_outline,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconConfig() {
    return Icon(
      Icons.settings,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _iconExit() {
    return Icon(
      Icons.exit_to_app,
      color: Colors.black54,
      size: 24.0,
    );
  }

  _onClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return MeuPerfil();
    }));
  }

  void _logedVerifier(String value) {
    if (value == "0") {
      setState(() {
        sharedPreferencesController.setlogedState("1");
      });
    }
  }

  void _setIMG(String value) {
    setState(() {
      urlImgPerfil = value;
    });
  }

  void _setName(String value) {
    setState(() {
      userName = value;
    });
  }

  void _setMail(String value) {
    setState(() {
      userMail = value;
    });
  }

  Future getUserData() async {
    await databaseReference
        .collection("users")
        .where("userID", isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map userData = f.data;

        if (userData["master"] != null) {
          masterUser = true;
        }
        sharedPreferencesController.setName(userData["nome"]);
        sharedPreferencesController.setAddress(userData["userAddress"]);
        sharedPreferencesController.setURLImg(userData["imgURL"]);
        sharedPreferencesController.setEmail(userData["email"]);
      });
    });
  }

  void _setUserID(String value) {
    setState(() {
      userID = value;
      getUserData();
      timerReserva();
      sharedPreferencesController.getEmailAuth();
    });
  }

  timerReserva() async {
    TimerReserva timerReserva = new TimerReserva();
    String aux = await timerReserva.timerVerifier(userID, appBarText);
    if (aux != "") {
      setState(() {
        appBarText = aux;
      });
    }
  }

  setAddress(String value) {
    setState(() {
      userAddress = value;
    });
  }
}
