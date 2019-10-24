import 'package:flutter/material.dart';

class Tela_Configuracoes extends StatefulWidget {
  @override
  _Tela_ConfiguracoesState createState() => _Tela_ConfiguracoesState();
}

class _Tela_ConfiguracoesState extends State<Tela_Configuracoes> {
  @override
  Widget build(BuildContext context) {
    return homeConfigurcoes();
  }
}

homeConfigurcoes(){
  return Scaffold(
    body: Container(
      child: Center(
        child: Text("Configurções"),
      ),
    ),
  );
}