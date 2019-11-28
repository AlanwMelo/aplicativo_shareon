import 'dart:io';

import 'package:aplicativo_shareon/utils/image_source_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:toast/toast.dart';

import '../main.dart';

class EditarPerfil extends StatefulWidget {
  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  final databaseReference = Firestore.instance;
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarEailController = TextEditingController();
  final confirmacaoSenhaController = TextEditingController();
  final validaSenhaController = TextEditingController();
  final fields = GlobalKey<FormState>();
  final fieldPass = GlobalKey<FormState>();

  String userName = "?";
  String userMail = "?";
  String userimgURL;
  File newIMG;
  String userAddress = "";
  String oldUserAddress = "";
  String userMedia = "-";
  String userID = "";
  GeoPoint userAddressLatLng;
  bool loading = false;
  String actualPass;

  bool alterName = false;
  bool alterMail = false;
  bool alterPass = false;
  bool alterIMG = false;
  bool alterAddress = false;

  @override
  void initState() {
    sharedPreferencesController.getName().then(_setUserName);
    sharedPreferencesController.getEmail().then(_setUserMail);
    sharedPreferencesController.getURLImg().then(_setURLImg);
    sharedPreferencesController.getAddress().then(_setAddress);
    sharedPreferencesController.getID().then(_setId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading == false
        ? editaPerfil()
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget editaPerfil() {
    return WillPopScope(
      onWillPop: () {
        return _alertExit(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Perfil'),
          elevation: 0,
          backgroundColor: Colors.indigoAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SizedBox.expand(
          child: Container(
            child: Container(
              child: Form(
                key: fields,
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: _img(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _toast("Segure para remover sua imagem atual", context);
                      },
                      onLongPress: () {
                        alterIMG = true;
                        setState(() {
                          userimgURL =
                              "https://firebasestorage.googleapis.com/v0/b/shareon.appspot.com/o/DefaultIMG%2FDefaultIMG.png?alt=media&token=9fbc8d45-36a1-45cf-a53b-0c0b7c7588a0";
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Center(
                          child: Container(
                            width: 150,
                            height: 30,
                            color: Colors.indigoAccent,
                            child: Center(
                              child: Text("Remover imagem",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 16),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: userName,
                          ),
                          controller: nameController,
                          validator: (text) {
                            if (text.isNotEmpty) {
                              alterName = true;
                              return null;
                            } else {
                              alterName = false;
                              return null;
                            }
                          },
                        )),
                    Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 16),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: userMail,
                          ),
                          controller: mailController,
                          validator: (text) {
                            if (text.isNotEmpty) {
                              alterMail = true;
                              if (!text.contains("@")) {
                                return "Digite um email válido";
                              } else {
                                return null;
                              }
                            } else {
                              alterMail = false;
                              return null;
                            }
                          },
                        )),
                    Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 16),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Confirmar email",
                          ),
                          controller: confirmarEailController,
                          validator: (text) {
                            if (mailController.text.isNotEmpty) {
                              if (mailController.text != text) {
                                return "A confirmação do email está diferente do email informado";
                              } else {
                                return null;
                              }
                            } else {
                              return null;
                            }
                          },
                        )),
                    Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 16),
                        child: TextFormField(
                          obscureText: true,
                          controller: senhaController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Nova senha",
                          ),
                          validator: (text) {
                            if (text.isNotEmpty) {
                              alterPass = true;
                              if (text.length < 8) {
                                return "Senha curta, mínimo 8 digitos";
                              } else {
                                return null;
                              }
                            } else {
                              alterPass = false;
                              return null;
                            }
                          },
                        )),
                    Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 16),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Confirmar Senha",
                          ),
                          controller: confirmacaoSenhaController,
                          validator: (text) {
                            if (senhaController.text.isNotEmpty) {
                              if (text.isEmpty) {
                                return "Campo confirmar email obrigatório";
                              } else if (senhaController.text != text) {
                                return "A confirmação do email está diferente do email informado";
                              } else {
                                return null;
                              }
                            } else {
                              return null;
                            }
                          },
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 22),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Center(
                            child: _text("Endereço: ", semititle: true),
                          ))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      child: GestureDetector(
                        onTap: () {
                          _selecionaLocalizacao(context);
                        },
                        child: Row(
                          children: <Widget>[
                            _icGPS(),
                            Container(
                              width: 280,
                              child: _text(userAddress),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 25.0),
                      child: Column(
                        children: <Widget>[
                          Text("Somente dados alterados serão salvos"),
                          Container(
                            width: 400.0,
                            height: 50.0,
                            child: RaisedButton(
                              color: Colors.indigoAccent,
                              child: new Text(
                                'Atualizar dados',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                if (fields.currentState.validate()) {
                                  _validaAlteracoes();
                                }
                              },
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
    );
  }

  void _setUserName(String name) {
    setState(() {
      userName = name;
    });
  }

  Future updatePassword(String password) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.updatePassword(password);
  }

  void _setUserMail(String email) {
    setState(() {
      userMail = email;
    });
  }

  void _setURLImg(String urlImg) {
    setState(() {
      userimgURL = urlImg;
    });
  }

  _img() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => ImageSourceSheet(onImageSelected: (image) {
                  setState(() {
                    alterIMG = true;
                    newIMG = image;
                    Navigator.of(context).pop();
                  });
                }));
      },
      onLongPress: () {
        if (newIMG != null) {
          setState(() {
            newIMG = null;
          });
        }
      },
      child: Container(
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
              color: Colors.indigoAccent,
              child: newIMG != null
                  ? Image.file(newIMG)
                  : userimgURL == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Image.network(
                          userimgURL,
                          fit: BoxFit.cover,
                        ),
            ),
          ),
        ),
      ),
    );
  }

  _text(String texto,
      {bool titulo = false, bool resumo = false, bool semititle = false}) {
    if (titulo == true) {
      return Text(
        "$texto",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 30,
        ),
      );
    } else if (resumo == true) {
      return Text(
        "$texto",
        style: TextStyle(fontSize: 16, color: Colors.black),
      );
    } else if (semititle == true) {
      return Text(
        texto,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 26,
        ),
      );
    } else {
      return Text(
        "$texto",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 19,
        ),
      );
    }
  }

  _setAddress(String value) {
    setState(() {
      userAddress = value;
    });
  }

  _getUserData() async {
    await databaseReference
        .collection("users")
        .where("userID", isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map userData = f.data;
        setState(() {
          userMedia = userData["media"];
          userAddress = userData["userAddress"];
          oldUserAddress = userData["userAddress"];
          actualPass = userData["password"];
        });
      });
    });
  }

  _setId(String value) {
    setState(() {
      userID = value;
      _getUserData();
    });
  }

  _icGPS() {
    return Icon(
      Icons.location_on,
      color: Colors.indigoAccent,
      size: 40.0,
      semanticLabel: 'Set Location',
    );
  }

  Future<Null> _selecionaLocalizacao(BuildContext context) async {
    LocationResult result = await LocationPicker.pickLocation(
        context, "AIzaSyDAVrOzCfJOoak50Fke6jDdW945_s6rv4U");

    if (result.address != null) {
      setState(() {
        alterAddress = true;
        userAddress = result.address;
      });
    }
    userAddressLatLng =
        new GeoPoint(result.latLng.latitude, result.latLng.longitude);
  }

  _toast(String texto, BuildContext context) {
    Toast.show("$texto", context,
        duration: 3,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.8));
  }

  void _atualizaDados() async {
    setState(() {
      loading = true;
    });

    setState(() {
      loading = false;
    });
  }

  _validaAlteracoes() {
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
                  height: 350,
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "Confirmação",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          alterName != true
                              ? Container()
                              : Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 8, right: 8, bottom: 8),
                                              child: Row(
                                                children: <Widget>[
                                                  _textConfirmacao("Novo nome:",
                                                      titulo: true),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 8, left: 8),
                                              child: Row(
                                                children: <Widget>[
                                                  _textConfirmacao(
                                                      nameController.text),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          alterMail != true
                              ? Container()
                              : Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 8, left: 8, bottom: 8),
                                        child: Row(
                                          children: <Widget>[
                                            _textConfirmacao("Novo Email",
                                                titulo: true),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 8, left: 8, bottom: 8),
                                        child: Row(
                                          children: <Widget>[
                                            _textConfirmacao(
                                                mailController.text),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          alterAddress != true
                              ? Container()
                              : Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 8, left: 8, bottom: 8),
                                        child: Row(
                                          children: <Widget>[
                                            _textConfirmacao("Novo Endereço",
                                                titulo: true),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 8, left: 8, bottom: 8),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child:
                                                  _textConfirmacao(userAddress),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          alterPass != true
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: _textConfirmacao("Senha alterada",
                                      titulo: true),
                                ),
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
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
                                                  _validaSenha();
                                                });
                                              },
                                              child: Text(
                                                "Confirmar alterações",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
                                                "Cancelar",
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
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
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

  _validaSenha() {
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
                  height: 220,
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "Validação",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 8, right: 8, bottom: 8),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Center(
                                                  child: _textConfirmacao(
                                                      "Informe sua senha atual",
                                                      titulo: true)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            child: Form(
                              key: fieldPass,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: validaSenhaController,
                                obscureText: true,
                                validator: (text) {
                                  if (text.isEmpty) {
                                    return "A senha precisa ser preenchida";
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(hintText: "Senha"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
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
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                if (fieldPass.currentState
                                                    .validate()) {
                                                  if (validaSenhaController
                                                          .text !=
                                                      actualPass) {
                                                    _toast("Senha incorreta",
                                                        context);
                                                  } else {}

                                                  // Navigator.pop(context);
                                                }
                                                setState(() {});
                                              },
                                              child: Text(
                                                "OK",
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
