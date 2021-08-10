import 'package:flutter/material.dart';
import 'package:waarfira/core/config/api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:waarfira/core/model/praticien.dart';
import 'package:waarfira/core/model/user.dart';
import 'package:waarfira/core/service/user-service.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class PraticienService {
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api/medecins';
  UserService userService=new UserService();
  User user;
  Future<http.Response> getMedecins() async {
    final token = await storage.read(key: 'token').then((value) => value);
    return http.get(Uri.parse(resUri), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<http.Response> createPraticien(Praticien praticien,String loginUser,String passwordUser) async {
    final token = await storage.read(key: 'token').then((value) => value);
    final String resUri = ApiConfig.URI + '/api/medecins';
    print('dans create medecin');
    user=new User(lastName: praticien.lastName,firstName: praticien.firstName,email: praticien.email,
        login: loginUser,password: passwordUser,activated:true);
    print('le password');
    print(user.password);
    await userService.createUser(user).then((value) async =>
    {
      if(value.statusCode==HttpStatus.created || value.statusCode==HttpStatus.ok){
        user=await userService.findByEmail(praticien.email).then((value) => value),
        praticien.userId=user.id,
        print(user.activated),
        user.password=passwordUser,
        user.login=loginUser,
        print('id'+user.id.toString()),
        print('password'+user.password),
        await http.post(Uri.parse(resUri),
            headers: {
              HttpHeaders.authorizationHeader: "Bearer " + token,
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(praticien.toJson())).then((value) async => {
          print(value.body),

        },onError: (e){print("erreur Praticen"+e);}),
      }
    },onError: (e){print("erreur User"+e);});

  }



  Future<http.Response> updateMedecin(Praticien praticien) async {
    final token = await storage.read(key: 'token').then((value) => value);
    final String resUri = ApiConfig.URI + '/api/medecins';
    return http.put(Uri.parse(resUri),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(praticien.toJson()));
  }
}
