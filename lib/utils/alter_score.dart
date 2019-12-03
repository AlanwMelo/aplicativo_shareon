import 'package:cloud_firestore/cloud_firestore.dart';

class AlterScore {
  final String userID;
  final String productID;

  AlterScore({this.userID, this.productID});

  final databaseReference = Firestore.instance;
  var _auxScoreValue;
  var _auxScoreTotal;
  int _auxListSize;

  alterscore() async {
    String id = userID != null ? userID : productID;
    _auxScoreValue = 0.0;
    _auxScoreTotal = 0.0;
    await databaseReference
        .collection("scoreValues")
        .where("ID", isEqualTo: id)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) async {
        Map alterDebit = f.data;

        _auxListSize = snapshot.documents.length;

        String aux = alterDebit["value"];
        double aux1 = double.parse(aux);

        _auxScoreValue = aux1;
        _auxScoreTotal = _auxScoreTotal + _auxScoreValue;

      });
    });

    if (_auxListSize >= 10) {

      _auxScoreTotal = _auxScoreTotal / _auxListSize;

      double auxParse = _auxScoreTotal;

      Map<String, dynamic> newScore = {
        "media": auxParse.toStringAsFixed(2),
      };

      if (userID != null) {
        await databaseReference
            .collection("users")
            .document(id)
            .updateData(newScore);
      } else {
        await databaseReference
            .collection("products")
            .document(id)
            .updateData(newScore);
      }
    }
  }
}
