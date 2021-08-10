import 'role.dart';

class User{
   int id;
   String email;
   String login;
   String password;
   String firstName;
   String lastName;
   List<dynamic> authorities;
   bool activated;
   String langKey;

  User({this.id, this.email, this.login, this.password, this.firstName,this.lastName,this.authorities,this.activated,this.langKey});
   User.fromJson(Map<String, dynamic> json){
      if(json['id']!=null)
         id=json['id'];
      if(json['email']!=null)
         email=json['email'];
      if(json['login']!=null)
         login=json['login'];
      if(json['password']!=null)
         password=json['password'];
      if(json['firstName']!=null)
         firstName=json['firstName'];
      if(json['lastName']!=null)
         lastName=json['lastName'];
      if(json['authorities']!=null)
         authorities=json['authorities'];
      if(json['activated']!=null)
         activated=json['activated'];
      if(json['langKey']!=null)
         langKey=json['langKey'];
   }

   Map<String, dynamic> toJson() => {
      if(id!=null)
         "id": id,
      "email": email,
      "login": login,
      "firstName": firstName,
      "lastName": lastName,
      "password": password,
      "authorities": authorities,
      "activated": activated,
      "langKey": langKey,
   };
}