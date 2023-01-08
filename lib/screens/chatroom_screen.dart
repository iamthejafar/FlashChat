import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tryproject/main.dart';
import 'package:tryproject/usermodel/chatroommodel.dart';
import 'package:tryproject/usermodel/messagemodel.dart';
import 'package:tryproject/usermodel/userModel.dart';

class ChatRomm extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final User firebaseuser;
  const ChatRomm({Key? key, required this.userModel, required this.targetUser, required this.chatroom, required this.firebaseuser}) : super(key: key);

  @override
  State<ChatRomm> createState() => _ChatRommState();
}

class _ChatRommState extends State<ChatRomm> {
  void sendMessage() async{
    String msg = msgController.text.trim();
    if(msg != null){
      MessageModel newMessage = MessageModel(
        sender: widget.userModel.uid,
        seen: false,
        createdon: Timestamp.now(),
        messageid: uuid.v1(),
        text: msg
      );

       FirebaseFirestore.instance.collection('chatrooms')
      .doc(widget.chatroom.chatroomid).collection('messages')
      .doc(newMessage.messageid).set(newMessage.toMap());
       log('message sent');

       widget.chatroom.lastMessage = msg;
       FirebaseFirestore.instance.collection('chatrooms')
      .doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());
    }
  }
  TextEditingController msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.targetUser.profilepic.toString()),),
            SizedBox(width: 10),
            Text(widget.targetUser.fullname.toString())
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('chatrooms')
                      .doc(widget.chatroom.chatroomid).collection('messages').orderBy('createdon',descending: true)
                      .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.connectionState==ConnectionState.active){
                          if(snapshot.hasData){
                            QuerySnapshot datasnap = snapshot.data as QuerySnapshot;
                            return ListView.builder(
                              reverse: true,
                              itemCount: datasnap.docs.length,
                              itemBuilder: (context,index){
                                MessageModel  currentMsgModel = MessageModel.fromMap(datasnap.docs[index].data() as Map<String,dynamic>);
                                bool isme = currentMsgModel.sender==widget.userModel.uid;
                                return Row(
                                  mainAxisAlignment: isme==true?MainAxisAlignment.end:MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: isme? Colors.blueAccent:Colors.greenAccent,
                                          borderRadius: BorderRadius.only(
                                              topLeft: isme ? Radius.circular(30): Radius.circular(0),
                                              bottomRight: Radius.circular(30),
                                              bottomLeft: Radius.circular(30),
                                              topRight: isme? Radius.circular(0): Radius.circular(30)
                                          ),
                                      ),
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      padding: EdgeInsets.all(7),
                                      // color: Colors.blueAccent,
                                      child: Text(
                                         currentMsgModel.text.toString(),
                                        style: TextStyle(
                                            fontSize: 17
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },

                            );

                          }
                          else if(snapshot.hasError){
                            return Center(child: Text('Error! Check your internet'),);

                          }
                          else{
                            return Center(child: Text('Say Hi To your Firend'),);
                          }
                        }
                        else{
                          return Center(child: Text('Something went wrong'),);
                        }
                      },
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter a Message.'
                            ),
                            controller: msgController,
                            maxLines: null,
                          )
                      ),
                      IconButton(onPressed: (){
                        sendMessage();
                        msgController.clear();
                      }, icon: Icon(Icons.send),color: Colors.blueAccent,)
                    ],
                  ),
                ),
              )
            ],
          ),

        ),
      ),
    );
  }
}
