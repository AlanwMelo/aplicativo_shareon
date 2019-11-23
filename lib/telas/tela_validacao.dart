import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:aplicativo_shareon/utils/shareon_appbar.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toast/toast.dart';

class TelaValidacao extends StatefulWidget {
  @override
  _TelaValidacaoState createState() => _TelaValidacaoState();
}

class _TelaValidacaoState extends State<TelaValidacao> {
  String barcode = "";
  int pin = 5728;
  int pinDuration = 32;
  GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      appBar: shareonAppbar(context, ""),
      body: telaValidacao(),
    );
  }

  telaValidacao() {
    return SingleChildScrollView(
      child: Container(
        height: 720,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Container(
                child: _text(
                    "Para validar uma transação escaneie o código do outro usuário, ou peça para ele escanear o seu."),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              child: RaisedButton(
                onPressed: () {
                  scan();
                },
                child: Text(
                  "Escanear",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _qrZone(""),
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
              child: _textPin(),
            )),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 400,
                    margin: EdgeInsets.only(bottom: 10, top: 8),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text(
                        "Validar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
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

  Future<void> generateQR() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => Toast.show("$barcode", context,
          duration: 3,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.8)));
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

  _textPin() {
    if (pinDuration > 1) {
      return _textAlerta(
          "Seu PIN é: $pin. E é válido por mais $pinDuration minutos.");
    }
    else {
      return _textAlerta(
          "Seu PIN é: $pin. E é válido por mais $pinDuration minuto.");
    }
  }
}

_qrZone(String qrText) {
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
        child: QrImage(
          backgroundColor: Colors.white,
          data: "Teste: Meu nome não é Batima",
          size: 300,
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
        fontSize: 16,
      ),
    );
  }
}
