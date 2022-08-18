import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseAuth get getauth => auth;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("users");

  String? getString;

  String? get getstringval => getString;

  //firebase user signup
  Future signup(String email, String password, String username) async {
    final prefs = await SharedPreferences.getInstance();

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await collectionReference.doc(userCredential.user!.uid).set({
      "userId": userCredential.user!.uid,
      "email": email,
      "username": username,
    });
    await prefs.setString("username", username);
    notifyListeners();
  }

// firebase user signin

  Future signin(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .whenComplete(() async {
      await prefs.reload();
    });
    notifyListeners();
  }
}
