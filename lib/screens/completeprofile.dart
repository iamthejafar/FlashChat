import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tryproject/components.dart';
import 'package:tryproject/screens/home_screen.dart';
import 'package:tryproject/usermodel/ui_helper.dart';
import 'package:tryproject/usermodel/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
  const CompleteProfile({Key? key, required this.userModel, required this.firebaseuser}) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  bool check = false;
  late File imagefile;
  void showphotooption(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Upload Profile Pic',style: TextStyle(color: Colors.black45),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async{
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
              leading: Icon(Icons.photo_album),
              title: Text('Select From Gallery',),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
              leading: Icon(Icons.camera_alt),
              title: Text('Open Camera',),
            )
          ],
        ),
      );
    });
  }

  void selectImage(ImageSource source) async{
    XFile ? pickedFile = await ImagePicker().pickImage(source: source);
    if(pickedFile!=null){
      cropImage(pickedFile);
    }
  }
  void cropImage(XFile file) async {
    CroppedFile? croppedimaage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 30,
    );
    if(croppedimaage!=null){
      setState(() {
        final File imageFile = File(croppedimaage.path);
        imagefile = imageFile;
        check = true;
      });
    }
  }
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();


  void checkvalues(){
    String fname = fullnamecontroller.text.trim();
    print(fname);
    if(fname == null||imagefile==null){
      UiHelper.showAlertDialog('Incomplete Data', context, 'Please Fill the field and choose image.');
      print("fill details");
    }
    else{
      uploadData();
    }
  }

  void uploadData() async{
    UiHelper.showLoadingDialog('Loading...', context);
    print('proceeding with uplload data');
    UploadTask uploadTask = FirebaseStorage.instance.ref('profilepic')
        .child(widget.userModel.uid.toString()).putFile(imagefile);
    TaskSnapshot snapshot = await uploadTask;
    print('image data uploaded');
    String? imageurl = await snapshot.ref.getDownloadURL();
    String? fullname = fullnamecontroller.text.trim();
    widget.userModel.fullname = fullname;
    widget.userModel.profilepic = imageurl;
    widget.userModel.status = statuscontroller.text.trim().toString();
    await FirebaseFirestore.instance.collection('users')
        .doc(widget.userModel.uid).set(widget.userModel.toMap()).then((value){
          print('data uploadedd...');
          log("Data uploaded");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Profile'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40,),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage: check==false?null:FileImage(imagefile),
                    child: check==false?Icon(Icons.person,size: 80.0,):null,
                  ),
                  onTap: (){
                    showphotooption();
                  },
                ),
                SizedBox(height: 30,),
                MyTextField(givencontroller: fullnamecontroller, hinttext: 'Enter Full Name', show: false),
                SizedBox(height: 20,),
                MyTextField(givencontroller: statuscontroller, hinttext: 'About', show: false),
                RoundedButton(btncolor: Colors.blueAccent,label: 'Submit',ontap: (){
                  checkvalues();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(userModel: widget.userModel,firebaseUser: widget.firebaseuser,)));
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


