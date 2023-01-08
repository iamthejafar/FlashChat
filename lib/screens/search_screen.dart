import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tryproject/components.dart';
import 'package:tryproject/screens/chatroom_screen.dart';
import 'package:tryproject/screens/welcome_screen.dart';
import 'package:tryproject/usermodel/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tryproject/usermodel/chatroommodel.dart';
import 'package:tryproject/constants.dart';
import '../main.dart';

var kcolor1 = Colors.white;
var kcolor2 = Colors.white;


class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchScreen({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String fullname = '';
  String email='';
  String ppurl ='';
  String uid = '';


  Future<ChatRoomModel?> getChatroomModel(UserModel newuser) async {
    ChatRoomModel chatRoom;
    QuerySnapshot snapshot = await _firestore.collection('chatrooms').where('participants.${widget.userModel.uid}',isEqualTo: true)
        .where('participants.${newuser.uid}',isEqualTo: true)
        .get();

    if(snapshot.docs.length>0){
      log('already');

      var docData = snapshot.docs[0].data();
      ChatRoomModel existingchatroom = ChatRoomModel.fromMap(docData as Map<String,dynamic>);

      chatRoom = existingchatroom;

    }
    else{
      log('no problem');
      ChatRoomModel newchatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: '',
        participants: {
          widget.userModel.uid.toString(): true,
          newuser.uid.toString(): true,
        }
      );
      chatRoom = newchatroom;
      await _firestore.collection('chatrooms').doc(newchatroom.chatroomid)
      .set(newchatroom.toMap());
      log('new chat room created');
    }
    return chatRoom;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: [
          GestureDetector(
            child: Icon(Icons.logout),
          onTap: ()async{
              await FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));

          },
        )],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10,),
            
            Container(
              margin: EdgeInsets.all(5),
                child: MyTextField1(givencontroller: searchController, hinttext: 'Enter user email', show: false)),
            RoundedButton(btncolor: Colors.blueAccent, label: 'Search', ontap: () async{
              var doc = _firestore.collection('users').where('email',isEqualTo: searchController.text)
              .where('email',isNotEqualTo: widget.userModel.email);
              var userdoc = doc.get().then((value) =>{
                print(value.docs.map((document) => {
                  setState(() {
                    kcolor1 = Colors.black38;
                    kcolor2 = Colors.blueAccent;
                    fullname = document['fullname'];
                    email = document['email'];
                    ppurl = document['profilepic'];
                    uid = document['uid'];

                  }),
                }))
              });
            }
            ),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kcolor2,
                borderRadius: BorderRadius.circular(10)
                
              ),
             
              child: ListTile(
                onTap: () async{
                  UserModel targetUser = UserModel(
                      fullname: fullname,
                      email: email,
                      uid: uid,
                      profilepic: ppurl
                  );
                  ChatRoomModel? chatroom = await getChatroomModel(targetUser);
                  if(chatroom!=null){
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context)=>ChatRomm(
                          userModel: widget.userModel,
                          targetUser: targetUser,
                          firebaseuser: widget.firebaseUser,
                          chatroom: chatroom,)));
                  }
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(ppurl),
                  backgroundColor: kcolor1,
                ),
                title: Text(fullname),
                subtitle: Text(email),
                trailing: Icon(Icons.message,color: kcolor1,),
              ),
            )



          ],
        ),
      ),
    );
  }
}


class MyTextField1 extends StatefulWidget {
  MyTextField1({
    Key? key,
    required this.givencontroller,required this.hinttext, required this.show,
  }) : super(key: key);

  final TextEditingController givencontroller;
  final String hinttext;
  final bool show;

  @override
  State<MyTextField1> createState() => _MyTextField1State();
}

class _MyTextField1State extends State<MyTextField1> {
  late bool obsecure = widget.show;
  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: widget.givencontroller,
      obscureText: obsecure==true?true:false,
      keyboardType: obsecure==true?TextInputType.number:null,
      style: ktextstyle2,
      decoration: InputDecoration(
        suffixIcon: widget.show==true?IconButton(
          onPressed: (){
            setState(() {
              if(obsecure==true){
                obsecure=false;
              }
              else{
                obsecure = true;
              }
            });
            print(obsecure);
          },
          icon: obsecure==true? Icon(Icons.visibility_off,):Icon(Icons.visibility),
        ):null,
        hintText: '${widget.hinttext}',
        hintStyle: TextStyle(
            color: Colors.black54
        ),
        contentPadding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
    );
  }
}