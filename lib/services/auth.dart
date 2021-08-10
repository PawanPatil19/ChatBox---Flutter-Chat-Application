import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';



class AuthServices with ChangeNotifier{

  String _errorMessage;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;



  Future register(String email, String password) async{

    try{
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;
      return user;
    } on SocketException{
      setMessage("No internet, please connect to the internet");
    } catch(e){
      setMessage(e.message);
    }
    notifyListeners();
  }

  Future login(String email, String password) async{
    try{
      UserCredential authResult = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;

      return user;
    } on SocketException{
      setMessage("No internet, please connect to the internet");
    } catch(e){

      setMessage(e.message);
    }
    notifyListeners();
  }




  Future signOut() async{
    try{
      return await firebaseAuth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }

  }


  void setMessage(message){
    _errorMessage = message;
    notifyListeners();
  }

  Stream<User> get user => firebaseAuth.authStateChanges().map((event) => event);

}