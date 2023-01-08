import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:tryproject/constants.dart';
import 'package:tryproject/screens/login_screen.dart';
import 'package:tryproject/components.dart';
import 'package:tryproject/screens/registeration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;
  void initState(){
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 2),);
    animation = ColorTween(begin: Colors.purple, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {
      });
    });
  }
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 70.0,
                    ),
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  WavyAnimatedText('Flash Chat', textStyle: ktextstyle1)
                ]
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(btncolor: Colors.lightBlueAccent,label: 'Log In',
              ontap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },),
            RoundedButton(btncolor: Colors.blueAccent,label: 'Register',
              ontap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
              },),
          ],
        ),
      ),
    );
  }
}


