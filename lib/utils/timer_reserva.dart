import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class _Timer {
  String status;
  Timestamp programedInitDate;

  _Timer(this.status, this.programedInitDate);
}

class TimerReserva {
  final databaseReference = Firestore.instance;
  SharedPreferencesController sharedPreferencesController =
      new SharedPreferencesController();
  List<_Timer> list = [];

  Future<String> timerVerifier(String userID, String actualState) async {
    list.clear();
    await getData(userID);
    int timeNow = Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch;
    int nearestTime = list[0].programedInitDate.millisecondsSinceEpoch;

    if (list.where((list) => list.status.contains("em andamento")).isNotEmpty) {
      if (actualState != "Reserva em andamento") {
        return "Reserva em andamento";
      } else {
        return "";
      }
    } else if ((nearestTime - timeNow) <= 3600000) {
      if (actualState != "Há uma reserva próxima") {
        return "Há uma reserva próxima";
      } else {
        return "";
      }
    }
    return "";
  }

  getData(String userID) async {
    await databaseReference
        .collection("solicitations")
        .where("requesterID", isEqualTo: userID)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Map productData = f.data;
        if (productData["status"] == "pendente" ||
            productData["status"] == "em andamento" ||
            productData["status"] == "aprovado") {
          list.add(new _Timer(
              productData["status"], productData["programedInitDate"]));
          list.sort(
              (a, b) => a.programedInitDate.compareTo(b.programedInitDate));
        }
      });
    });
  }
}
