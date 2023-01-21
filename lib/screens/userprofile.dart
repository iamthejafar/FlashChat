import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tryproject/constants.dart';
import 'package:tryproject/screens/viewphoto.dart';
import 'package:tryproject/usermodel/userModel.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, required this.userModel, required this.firebaseuser}) : super(key: key);
  final UserModel userModel;
  final User firebaseuser;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.userModel.profilepic.toString()),),
            SizedBox(width: 20,),
            Text(widget.userModel.fullname.toString()),
            SizedBox(width: 91,),
            DropDown(text1: 'Security  Info', text2: 'Share Profile')
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  Hero(
                    tag: 'propic',
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewPhoto(userModel: widget.userModel,firebaseUser: widget.firebaseuser,showdropdown: true,)));
                      },
                      child: CircleAvatar(
                        radius: 150,
                        backgroundImage: NetworkImage(widget.userModel.profilepic.toString()),
                      ),
                    ),
                  ),
                  Text(
                    widget.userModel.fullname.toString(),
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    widget.userModel.email.toString(),
                    style: ktextstyle2,
                  ),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('About',style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(
                    widget.userModel.status.toString(),
                    style: ktextstyle2,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Actions',style: TextStyle(fontWeight: FontWeight.bold),),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0.1,
                    leading: Icon(Icons.block,color: Colors.red,),
                    title: Text(
                      'Block ${widget.userModel.fullname.toString()}',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0.1,
                    leading: Icon(Icons.thumb_down,color: Colors.red,),
                    title: Text(
                      'Report ${widget.userModel.fullname.toString()}',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
                      ),
                    ),
                  ),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
