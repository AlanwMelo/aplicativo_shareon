import 'package:aplicativo_shareon/telas/tela_creditos.dart';
import 'package:aplicativo_shareon/utils/seletor_calendario.dart';
import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../main.dart';

class TelaReservar extends StatefulWidget {
  final String productID;
  final productPrice;

  TelaReservar({@required this.productID, @required this.productPrice});

  @override
  _TelaReservarState createState() => _TelaReservarState();
}

class _TelaReservarState extends State<TelaReservar> {
  DateTime dataBase = DateTime.now();
  DateTime dataInicio = DateTime.now();
  DateTime dataFim = DateTime.now();
  TimeOfDay timeInicio = TimeOfDay.now();
  TimeOfDay timeFim = TimeOfDay.now();
  int duracao = 60;
  String strduracao;
  final databaseReference = Firestore.instance;
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  String userID = "";
  String productName = "";
  String productMedia = "";
  String productOwner = "";
  String productOwnerID = "";
  String productDescription = "";
  String productIMG = "";
  String productType = "";
  double userDebit;

  // Strings
  String _dataInicio = DateTime.now().day.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().year.toString();
  String _dataFim = DateTime.now().day.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().year.toString();
  String _horarioInicio = DateTime.now().hour.toString().padLeft(2, "0") +
      ":" +
      DateTime.now().minute.toString().padLeft(2, "0");
  String _horarioFim;

  // Strings

  double valordoDoProduto = 0;
  double valorEstimado = 0;
  String calcValorProdutoConversor = 0.toStringAsFixed(2);

  @override
  void initState() {
    super.initState();
    if (userID == "") {
      sharedPreferencesController.getID().then(_setID);
    }
    getTimeString(duracao);
    _horarioFim = _horarioFimPadrao();
  }

  @override
  Widget build(BuildContext context) {
    getProductIMG();
    return getProductData();
  }

