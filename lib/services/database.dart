import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class DatabaseMethods{
  getUsersByUsername(String username) async{
    return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();
  }

  getUsersByUseremail(String useremail) async{
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: useremail).get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatroomID, chatroomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatroomID).set(chatroomMap).catchError((e){
          print(e.toString());
    });
  }

  getMessages(String chatID) async{
    return await FirebaseFirestore.instance.collection("ChatRoom").doc(chatID).collection("chats").orderBy("time", descending: false)
        .snapshots();
  }
  addMessages(String chatID, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatID).collection("chats")
        .add(messageMap).catchError((e){print(e.toString());
    });
  }

  getChats(String username) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users", arrayContains: username).snapshots();
  }


}