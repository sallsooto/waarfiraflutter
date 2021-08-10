import 'package:waarfira/core/config/api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../model/specialite.dart';

class SpecialiteService {
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api/specialities';
  Future<http.Response> getSpecialites() async {
    final token = await storage.read(key: 'token').then((value) => value);
    return http.get(Uri.parse(resUri), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<http.Response> createSpecialite(Specialite specialite) async {
    final token = await storage.read(key: 'token').then((value) => value);
    final String resUri = ApiConfig.URI + '/api/specialities';
    return http.post(Uri.parse(resUri),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(specialite.toJson()));
  }

  Future<http.Response> updateSpecialite(Specialite specialite) async {
    final token = await storage.read(key: 'token').then((value) => value);
    final String resUri = ApiConfig.URI + '/api/specialities';
    return http.put(Uri.parse(resUri),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(specialite.toJson()));
  }
}
