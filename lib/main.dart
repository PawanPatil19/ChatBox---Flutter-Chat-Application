import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/views/chatroom.dart';
import 'package:flutter/material.dart';
import 'helper/authenticate.dart';
import 'views/signin.dart';
import 'views/signup.dart';
import 'package:firebase_core/firebase_core.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userStatus;

  @override
  void initState() {
    getStatus();
    super.initState();
  }

  getStatus() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userStatus = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber ,
        scaffoldBackgroundColor: Colors.black38,
        primarySwatch: Colors.blue,
      ),
      home: userStatus!=null ? userStatus ? ChatRoom() : Authenticate() : Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}




