import 'package:aplicativo_shareon/utils/seletor_calendario.dart';
import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tela_Reservar extends StatefulWidget {
  @override
  _Tela_ReservarState createState() => _Tela_ReservarState();
}

class _Tela_ReservarState extends State<Tela_Reservar> {
  DateTime dataBase = DateTime.now();
  DateTime dataInicio = DateTime.now();
  DateTime dataFim = DateTime.now();
  TimeOfDay timeInicio = TimeOfDay.now();
  TimeOfDay timeFim = TimeOfDay.now();

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

  String _horarioFim = _horarioFimPadrao();

  // Strings

  double ValordoProduto = 50;
  double ValorEstimado = 50;
  String calcValorProdutoConversor = 50.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return _homeReservar();
  }

  _homeReservar() {
    return Scaffold(
      appBar: shareon_appbar(),
      backgroundColor: Colors.indigo,
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _text("Nome do produto", Titulo: true),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 16),
              child: _img(),
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
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 500,
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text(
                            "Confirmar solicitação",
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
              ),
            ),
          ],
        ),
      ),
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
        print("A data selecionada não pode ser menor que a atual");
      } else {
        setState(() {
          _valorEstimado(ValordoProduto, dataInicio, dataFim);
          _horarioConfirmado(inicioFim, horarioSelecionado);
        });
      }
    } else if (horarioSelecionado != null && inicioFim == "fim") {
      dataFim = DateTime(dataFim.year, dataFim.month, dataFim.day,
          horarioSelecionado.hour, horarioSelecionado.minute);

      if (dataFim.isBefore(dataInicio)) {
        print("A data selecionada não pode ser menor que a data de inicio");
      } else {
        setState(() {
          _valorEstimado(ValordoProduto, dataInicio, dataFim);
          _horarioConfirmado(inicioFim, horarioSelecionado);
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
        print("A data selecionada não pode ser menor que a atual");
      } else
        setState(() {
          _valorEstimado(ValordoProduto, dataInicio, dataFim);

          _dataInicio = DiaSelecionado.day.toString() +
              "/" +
              DiaSelecionado.month.toString() +
              "/" +
              DiaSelecionado.year.toString();
        });
    }
    if (DiaSelecionado != null && inicioFim == "fim") {
      dataInicio = DateTime(DiaSelecionado.year, DiaSelecionado.month,
          DiaSelecionado.day, dataInicio.hour, dataInicio.minute);

      if (dataFim.isBefore(dataInicio)) {
      } else {
        setState(() {
          _valorEstimado(ValordoProduto, dataInicio, dataFim);

          _dataFim = DiaSelecionado.day.toString() +
              "/" +
              DiaSelecionado.month.toString() +
              "/" +
              DiaSelecionado.year.toString();
        });
      }
    }
  }

  _valorEstimado(double valordoProduto, DateTime dataInicio, DateTime dataFim) {
    DateTime retirada = dataInicio;
    DateTime devolucao = dataFim;

    int duracao = (retirada.difference(devolucao).inMinutes);

    valordoProduto = ValordoProduto / (60);

    print("$valordoProduto");
    print("$duracao");

    double calcValorProduto = duracao.toDouble() * valordoProduto;

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

        _valorEstimado(ValordoProduto, dataInicio, dataFim);
      });
    }
  }
}

_img() {
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
            "https://avatars2.githubusercontent.com/u/49197693?s=400&v=4",
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
