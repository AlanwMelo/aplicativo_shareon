import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AvaliacoesProdutos extends StatefulWidget {
  final String id;

  AvaliacoesProdutos({@required this.id});

  @override
  _AvaliacoesProdutosState createState() => _AvaliacoesProdutosState();
}

class _AvaliacoesHist {
  String description;
  Timestamp ts;

  _AvaliacoesHist(this.description, this.ts);
}

class _AvaliacoesProdutosState extends State<AvaliacoesProdutos> {
  List<_AvaliacoesHist> avaliacoes = [];
  final databaseReference = Firestore.instance;

  @override
  void initState() {
    _getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Avaliações do produto'),
        elevation: 0,
        backgroundColor: Colors.indigoAccent,
      ),
      backgroundColor: Colors.indigoAccent,
      body: homeFAQ(),
    );
  }

  _getList() async {
    await databaseReference
        .collection("scoreValues")
        .where("ID", isEqualTo: widget.id)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map values = f.data;
        if (values["description"] != null) {
          Timestamp auxTS =
              values["statusTS"] ?? Timestamp.fromDate(DateTime.now());
          setState(() {
            avaliacoes.add(new _AvaliacoesHist(values["description"], auxTS));
            avaliacoes.sort((a, b) => b.ts.compareTo(a.ts));
          });
        }
      });
    });
  }

  homeFAQ() {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          color: Colors.indigoAccent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 40,
            ),
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  color: Colors.white,
                  child: avaliacoes.length == 0
                      ? Center(
                          child: _text(
                              "Este produto ainda não possui avaliações.",
                              resumo: true),
                        )
                      : _avaliacoesList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _avaliacoesList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: avaliacoes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _avaliacoesText(avaliacoes[index].description),
                    ],
                  ),
                  Divider(thickness: 2),
                ],
              ));
        });
  }

  _avaliacoesText(String text) {
    return Text(
      "$text",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black54,
        fontSize: 16,
      ),
    );
  }

  _text(String texto,
      {bool titulo = false, bool resumo = false, bool semititle = false}) {
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
        style: TextStyle(fontSize: 16, color: Colors.black),
      );
    } else if (semititle == true) {
      return Text(
        texto,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 26,
        ),
      );
    } else {
      return Text(
        "$texto",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 19,
        ),
      );
    }
  }
}
