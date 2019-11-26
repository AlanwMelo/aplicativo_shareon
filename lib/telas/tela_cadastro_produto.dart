import 'dart:io';

import 'package:aplicativo_shareon/utils/image_source_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:toast/toast.dart';

class CadastroProduto extends StatefulWidget {
  final String userID;

  CadastroProduto(this.userID);

  @override
  _CadastroProdutoState createState() => _CadastroProdutoState();
}

class _CadastroProdutoState extends State<CadastroProduto> {
  final databaseReference = Firestore.instance;
  final storageRef = FirebaseStorage.instance;
  final campos = GlobalKey<FormState>();
  final camposLivros = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = MoneyMaskedTextController();
  String productAddress = "Informe onde encontrar seu produto";
  GeoPoint productLocation;

  //livros
  final titleController = TextEditingController();
  final editoraController = TextEditingController();
  File _imgMain;
  File _img2;
  File _img3;
  File _img4;
  File _img5;
  int btPointer;

  //int btPointer = 1 Materiais Esportivos / 2 Livros / 3 Escritorio / 4 Eletrodomesticos

  @override
  void initState() {
    print(_imgMain);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeCadastroProduto(),
    );
  }

  final _fieldstyle = TextStyle(color: Colors.black, fontSize: 16);

  InputDecoration _buildDecoration(String label) {
    return InputDecoration(
      hintText: label,
      alignLabelWithHint: true,
      labelStyle: TextStyle(color: Colors.black),
    );
  }

  homeCadastroProduto() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            height: 50,
            color: Colors.indigoAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _text("Cadastrar produto"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 100,
                  ),
                  child: Container(
                    child: Form(
                      key: campos,
                      child: ListView(
                        padding: EdgeInsets.all(16),
                        children: <Widget>[
                          Text(
                            "Imagens",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          _imgSelectorContoller(),
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
                                    margin: EdgeInsets.only(left: 8),
                                    width: 300,
                                    child: Text(
                                      productAddress,
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
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              style: _fieldstyle,
                              decoration: _buildDecoration("Nome do produto"),
                              controller: nameController,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "O nome do produto é obrigatório";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              style: _fieldstyle,
                              maxLines: 6,
                              decoration: _buildDecoration("Descrição"),
                              controller: descriptionController,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Informe uma descrição do seu produto";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              style: _fieldstyle,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: _buildDecoration("Preço"),
                              controller: priceController,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "O preço do produto é obrigatório";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Text("Tipo de produto: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        width: 100,
                                        height: 50,
                                        child: FlatButton(
                                          onPressed: () {},
                                          color: Colors.indigoAccent,
                                          child: Text("Materiais Esportivos",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 50,
                                        child: FlatButton(
                                          onPressed: () {
                                            if (btPointer != 2) {
                                              setState(() {
                                                btPointer = 2;
                                              });
                                            }
                                          },
                                          color: Colors.indigoAccent,
                                          child: Text("Livros",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 50,
                                        child: FlatButton(
                                          onPressed: () {},
                                          color: Colors.indigoAccent,
                                          child: Text("Materiais de Escritório",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        width: 300,
                                        height: 50,
                                        child: FlatButton(
                                          onPressed: () {},
                                          color: Colors.indigoAccent,
                                          child: Text("Eletrodomésticos",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _infoTipo(),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            height: 40,
                            child: RaisedButton(
                              child: Text(
                                "Cadastrar",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                if (_imgMain == null &&
                                    _img2 == null &&
                                    _img3 == null &&
                                    _img4 == null &&
                                    _img5 == null) {
                                  _toast(
                                      "O produto deve possuir pelo menos uma imagem",
                                      context);
                                } else if (btPointer == null) {
                                  _toast(
                                      "As informações do tipo do produto precisam ser preenchidas",
                                      context);
                                } else if (productLocation == null) {
                                  _toast(
                                      "A localização do produto deve ser informada",
                                      context);
                                } else if (btPointer == 2) {
                                  if (_imgMain == null) {
                                    if (_img2 != null) {
                                      _imgMain = _img2;
                                      _img2 = null;
                                    } else if (_img3 != null) {
                                      _imgMain = _img3;
                                      _img3 = null;
                                    } else if (_img4 != null) {
                                      _imgMain = _img4;
                                      _img4 = null;
                                    } else if (_img5 != null) {
                                      _imgMain = _img5;
                                      _img5 = null;
                                    }
                                  }
                                  if (camposLivros.currentState.validate()) {
                                    _cadastraLivro();
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _text(String x) {
    return Text(
      x,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _imgSelectorContoller() {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                  onLongPress: _imgRemoverMain,
                  child: _imgMain != null
                      ? Container(
                          child: new Image.file(
                            _imgMain,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        )
                      : _imgSelector(1)),
              GestureDetector(
                  onLongPress: _imgRemover2,
                  child: _img2 != null
                      ? Container(
                          child: new Image.file(
                            _img2,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        )
                      : _imgSelector(2)),
              GestureDetector(
                  onLongPress: _imgRemover3,
                  child: _img3 != null
                      ? Container(
                          child: new Image.file(
                            _img3,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        )
                      : _imgSelector(3)),
            ],
          ),
          Container(
            width: 240,
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                    onLongPress: _imgRemover4,
                    child: _img4 != null
                        ? Container(
                            child: new Image.file(
                              _img4,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          )
                        : _imgSelector(4)),
                GestureDetector(
                    onLongPress: _imgRemover5,
                    child: _img5 != null
                        ? Container(
                            child: new Image.file(
                              _img5,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          )
                        : _imgSelector(5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _imgADD(int caller) {
    return Container(
      child: GestureDetector(
        child: Container(
          height: 100,
          width: 100,
          child: Icon(
            Icons.camera_enhance,
            color: Colors.black,
          ),
          color: Colors.indigoAccent.withAlpha(80),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => ImageSourceSheet(
              onImageSelected: (image) {
                setState(() {
                  if (caller == 1) {
                    _imgMain = image;
                  } else if (caller == 2) {
                    _img2 = image;
                  } else if (caller == 3) {
                    _img3 = image;
                  } else if (caller == 4) {
                    _img4 = image;
                  } else if (caller == 5) {
                    _img5 = image;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }

  _imgSelector(int caller) {
    if (caller == 1) {
      return Container(
        child: _imgADD(1),
      );
    } else if (caller == 2) {
      return Container(
        child: _imgADD(2),
      );
    } else if (caller == 3) {
      return Container(
        child: _imgADD(3),
      );
    } else if (caller == 4) {
      return Container(
        child: _imgADD(4),
      );
    } else if (caller == 5) {
      return Container(
        child: _imgADD(5),
      );
    }
  }

  _imgRemoverMain() {
    setState(() {
      _imgMain = null;
    });
  }

  _imgRemover2() {
    setState(() {
      _img2 = null;
    });
  }

  _imgRemover3() {
    setState(() {
      _img3 = null;
    });
  }

  _imgRemover4() {
    setState(() {
      _img4 = null;
    });
  }

  _imgRemover5() {
    setState(() {
      _img5 = null;
    });
  }

  _infoTipo() {
    //int btPointer = 1 Materiais Esportivos / 2 Livros / 3 Escritorio / 4 Eletrodomesticos
    if (btPointer == 1) {
    } else if (btPointer == 2) {
      return Container(
        height: 130,
        child: Form(
          key: camposLivros,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 12),
                child: TextFormField(
                  style: _fieldstyle,
                  decoration: _buildDecoration("Título"),
                  validator: (text) {
                    if (text.isEmpty) {
                      return "O título deve ser informado";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: TextFormField(
                  style: _fieldstyle,
                  decoration: _buildDecoration("Editora"),
                  validator: (text) {
                    if (text.isEmpty) {
                      return "A Editora deve ser informada";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (btPointer == 3) {
    } else if (btPointer == 4) {
    } else {
      return Container();
    }
  }

  _toast(String texto, BuildContext context) {
    Toast.show("$texto", context,
        duration: 3,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.8));
  }

  _cadastraLivro() async {
    String adStatus = "em provisionamento";
    Timestamp insertioDate = Timestamp.fromDate(DateTime.now());
    Map<String, dynamic> cadastraProduto = {
      "description": descriptionController.text,
      "insertionDate": insertioDate,
      "location": productLocation,
      "name": nameController.text,
      "ownerID": widget.userID,
      "price": priceController.text,
      "type": "livro",
      "media": "-",
      "adStatus": adStatus,
    };

    final newProduct =
        await databaseReference.collection("products").add(cadastraProduto);
    String idWriter = newProduct.documentID;

    Map<String, dynamic> setID = {
      "ID": idWriter,
    };

    await databaseReference
        .collection("products")
        .document(idWriter)
        .updateData(setID);

    File aux = _imgMain;
    File aux2 = _img2;
    File aux3 = _img3;
    File aux4 = _img4;
    File aux5 = _img5;
    String img1InDB;
    String img2InDB;
    String img3InDB;
    String img4InDB;
    String img5InDB;

    if (aux5 != null) {
      final StorageUploadTask task =
          storageRef.ref().child("/productsIMG/$idWriter/img5").putFile(aux5);
      img5InDB = await (await task.onComplete).ref.getDownloadURL();
    }
    if (aux4 != null) {
      final StorageUploadTask task =
          storageRef.ref().child("/productsIMG/$idWriter/img4").putFile(aux4);
      img4InDB = await (await task.onComplete).ref.getDownloadURL();
    }
    if (aux3 != null) {
      final StorageUploadTask task =
          storageRef.ref().child("/productsIMG/$idWriter/img3").putFile(aux3);
      img3InDB = await (await task.onComplete).ref.getDownloadURL();
    }
    if (aux2 != null) {
      final StorageUploadTask task =
          storageRef.ref().child("/productsIMG/$idWriter/img2").putFile(aux2);
      img2InDB = await (await task.onComplete).ref.getDownloadURL();
    }
    if (aux != null) {
      final StorageUploadTask task =
          storageRef.ref().child("/productsIMG/$idWriter/mainIMG").putFile(aux);
      img1InDB = await (await task.onComplete).ref.getDownloadURL();

      await task.onComplete;

      Map<String, dynamic> imgListDB = {
        "productID": idWriter,
        "productMainIMG": img1InDB == null ? "" : img1InDB,
        "productIMG2": img2InDB == null ? "" : img2InDB,
        "productIMG3": img3InDB == null ? "" : img3InDB,
        "productIMG4": img4InDB == null ? "" : img4InDB,
        "productIMG5": img5InDB == null ? "" : img5InDB,
      };

      await databaseReference.collection("productIMGs").add(imgListDB);

      Map<String, dynamic> setStatus = {
        "adStatus": "ativo",
      };
      await databaseReference
          .collection("products")
          .document(idWriter)
          .updateData(setStatus);

    }
  }

  _icGPS() {
    return Icon(
      Icons.location_on,
      color: Colors.indigoAccent,
      size: 30.0,
      semanticLabel: 'Set Location',
    );
  }

  Future<Null> _selecionaLocalizacao(BuildContext context) async {
    LocationResult result = await LocationPicker.pickLocation(
        context, "AIzaSyDAVrOzCfJOoak50Fke6jDdW945_s6rv4U");

    if (result.address != null) {
      setState(() {
        productAddress = result.address;
      });
    }
    productLocation =
        new GeoPoint(result.latLng.latitude, result.latLng.longitude);
  }

  errorHandler(var value) {
    print(value);
  }
}
