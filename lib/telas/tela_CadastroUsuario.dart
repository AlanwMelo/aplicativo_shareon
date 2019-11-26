import 'package:aplicativo_shareon/models/usuario_model.dart';
import 'package:aplicativo_shareon/telas/tela_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';
import 'package:valida_cpf/valida_cpf.dart';

// import 'home.dart';

class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  final cpfController = new MaskedTextController(mask: '000.000.000-00');
  final enderecoController = TextEditingController();
  final campos = GlobalKey<FormState>();
  final verificacao = GlobalKey<ScaffoldState>();
  final databaseReference = Firestore.instance;
  String stringUserAddress = "Informe seu endereço";
  GeoPoint userAddress;
  String cpf;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return Login();
        }));
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
                        } else if (text.length < 6) {
                          return "Senha curta, mínimo 6 digitos";
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
                          return "A confirmeção da senha está diferente da senha informada";
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
                    GestureDetector(
                      onTap: () {
                        _selecionaLocalizacao(context);
                      },
                      child: Row(
                        children: <Widget>[
                          _icGPS(),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            width: 300,
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
                      child: RaisedButton(
                        child: Text(
                          "Criar Conta",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          if (campos.currentState.validate()) {
                            if (stringUserAddress == "Informe seu endereço") {
                              _toast("Informe seu endereço", context);
                            } else {
                              bool cpfInUse = false;
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

                              if (cpfInUse == true) {
                                print("CPF em uso");
                              } else {
                                Map<String, dynamic> userData = {
                                  "nome": nomeController.text,
                                  "email": emailController.text,
                                  "cpf": cpf,
                                  "debit": 0,
                                  "userAddress": userAddress,
                                  "state": "criado",
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
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
    });
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
    userAddress = new GeoPoint(result.latLng.latitude, result.latLng.longitude);
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
        duration: 3,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.8));
  }
}
