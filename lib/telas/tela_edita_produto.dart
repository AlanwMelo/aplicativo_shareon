import 'dart:io';

import 'package:aplicativo_shareon/telas/home.dart';
import 'package:aplicativo_shareon/utils/image_source_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:toast/toast.dart';

class EditaProduto extends StatefulWidget {
  final String userID;
  final String productID;

  EditaProduto({@required this.userID, @required this.productID});

  @override
  _EditaProdutoState createState() => _EditaProdutoState();
}

class _EditaProdutoState extends State<EditaProduto> {
  final databaseReference = Firestore.instance;
  final storageRef = FirebaseStorage.instance;
  final camposEditar = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = MoneyMaskedTextController();
  String productAddress = "Informe onde encontrar seu produto";
  bool alteredAddress = false;
  GeoPoint productLocation;
  bool canPop = true;
  String actualName = "";
  String actualPrice = "";
  String actualDescription = "";
  String actualType = "";
  String imgDOCid = "";

  //Materiais Esportivos
  final campoEsportivoEditar = GlobalKey<FormState>();
  final marcaEsportivoController = TextEditingController();
  int _radioValueME = 0;
  bool tamanhoInformado = false;
  String tamanho;
  String actualTamanho = "";
  String actualMarcaEsportivo = "";

  //livros
  final camposLivrosEditar = GlobalKey<FormState>();
  final livroTituloController = TextEditingController();
  final livroEditoraController = TextEditingController();
  String actualTituloLivro = "";
  String actualEditoraLivro = "";

  //Materiais de Escritorio

  //Eletrodomesticos
  final campoEletroEditar = GlobalKey<FormState>();
  final marcaEletroController = TextEditingController();
  bool voltagemInformada = false;
  String voltagem;
  String actualVoltagem = "";
  String actualMarcaVoltagem = "";
  int _radioValueEletro = 0;

  File _imgMain;
  File _img2;
  File _img3;
  File _img4;
  File _img5;
  bool imgMainModif = false;
  bool img2Modif = false;
  bool img3Modif = false;
  bool img4Modif = false;
  bool img5Modif = false;
  String _imgMainUrl = "";
  String _img2Url = "";
  String _img3Url = "";
  String _img4Url = "";
  String _img5Url = "";
  int btPointer;
  bool livrosPressed = false;
  bool eletrodomesticosPressed = false;
  bool materiaisEsportivosPressed = false;
  bool materiaisEscritorioPressed = false;
  bool loading = false;

  //int btPointer = 1 Materiais Esportivos / 2 Livros / 3 Escritorio / 4 Eletrodomesticos

  @override
  void initState() {
    getProductData();
    super.initState();
  }

