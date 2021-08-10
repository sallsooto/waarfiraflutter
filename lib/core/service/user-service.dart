import 'package:waarfira/core/config//api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:waarfira/core/model/user.dart';

class UserService {
  List<User> users=[];
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api';
  static Future<http.Response> authenticate(String username, String password) {
    return http.post(Uri.parse(ApiConfig.URI + '/api/authenticate'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({"username": username, "password": password}));
  }

  Future<http.Response> activateAccount(String key) async {
    final token = await storage.read(key: 'token').then((value) => value);
    return http.get(Uri.parse(resUri+'/activate?key='+key), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<http.Response> createUser(User user) async {
    final token = await storage.read(key: 'token').then((value) => value);
    final String resUri = ApiConfig.URI + '/api/register';
    return http.post(Uri.parse(resUri),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(user.toJson()));
  }

  Future<http.Response> getUsers() async {
    final token = await storage.read(key: 'token').then((value) => value);
    return http.get(Uri.parse(resUri+'/users'), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }



  Future<User> findByEmail(String email) async{
    User leUser=new User();
    await getUsers().then((value) => {
      users=(jsonDecode(value.body).
      map((i)=>User.fromJson(i)).toList())
          .cast<User>().toList(),
    });
    if(users!=null){
      users.forEach((user) {
        if(user.email!=null){
          if(user.email.compareTo(email)==0){
            leUser=user;
          }
        }
      });
    }
    return leUser;
  }


/*  Future<http.Response> getUserExtras() async {
    final token = await storage.read(key: 'token').then((value) => value);
    return http.get(Uri.parse(ApiConfig.URI + '/user-extras'), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  } */
}
