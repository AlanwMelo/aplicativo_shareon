import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import '../main.dart';

class UserModel extends Model {
  FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool carregando = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  } //usuario atual

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    carregando = true;
    notifyListeners();

    auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((user) async {
      firebaseUser = user;

      await saveUserData(userData);

      onSuccess();
      carregando = false;
      firebaseUser.sendEmailVerification();
      _loadCurrentUser();
      notifyListeners();
    }).catchError((e) {
      onFail();
      carregando = false;
      notifyListeners();
    });
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    carregando = true;
    notifyListeners();

    auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user;

      await _loadCurrentUser();

      onSuccess();
      carregando = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      carregando = false;
      notifyListeners();
    });
  }

  void recoverPass(String email) {
    auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isAuthenticated(FirebaseUser user) async {
    SharedPreferencesController sharedPreferencesController =
    new SharedPreferencesController();

    await user.reload();
    sharedPreferencesController.setEmailAuth(user.isEmailVerified);
    return user.isEmailVerified;
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    firebaseUser = null;

    if (firebaseUser == null) {
      firebaseUser = await auth.currentUser();

      await _setSharedID(firebaseUser.uid);

      Map<String, dynamic> setID = {
        "userID": firebaseUser.uid,
      };
      Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .updateData(setID);
    }

    if (firebaseUser != null) {
      if (userData["nome"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }

  // ignore: missing_return
  Future _setSharedID(String value) {
    SharedPreferencesController sharedPreferencesController =
        new SharedPreferencesController();

    sharedPreferencesController.setID(value);

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((fcmtoken) async {
      Map<String, dynamic> setFCMToken = {
        "fcmToken": fcmtoken,
      };
      await databaseReference
          .collection("users")
          .document(value)
          .updateData(setFCMToken);
    });
  }
}
