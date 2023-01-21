class UserModel{
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;
  String? status;
  UserModel({this.status, this.uid, this.fullname, this.email, this.profilepic});

  UserModel.fromMap(Map<String,dynamic> map){
    this.uid = map['uid'];
    this.fullname = map['fullname'];
    this.email = map['email'];
    this.profilepic = map['profilepic'];
    this.status = map['status'];
  }
  UserModel.fromJson(Map<String,dynamic> json){
    this.uid = json['uid'];
    this.fullname = json['fullname'];
    this.email = json['email'];
    this.profilepic = json['profilepic'];
    this.status = json['status'];
  }

  Map<String,dynamic> toMap(){
    return{
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'profilepic': profilepic,
      'status' : status
    };
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = Map<String, dynamic>();

      data['uid']= uid;
      data['fullname']= fullname;
      data['email']=  email;
      data['profilepic']= profilepic;
      data['status'] = status;

      return data;
  }

}