import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tryproject/screens/home_screen.dart';
import 'package:tryproject/screens/welcome_screen.dart';
import 'package:tryproject/usermodel/firebasehelper.dart';
import 'package:tryproject/usermodel/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser = FirebaseAuth.instance.currentUser;

  if(currentUser!=null){
    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentUser.uid.toString());
    if(thisUserModel!=null){
      return runApp(MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser,));
    }
  }
  else{
    return runApp(MyApp());
  }
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: WelcomeScreen(),
        ),
      ),
    );
  }
}


class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyAppLoggedIn({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(userModel: userModel,firebaseUser: firebaseUser,),
    );
  }
}