  _homeReservar(BuildContext context) {
    return Scaffold(
      appBar: shareonAppbar(context),
      backgroundColor: Colors.indigoAccent,
      body: SingleChildScrollView(
        child: Container(
          height: 720,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _text(productName, titulo: true),
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
                child: _img(productIMG),
              ),
              _text(
                  "Para reservar um produto você precisa informar a data e a hora que deseja utiliza-lo para checarmos sua disponibilidade."),
              Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: _text("Retirada:"),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              _selecionarData(context, "inicio");
                            },
                            child: Text("$_dataInicio",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              _selecionarHorario(context, "inicio");
                            },
                            child: Text("$_horarioInicio",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: _text("Devolução:"),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              _selecionarData(context, "fim");
                            },
                            child: Text("$_dataFim",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              _selecionarHorario(context, "fim");
                            },
                            child: Text("$_horarioFim",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8, right: 8, left: 8),
                child: _text("Valor estimado:"),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8, right: 8, left: 8),
                child: _text("R\$ $calcValorProdutoConversor"),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 500,
                      margin:
                          EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                      child: RaisedButton(
                        onPressed: () {
                          if (dataFim.isBefore(dataInicio)) {
                            _toast(
                                "A data de devolução não pode ser menor que a data de retirada.",
                                context);
                          } else if (double.parse(calcValorProdutoConversor) >
                              userDebit) {
                            _semSaldo(context);
                          } else {
                            _alertConfirmacao(context);
                          }
                        },
                        child: Text(
                          "Reservar",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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

  _alertConfirmacao(BuildContext context) {
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
                          Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _textConfirmacao("Data de retirada:",
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
                                          "$_dataInicio $_horarioInicio"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _textConfirmacao("Data de devolução:",
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
                                          "$_dataFim $_horarioFim"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _textConfirmacao("Duração: ",
                                          titulo: true),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _textConfirmacao("$strduracao"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _textConfirmacao("Valor estimado: ",
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
                                          "R\$ $calcValorProdutoConversor"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
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
                                            _solicitaReserva();
                                          });
                                        },
                                        child: Text(
                                          "Confirmar Solicitação",
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

  _semSaldo(BuildContext context) {
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
                  height: 380,
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              "Saldo insuficiente",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _textConfirmacao("Saldo atual:",
                                          titulo: true),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _textConfirmacao("$userDebit"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _textConfirmacao(
                                          "Valor estimado do aluguel:",
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
                                          "$calcValorProdutoConversor"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _textConfirmacao("Duração: ",
                                          titulo: true),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _textConfirmacao("$strduracao"),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 3,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: _textConfirmacao(
                                      "Você deve comprar mais créditos ou ajustar as datas para continuar.",
                                      center: true),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
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
                                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Creditos()));
                                          });
                                        },
                                        child: Text(
                                          "Comprar mais créditos",
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
                                          "Ajustar",
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

  Future<Null> _selecionarHorario(
      BuildContext context, String inicioFim) async {
    final TimeOfDay horarioSelecionado = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (horarioSelecionado != null && inicioFim == "inicio") {
      dataInicio = DateTime(dataInicio.year, dataInicio.month, dataInicio.day,
          horarioSelecionado.hour, horarioSelecionado.minute);
      if (dataInicio.isBefore(dataBase)) {
        _toast("A data de inicio não pode ser menor que a atual.", context);
        setState(() {
          dataInicio = DateTime.now();
          calcValorProdutoConversor = valordoDoProduto.toStringAsFixed(2);
          _horarioConfirmado("inicio", TimeOfDay.now());
        });
      } else {
        setState(() {
          _verificaEstimado();
          _horarioConfirmado("inicio", horarioSelecionado);
        });
      }
    }
    if (horarioSelecionado != null && inicioFim == "fim") {
      dataFim = DateTime(dataFim.year, dataFim.month, dataFim.day,
          horarioSelecionado.hour, horarioSelecionado.minute);
      if (dataFim.isBefore(dataInicio)) {
        _toast("A data de devolução não pode ser menor que a data de retirada.",
            context);
        setState(() {
          dataFim = DateTime.now();
          _horarioConfirmado("fim", TimeOfDay.now());
          calcValorProdutoConversor = valordoDoProduto.toStringAsFixed(2);
        });
      } else {
        setState(() {
          _verificaEstimado();
          _horarioConfirmado("fim", horarioSelecionado);
        });
      }
    }
  }

  Future<Null> _selecionarData(BuildContext context, String inicioFim) async {
    final DateTime diaSelecionado = await showSeletorCalendario(
      context: context,
      initialDate: DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2022),
    );
    if (diaSelecionado != null && inicioFim == "inicio") {
      dataInicio = DateTime(diaSelecionado.year, diaSelecionado.month,
          diaSelecionado.day, dataInicio.hour, dataInicio.minute);
      if (dataInicio.isBefore(dataBase)) {
        _toast("A data de inicio não pode ser menor que a atual.", context);
        setState(() {
          dataInicio = DateTime.now();
          _horarioConfirmado("inicio", TimeOfDay.now());
          calcValorProdutoConversor = valordoDoProduto.toStringAsFixed(2);
          _dataInicio = dataInicio.day.toString() +
              "/" +
              dataInicio.month.toString() +
              "/" +
              dataInicio.year.toString();
        });
      } else {
        setState(() {
          _verificaEstimado();
          _dataInicio = diaSelecionado.day.toString() +
              "/" +
              diaSelecionado.month.toString() +
              "/" +
              diaSelecionado.year.toString();
        });
      }
    }

    if (diaSelecionado != null && inicioFim == "fim") {
      dataFim = DateTime(diaSelecionado.year, diaSelecionado.month,
          diaSelecionado.day, dataFim.hour, dataFim.minute);
      if (dataFim.isBefore(dataInicio)) {
        _toast("A data de devolução não pode ser menor que a data de retirada.",
            context);
        setState(() {
          dataFim = DateTime.now();
          dataFim = DateTime.now();
          _horarioConfirmado("fim", TimeOfDay.now());

          calcValorProdutoConversor = valordoDoProduto.toStringAsFixed(2);
          _dataFim = dataFim.day.toString() +
              "/" +
              dataFim.month.toString() +
              "/" +
              dataFim.year.toString();
        });
      } else {
        setState(() {
          _verificaEstimado();
          _dataFim = diaSelecionado.day.toString() +
              "/" +
              diaSelecionado.month.toString() +
              "/" +
              diaSelecionado.year.toString();
        });
      }
    }
  }

  getTimeString(int value) {
    double totalOfMins = value.toDouble();
    double dias = totalOfMins / 1440;
    double horas = (totalOfMins % 1440) / 60;
    double min = totalOfMins % 60;

    strduracao = "${_strgDia(dias.toInt(), horas.toInt(), min.toInt())}"
        "${_strgHora(horas.toInt(), min.toInt())}"
        "${_strgMin(min.toInt())}";
  }

  _verificaEstimado() {
    if (dataInicio.isAfter(dataFim)) {
      calcValorProdutoConversor = valordoDoProduto.toStringAsFixed(2);
    } else {
      _valorEstimado(valordoDoProduto, dataInicio, dataFim);
    }
  }

  _valorEstimado(double valordoProduto, DateTime dataInicio, DateTime dataFim) {
    DateTime retirada = dataInicio;
    DateTime devolucao = dataFim;
    duracao = (devolucao.difference(retirada).inMinutes);
    valordoProduto = valordoDoProduto / (60);
    double calcValorProduto = duracao.toDouble() * valordoProduto;
    getTimeString(duracao);
    calcValorProdutoConversor = calcValorProduto.toStringAsFixed(2);
    valorEstimado = calcValorProduto;
  }

  _horarioConfirmado(String inicioFim, TimeOfDay time) {
    if (time != null && inicioFim == "inicio") {
      setState(() {
        _horarioInicio = time.hour.toString().padLeft(2, "0") +
            ":" +
            time.minute.toString().padLeft(2, "0");
      });
    } else if (time != null && inicioFim == "fim") {
      setState(() {
        _horarioFim = time.hour.toString().padLeft(2, "0") +
            ":" +
            time.minute.toString().padLeft(2, "0");
      });
    }
  }

  _img(String img) {
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
            child: Image.network(
              img,
              fit: BoxFit.cover,
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
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20,
        ),
      );
    }
  }

  _horarioFimPadrao() {
    int x = DateTime.now().hour.toInt();

    if (0 < x && x < 23) {
      x = x + 1;
    } else if (x == 23) {
      x = 0;
    } else {
      x = 1;
    }
    String hora = x.toString().padLeft(2, "0") +
        ":" +
        DateTime.now().minute.toString().padLeft(2, "0");

    return hora;
  }

  _toast(String texto, BuildContext context) {
    Toast.show("$texto", context,
        duration: 3,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.8));
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

  getProductIMG() async {
    await databaseReference
        .collection("productIMGs")
        .where("productID", isEqualTo: (widget.productID))
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map getIMG = f.data;
        setState(() {
          productIMG = getIMG["productMainIMG"];
        });
      });
    });
  }

  getProductData() {
    return FutureBuilder(
        future: databaseReference
            .collection("products")
            .where("ID", isEqualTo: (widget.productID))
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            Map productData = f.data;
            valordoDoProduto = double.parse(productData["price"]);
            valorEstimado = double.parse(productData["price"]);
            productName = productData["name"];
            productDescription = productData["description"];
            productMedia = productData["media"];
            productOwnerID = productData["ownerID"];
            productType = productData["type"];

            if (calcValorProdutoConversor == "0.00") {
              setState(() {
                calcValorProdutoConversor = valordoDoProduto.toStringAsFixed(2);
              });
            }
          });
        }),
        builder: (context, snapshot) {
          return _homeReservar(context);
        });
  }

  _strgDia(int dia, int hora, int min) {
    if (dia > 0 && hora == 0) {
      if (dia == 0) {
        return "";
      } else if (dia == 1) {
        return "$dia Dia e ";
      } else if (dia > 1) {
        return "$dia Dias e ";
      }
    } else {
      if (dia == 0) {
        return "";
      } else if (dia == 1) {
        return "$dia Dia ";
      } else if (dia > 1) {
        return "$dia Dias ";
      }
    }
  }

  _strgHora(int hora, int min) {
    if (min > 0) {
      if (hora == 0) {
        return "";
      } else if (hora == 1) {
        return "$hora Hora e ";
      } else if (hora > 1) {
        return "$hora Horas e ";
      }
    } else {
      if (hora == 0) {
        return "";
      } else if (hora == 1) {
        return "$hora Hora";
      } else if (hora > 1) {
        return "$hora Horas";
      }
    }
  }

  _strgMin(int min) {
    if (min == 0) {
      return "";
    } else if (min == 1) {
      return "$min minuto";
    } else if (min > 1) {
      return "$min minutos";
    }
  }

  _solicitaReserva() async {
    String status = "pendente";
    Map<String, dynamic> solicitaReserva = {
      "productID": (widget.productID),
      "productPrice": valordoDoProduto,
      "programedInitDate": _dataInicio,
      "estimatedEndPrice": valorEstimado,
      "estimatedDuration": duracao,
      "programedEndDate": _dataFim,
      "programedInitTime": _horarioInicio,
      "programedEndTime": _horarioFim,
      "requesterID": userID,
      "status": status,
    };

    final newReserve = await databaseReference
        .collection("solicitations")
        .add(solicitaReserva);
    String idWriter = newReserve.documentID;
    Map<String, dynamic> setID = {
      "solicitationID": idWriter,
    };
    await databaseReference
        .collection("solicitations")
        .document(idWriter)
        .updateData(setID);
  }

  void _setID(String value) {
    setState(() {
      userID = value;
      getSaldo();
    });
  }

  getSaldo() async {
    await databaseReference
        .collection("users")
        .where("userID", isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        var aux = productData["debit"];
        setState(() {
          userDebit = aux.toDouble();
        });
      });
    });
  }
}
