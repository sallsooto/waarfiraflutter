import 'dart:convert';

import 'package:waarfira/core/model/consultation.dart';
import 'package:waarfira/core/model/patient.dart';
import 'package:waarfira/core/model/praticien.dart';
import 'package:waarfira/core/model/rv.dart';
import 'package:waarfira/core/util/DateConverter.dart';

class AppFile {
  int id;
  String name;
  String fDataContentType;
  Object fData;
  int ownerId;
  String createdAt;
  //Folder Folder;

  AppFile({
    this.id,
    this.name,
    this.fDataContentType,
    this.fData,
    this.ownerId,
    this.createdAt,

  });

  AppFile.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) id = json['id'];
    if (json['name'] != null) name = json['name'];
    if (json['fDataContentType'] != null) fDataContentType = json['fDataContentType'];
    if (json['fData'] != null) fData = json['fData'];
    if (json['ownerId'] != null) ownerId = json['ownerId'];
    if (json['createdAt'] != null) createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "fDataContentType": fDataContentType,
    "fData": fData,
    "ownerId": ownerId,
    "createdAt": createdAt,

  };

}