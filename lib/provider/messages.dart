import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesCollection with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("messages");
  FirebaseAuth get getauth => _auth;
  CollectionReference get getusercollections => _collectionReference;

  Future usermessages(BuildContext context, String messages) async {
    final prefs = await SharedPreferences.getInstance();
    await _collectionReference.add({
      "userId": _auth.currentUser!.uid,
      "text": messages,
      "username": prefs.getString("username"),
      "time": DateTime.now(),
    });
    notifyListeners();
  }
}
