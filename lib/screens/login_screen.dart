import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tryproject/components.dart';
import 'package:tryproject/constants.dart';
import 'package:tryproject/screens/home_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tryproject/usermodel/ui_helper.dart';
import 'package:tryproject/usermodel/userModel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showspinner = false;

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  void checkvalues(){
    String email = emailcontroller.text.trim();
    String pass = passcontroller.text.trim();

    if(email == null || pass == null){
      print("fill details");
      UiHelper.showAlertDialog('Incomplete Data', context, 'Please fill all the fields');
    }
    else{
      logIn(email, pass);
    }
  }

  logIn(var email,var password)async{
    UserCredential? credential;
    UiHelper.showLoadingDialog('Logging in..', context);
    try{
      credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      UiHelper.showAlertDialog('An error occured', context, e.message.toString());
      print(e.message.toString());
    }

    if(credential!=null){
      String uid = _auth.currentUser!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users')
      .doc(uid).get();

      UserModel userModel = UserModel.fromMap(userData.data() as Map<String,dynamic>);
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(userModel: userModel, firebaseUser: credential!.user!,)));
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 48.0,),
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
                  RoundedButton(btncolor: Colors.lightBlueAccent,label: 'Log In',
                    ontap: (){
                    checkvalues();
                    },
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