  @override
  build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (canPop == true) {
          return _alertExit(context);
        } else {
          _toast("Aguarde os dados serem carregados", context);
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Editar produto"),
          elevation: 0,
          backgroundColor: Colors.indigoAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: loading == false
            ? homeEditaProduto()
            : Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
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

  homeEditaProduto() {
    return Container(
      child: Column(
        children: <Widget>[
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
                      key: camposEditar,
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
                                    width: 280,
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
                              decoration: _buildDecoration(actualName),
                              controller: nameController,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              style: _fieldstyle,
                              maxLines: 6,
                              decoration: _buildDecoration(actualDescription),
                              controller: descriptionController,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              style: _fieldstyle,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: _buildDecoration(actualPrice),
                              controller: priceController,
                              validator: (text) {
                                if (text.isEmpty || text == "0,00") {
                                  return "O preço do produto é obrigatório";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 12),
                              child: _textBlack("Tipo de produto:")),
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
                                          color:
                                              materiaisEsportivosPressed == true
                                                  ? Colors.orange
                                                  : Colors.indigoAccent,
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
                                          onPressed: () {},
                                          color: livrosPressed == true
                                              ? Colors.orange
                                              : Colors.indigoAccent,
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
                                          color:
                                              materiaisEscritorioPressed == true
                                                  ? Colors.orange
                                                  : Colors.indigoAccent,
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
                                          color: eletrodomesticosPressed == true
                                              ? Colors.orange
                                              : Colors.indigoAccent,
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
                                "Editar",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                if (camposEditar.currentState.validate()) {
                                  if (_imgMain == null &&
                                      _img2 == null &&
                                      _img3 == null &&
                                      _img4 == null &&
                                      _img5 == null &&
                                      _imgMainUrl == "") {
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
                                  } else if (_imgMain == null) {
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
                                  } else if (btPointer == 1) {
                                    if (campoEsportivoEditar.currentState
                                        .validate()) {
                                      _editaMaterialEsportivo().then((value) =>
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return Home();
                                          })));
                                    }
                                  } else if (btPointer == 2) {
                                    if (camposLivrosEditar.currentState
                                        .validate()) {
                                      _editaLivro().then((value) =>
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return Home();
                                          })));
                                    }
                                  } else if (btPointer == 3) {
                                    _editaEscritorio().then((value) =>
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return Home();
                                        })));
                                  } else if (btPointer == 4) {
                                    if (campoEletroEditar.currentState
                                        .validate()) {
                                      _editaEletro().then((value) =>
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return Home();
                                          })));
                                    }
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

  _textBlack(String x) {
    return Text(x, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
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
                  child: _imgMainUrl != ""
                      ? Container(
                          child: new Image.network(
                            _imgMainUrl,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        )
                      : _imgMain != null
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
                  child: _img2Url != ""
                      ? Container(
                          child: new Image.network(
                            _img2Url,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        )
                      : _img2 != null
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
                  child: _img3Url != ""
                      ? Container(
                          child: new Image.network(
                            _img3Url,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        )
                      : _img3 != null
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
                    child: _img4Url != ""
                        ? Container(
                            child: new Image.network(
                              _img4Url,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          )
                        : _img4 != null
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
                    child: _img5Url != ""
                        ? Container(
                            child: new Image.network(
                              _img5Url,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          )
                        : _img5 != null
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
                    imgMainModif = true;
                    _imgMain = image;
                  } else if (caller == 2) {
                    img2Modif = true;
                    _img2 = image;
                  } else if (caller == 3) {
                    img3Modif = true;
                    _img3 = image;
                  } else if (caller == 4) {
                    img4Modif = true;
                    _img4 = image;
                  } else if (caller == 5) {
                    img5Modif = true;
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
      imgMainModif = true;
      _imgMainUrl = "";
      _imgMain = null;
    });
  }

  _imgRemover2() {
    setState(() {
      img2Modif = true;
      _img2Url = "";
      _img2 = null;
    });
  }

  _imgRemover3() {
    setState(() {
      img3Modif = true;
      _img3Url = "";
      _img3 = null;
    });
  }

  _imgRemover4() {
    setState(() {
      img4Modif = true;
      _img4Url = "";
      _img4 = null;
    });
  }

  _imgRemover5() {
    setState(() {
      img5Modif = true;
      _img5Url = "";
      _img5 = null;
    });
  }

  _infoTipo() {
    //int btPointer = 1 Materiais Esportivos / 2 Livros / 3 Escritorio / 4 Eletrodomesticos
    if (btPointer == 1) {
      void _handleRadioValueME(int value) {
        setState(() {
          _radioValueME = value;

          switch (_radioValueME) {
            case 1:
              tamanhoInformado = true;
              tamanho = "P";
              break;
            case 2:
              tamanhoInformado = true;
              tamanho = "M";
              break;
            case 3:
              tamanhoInformado = true;
              tamanho = "G";
              break;
          }
        });
      }

      return Container(
        margin: EdgeInsets.only(top: 8),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                _textBlack("Tamanho: "),
                Radio(
                  value: 1,
                  groupValue: _radioValueME,
                  onChanged: _handleRadioValueME,
                ),
                _textBlack("P"),
                Radio(
                  value: 2,
                  groupValue: _radioValueME,
                  onChanged: _handleRadioValueME,
                ),
                _textBlack("M"),
                Radio(
                  value: 3,
                  groupValue: _radioValueME,
                  onChanged: _handleRadioValueME,
                ),
                _textBlack("G"),
              ],
            ),
            Form(
              key: campoEsportivoEditar,
              child: Container(
                margin: EdgeInsets.only(top: 12),
                child: TextFormField(
                  style: _fieldstyle,
                  decoration: _buildDecoration("Marca"),
                  controller: marcaEsportivoController,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (btPointer == 2) {
      return Container(
        height: 160,
        child: Form(
          key: camposLivrosEditar,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 12),
                child: TextFormField(
                  style: _fieldstyle,
                  decoration: _buildDecoration(actualTituloLivro),
                  controller: livroTituloController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: TextFormField(
                  style: _fieldstyle,
                  decoration: _buildDecoration(actualEditoraLivro),
                  controller: livroEditoraController,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (btPointer == 3) {
      return Container();
    } else if (btPointer == 4) {
      void _handleRadioValueEletro(int value) {
        setState(() {
          _radioValueEletro = value;

          switch (_radioValueEletro) {
            case 1:
              voltagemInformada = true;
              voltagem = "110";
              break;
            case 2:
              voltagemInformada = true;
              voltagem = "220";
              break;
            case 3:
              voltagemInformada = true;
              voltagem = "bivolt";
              break;
          }
        });
      }

      return Container(
        margin: EdgeInsets.only(top: 8),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                _textBlack("Voltagem: "),
                Radio(
                  value: 1,
                  groupValue: _radioValueEletro,
                  onChanged: _handleRadioValueEletro,
                ),
                _textBlack("110"),
                Radio(
                  value: 2,
                  groupValue: _radioValueEletro,
                  onChanged: _handleRadioValueEletro,
                ),
                _textBlack("220"),
                Radio(
                  value: 3,
                  groupValue: _radioValueEletro,
                  onChanged: _handleRadioValueEletro,
                ),
                _textBlack("bivolt"),
              ],
            ),
            Form(
              key: campoEletroEditar,
              child: Container(
                margin: EdgeInsets.only(top: 12),
                child: TextFormField(
                  style: _fieldstyle,
                  decoration: _buildDecoration("Marca"),
                  controller: marcaEletroController,
                ),
              ),
            ),
          ],
        ),
      );
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

  Future _editaMaterialEsportivo() async {
    setState(() {
      canPop = false;
      loading = true;
    });

    String priceAux = priceController.text.replaceAll(",", ".");
    print(priceAux);

    String adStatus = "em provisionamento";
    Timestamp insertioDate = Timestamp.fromDate(DateTime.now());
    Map<String, dynamic> editaProduto = {
      "description": descriptionController.text,
      "insertionDate": insertioDate,
      "location": productLocation,
      "name": nameController.text,
      "ownerID": widget.userID,
      "price": double.parse(priceAux),
      "type": "material esportivo",
      "media": "-",
      "adStatus": adStatus,
      "marca": marcaEsportivoController.text,
      "tamanho": tamanho == null ? "" : tamanho,
    };

    final newProduct =
        await databaseReference.collection("products").add(editaProduto);
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
    } else {
      img5InDB = _img5Url;
    }
    if (aux4 != null) {
      final StorageUploadTask task =
          storageRef.ref().child("/productsIMG/$idWriter/img4").putFile(aux4);
      img4InDB = await (await task.onComplete).ref.getDownloadURL();
    } else {
      img4InDB = _img4Url;
    }
    if (aux3 != null) {
      final StorageUploadTask task =
          storageRef.ref().child("/productsIMG/$idWriter/img3").putFile(aux3);
      img3InDB = await (await task.onComplete).ref.getDownloadURL();
    } else {
      img3InDB = _img3Url;
    }
    if (aux2 != null) {
      final StorageUploadTask task =
          storageRef.ref().child("/productsIMG/$idWriter/img2").putFile(aux2);
      img2InDB = await (await task.onComplete).ref.getDownloadURL();
    } else {
      img2InDB = _img2Url;
    }
    if (aux != null) {
      final StorageUploadTask task =
          storageRef.ref().child("/productsIMG/$idWriter/mainIMG").putFile(aux);
      img1InDB = await (await task.onComplete).ref.getDownloadURL();
      await task.onComplete;
    } else {
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
    _toast("Produto editado", context);

    setState(() {
      canPop = true;
      loading = false;
    });
  }

  Future _editaLivro() async {
    setState(() {
      canPop = false;
      loading = true;
    });

    String priceAux = priceController.text.replaceAll(",", ".");
    print(priceAux);

    String adStatus = "em atualização";
    String description = descriptionController.text.isEmpty
        ? actualDescription
        : descriptionController.text;
    String name =
        nameController.text.isEmpty ? actualName : nameController.text;
    String titulo = livroTituloController.text.isEmpty
        ? actualTituloLivro
        : livroTituloController.text;
    String editora = livroEditoraController.text.isEmpty
        ? actualEditoraLivro
        : livroEditoraController.text;
    Map<String, dynamic> editaProduto = {
      "description": description,
      "location": productLocation,
      "name": name,
      "ownerID": widget.userID,
      "price": double.parse(priceAux),
      "type": "livro",
      "adStatus": adStatus,
      "titulo": titulo,
      "editora": editora,
    };

    await databaseReference
        .collection("products")
        .document(widget.productID)
        .updateData(editaProduto);

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

    if (imgMainModif == true) {}
    if (aux5 != null) {
      final StorageUploadTask task = storageRef
          .ref()
          .child("/productsIMG/${widget.productID}/img5")
          .putFile(aux5);
      img5InDB = await (await task.onComplete).ref.getDownloadURL();
    } else {
      img5InDB = _img5Url;
    }
    if (aux4 != null) {
      final StorageUploadTask task = storageRef
          .ref()
          .child("/productsIMG/${widget.productID}/img4")
          .putFile(aux4);
      img4InDB = await (await task.onComplete).ref.getDownloadURL();
    } else {
      img4InDB = _img4Url;
    }
    if (aux3 != null) {
      final StorageUploadTask task = storageRef
          .ref()
          .child("/productsIMG/${widget.productID}/img3")
          .putFile(aux3);
      img3InDB = await (await task.onComplete).ref.getDownloadURL();
    } else {
      img3InDB = _img3Url;
    }
    if (aux2 != null) {
      final StorageUploadTask task = storageRef
          .ref()
          .child("/productsIMG/${widget.productID}/img2")
          .putFile(aux2);
      img2InDB = await (await task.onComplete).ref.getDownloadURL();
    } else {
      img2InDB = _img2Url;
    }
    if (aux != null) {
      final StorageUploadTask task = storageRef
          .ref()
          .child("/productsIMG/${widget.productID}/mainIMG")
          .putFile(aux);
      img1InDB = await (await task.onComplete).ref.getDownloadURL();
    } else {
      img1InDB = _imgMainUrl;

      Map<String, dynamic> imgListDB = {
        "productMainIMG": img1InDB == null ? "" : img1InDB,
        "productIMG2": img2InDB == null ? "" : img2InDB,
        "productIMG3": img3InDB == null ? "" : img3InDB,
        "productIMG4": img4InDB == null ? "" : img4InDB,
        "productIMG5": img5InDB == null ? "" : img5InDB,
      };

      await databaseReference
          .collection("productIMGs")
          .document(imgDOCid)
          .updateData(imgListDB);

      Map<String, dynamic> setStatus = {
        "adStatus": "ativo",
      };
      await databaseReference
          .collection("products")
          .document(widget.productID)
          .updateData(setStatus);
    }
    _toast("Produto editado", context);

    setState(() {
      loading = false;
      canPop = true;
    });
  }

  Future _editaEscritorio() async {
    setState(() {
      loading = true;
      canPop = false;
    });

    String priceAux = priceController.text.replaceAll(",", ".");

    String adStatus = "em provisionamento";
    Timestamp insertioDate = Timestamp.fromDate(DateTime.now());
    Map<String, dynamic> editaProduto = {
      "description": descriptionController.text,
      "insertionDate": insertioDate,
      "location": productLocation,
      "name": nameController.text,
      "ownerID": widget.userID,
      "price": double.parse(priceAux),
      "type": "material de escritorio",
      "media": "-",
      "adStatus": adStatus,
    };

    final newProduct =
        await databaseReference.collection("products").add(editaProduto);
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
    _toast("Produto editado", context);

    setState(() {
      canPop = true;
      loading = false;
    });
  }

  Future _editaEletro() async {
    setState(() {
      loading = true;
      canPop = false;
    });

    String priceAux = priceController.text.replaceAll(",", ".");
    print(priceAux);

    String adStatus = "em provisionamento";
    Timestamp insertioDate = Timestamp.fromDate(DateTime.now());
    Map<String, dynamic> editaProduto = {
      "description": descriptionController.text,
      "insertionDate": insertioDate,
      "location": productLocation,
      "name": nameController.text,
      "ownerID": widget.userID,
      "price": double.parse(priceAux),
      "type": "eletrodomestico",
      "media": "-",
      "adStatus": adStatus,
      "marca": marcaEletroController.text,
      "voltagem": voltagem,
    };

    final newProduct =
        await databaseReference.collection("products").add(editaProduto);
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
    _toast("Produto editado", context);

    setState(() {
      canPop = true;
      loading = false;
    });
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
        alteredAddress = true;
        productAddress = result.address;
      });
    }
    productLocation =
        new GeoPoint(result.latLng.latitude, result.latLng.longitude);
  }

  errorHandler(var value) {
    print(value);
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

  getProductData() async {
    await databaseReference
        .collection("products")
        .where("ID", isEqualTo: widget.productID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        productAddress = productData["productAddress"];
        productLocation = productData["location"];
        actualDescription = productData["description"];
        actualName = productData["name"];
        actualPrice = productData["price"].toString();
        actualType = productData["type"];
        if (actualType == "material esportivo") {
          btPointer = 1;
        } else if (actualType == "livro") {
          btPointer = 2;
          livrosPressed = true;
          actualEditoraLivro = productData["editora"];
          actualTituloLivro = productData["titulo"];
        } else if (actualType == "material de escritorio") {
          btPointer = 3;
        } else if (actualType == "eletrodomestico") {
          btPointer = 4;
        }
      });
    });
    await databaseReference
        .collection("productIMGs")
        .where("productID", isEqualTo: widget.productID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productIMG = f.data;

        _imgMainUrl = productIMG["productMainIMG"];
        _img2Url = productIMG["productIMG2"];
        _img3Url = productIMG["productIMG3"];
        _img4Url = productIMG["productIMG4"];
        _img5Url = productIMG["productIMG5"];
        imgDOCid = productIMG["docID"];
      });
    });
  }
}
