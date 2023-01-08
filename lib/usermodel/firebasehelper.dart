
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tryproject/usermodel/userModel.dart';

class FirebaseHelper{
  static Future<UserModel?> getUserModelById(String uid) async{
    UserModel? userModel;
    DocumentSnapshot docsnap = await FirebaseFirestore.instance.collection('users')
    .doc(uid).get();
    if(docsnap!=null){
      userModel = UserModel.fromMap(docsnap.data() as Map<String,dynamic>);
    }
    return userModel;
  }
}