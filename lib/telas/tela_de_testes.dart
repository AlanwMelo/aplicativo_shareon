import 'package:aplicativo_shareon/telas/tela_reserva_proxima.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tela_Testes extends StatefulWidget {
  @override
  _Tela_TestesState createState() => _Tela_TestesState();
}

class _Tela_TestesState extends State<Tela_Testes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                ),
                RaisedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                      return Tela_Reserva_Proxima();
                    }));
                  },
                  child: Text("Tela \"Reserva Próxima\""),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
