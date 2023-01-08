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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
          appBar: AppBar(
            actions: [Padding(
              padding: EdgeInsets.only(right: 15),
              child: GestureDetector(child: Icon(Icons.logout),
                  onTap: () async{
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));
                  },
              ),
            )],
            title: Text('Flash Chat'),
          ),
          body: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('chatrooms')
                    .where('participants.${widget.userModel.uid}',isEqualTo: true ).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.connectionState == ConnectionState.active){
                    if(snapshot.hasData){
                      QuerySnapshot docsnapshot = snapshot.data as QuerySnapshot;

                      return Scrollbar(
                        thumbVisibility: true,
                        trackVisibility: true,
                        thickness: 20.0,
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
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: Colors.black)
                                        )
                                      ),
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatRomm(
                                              userModel: widget.userModel,
                                              targetUser: targetUser,
                                              chatroom: chatmodel,
                                              firebaseuser: widget.firebaseUser
                                          )));
                                        },
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(targetUser.profilepic.toString()),
                                        ),
                                        title: Text(targetUser.fullname.toString()),
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
                                  return Center(child: Text('Network Issue...'),);
                                }
                              },
                            );
                          },
                        ),
                      );
                    }
                    else if(snapshot.hasError){
                      return Center(child: Text('Something Went wrong'),);
                    }
                    else{
                      return Center(child: Text('Something Went wrong'),);
                    }
                  }
                  else{
                    return Center(child: Text('Something Went wrong'),);
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
