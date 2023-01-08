import 'dart:io';
import 'package:tryproject/screens/completeprofile.dart';
import 'package:tryproject/usermodel/ui_helper.dart';
import 'package:tryproject/usermodel/userModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tryproject/components.dart';
import 'package:tryproject/constants.dart';
import 'package:tryproject/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool showspinner = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController cpasscontroller = TextEditingController();

  void checkvalues(){
    String email = emailcontroller.text.trim();
    String pass = passcontroller.text.trim();
    String cpass = cpasscontroller.text.trim();

    if(email == null || pass == null || cpass == null){
      print("fill details");
      UiHelper.showAlertDialog('Incomplete Data', context, 'Please fill all the fields');
    }
    else if(cpass!=pass){
      print("pass not match");
      UiHelper.showAlertDialog('Password Missmatch', context, 'The Passwords you entered does not match!');

    }
    else{
      signup(email, pass);
    }
  }
  void signup(var email, var password) async{
    UiHelper.showLoadingDialog('Signing up...', context);
    UserCredential ? credential;
    try{
      credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
      Navigator.pop(context);
      UiHelper.showAlertDialog('An error occured', context, e.message.toString());
      print(e.code.toString());
    }

    if(credential!=null){
      String uid = credential.user!.uid;
      UserModel newUser= UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: ""
      );
      await _firestore.collection('users').doc(email).set(newUser.toMap())
      .then((value){
        print('Done');
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CompleteProfile(userModel: newUser, firebaseuser: credential!.user!)));
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(20),
          child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 60,),
                    Hero(
                      tag: 'logo',
                      child: Container(
                        height: 200.0,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                    SizedBox(height: 20,),
                    MyTextField(givencontroller: emailcontroller, hinttext: 'Enter your email', show: false),
                    SizedBox(height: 15,),
                    MyTextField(givencontroller: passcontroller, hinttext: 'Enter your password', show: true),
                    SizedBox(height: 15,),
                    MyTextField(givencontroller: cpasscontroller, hinttext: 'Confirm your password', show: true),
                    RoundedButton(btncolor: Colors.lightBlueAccent,label: 'Register',
                      ontap: () async {
                      checkvalues();
                      },),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}


