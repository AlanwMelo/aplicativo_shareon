import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AlterDebit {
  final String userID;

  AlterDebit({@required this.userID});

  final databaseReference = Firestore.instance;
  var _auxDebitValue;
  var _auxDebitTotal;

  alterdebit() async {
    _auxDebitValue = 0.0;
    _auxDebitTotal = 0.0;
    await databaseReference
        .collection("debitHist")
        .where("userID", isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map alterDebit = f.data;

        _auxDebitValue = alterDebit["debit"];
        _auxDebitTotal = _auxDebitTotal + _auxDebitValue;
      });
    });

    Map<String, dynamic> newDebit = {
      "debit": _auxDebitTotal,
    };

    await databaseReference
        .collection("users")
        .document(userID)
        .updateData(newDebit);
  }
}
