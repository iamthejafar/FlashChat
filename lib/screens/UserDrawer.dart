
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tryproject/constants.dart';
import 'package:tryproject/screens/Bottomsheet.dart';
import 'package:tryproject/screens/contacts.dart';
import 'package:tryproject/screens/viewphoto.dart';
import 'package:tryproject/screens/viewphoto.dart';
import 'package:tryproject/screens/welcome_screen.dart';
import 'package:tryproject/usermodel/userModel.dart';
import 'package:tryproject/usermodel/firebasehelper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../usermodel/chatroommodel.dart';
import '../usermodel/ui_helper.dart';

class UserDrawer extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const UserDrawer({Key? key, required this.userModel, required this.firebaseUser,}) : super(key: key);


  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  final _firestore = FirebaseFirestore.instance;
  late UserModel uModel;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Drawer(
        child: StreamBuilder(
          stream: _firestore.collection('users').doc(widget.firebaseUser.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                var data = snapshot.data!.data();
                print(snapshot.data);
                uModel = UserModel(
                    fullname:  data['fullname'],
                    status:  data['status'],
                    profilepic: data['profilepic'],
                    email: data['email']
                );
                print(uModel.profilepic.toString());
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPhoto(userModel: widget.userModel, firebaseUser: widget.firebaseUser, showdropdown: true,)));
                      },
                      child: Container(
                        height: 250,
                        child: UserAccountsDrawerHeader(
                          accountName: null,
                          accountEmail: null,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(uModel.profilepic.toString())
                              )
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(uModel.fullname.toString(),style: ktextstyle2,),
                      trailing: IconButton(
                        onPressed: (){
                          showModalBottomSheet(context: context, builder: (context)=> BotSheet(userModel: widget.userModel, firebaseUser: widget.firebaseUser, text : 'Enter Name', check: false,));
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                    ListTile(
                      title: Text('About'),
                      subtitle: Text(uModel.status.toString()),
                      trailing: IconButton(
                          onPressed: (){
                            showModalBottomSheet(context: context, builder: (context)=> BotSheet(userModel: widget.userModel, firebaseUser: widget.firebaseUser, text : 'Add About', check: true,));
                          },
                          icon: Icon(Icons.edit)),
                    ),
                    Tile(icon: null, text: 'Accounts'),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Contacts(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
                      },
                        child: Tile(icon: Icon(Icons.person),text: 'Contacts',)),
                    Tile(icon: Icon(Icons.group),text: 'Groups',),
                    GestureDetector(
                        onTap: (){
                          FirebaseAuth.instance.signOut();
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                        },
                        child: Tile(icon: Icon(Icons.logout), text: 'Log Out')
                    ),
                    Divider(),
                    Tile(icon: null,text: 'App and developers',),
                    Tile(icon: Icon(Icons.share), text: 'Share this app'),
                    Tile(icon: Icon(Icons.star), text: 'Rate this app'),
                    Tile(icon: Icon(Icons.bug_report), text: 'Report a bug'),
                    Tile(icon: Icon(Icons.privacy_tip), text: 'Privacy Policy'),
                    Tile(icon: null, text: 'Connect with us'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: () async{
                          String url = "mailto:jafarjalali128@gmail.com";
                          var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                          if(urllaunchable){
                            await launch(url); //launch is from url_launcher package to launch URL
                          }else{
                            print("URL can't be launched.");
                          }
                          //
                        }, icon: Icon(Icons.email)),
                        IconButton(
                            onPressed: ()async{
                              String url = "https://github.com/iamthejafar";
                              var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                              if(urllaunchable){
                                await launch(url); //launch is from url_launcher package to launch URL
                              }else{
                                print("URL can't be launched.");
                              }
                            }, icon: Icon(FontAwesomeIcons.github)),
                        IconButton(
                            icon: Icon(FontAwesomeIcons.twitter),
                          onPressed: () async{
                            String url = "https://twitter.com/iamthejafar";
                            var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                            if(urllaunchable){
                              await launch(url); //launch is from url_launcher package to launch URL
                            }else{
                              print("URL can't be launched.");
                            }
                          },
                        ),

                      ],
                    ),

                  ],
                );
              }
              else{
                return Center();
              }

            }
            else{
              return Center();
            }
          },
        )
      ),
    );
  }
}

class Tile extends StatelessWidget {

  final Icon? icon;
  final String text;
  const Tile({
    Key? key, required this.icon, required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(text),
    );
  }
}







