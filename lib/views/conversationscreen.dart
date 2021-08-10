import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {

  String chatID;
  ConversationScreen(this.chatID);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEditingController = new TextEditingController();

  Stream chatMessagesStream;
  Widget MessageList(){
    return StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                return MessageTile(snapshot.data.docs[index].data()["message"],
                snapshot.data.docs[index].data()["sendBy"] == Constants.myName);
            }) : Container();
        },
    );
  }

  sendMsg(){
    if(messageEditingController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message":messageEditingController.text,
        "sendBy" : Constants.myName,
        "time" :DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addMessages(widget.chatID, messageMap);
      messageEditingController.text = "";
    }
  }

  @override
  void initState() {
   databaseMethods.getMessages(widget.chatID).then((val){
      setState(() {
        chatMessagesStream = val;
      });
    });
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            MessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black87,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: simpleTextStyle(),
                          decoration: InputDecoration(
                            hintText: "Type a message ....",
                            hintStyle: TextStyle(
                                color: Colors.white,
                            ),
                            border: InputBorder.none,
                          ),
                        )
                    ),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: (){
                        sendMsg();
                      },


                      child: Container(
                          height:40,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png")),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool byMe;
  MessageTile(this.message, this.byMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.only(left: byMe?0:20 , right: byMe?20:0) ,
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: byMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: byMe ? [
            const Color (0xFFFFC107),
              const Color (0xFFFF8F00)

            ]
              : [
              const Color (0XFF616161),
          const Color (0XFF424242)
              ],
          ),
        borderRadius: byMe ?
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
            ):
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)
            )
        ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 17
        ),),
      ),
    );
  }
}
