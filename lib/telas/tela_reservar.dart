import 'package:aplicativo_shareon/utils/seletor_calendario.dart';
import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Tela_Reservar extends StatefulWidget {
  String productID;
  double productPrice;

  Tela_Reservar({@required this.productID, @required this.productPrice});

  @override
  _Tela_ReservarState createState() => _Tela_ReservarState();
}

class _Tela_ReservarState extends State<Tela_Reservar> {
  DateTime dataBase = DateTime.now();
  DateTime dataInicio = DateTime.now();
  DateTime dataFim = DateTime.now();
  TimeOfDay timeInicio = TimeOfDay.now();
  TimeOfDay timeFim = TimeOfDay.now();
  int duracao = 60;
  String Strduracao;
  final databaseReference = Firestore.instance;
  String productName = "";
  String productMedia = "";
  String productOwner = "";
  String productOwnerID = "";
  String productDescription = "";
  String productIMG = "";
  String productType = "";

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

  double ValordoProduto = 0;
  double ValorEstimado = 0;
  String calcValorProdutoConversor = 0.toStringAsFixed(2);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimeString(duracao);
    _horarioFim = _horarioFimPadrao();
  }

  @override
  Widget build(BuildContext context) {
    return getProductData();
  }

  _homeReservar(BuildContext context) {
    return Scaffold(
      appBar: shareon_appbar(context),
      backgroundColor: Colors.indigoAccent,
      body: SingleChildScrollView(
        child: Container(
          height: 720,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _text(productName, Titulo: true),
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
                              _SelecionarData(context, "inicio");
                            },
                            child: Text("$_dataInicio"),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              _SelecionarHorario(context, "inicio");
                            },
                            child: Text(
                              "$_horarioInicio",
                            ),
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
                              _SelecionarData(context, "fim");
                            },
                            child: Text("$_dataFim"),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              _SelecionarHorario(context, "fim");
                            },
                            child: Text("$_horarioFim"),
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
                            _Toast(
                                "A data de devolução não pode ser menor que a data de retirada.",
                                context);
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
                                      _TextConfirmacao("Data de retirada:",
                                          Titulo: true),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _TextConfirmacao(
                                          "$_dataInicio $_horarioInicio"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _TextConfirmacao("Data de devolução:",
                                          Titulo: true),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _TextConfirmacao(
                                          "$_dataFim $_horarioFim"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _TextConfirmacao("Duração: ",
                                          Titulo: true),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _TextConfirmacao("$Strduracao"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _TextConfirmacao("Valor estimado: ",
                                          Titulo: true),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 8, left: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      _TextConfirmacao(
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

  Future<Null> _SelecionarHorario(
      BuildContext context, String inicioFim) async {
    final TimeOfDay horarioSelecionado = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (horarioSelecionado != null && inicioFim == "inicio") {
      dataInicio = DateTime(dataInicio.year, dataInicio.month, dataInicio.day,
          horarioSelecionado.hour, horarioSelecionado.minute);
      if (dataInicio.isBefore(dataBase)) {
        _Toast("A data de inicio não pode ser menor que a atual.", context);
        setState(() {
          dataInicio = DateTime.now();
          calcValorProdutoConversor = ValordoProduto.toStringAsFixed(2);
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
        _Toast("A data de devolução não pode ser menor que a data de retirada.",
            context);
        setState(() {
          dataFim = DateTime.now();
          _horarioConfirmado("fim", TimeOfDay.now());
          calcValorProdutoConversor = ValordoProduto.toStringAsFixed(2);
        });
      } else {
        setState(() {
          _verificaEstimado();
          _horarioConfirmado("fim", horarioSelecionado);
        });
      }
    }
  }

  Future<Null> _SelecionarData(BuildContext context, String inicioFim) async {
    final DateTime DiaSelecionado = await showSeletorCalendario(
      context: context,
      initialDate: DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2022),
    );
    if (DiaSelecionado != null && inicioFim == "inicio") {
      dataInicio = DateTime(DiaSelecionado.year, DiaSelecionado.month,
          DiaSelecionado.day, dataInicio.hour, dataInicio.minute);
      if (dataInicio.isBefore(dataBase)) {
        _Toast("A data de inicio não pode ser menor que a atual.", context);
        setState(() {
          dataInicio = DateTime.now();
          _horarioConfirmado("inicio", TimeOfDay.now());
          calcValorProdutoConversor = ValordoProduto.toStringAsFixed(2);
          _dataInicio = dataInicio.day.toString() +
              "/" +
              dataInicio.month.toString() +
              "/" +
              dataInicio.year.toString();
        });
      } else {
        setState(() {
          _verificaEstimado();
          _dataInicio = DiaSelecionado.day.toString() +
              "/" +
              DiaSelecionado.month.toString() +
              "/" +
              DiaSelecionado.year.toString();
        });
      }
    }

    if (DiaSelecionado != null && inicioFim == "fim") {
      dataFim = DateTime(DiaSelecionado.year, DiaSelecionado.month,
          DiaSelecionado.day, dataFim.hour, dataFim.minute);
      if (dataFim.isBefore(dataInicio)) {
        _Toast("A data de devolução não pode ser menor que a data de retirada.",
            context);
        setState(() {
          dataFim = DateTime.now();
          dataFim = DateTime.now();
          _horarioConfirmado("fim", TimeOfDay.now());

          calcValorProdutoConversor = ValordoProduto.toStringAsFixed(2);
          _dataFim = dataFim.day.toString() +
              "/" +
              dataFim.month.toString() +
              "/" +
              dataFim.year.toString();
        });
      } else {
        setState(() {
          _verificaEstimado();
          _dataFim = DiaSelecionado.day.toString() +
              "/" +
              DiaSelecionado.month.toString() +
              "/" +
              DiaSelecionado.year.toString();
        });
      }
    }
  }

  getTimeString(int value) {
    double tot_mins = value.toDouble();
    double dias = tot_mins / 1440;
    double horas = (tot_mins % 1440) / 60;
    double min = tot_mins % 60;

    Strduracao = "${_StrgDia(dias.toInt(), horas.toInt(), min.toInt())}"
        "${_StrgHora(horas.toInt(), min.toInt())}"
        "${_StrgMin(min.toInt())}";
  }

  _verificaEstimado() {
    if (dataInicio.isAfter(dataFim)) {
      calcValorProdutoConversor = ValordoProduto.toStringAsFixed(2);
    } else {
      _valorEstimado(ValordoProduto, dataInicio, dataFim);
    }
  }

  _valorEstimado(double valordoProduto, DateTime dataInicio, DateTime dataFim) {
    DateTime retirada = dataInicio;
    DateTime devolucao = dataFim;
    duracao = (devolucao.difference(retirada).inMinutes);
    valordoProduto = ValordoProduto / (60);
    double calcValorProduto = duracao.toDouble() * valordoProduto;
    getTimeString(duracao);
    calcValorProdutoConversor = calcValorProduto.toStringAsFixed(2);
    ValorEstimado = calcValorProduto;
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

  _text(String texto, {bool Titulo = false, bool Resumo = false}) {
    if (Titulo == true) {
      return Text(
        "$texto",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 30,
        ),
      );
    } else if (Resumo == true) {
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

  _Toast(String texto, BuildContext context) {
    Toast.show("$texto", context,
        duration: 3,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.8));
  }

  _TextConfirmacao(String texto, {bool Titulo = false}) {
    if (Titulo) {
      return Text(
        "$texto",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
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

  Widget getProductData() {
    return FutureBuilder(
        future: databaseReference
            .collection("products")
            .where("ID", isEqualTo: (widget.productID))
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            Map productData = f.data;
            productIMG = productData["imgs"];
            ValordoProduto = double.parse(productData["price"]);
            ValorEstimado = double.parse(productData["price"]);
            productName = productData["name"];
            productDescription = productData["description"];
            productMedia = productData["media"];
            productOwnerID = productData["ownerID"];
            productType = productData["type"];


            if (calcValorProdutoConversor == "0.00"){
              setState(() {
                calcValorProdutoConversor = ValordoProduto.toStringAsFixed(2);
              });
            }


          });
        }),
        builder: (context, snapshot) {
          return _homeReservar(context);
        });
  }

  _StrgDia(int dia, int hora, int min) {
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

  _StrgHora(int hora, int min) {
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

  _StrgMin(int min) {
    if (min == 0) {
      return "";
    } else if (min == 1) {
      return "$min minuto";
    } else if (min > 1) {
      return "$min minutos";
    }
  }
}
