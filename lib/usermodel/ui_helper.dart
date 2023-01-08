import 'package:flutter/material.dart';

class UiHelper{

  static void showAlertDialog(String title, BuildContext context, String content){

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
              },
            child: Text('Ok'))
      ],

    );
    
    showDialog(context: context, builder: (context)=>alertDialog);

  }


  static void showLoadingDialog(String title, BuildContext context){
    AlertDialog loadingDialog = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 30,),
          Text(title)
        ],
      ),
    ); 
    
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
      return loadingDialog;
    });

  }

}