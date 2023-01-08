class UserModel{
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;

  UserModel({this.uid, this.fullname, this.email, this.profilepic});

  UserModel.fromMap(Map<String,dynamic> map){
    this.uid = map['uid'];
    this.fullname = map['fullname'];
    this.email = map['email'];
    this.profilepic = map['profilepic'];
  }
  UserModel.fromJson(Map<String,dynamic> json){
    this.uid = json['uid'];
    this.fullname = json['fullname'];
    this.email = json['email'];
    this.profilepic = json['profilepic'];
  }

  Map<String,dynamic> toMap(){
    return{
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'profilepic': profilepic
    };
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = Map<String, dynamic>();

      data['uid']= uid;
      data['fullname']= fullname;
      data['email']=  email;
      data['profilepic']= profilepic;

      return data;
  }

}