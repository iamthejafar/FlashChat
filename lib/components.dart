import 'dart:io';

import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
class RoundedButton extends StatelessWidget {
  late final Color btncolor;
  late final String label;
  late final Function ontap;

  RoundedButton({required this.btncolor,required this.label,required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: btncolor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            ontap();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            '$label',
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
   MyTextField({
    Key? key,
    required this.givencontroller,required this.hinttext, required this.show,
  }) : super(key: key);

  final TextEditingController givencontroller;
  final String hinttext;
  final bool show;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool obsecure = widget.show;
  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: widget.givencontroller,
      obscureText: obsecure==true?true:false,
      keyboardType: obsecure==true?TextInputType.number:null,
      style: ktextstyle2,
      decoration: InputDecoration(
        suffixIcon: widget.show==true?IconButton(
          onPressed: (){
            setState(() {
              if(obsecure==true){
                obsecure=false;
              }
              else{
                obsecure = true;
              }
            });
            print(obsecure);
          },
          icon: obsecure==true? Icon(Icons.visibility_off,):Icon(Icons.visibility),
        ):null,
        hintText: '${widget.hinttext}',
        hintStyle: TextStyle(
            color: Colors.black54
        ),
        contentPadding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}


// class ShowPhotoDialog extends StatelessWidget {
//    ShowPhotoDialog({Key? key}) : super(key: key);
//   late File imagefile;
//    showphotooption(BuildContext context){
//      showDialog(context: context, builder: (context){
//        return AlertDialog(
//          title: Text('Upload Profile Pic',style: TextStyle(color: Colors.black45),),
//          content: Column(
//            mainAxisSize: MainAxisSize.min,
//            children: [
//              ListTile(
//                onTap: () async{
//                  Navigator.pop(context);
//                  selectImage(ImageSource.gallery);
//                },
//                leading: Icon(Icons.photo_album),
//                title: Text('Select From Gallery',),
//              ),
//              ListTile(
//                onTap: (){
//                  Navigator.pop(context);
//                  selectImage(ImageSource.camera);
//                },
//                leading: Icon(Icons.camera_alt),
//                title: Text('Open Camera',),
//              )
//            ],
//          ),
//        );
//      });
//    }
//
//    selectImage(ImageSource source) async{
//      XFile ? pickedFile = await ImagePicker().pickImage(source: source);
//      if(pickedFile!=null){
//        cropImage(pickedFile);
//      }
//    }
//    cropImage(XFile file) async {
//      CroppedFile? croppedimaage = await ImageCropper().cropImage(
//        sourcePath: file.path,
//        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//        compressQuality: 30,
//      );
//      if(croppedimaage!=null){
//        final File imageFile = File(croppedimaage.path);
//        imagefile = imageFile;
//      }
//    }
//
//    getImage(){
//      return imagefile;
//    }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center();
//   }
// }
//
//
//
//
