import 'dart:convert';

import 'package:waarfira/core/model/consultation.dart';
import 'package:waarfira/core/model/patient.dart';
import 'package:waarfira/core/model/praticien.dart';
import 'package:waarfira/core/model/rv.dart';
import 'package:waarfira/core/util/DateConverter.dart';

class ConsultationFile {
  int id;
  int fileId;
  String fileName;
  int ownerId;
  Consultation consultation;

  ConsultationFile({
    this.id,
    this.fileId,
    this.fileName,
    this.ownerId,
    this.consultation});

  ConsultationFile.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) id = json['id'];
    if (json['fileId'] != null) fileId = json['fileId'];
    if (json['fileName'] != null) fileName = json['fileName'];
    if (json['ownerId'] != null) ownerId = json['ownerId'];
    if (json['consultation'] != null) consultation = Consultation.fromJson(json['consultation']);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "fileId": fileId,
    "fileName": fileName,
    "ownerId": ownerId,
    if(consultation!=null)
      "consultation": {
        "id": consultation.id,
      },
  };

}