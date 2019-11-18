import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class Creditos extends StatefulWidget {
  @override
  _CreditosState createState() => _CreditosState();
}

class _CreditosState extends State<Creditos> {
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  final databaseReference = Firestore.instance;
  double saldo = 0;
  String userID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userID == "") {
      sharedPreferencesController.getID().then(_setUserID);
    }
    return Scaffold(
      body: homeCreditos(),
    );
  }

  adicionarCreditos(BuildContext context) {
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
                    height: 370,
                    width: 350,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 32, top: 32, right: 8, left: 8),
                            child: Text(
                              "Os créditos do Share On são adicionados através do Mercado Pago. \n"
                              "Informe um dos seguintes valores e você será redirecionado para a página de pagamento.",
                              style: TextStyle(
                                fontFamily: 'RobotoMono',
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      height: 80,
                                      child: btCreditos("R\$ 50", 50),
                                    ),
                                    Container(
                                        height: 80,
                                        child: btCreditos("R\$100", 100)),
                                    Container(
                                        height: 80,
                                        child: btCreditos("R\$ 200", 200))
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                          height: 80,
                                          child: btCreditos("R\$ 300", 300)),
                                      Container(
                                          height: 80,
                                          child: btCreditos("R\$ 500", 500)),
                                      Container(
                                          height: 80,
                                          child: btCreditos("R\$ 1000", 1000)),
                                    ],
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

  homeCreditos() {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: 300,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 32, left: 8, right: 8),
                child: _text("Meus créditos:"),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Text(
                  "R\$ ${saldo.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 32, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: () {},
                        child:
                            Text("Ver histórico", textAlign: TextAlign.center),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          adicionarCreditos(context);
                        },
                        child: Container(
                          child: Text("Adicionar créditos",
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: () {},
                        child: Container(
                          child: Text(
                            "Resgatar créditos",
                            textAlign: TextAlign.center,
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
    );
  }

  _setUserID(String value) {
    setState(() {
      userID = value;
      getData();
    });
  }

  getData() async {
    await databaseReference
        .collection("users")
        .where("userID", isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        var aux = productData["debit"];
        setState(() {
          saldo = aux.toDouble();
        });
      });
    });
  }

  btCreditos(String text, int valor) {
    return RaisedButton(
      color: Colors.indigoAccent,
      onPressed: () {
        _launchURL(valor);
      },
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  _launchURL(int valor) async {
    if (valor == 50) {
      const url =
          'https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=99236958-e1c1ac19-8b7d-488c-a5c5-2b78c1b48ac5';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    if (valor == 100) {
      const url =
          'https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=99236958-7609b48f-14c2-43e3-b569-5a43980f73d5';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    if (valor == 200) {
      const url =
          'https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=99236958-8eebe6a8-979a-4697-93fa-fc33d11d4e32';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    if (valor == 300) {
      const url =
          'https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=99236958-b0db2459-1f51-489e-824b-32a8d302f6f3';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    if (valor == 500) {
      const url =
          'https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=99236958-f5d22b30-e3d7-4297-a42f-9fbb0949f288';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    if (valor == 1000) {
      const url =
          'https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=99236958-d45f4ffe-9242-42d6-b60a-53d270188214';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}

_text(String s) {
  return Text(
    s,
    style: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}
