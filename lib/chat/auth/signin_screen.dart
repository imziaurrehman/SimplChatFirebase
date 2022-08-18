import 'package:chatappwithfirebaseflutter/chat/auth/signup_screen.dart';
import 'package:chatappwithfirebaseflutter/chat/chat_screen.dart';
import 'package:chatappwithfirebaseflutter/provider/auth.dart';
import 'package:chatappwithfirebaseflutter/provider/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController usernametext = TextEditingController();
  final TextEditingController emailtext = TextEditingController();
  final TextEditingController passwordtext = TextEditingController();

  @override
  void dispose() {
    usernametext.dispose();
    emailtext.dispose();
    passwordtext.dispose();
    super.dispose();
  }

  // String name = "";
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<MessagesCollection>(context, listen: false);

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "User Login Screen",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // login text.
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: size.height * 0.10),
                    child: const Text(
                      "Login",
                      textScaleFactor: 2.0,
                    )),

                SizedBox(
                  height: size.height * 0.06,
                ),

                // email text field here.
                TextField(
                  decoration: InputDecoration(
                      hintText: "User Email Address Here",
                      label: const Text("Email"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: const Icon(Icons.email_outlined),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 18)),
                  controller: emailtext,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  maxLength: 20,
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                // password text field here.
                TextField(
                  decoration: InputDecoration(
                    hintText: "User Password Here",
                    label: const Text("Password"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon: const Icon(Icons.password_outlined),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 18),
                  ),
                  controller: passwordtext,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  maxLength: 20,
                ),
                // login button
                SizedBox(
                  height: size.height * 0.2 / 8,
                ),
                Consumer<Auth>(
                  builder: (context, value, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await value
                                .signin(emailtext.text.trim(),
                                    passwordtext.text.trim())
                                .whenComplete(() {
                              user = FirebaseAuth.instance.currentUser;
                              collectionReference.doc(user!.uid).get().then(
                                  (DocumentSnapshot<Object?> value) =>
                                      prefs.setString(
                                          "username", value["username"]));
                            });
                          },
                          child: const Text("Login")),
                    );
                  },
                ),

                SizedBox(
                  height: size.height * 0.2 / 15,
                ),
                // signup button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("if user is not loggedin already then\t"),

                    // signup button
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ));
                        },
                        child: const Text("Register")),
                    const Text("yourself?")
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
