import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatConversa extends StatelessWidget {

  _enviarMensagem(){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.indigo,
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.photo),
          iconSize: 25,
          color: Colors.indigo,
          onPressed: (){},
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enviar Mensagem..."
              ),
            ),
          ),
          IconButton(icon: Icon(Icons.send),
          iconSize: 25,
          color: Colors.indigo,
          onPressed: (){},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fulano"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
            ),
          )
        ],
      ),
    );
  }

}
