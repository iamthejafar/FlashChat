import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tryproject/usermodel/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewPhoto extends StatefulWidget {
  const ViewPhoto({Key? key, required this.userModel, required this.firebaseUser, required this.showdropdown}) : super(key: key);
  final UserModel userModel;
  final User firebaseUser;
  final bool showdropdown;
  @override
  State<ViewPhoto> createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget.showdropdown==true?DropDown(text1: 'Update Profile', text2: 'Delete Profile',):Container(),
            Container(
              margin: EdgeInsets.only(top: 150),
              height: 500,
              child: PhotoView(
                imageProvider: NetworkImage(widget.userModel.profilepic.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DropDown extends StatelessWidget {
  final String text1;
  final String text2;
  const DropDown({Key? key, required this.text1, required this.text2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (item){
        if(item == 1){
          print(1);
        }
        else{
          print(2);
        }

      },
      icon: Icon(
        Icons.more_vert_outlined,
        color: Colors.white,

      ),
      itemBuilder: (context)=>[
        PopupMenuItem(
            value: 1,
            child: Text(text1)
        ),
        PopupMenuItem(
            value: 2,
            child: Text(text2)
        )
      ],
    );
  }
}

