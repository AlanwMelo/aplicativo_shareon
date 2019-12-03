import 'dart:math';

import 'package:aplicativo_shareon/utils/alter_debit.dart';
import 'package:aplicativo_shareon/utils/alter_score.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:toast/toast.dart';
import 'package:valida_cpf/valida_cpf.dart';

class Master extends StatefulWidget {
  @override
  _MasterState createState() => _MasterState();
}

class _MasterState extends State<Master> {
  final fieldsSaldo = GlobalKey<FormState>();
  final fieldsAvaliacoes = GlobalKey<FormState>();
  final databaseReference = Firestore.instance;
  final alterSaldoCPF = new MaskedTextController(mask: '000.000.000-00');
  final saldo = MoneyMaskedTextController();
  final avaliacoesID = TextEditingController();
  String cpf;
  double auxDouble;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading == false
        ? mater()
        : Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget mater() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Master'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Center(
          child: Form(
            key: fieldsSaldo,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Alterar saldo de créditos:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 26,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Para alterar o saldo de créditos informe o valor e o CPF",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 16,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: TextFormField(
                        controller: alterSaldoCPF,
                        decoration: InputDecoration(
                          hintText: "CPF",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (text) {
                          if (text.length != 14) {
                            return "O CPF deve conter 11 dígitos";
                          }
                          String aux = text.replaceAll(".", "");
                          cpf = aux.replaceAll("-", "");

                          if (validaCpf(cpf) == false) {
                            return "CPF inválido";
                          }
                          if (text.isEmpty) {
                            return "Campo CPF obrigatório";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: TextFormField(
                        controller: saldo,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (text) {
                          if (text.isEmpty || text == "0,00") {
                            return "O valor não pode ser 0";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 400,
                      margin: EdgeInsets.only(right: 16, left: 16),
                      child: RaisedButton(
                        color: Colors.indigoAccent,
                        onPressed: () {
                          if (fieldsSaldo.currentState.validate()) {
                            String aux1 = saldo.text.replaceAll(".", "");
                            String aux2 = aux1.replaceAll(",", ".");
                            auxDouble = double.parse(aux2);
                            alertExit(context, caller: 1);
                          }
                        },
                        child: Text(
                          "Inserir Saldo",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      margin: EdgeInsets.only(right: 16, left: 16),
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          if (fieldsSaldo.currentState.validate()) {
                            alertExit(context, caller: 2);
                            print(cpf);
                            print(saldo.text);
                          }

                          print(saldo.text);
                          String aux1 = saldo.text.replaceAll(".", "");
                          String aux2 = aux1.replaceAll(",", ".");
                          auxDouble = double.parse(aux2);
                          print(auxDouble * -1);
                        },
                        child: Text(
                          "Remover Saldo",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    Form(
                      key: fieldsAvaliacoes,
                      child: Container(
                        margin: EdgeInsets.all(16),
                        child: TextFormField(
                          controller: avaliacoesID,
                          decoration: InputDecoration(
                            hintText: "ID a ser afetado",
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Informe o ID a ser alterado";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      margin: EdgeInsets.only(right: 16, left: 16),
                      child: RaisedButton(
                        color: Colors.indigoAccent,
                        onPressed: () {
                          if (fieldsAvaliacoes.currentState.validate()) {
                            alertExit(context, caller: 3);
                          }
                        },
                        child: Text(
                          "Inserir 10 avaliações",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    Container(
                      width: 400,
                      margin: EdgeInsets.only(right: 16, left: 16),
                      child: RaisedButton(
                        color: Colors.indigoAccent,
                        onPressed: () {
                          alertExit(context, caller: 4);
                        },
                        child: Text(
                          "Atualizar status das reservas",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  alertExit(BuildContext context, {int caller}) {
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
                              "Confirmação",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            "Deseja mesmo confirmar esta ação?",
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
                                          confirmar(caller);
                                          setState(() {
                                            Navigator.pop(context);
                                          });
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

  confirmar(int caller) async {
    if (caller == 1) {
      setState(() {
        loading = true;
      });
      await databaseReference
          .collection("users")
          .where("cpf", isEqualTo: cpf)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) async {
          Map usarData = f.data;

          String aux = usarData["userID"];

          Map<String, dynamic> debitADD = {
            "userID": aux,
            "reason": "altered by master",
            "debit": auxDouble,
            "statusTS": Timestamp.fromDate(DateTime.now()),
          };

          await databaseReference.collection("debitHist").add(debitADD);

          var alter = AlterDebit(userID: aux);
          alter.alterdebit();

          alterSaldoCPF.text = "";

          _toast("Créditos removidos com sucesso", context);
        });
      });
      setState(() {
        loading = false;
      });
    } else if (caller == 2) {
      setState(() {
        loading = true;
      });
      await databaseReference
          .collection("users")
          .where("cpf", isEqualTo: cpf)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) async {
          Map usarData = f.data;

          String aux = usarData["userID"];

          Map<String, dynamic> debitADD = {
            "userID": aux,
            "reason": "altered by master",
            "debit": auxDouble * -1,
            "statusTS": Timestamp.fromDate(DateTime.now()),
          };

          await databaseReference.collection("debitHist").add(debitADD);

          var alter = AlterDebit(userID: aux);
          alter.alterdebit();

          saldo.text = "";

          _toast("Créditos inseridos com sucesso", context);
        });
      });
      setState(() {
        loading = false;
      });
    } else if (caller == 3) {
      String result;
      setState(() {
        loading = true;
      });

      var isUser = await databaseReference
          .collection("users")
          .where("userID", isEqualTo: avaliacoesID.text)
          .getDocuments();

      var isProduct = await databaseReference
          .collection("products")
          .where("ID", isEqualTo: avaliacoesID.text)
          .getDocuments();

      for (int aux = 0; aux < 10; aux++) {
        int random = new Random().nextInt(6);

        if (random == 0) {
          random = random + 3;
        }

        Map<String, dynamic> randonScore = {
          "ID": avaliacoesID.text,
          "decription": "random generated",
          "TS": Timestamp.fromDate(DateTime.now()),
          "value": random.toString(),
        };

        if (isUser.documents.length > 0) {
          await databaseReference.collection("scoreValues").add(randonScore);
          var aux = AlterScore(userID: avaliacoesID.text);
          aux.alterscore();
          result = "Score do usuário alterado";
        } else if (isProduct.documents.length > 0) {
          await databaseReference.collection("scoreValues").add(randonScore);
          var aux1 = AlterScore(productID: avaliacoesID.text);
          aux1.alterscore();
          result = "Score do produto alterado";
        } else {
          result = "ID não encontrado";
        }
      }

      _toast(result, context);

      setState(() {
        avaliacoesID.text = "";
        loading = false;
      });
    } else if (caller == 4) {}
  }

  _toast(String texto, BuildContext context) {
    Toast.show("$texto", context,
        duration: 3,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.8));
  }
}
