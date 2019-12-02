import 'package:flutter/material.dart';

class TelaConfiguracoes extends StatefulWidget {
  @override
  _TelaConfiguracoesState createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  @override
  Widget build(BuildContext context) {
    return homeConfiguracoes();
  }
}

homeConfiguracoes() {
  return Scaffold(
    body: Container(
      child: Center(
        child: Text("Configurções"),
      ),
    ),
  );
}
