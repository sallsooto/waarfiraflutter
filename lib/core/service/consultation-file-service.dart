import 'package:waarfira/core/config/api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:waarfira/core/model/consultation-file.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ConsultationFileService {
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api/consulation-files';
  Future<http.Response> getAllConsultationFiles() async {
    final token = await storage.read(key: 'token').then((value) => value);
    return http.get(Uri.parse(resUri), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<http.Response> createConsultationFile(ConsultationFile consultationFile) async {
    final token = await storage.read(key: 'token').then((value) => value);
    final String resUri = ApiConfig.URI + '/api/consulation-files';
    return http.post(Uri.parse(resUri),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(consultationFile.toJson()));
  }
}
