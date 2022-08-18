// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:chatappwithfirebaseflutter/provider/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'MessagesHandler.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  bool value = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MessagesCollection>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            value ? "${user!.email}" : "",
            style: const TextStyle(color: Colors.black87),
          ),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: const IconThemeData(color: Colors.black87),
          leading: IconButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("username");
                print(prefs.remove("username"));
              },
              icon: const Icon(Icons.logout_outlined)),
        ),
        bottomSheet: const MessagesHandler(),
        // display messages here
        body: StreamBuilder(
          stream: provider.getusercollections
              .orderBy("time", descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                // reverse: true,
                primary: true,
                physics: const ScrollPhysics(),

                // shrinkWrap: true,
                // reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  if (provider.getauth.currentUser!.uid !=
                      documentSnapshot["userId"]) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.topLeft,
                      child: ListTile(
                          title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(148, 0, 0, 0),
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(
                              "${documentSnapshot["username"]}\t:\t${documentSnapshot["text"]}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )),
                    );
                  } else {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment:
                            user!.uid == documentSnapshot["userId"]
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 7, 107, 188)),
                              child: Text(
                                "${documentSnapshot["username"]}\t:\t" +
                                    documentSnapshot["text"],
                                style: const TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    );
                  }
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
