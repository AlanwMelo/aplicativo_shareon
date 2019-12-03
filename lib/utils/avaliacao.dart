import 'package:aplicativo_shareon/telas/home.dart';
import 'package:aplicativo_shareon/utils/alter_score.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Avaliacao extends StatefulWidget {
  final String ownerID;
  final String requesterID;
  final String userID;
  final String productID;

  Avaliacao(
      {@required this.ownerID,
      @required this.userID,
      @required this.productID,
      @required this.requesterID});

  @override
  _AvaliacaoState createState() => _AvaliacaoState();
}

class _AvaliacaoState extends State<Avaliacao> {
  final databaseReference = Firestore.instance;
  int userStarControl = 0;
  int productStarControl = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return _avaliacao();
  }

  _avaliacao() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.white.withOpacity(0.1),
        child: loading != false
            ? Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()),
              )
            : WillPopScope(
                onWillPop: () async {
                  return false;
                  /*return Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext contex) {
                    return Home();
                  }));*/
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Container(
                        color: Colors.white,
                        child: Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 8, top: 8),
                                child: Text(
                                  "Avaliação",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 3,
                              ),
                              Container(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: 8, left: 8, bottom: 8),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: _textConfirmacao(
                                                  "Avaliação do usuário:",
                                                  titulo: true),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: _starsUser(),
                                    ),
                                    widget.ownerID == widget.userID
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(
                                                right: 8, left: 8, bottom: 8),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Center(
                                                    child: _textConfirmacao(
                                                        "Avaliação do produto:",
                                                        titulo: true),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    widget.ownerID == widget.userID
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(bottom: 8),
                                            child: _starsProduct(),
                                          ),
                                  ],
                                ),
                              ),
                              Container(
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
                                              loading = true;
                                            });
                                            _salvaAvaliacao();
                                          },
                                          child: Text(
                                            "Avaliar",
                                            textAlign: TextAlign.center,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  _textConfirmacao(String texto, {bool titulo = false, bool center = false}) {
    if (titulo) {
      return Text(
        "$texto",
        style: TextStyle(
          fontFamily: 'RobotoMono',
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
          fontFamily: 'RobotoMono',
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
          fontFamily: 'RobotoMono',
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: 16,
          decoration: TextDecoration.none,
        ),
      );
    }
  }

  _iconFullStar() {
    return Icon(
      Icons.star,
      color: Colors.black,
      size: 45.0,
    );
  }

  _iconEmptyStar() {
    return Icon(
      Icons.star_border,
      color: Colors.black54,
      size: 45.0,
    );
  }

  _starsUser() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                setState(() {
                  userStarControl = 1;
                });
              },
              child: userStarControl >= 1 ? _iconFullStar() : _iconEmptyStar()),
          GestureDetector(
              onTap: () {
                setState(() {
                  userStarControl = 2;
                });
              },
              child: userStarControl >= 2 ? _iconFullStar() : _iconEmptyStar()),
          GestureDetector(
              onTap: () {
                setState(() {
                  userStarControl = 3;
                });
              },
              child: userStarControl >= 3 ? _iconFullStar() : _iconEmptyStar()),
          GestureDetector(
              onTap: () {
                setState(() {
                  userStarControl = 4;
                });
              },
              child: userStarControl >= 4 ? _iconFullStar() : _iconEmptyStar()),
          GestureDetector(
              onTap: () {
                setState(() {
                  userStarControl = 5;
                });
              },
              child: userStarControl >= 5 ? _iconFullStar() : _iconEmptyStar()),
        ],
      ),
    );
  }

  _starsProduct() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                setState(() {
                  productStarControl = 1;
                });
              },
              child:
                  productStarControl >= 1 ? _iconFullStar() : _iconEmptyStar()),
          GestureDetector(
              onTap: () {
                setState(() {
                  productStarControl = 2;
                });
              },
              child:
                  productStarControl >= 2 ? _iconFullStar() : _iconEmptyStar()),
          GestureDetector(
              onTap: () {
                setState(() {
                  productStarControl = 3;
                });
              },
              child:
                  productStarControl >= 3 ? _iconFullStar() : _iconEmptyStar()),
          GestureDetector(
              onTap: () {
                setState(() {
                  productStarControl = 4;
                });
              },
              child:
                  productStarControl >= 4 ? _iconFullStar() : _iconEmptyStar()),
          GestureDetector(
              onTap: () {
                setState(() {
                  productStarControl = 5;
                });
              },
              child:
                  productStarControl >= 5 ? _iconFullStar() : _iconEmptyStar()),
        ],
      ),
    );
  }

  _salvaAvaliacao() async {
    if (widget.ownerID == widget.userID) {
      Map<String, dynamic> requesterScore = {
        "value": userStarControl.toString(),
        "ID": widget.requesterID,
      };

      await databaseReference.collection("scoreValues").add(requesterScore);

      var aux = new AlterScore(userID: widget.requesterID);
      aux.alterscore();

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      }));
    } else {
      Map<String, dynamic> productScore = {
        "value": productStarControl.toString(),
        "ID": widget.productID,
      };
      Map<String, dynamic> ownerScore = {
        "value": userStarControl.toString(),
        "ID": widget.userID,
      };

      await databaseReference.collection("scoreValues").add(productScore);
      await databaseReference.collection("scoreValues").add(ownerScore);

      var aux = new AlterScore(userID: widget.ownerID);
      aux.alterscore();
      var aux2 = new AlterScore(userID: widget.productID);
      aux2.alterscore();

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      }));
    }
  }
}
