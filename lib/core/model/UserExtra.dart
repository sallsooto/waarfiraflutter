import 'package:waarfira/core/model/user.dart';

class UserExtra{
  int id;
  String fonction;
  String matricule;
  String phoneNumber;
  User user;

  UserExtra({this.id, this.fonction, this.matricule, this.phoneNumber, this.user});

  UserExtra.fromJson(Map<String, dynamic> json){
    if(json['id']!=null)
      id=json['id'];
    if(json['fonction']!=null)
      fonction=json['fonction'];
    if(json['matricule']!=null)
      matricule=json['matricule'];
    if(json['phoneNumber']!=null)
      phoneNumber=json['phoneNumber'];
    if(json['user']!=null)
      user=User.fromJson(json['user']);
  }

}