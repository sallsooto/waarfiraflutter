import 'package:waarfira/core/config/api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:waarfira/core/model/praticien.dart';
import 'package:waarfira/core/model/rv.dart';


class RvService {
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api/rvs';
  Future<http.Response> getRvByMedecinAndStatus(int medecinId, String status) async {
    final token = await storage.read(key: 'token').then((value) => value);
    return await http.get(Uri.parse(resUri+"?status.equals="+status+"&medecinId.equals=$medecinId"),  headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<http.Response> createRv(Rv rv) async {
    final token = await storage.read(key: 'token').then((value) => value);
    final String resUri = ApiConfig.URI + '/api/rvs';
    return await http.post(Uri.parse(resUri),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(rv.toJson()));
  }

  Future<http.Response> getRvsByPatientIdAndDate(int patientId, DateTime date) async {
    final token = await storage.read(key: 'token').then((value) => value);
    return http.get(Uri.parse(resUri+"/patient-visio-rvs/?patientId.equals=$patientId"+"&instant.equals=$date"), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  List<Rv> getRvByResponseBody(String responseBody){
    return (jsonDecode(responseBody)
        .map((i) => Rv.fromJson(i))
        .toList())
        .cast<Rv>()
        .toList();
  }


}