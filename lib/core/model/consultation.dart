import 'dart:convert';

import 'package:waarfira/core/model/patient.dart';
import 'package:waarfira/core/model/praticien.dart';
import 'package:waarfira/core/model/rv.dart';
import 'package:waarfira/core/util/DateConverter.dart';

class Consultation {
  int id;
  String roomName;
  DateTime startAt;
  DateTime finishAt;
  int participantsNumber;
  bool inProgress;
  Rv rv;

  Consultation({
    this.id,
    this.roomName,
    this.startAt,
    this.finishAt,
    this.participantsNumber,
    this.inProgress,
    this.rv});

  Consultation.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) id = json['id'];
    if (json['roomName'] != null) roomName = json['roomName'];
    //if (json['startAt'] != null) startAt = DateConverter.stringToDate(json['startAt']);
    //if (json['finishAt'] != null) finishAt = DateConverter.stringToDate(json['finishAt']);
    if (json['participantsNumber'] != null) participantsNumber = json['participantsNumber'];
    if (json['inProgress'] != null) inProgress = json['inProgress'];
    if (json['rv'] != null) rv = Rv.fromJson(json['rv']);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "roomName": roomName,
    "startAt": DateConverter.timeStampToJson(startAt),
    "finishAt": DateConverter.timeStampToJson(finishAt),
    "participantsNumber": participantsNumber,
    "inProgress": inProgress,
    if(rv!=null)
      "rv": {
        "id": rv.id,
      },
  };

}