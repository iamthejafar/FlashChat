import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tryproject/main.dart';
import 'package:tryproject/screens/userprofile.dart';
import 'package:tryproject/screens/viewphoto.dart';
import 'package:tryproject/usermodel/chatroommodel.dart';
import 'package:tryproject/usermodel/messagemodel.dart';
import 'package:tryproject/usermodel/userModel.dart';

import '../usermodel/ui_helper.dart';

class ChatRomm extends StatefulWidget {
  final UserModel userModel;
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final User firebaseUser;
  const ChatRomm({Key? key, required this.userModel, required this.targetUser, required this.chatroom, required this.firebaseUser}) : super(key: key);

  @override
  State<ChatRomm> createState() => _ChatRommState();
}

class _ChatRommState extends State<ChatRomm> {

  bool check = false;
  late bool check2 = true;
  late String oldurl;
  File? imagefile;
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
        sendImage();
      });
    }
  }
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();

  void checkvalues(){
    if(imagefile==null){
      UiHelper.showAlertDialog('Incomplete Data', context, 'Please Fill the field and choose image.');
      print("fill details");
    }
    else{
      if(check2 == false){
        sendMessage();
      }

    }
  }

  void sendImage() async{
    var msgid = uuid.v1();
    if(imagefile == null){
      print('image file is null');
    }
    UploadTask uploadTask = FirebaseStorage.instance.ref('messagespic')
        .child(msgid).putFile(imagefile!);
    TaskSnapshot snapshot = await uploadTask;
    String? imageurl = await snapshot.ref.getDownloadURL();
    MessageModel newMessage = MessageModel(
      sender: widget.userModel.uid,
      seen: false,
      createdon: Timestamp.now(),
      messageid: msgid,
      text: null,
      imageurl: imageurl!=null?imageurl:null,
    );
    FirebaseFirestore.instance.collection('chatrooms')
        .doc(widget.chatroom.chatroomid).collection('messages')
        .doc(newMessage.messageid).set(newMessage.toMap());
    log('message sent');
  }
  void sendMessage() async{
    String? msg = msgController.text.trim();
    var time = Timestamp.now();
    var msgid = uuid.v1();
    if(imagefile!=null){
      print('not null');
    }
    if(msg!=null){
      MessageModel newMessage = MessageModel(
          sender: widget.userModel.uid,
          seen: false,
          createdon: Timestamp.now(),
          messageid: msgid,
          text: msg!=null?msg:null,
          imageurl: null,

      );

       FirebaseFirestore.instance.collection('chatrooms')
      .doc(widget.chatroom.chatroomid).collection('messages')
      .doc(newMessage.messageid).set(newMessage.toMap());
       log('message sent');

       widget.chatroom.lastmsgtime = time;
       widget.chatroom.lastMessage = msg;
       FirebaseFirestore.instance.collection('chatrooms')
      .doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());
    }

  }
  TextEditingController msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile(userModel: widget.targetUser, firebaseuser: widget.firebaseUser)));
          },
          child: InkWell(
            hoverColor: Colors.grey[200],
            child: Row(
              children: [
                Hero(
                  tag: 'propic',
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.targetUser.profilepic.toString()),
                    )
                ),
                SizedBox(width: 10),
                Text(widget.targetUser.fullname.toString())
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('chatrooms')
                      .doc(widget.chatroom.chatroomid).collection('messages').orderBy('createdon',descending: true)
                      .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.connectionState==ConnectionState.active){
                          if(snapshot.hasData){
                            QuerySnapshot datasnap = snapshot.data as QuerySnapshot;
                            return ListView.builder(
                              reverse: true,
                              itemCount: datasnap.docs.length,
                              itemBuilder: (context,index){
                                MessageModel  currentMsgModel = MessageModel.fromMap(datasnap.docs[index].data() as Map<String,dynamic>);
                                bool isme = currentMsgModel.sender==widget.userModel.uid;
                                return Row(
                                  mainAxisAlignment: isme==true?MainAxisAlignment.end:MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: isme? Colors.blueAccent:Colors.greenAccent,
                                          borderRadius: BorderRadius.only(
                                              topLeft: isme ? Radius.circular(10): Radius.circular(0),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              topRight: isme? Radius.circular(0): Radius.circular(10)
                                          ),
                                      ),
                                      margin: EdgeInsets.symmetric(vertical: 3),
                                      padding: EdgeInsets.all(4),

                                      child: currentMsgModel.imageurl == null?Row(
                                        children: [
                                          Text(
                                             currentMsgModel.text.toString(),
                                             style: TextStyle(
                                               fontSize: 15
                                             ),
                                           ),
                                          SizedBox(width: 2,),
                                          Container(
                                            child: Text(
                                              DateFormat.jm().format(currentMsgModel.createdon!.toDate()).toString(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            margin: EdgeInsets.only(top: 6),
                                          ),
                                        ],
                                      ):
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewPhoto(userModel: widget.userModel, firebaseUser: widget.firebaseUser, showdropdown: false)));

                                            },
                                            child: Container(
                                               child: ClipRRect(
                                                 child: Image.network(
                                                     currentMsgModel.imageurl.toString(),
                                                   fit: BoxFit.cover,
                                                 ),
                                                 borderRadius: BorderRadius.circular(9),
                                               ),
                                              height: 300,
                                              width: 275,
                                             ),
                                          ),
                                          Container(
                                            child: Text(
                                              DateFormat.jm().format(currentMsgModel.createdon!.toDate()).toString(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            margin: EdgeInsets.only(top: 6),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },

                            );

                          }
                          else if(snapshot.hasError){
                            return Center(child: Text('Error! Check your internet'),);

                          }
                          else{
                            return Center(child: Text('Say Hi To your Firend'),);
                          }
                        }
                        else{
                          return Center(child: Text('Something went wrong'),);
                        }
                      },
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter a Message.'
                            ),
                            controller: msgController,
                            maxLines: null,
                          )
                      ),
                      GestureDetector(
                        onTap: (){
                          check2 = true;
                          showphotooption();
                          print('check2 = $check2');
                        },
                          child: Icon(Icons.attach_file)),
                      SizedBox(width: 5,),
                      GestureDetector(
                        onTap: (){
                          check2 = false;
                          // setState(() {
                          print('check2 = $check2');
                            sendMessage();
                            msgController.clear();
                          // });
                        },
                          child: Icon(Icons.send)),
                      SizedBox(width: 5,)
                    ],
                  ),
                ),
              )
            ],
          ),

        ),
      ),
    );
  }
}
