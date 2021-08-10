import 'dart:convert';

import 'package:waarfira/core/model/patient.dart';
import 'package:waarfira/core/model/praticien.dart';
import 'package:waarfira/core/util/DateConverter.dart';

class Rv {
  int id;
  bool canceledByMedecin;
  DateTime dte;
  Praticien medecin;
  String status;
  Patient patient;

  Rv({
    this.id,
    this.canceledByMedecin,
     this.dte,
    this.medecin,
    this.status,
    this.patient});

  Rv.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) id = json['id'];
    if (json['canceledByMedecin'] != null) canceledByMedecin = json['canceledByMedecin'];
    if (json['dte'] != null) dte = DateConverter.stringToDate(json['dte']);
    if (json['medecin'] != null) medecin = Praticien.fromJson(json['medecin']);
    if (json['status'] != null) status = json['status'];
    if (json['patient'] != null) patient = Patient.fromJson(json['patient']);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "canceledByMedecin": canceledByMedecin,
    "dte": DateConverter.timeStampToJson(dte),
    if(medecin!=null)
      "medecin": {
        "id": medecin.id,
      },
    "status": status,
    if(patient!=null)
      "patient": {
        "id": patient.id,
      },
  };



}

enum Status {
  VALID, REALISED, CANCELED
}