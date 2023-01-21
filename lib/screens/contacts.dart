import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tryproject/usermodel/chatroommodel.dart';
import 'package:tryproject/usermodel/firebasehelper.dart';
import 'package:tryproject/usermodel/userModel.dart';

import 'chatroom_screen.dart';


class Contacts extends StatefulWidget {
  const Contacts({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);
  final UserModel userModel;
  final User firebaseUser;
  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chatrooms')
                .where('users', arrayContains: widget.userModel.uid)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){

              QuerySnapshot datasnap = snapshot.data as QuerySnapshot;
              return ListView.builder(
                itemCount: datasnap.docs.length,
                itemBuilder: (context,index){
                  ChatRoomModel chatmodel = ChatRoomModel.fromMap(datasnap.docs[index].data() as Map<String,dynamic>);
                  Map<String,dynamic> participants = chatmodel.participants!;
                  List<String> participantkeys = participants.keys.toList();
                  participantkeys.remove(widget.userModel.uid);
                  print(chatmodel.users);
                  return FutureBuilder(
                    future: FirebaseHelper.getUserModelById(participantkeys[0]),
                    builder: (context,userData){
                      if(userData.connectionState == ConnectionState.done){
                        if(userData.data != null){
                          UserModel targetUser = userData.data as UserModel;
                          return Container(
                            margin: EdgeInsets.only(top: 10, right: 5, left: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatRomm(
                                    userModel: widget.userModel,
                                    targetUser: targetUser,
                                    chatroom: chatmodel,
                                    firebaseUser: widget.firebaseUser
                                )));

                                var temp = chatmodel.lastmsgtime!.toDate();
                                var t = DateFormat.jm().format(temp);
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(targetUser.profilepic.toString()),
                              ),
                              title: Text(targetUser.fullname.toString()),
                              trailing: chatmodel.lastmsgtime != null?Text(
                                DateFormat.jm().format(chatmodel.lastmsgtime!.toDate()).toString(),
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700
                                ),
                              ):null,
                              subtitle: (chatmodel.lastMessage.toString()!="") ? Text(chatmodel.lastMessage.toString()):
                              Text('Say Hi to your new friend',style:TextStyle(color: Colors.blueAccent) ,),
                            ),
                          );
                        }
                        else{
                          return Center(child: Text('No Recent Friends. Search for new friends.'),);
                        }
                      }
                      else{
                        return Center();
                      }
                    },
                  );

                },
              );

            }
            else{
              return CircularProgressIndicator();
            }
          }
          else{
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
