import 'package:flutter/material.dart';
import 'package:tryproject/constants.dart';
import 'package:tryproject/screens/chatroom_screen.dart';
import 'package:tryproject/screens/login_screen.dart';
import 'package:tryproject/screens/search_screen.dart';
import 'package:tryproject/screens/welcome_screen.dart';
import 'package:tryproject/usermodel/chatroommodel.dart';
import 'package:tryproject/usermodel/firebasehelper.dart';
import 'package:tryproject/usermodel/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'UserDrawer.dart';
class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomeScreen({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showspinner = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: Scaffold(
          drawer: UserDrawer(userModel: widget.userModel ,firebaseUser: widget.firebaseUser,),
          appBar: AppBar(

            title: Text('Messages'),
          ),
          body: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('chatrooms')
                    .where('users', arrayContains: widget.userModel.uid)
                    .orderBy('lastmsgtime',descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.connectionState == ConnectionState.active){
                    if(snapshot.hasData){
                      QuerySnapshot docsnapshot = snapshot.data as QuerySnapshot;
                      return Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: docsnapshot.docs.length,
                            itemBuilder: (context,index){
                              ChatRoomModel chatmodel = ChatRoomModel.fromMap(
                                docsnapshot.docs[index]
                                    .data() as Map<String,dynamic>);
                              Map<String,dynamic> participants = chatmodel.participants!;
                              List<String> participantkeys = participants.keys.toList();
                              participantkeys.remove(widget.userModel.uid);
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
                          ),
                        ),
                      );
                    }
                    else if(snapshot.hasError){
                      return CircularProgressIndicator();
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                  }
                  else{
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen(userModel: widget.userModel,firebaseUser: widget.firebaseUser,)));
            },
          ),

        ),
      ),
    );
  }
}
