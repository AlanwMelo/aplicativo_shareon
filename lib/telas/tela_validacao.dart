import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tela_Validacao extends StatefulWidget {
  @override
  _Tela_ValidacaoState createState() => _Tela_ValidacaoState();
}

class _Tela_ValidacaoState extends State<Tela_Validacao> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: shareon_appbar(context),
      body: telaValidacao(),
    );
  }

  telaValidacao() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              child: _text(
                  "Para validar uma transação escaneie o código do outro usuário, ou peça para ele escanear o seu."),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: RaisedButton(
              onPressed: () {
                scan();
              },
              child: Text("Escanear",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: _QRZone(),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 8),
              child: _text(
                  "Ou se preferir digite sua senha no celular dele, ou peça para que ele digite a dele."),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Center(
                    child: _boxSenha(),
                  ),
                ),
                Container(
                  child: Center(
                    child: _boxSenha(),
                  ),
                ),
                Container(
                  child: Center(
                    child: _boxSenha(),
                  ),
                ),
                Container(
                  child: Center(
                    child: _boxSenha(),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 8),
              child: _textAlerta(
                  "IMPORTANTE: Nunca deixe com que a outra pessoa saiba sua senha."),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 400,
                    margin: EdgeInsets.only(bottom: 10),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text("Validar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _boxSenha() {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 60,
          minHeight: 60,
          maxHeight: 60,
          maxWidth: 60,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          child: Container(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}

_QRZone() {
  return Container(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 300,
        minHeight: 300,
        maxHeight: 300,
        maxWidth: 300,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        child: Container(
          color: Colors.white,
        ),
      ),
    ),
  );
}

_textAlerta(String texto) {
  return Text(
    "$texto",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.yellow,
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
        fontSize: 16,
      ),
    );
  }
}
