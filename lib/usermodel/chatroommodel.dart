import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel{
  String? chatroomid;
  Map<String,dynamic>? participants;
  String? lastMessage;
  Timestamp? createdon;

  ChatRoomModel({this.chatroomid,this.participants,this.lastMessage,this.createdon});

  ChatRoomModel.fromMap(Map<String,dynamic> map){
    chatroomid = map['chatroomid'];
    participants = map['participants'];
    lastMessage = map['lastmessage'];
    createdon = map['createdon'];
  }

  Map<String,dynamic> toMap(){
    return{
      'chatroomid' : chatroomid,
      'participants': participants,
      'lastmessage' : lastMessage,
      'createdon' : createdon
    };
  }
}