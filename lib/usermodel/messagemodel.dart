import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String? messageid;
  String? sender;
  String? text;
  Timestamp? createdon;
  bool? seen;
  String? imageurl;

  MessageModel({this.imageurl,this.sender,this.text,this.createdon,this.seen,this.messageid});

  MessageModel.fromMap(Map<String,dynamic> map){
    messageid = map['messageid'];
    sender = map['sender'];
    text = map['text'];
    createdon = map['createdon'];
    seen = map['seen'];
    imageurl = map['imageurl'];
  }

  Map<String,dynamic> toMap(){
    return{
      'sender':sender,
      'text':text,
      'messageid': messageid,
      'createdon':createdon,
      'seen':seen,
      'imageurl': imageurl
    };
  }


}