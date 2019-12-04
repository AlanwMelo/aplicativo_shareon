import 'dart:convert';

import 'package:aplicativo_shareon/models/usuario_model.dart';
import 'package:aplicativo_shareon/telas/home.dart';
import 'package:aplicativo_shareon/telas/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';
import 'package:valida_cpf/valida_cpf.dart';

class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final confirmarEmailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  final cpfController = new MaskedTextController(mask: '000.000.000-00');
  final telefoneController = new MaskedTextController(mask: '(00) 00000-0000');
  final enderecoController = TextEditingController();
  final campos = GlobalKey<FormState>();
  final verificacao = GlobalKey<ScaffoldState>();
  final databaseReference = Firestore.instance;
  String stringUserAddress = "Informe seu endereço";
  GeoPoint userAddressLatLng;
  String cpf;
  bool btloading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _alertExit(context);
      },
      child: Scaffold(
          key: verificacao,
          appBar: AppBar(
            title: Text("Criar Conta"),
            centerTitle: true,
          ),
          body: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.carregando)
                return Center(
                  child: CircularProgressIndicator(),
                );

              return Form(
                key: campos,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: nomeController,
                      decoration: InputDecoration(hintText: "Nome Completo"),
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Campo Nome Completo obrigatório";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(hintText: "E-mail"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Campo Email obrigatório";
                        } else if (!text.contains("@")) {
                          return "Digite um email válido";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: confirmarEmailController,
                      decoration: InputDecoration(hintText: "Confirmar e-mail"),
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Campo confirmar email obrigatório";
                        } else if (emailController.text != text) {
                          return "A confirmação do email está diferente do email informado";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: senhaController,
                      decoration: InputDecoration(hintText: "Senha"),
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Campo Senha obrigatório";
                        } else if (text.length < 8) {
                          return "Senha curta, mínimo 8 digitos";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: confirmarSenhaController,
                      decoration: InputDecoration(hintText: "Confirmar senha"),
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Campo confirmar senha obrigatório";
                        } else if (senhaController.text != text) {
                          return "A confirmação da senha está diferente da senha informada";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: cpfController,
                      decoration: InputDecoration(hintText: "CPF"),
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
                    SizedBox(height: 16.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: telefoneController,
                      decoration: InputDecoration(hintText: "Telefone"),
                      validator: (text) {
                        if (text.length != 15) {
                          return "O telefone informado não é válido";
                        }
                        if (text.isEmpty) {
                          return "Campo telefone obrigatório";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        _selecionaLocalizacao(context);
                      },
                      child: Row(
                        children: <Widget>[
                          _icGPS(),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            width: 280,
                            child: Text(
                              stringUserAddress,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 44.0,
                      child: Container(
                        child: btloading != false
                            ? RaisedButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {},
                                child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white)),
                              )
                            : RaisedButton(
                                child: Text(
                                  "Criar Conta",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                textColor: Colors.white,
                                color: Theme.of(context).primaryColor,
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  if (campos.currentState.validate()) {
                                    if (stringUserAddress ==
                                        "Informe seu endereço") {
                                      _toast("Informe seu endereço", context);
                                    } else {
                                      bool cpfInUse = false;
                                      bool emailInUse = false;

                                      await databaseReference
                                          .collection("users")
                                          .where("email")
                                          .getDocuments()
                                          .then((QuerySnapshot snapshot) {
                                        snapshot.documents.forEach((f) {
                                          Map mappedEmail = f.data;
                                          if (mappedEmail["email"] ==
                                              emailController.text) {
                                            emailInUse = true;
                                          }
                                        });
                                      });

                                      await databaseReference
                                          .collection("users")
                                          .where("cpf")
                                          .getDocuments()
                                          .then((QuerySnapshot snapshot) {
                                        snapshot.documents.forEach((f) {
                                          Map mappedCPF = f.data;
                                          if (mappedCPF["cpf"] == cpf) {
                                            cpfInUse = true;
                                          }
                                        });
                                      });
                                      if (emailInUse == true) {
                                        _toast(
                                            "Este email já está sendo utilizado",
                                            context);
                                      } else if (cpfInUse == true) {
                                        _cpfEmUso(context);
                                      } else {
                                        _btLoader();
                                        double debit = 0;

                                        var passEncode =
                                            utf8.encode(senhaController.text);
                                        var base64Str =
                                            base64.encode(passEncode);

                                        Map<String, dynamic> userData = {
                                          "nome": nomeController.text,
                                          "email": emailController.text,
                                          "password": base64Str,
                                          "cpf": cpf,
                                          "tel_contato":
                                              telefoneController.text,
                                          "debit": debit,
                                          "media": "-",
                                          "userAddressLatLng":
                                              userAddressLatLng,
                                          "userAddress": stringUserAddress,
                                          "authenticated": false,
                                          "imgURL":
                                              "https://firebasestorage.googleapis.com/v0/b/shareon.appspot.com/o/DefaultIMG%2FDefaultIMG.png?alt=media&token=9fbc8d45-36a1-45cf-a53b-0c0b7c7588a0",
                                        };

                                        model.signUp(
                                            userData: userData,
                                            pass: senhaController.text,
                                            onSuccess: sucesso,
                                            onFail: falha);
                                      }
                                    }
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }

  void sucesso() {
    verificacao.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    _alertAuth(context);
  }

  void falha() {
    verificacao.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }

  Future<Null> _selecionaLocalizacao(BuildContext context) async {
    LocationResult result = await LocationPicker.pickLocation(
        context, "AIzaSyDAVrOzCfJOoak50Fke6jDdW945_s6rv4U");

    if (result.address != null) {
      setState(() {
        stringUserAddress = result.address;
      });
    }
    userAddressLatLng =
        new GeoPoint(result.latLng.latitude, result.latLng.longitude);
  }

  _icGPS() {
    return Icon(
      Icons.location_on,
      color: Colors.indigoAccent,
      size: 30.0,
      semanticLabel: 'Set Location',
    );
  }

  _toast(String texto, BuildContext context) {
    Toast.show("$texto", context,
        duration: 5,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.8));
  }

  _cpfEmUso(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          color: Colors.white.withOpacity(0.1),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: GestureDetector(
                onTap: () => null,
                child: Container(
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "O CPF informado já está em uso",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'RobotoMono',
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: _textConfirmacao(
                                      "O CPF ${cpfController.text} já está sendo utilizado por outro usuário.",
                                      center: true),
                                ),
                                Divider(
                                  thickness: 3,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: _textConfirmacao(
                                      "Se você esqueceu sua senha você pode alterá-la atravéz do link a seguir:"),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    auth.sendPasswordResetEmail(
                                        email: emailController.text);
                                    _toast("Email enviado", context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: 8, left: 8, bottom: 8),
                                    child: Row(
                                      children: <Widget>[
                                        _textConfirmacao("Recuperar senha",
                                            titulo: true),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 3,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 8, right: 8, left: 8, bottom: 8),
                                  child: _textConfirmacao(
                                      "Se você ainda não possuí conta ou quer alterar o email vinculado a seu CPF"
                                      " entre em contato com nossa equipe através do email:"),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 32),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Center(
                                          child: _textConfirmacao(
                                              "aplicativoshareon@gmail.com",
                                              titulo: true),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.indigoAccent,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 70,
                                    child: RaisedButton(
                                      color: Colors.indigoAccent,
                                      onPressed: () {
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text(
                                        "Ajustar CPF informado",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
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
          fontFamily: 'RobotoMono',
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
          fontFamily: 'RobotoMono',
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
          fontFamily: 'RobotoMono',
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: 16,
          decoration: TextDecoration.none,
        ),
      );
    }
  }

  _alertExit(BuildContext context) {
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
                    height: 160,
                    width: 300,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "Voltar",
                              style: TextStyle(
                                fontFamily: 'RobotoMono',
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: _textConfirmacao(
                                "Deseja mesmo voltar? Os dados preenchidos serão perdidos"),
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
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return Login();
                                          }));
                                        },
                                        child: Text(
                                          "Voltar",
                                          style: TextStyle(
                                            fontFamily: 'RobotoMono',
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

  _alertAuth(BuildContext context) {
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
                    height: 260,
                    width: 300,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "Autenticação",
                              style: TextStyle(
                                fontFamily: 'RobotoMono',
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 3,
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: _textConfirmacao(
                                "Um email de autenticação será enviado ao email informado. \n\nPor favor siga os passos "
                                "descritos nele para poder utilizar todas as funcionalidades do app",
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
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Home()));
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                            fontFamily: 'RobotoMono',
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

  Future _btLoader() async {
    setState(() {
      btloading = true;
    });
    await Future.delayed(Duration(seconds: 10));
    setState(() {
      btloading = false;
    });
  }
}
