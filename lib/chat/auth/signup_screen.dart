import 'package:chatappwithfirebaseflutter/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "User Registeration Screen",
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

                // user name text field.

                TextField(
                  decoration: InputDecoration(
                      hintText: "Username Here",
                      label: const Text("username"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: const Icon(Icons.email_outlined),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 18)),
                  controller: usernametext,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  maxLength: 20,
                ),

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
                            setState(() {
                              isloading == true;
                            });
                            await value.signup(
                                emailtext.text.trim(),
                                passwordtext.text.trim(),
                                usernametext.text.trim());
                            setState(() {
                              isloading == false;
                            });
                          },
                          child: isloading
                              ? const Center(child: CircularProgressIndicator())
                              : const Text("Register")),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
