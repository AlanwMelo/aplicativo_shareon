import 'dart:convert';
import 'dart:io';

import 'package:aplicativo_shareon/telas/home.dart';
import 'package:aplicativo_shareon/utils/image_source_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
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
  final storageRef = FirebaseStorage.instance;
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarEailController = TextEditingController();
  final confirmacaoSenhaController = TextEditingController();
  final validaSenhaController = TextEditingController();
  final telefoneController = new MaskedTextController(mask: '(00) 00000-0000');
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
  String actualPhone = "";
  GeoPoint userAddressLatLng;
  bool loading = false;
  bool canPop = true;
  String actualPass;

  bool alterName = false;
  bool alterMail = false;
  bool alterPass = false;
  bool alterIMG = false;
  bool alterAddress = false;
  bool alterPhone = false;

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
    return WillPopScope(
      onWillPop: () async {
        if (canPop == true) {
          return _alertExit(context);
        } else {
          _toast("Aguarde os dados serem carregados", context);
          return false;
        }
      },
      child: loading == false
          ? editaPerfil()
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  editaPerfil() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Editar perfil'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            _alertExit(context);
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
                          height: 40,
                          color: Colors.indigoAccent,
                          child: Center(
                            child: Text("Remover imagem",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 16, left: 8, right: 8),
                      child: TextFormField(
                        textAlign: TextAlign.justify,
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
                      margin: EdgeInsets.only(top: 16, left: 8, right: 8),
                      child: TextFormField(
                        textAlign: TextAlign.justify,
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
                      margin: EdgeInsets.only(top: 16, left: 8, right: 8),
                      child: TextFormField(
                        textAlign: TextAlign.justify,
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
                      margin: EdgeInsets.only(top: 16, left: 8, right: 8),
                      child: TextFormField(
                        obscureText: true,
                        controller: senhaController,
                        textAlign: TextAlign.justify,
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
                      margin: EdgeInsets.only(top: 16, left: 8, right: 8),
                      child: TextFormField(
                        textAlign: TextAlign.justify,
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
                    margin: EdgeInsets.only(top: 16, left: 8, right: 8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: telefoneController,
                      decoration: InputDecoration(hintText: actualPhone),
                      validator: (text) {
                        if (telefoneController.text.isNotEmpty) {
                          alterPhone = true;
                          if (text.length != 15) {
                            return "O telefone informado não é válido";
                          }
                          if (text.isEmpty) {
                            return "Campo telefone obrigatório";
                          } else {
                            return null;
                          }
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24, left: 8, right: 8),
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
                    margin: EdgeInsets.only(top: 12, left: 8, right: 8),
                    child: GestureDetector(
                      onTap: () {
                        _selecionaLocalizacao(context);
                      },
                      child: Row(
                        children: <Widget>[
                          _icGPS(),
                          Expanded(
                            child: Container(
                              child: _text(userAddress),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 25.0, left: 8, right: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                            "Os dados só serão alterados após clicar no botão"),
                        Container(
                          padding: EdgeInsets.all(8),
                          width: 400.0,
                          height: 60.0,
                          child: RaisedButton(
                            color: Colors.indigoAccent,
                            child: new Text(
                              'Atualizar dados',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (fields.currentState.validate()) {
                                if (alterIMG == false &&
                                    alterPass == false &&
                                    alterName == false &&
                                    alterMail == false &&
                                    alterAddress == false &&
                                    alterPhone == false) {
                                  _toast("Nenhum dado foi alterado", context);
                                } else {
                                  bool emailInUse = false;

                                  await databaseReference
                                      .collection("users")
                                      .where("email")
                                      .getDocuments()
                                      .then((QuerySnapshot snapshot) {
                                    snapshot.documents.forEach((f) {
                                      Map mappedEmail = f.data;
                                      if (mappedEmail["email"] ==
                                          mailController.text) {
                                        emailInUse = true;
                                      }
                                    });
                                  });
                                  if (emailInUse == true) {
                                    _toast("Este email já está sendo utilizado",
                                        context);
                                  } else {
                                    _validaAlteracoes();
                                  }
                                }
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
    );
  }

  void _setUserName(String name) {
    setState(() {
      userName = name;
    });
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
        padding: EdgeInsets.all(8),
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
                  ? Image.file(
                      newIMG,
                      fit: BoxFit.cover,
                    )
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
          actualPhone = userData["tel_contato"];
          userMedia = userData["media"];
          userAddress = userData["userAddress"];
          oldUserAddress = userData["userAddress"];
          var base64Str = base64.decode(userData["password"]);
          var passDecode = utf8.decode(base64Str);

          actualPass = passDecode;
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
      canPop = false;
      loading = true;
    });
    Navigator.of(context).pop();
    if (alterName == true) {
      sharedPreferencesController.setName(nameController.text);
      Map<String, dynamic> attName = {
        "nome": nameController.text,
      };

      await databaseReference
          .collection("users")
          .document(userID)
          .updateData(attName);
    }
    if (alterPass == true) {
      var passEncode = utf8.encode(senhaController.text);
      var base64Str = base64.encode(passEncode);

      Map<String, dynamic> attPass = {
        "password": base64Str,
      };

      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      var userAuth = EmailAuthProvider.getCredential(
          email: userMail, password: actualPass);
      await user.reauthenticateWithCredential(userAuth).then((ok) async {
        await user.updatePassword(senhaController.text).then((ok) async {
          await databaseReference
              .collection("users")
              .document(userID)
              .updateData(attPass);
        });
      });
    }
    if (alterMail == true) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      var userAuth = EmailAuthProvider.getCredential(
          email: userMail, password: actualPass);
      await user.reauthenticateWithCredential(userAuth).then((ok) async {
        await user.updateEmail(mailController.text).then((ok) async {
          user.sendEmailVerification();
          sharedPreferencesController.setEmail(mailController.text);
          sharedPreferencesController.setEmailAuth(false);

          Map<String, dynamic> attMail = {
            "email": mailController.text,
            "authenticated": false,
          };

          await databaseReference
              .collection("users")
              .document(userID)
              .updateData(attMail);
        });
      });
    }
    if (alterAddress == true) {
      sharedPreferencesController.setAddress(userAddress);
      Map<String, dynamic> attAddress = {
        "userAddress": userAddress,
        "userAddressLatLng": userAddressLatLng,
      };

      await databaseReference
          .collection("users")
          .document(userID)
          .updateData(attAddress);
    }
    if (alterPhone == true) {
      Map<String, dynamic> attPhone = {
        "tel_contato": telefoneController.text,
      };
      await databaseReference
          .collection("users")
          .document(userID)
          .updateData(attPhone);
    }
    if (alterIMG == true) {
      String newUserImg;
      if (newIMG != null) {
        final StorageUploadTask task =
            storageRef.ref().child("/usersIMG/$userID/IMG").putFile(newIMG);
        newUserImg = await (await task.onComplete).ref.getDownloadURL();

        await task.onComplete;
        sharedPreferencesController.setURLImg(newUserImg);

        Map<String, dynamic> attIMG = {
          "imgURL": newUserImg,
        };
        await databaseReference
            .collection("users")
            .document(userID)
            .updateData(attIMG);
      } else {
        sharedPreferencesController.setURLImg(userimgURL);
        Map<String, dynamic> attIMG = {
          "imgURL": userimgURL,
        };
        await databaseReference
            .collection("users")
            .document(userID)
            .updateData(attIMG);
      }
    }
    setState(() {
      canPop = true;
      loading = false;
    });
    Navigator.of(context).pop();
    _success();
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
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            height: 30,
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
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
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
                                                  right: 8, left: 8, bottom: 8),
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
                                    mainAxisSize: MainAxisSize.min,
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
                          alterPhone != true
                              ? Container()
                              : Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 8, left: 8, bottom: 8),
                                        child: Row(
                                          children: <Widget>[
                                            _textConfirmacao("Novo Telefone",
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
                                                telefoneController.text),
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
                                    mainAxisSize: MainAxisSize.min,
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
                          alterIMG != true
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: _textConfirmacao("Imagem alterada",
                                      titulo: true),
                                ),
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  color: Colors.indigoAccent,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          height: 60,
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
                                          height: 60,
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
                    width: 300,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "Voltar",
                              style: TextStyle(
                                fontFamily: 'RobotoMono',
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[800],
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: _textConfirmacao(
                                "Deseja mesmo voltar? Os dados preenchidos serão perdidos"),
                          ),
                          Container(
                            color: Colors.indigoAccent,
                            margin: EdgeInsets.only(
                              top: 8,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 60,
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
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 60,
                                    child: RaisedButton(
                                      color: Colors.indigoAccent,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancelar",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
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
          fontFamily: 'RobotoMono',
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
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
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
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                            onPressed: () async {
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
                                                } else {
                                                  _atualizaDados();
                                                }
                                              }
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

  void _success() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return Home();
    }));
  }
}
