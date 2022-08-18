import 'package:chatappwithfirebaseflutter/chat/auth/signup_screen.dart';
import 'package:chatappwithfirebaseflutter/provider/auth.dart';
import 'package:chatappwithfirebaseflutter/provider/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'chat/auth/signin_screen.dart';
import 'chat/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessagesCollection(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthChange(),

        // const SigninScreen()
        // const ChatScreen()
      ),
    );
  }
}

class AuthChange extends StatelessWidget {
  AuthChange({Key? key}) : super(key: key);
  bool islogin = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong!"));
        }
        if (snapshot.hasData) {
          return ChatScreen();
        } else {
          return islogin ? const SignupScreen() : const SigninScreen();
        }
      },
    );
  }
}
