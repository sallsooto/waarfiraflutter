import 'package:flutter/material.dart';
import 'package:waarfira/core/config/api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:waarfira/core/model/user.dart';
import 'package:waarfira/core/service/user-service.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../model/patient.dart';

class PatientService {
  List<Patient> patients=[];
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api/patients';
   UserService userService=new UserService();
   User user;
  Future<http.Response> getPatients() async {
    final token = await storage.read(key: 'token').then((value) => value);
    return http.get(Uri.parse(resUri), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<http.Response> createPatient(Patient patient,String loginUser,String passwordUser,Patient parent) async {
    final String resUri = ApiConfig.URI + '/api/patients/register';
    print('dans create patient');
    user=new User(lastName: patient.lastName,firstName: patient.firstName,email: loginUser,
        login: loginUser,password: passwordUser,activated:true, langKey: 'fr');
    await userService.createUser(user).then((value) async =>
    {
      if(value.statusCode==HttpStatus.created || value.statusCode==HttpStatus.ok){
          user=await userService.findByEmail(loginUser).then((value) => value),
          patient.userId=user.id,
          print(user.activated),
          print(user.email),
         await http.post(Uri.parse(resUri+"/"+user.email),
          headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(patient.toJson())).then((value) async => {
            print(value.body),
            if(parent!=null){
              if(parent.patients==null){
                parent.patients=[],
                parent.patients.add(patient),
              }
              else
              parent.patients.add(patient),
              await updatePatient(parent).then((value) => {
                print('proche ajouté'),
              })
            }

          },onError: (e){print("erreur Patient"+e);}),
      }
    },onError: (e){print("erreur User"+e);});

  }
  
  

  Future<http.Response> updatePatient(Patient patient) async {
    final token = await storage.read(key: 'token').then((value) => value);
    final String resUri = ApiConfig.URI + '/api/patients';
    return http.put(Uri.parse(resUri),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(patient.toJson()));
  }


  Future<http.Response> getPatientByUserId(int userId) async {
    final token = await storage.read(key: 'token').then((value) => value);
    final String resUri = ApiConfig.URI + '/api/patients';
    return await http.get(Uri.parse(resUri+"?userId.equals=$userId"),  headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<Patient> findByUserId(int user_id) async{
    Patient lePatient=new Patient();
    await getPatients().then((value) => {
      patients=(jsonDecode(value.body).
      map((i)=>Patient.fromJson(i)).toList())
          .cast<Patient>().toList(),
    });
    if(patients!=null){
      patients.forEach((patient) {
        print('patient id '+patient.id.toString());
        print('patient user id '+patient.userId.toString());
        if(patient.id!=null){
          if(patient.userId==user_id){
            lePatient=patient;
          }
        }
      });
    }
    return lePatient;
  }
  List<Patient> getPatientsByResponseBody(String responseBody){
    return (jsonDecode(responseBody)
        .map((i) => Patient.fromJson(i))
        .toList())
        .cast<Patient>()
        .toList();
  }
}
