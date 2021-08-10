import 'package:waarfira/core/config/api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:waarfira/core/model/consultation.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:waarfira/core/model/praticien.dart';
import 'package:waarfira/core/model/rv.dart';


class ConsultationService {
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api/consultations';

  Future<http.Response> getInProgressPatientConsultation(int patientId) async {
    print('dans get in progress');
    print('le patient id '+patientId.toString());
    final token = await storage.read(key: 'token').then((value) => value);
    return http.get(Uri.parse(resUri+"/inprogress-for-patient/$patientId"), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  List<Consultation> getConsultationByResponseBody(String responseBody){
    return (jsonDecode(responseBody)
        .map((i) => Consultation.fromJson(i))
        .toList())
        .cast<Consultation>()
        .toList();
  }


}