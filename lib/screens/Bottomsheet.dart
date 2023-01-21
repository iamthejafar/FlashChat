import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tryproject/screens/UserDrawer.dart';

import '../usermodel/userModel.dart';


class BotSheet extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String text;
  final bool check;

  BotSheet({required this.check, required this.text,required this.userModel, required this.firebaseUser});

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$text',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueAccent,
            ),),
          TextField(
            controller: controller,
            maxLines: 5,
            minLines: 1,
            autofocus: true,
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')
              ),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    check? userModel.status = controller.text.toString() : userModel.fullname = controller.text.toString();
                    await FirebaseFirestore.instance.collection('users')
                        .doc(userModel.uid).set(userModel.toMap()).then((value){
                      print('data uploadedd...');
                    });

                  },
                  child: Text('Save')
              )
            ],
          )
        ],
      ),
    );
  }
}
