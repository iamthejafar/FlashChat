import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel{
  String? chatroomid;
  Map<String,dynamic>? participants;
  String? lastMessage;
  Timestamp? createdon;
  Timestamp? lastmsgtime;
  List<dynamic>? users;
  Map<String,dynamic>? watchers;

  ChatRoomModel({this.watchers,this.users,this.chatroomid,this.participants,this.lastMessage,this.createdon,this.lastmsgtime});

  ChatRoomModel.fromMap(Map<String,dynamic> map){
    chatroomid = map['chatroomid'];
    participants = map['participants'];
    watchers = map['watchers'];
    lastMessage = map['lastmessage'];
    createdon = map['createdon'];
    lastmsgtime = map['lastmsgtime'];
    users = map['users'];
  }

  Map<String,dynamic> toMap(){
    return{
      'chatroomid' : chatroomid,
      'participants': participants,
      'lastmessage' : lastMessage,
      'createdon' : createdon,
      'lastmsgtime' : lastmsgtime,
      'users' : users,
      'watchers' : watchers
    };
  }
}