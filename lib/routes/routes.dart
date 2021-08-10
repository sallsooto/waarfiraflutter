import 'package:waarfira/main.dart';
import 'package:waarfira/ui/home-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:waarfira/ui/list-medecins.dart';
import 'package:waarfira/ui/list-specialites.dart';
import 'package:waarfira/ui/meetings.dart';
import 'package:waarfira/ui/patient-proche.dart';
import 'package:waarfira/ui/patient.dart';
import 'package:waarfira/ui/praticien.dart';
import 'package:waarfira/ui/specialite.dart';

class Routes {
  final _storage = new FlutterSecureStorage();
  static const String home = '/home';
  static const String login = '/login';
  static const String logout = '/logout';
  static const specialites = '/specialites';
  static const medecins = '/medecins';
  static const patients = '/patients';
  static const meetings = '/meetings';
  MaterialPageRoute makeNamedRoute(
      BuildContext context, RouteSettings settings) {
    if (settings.name == home || settings.name == '/') {
      return MaterialPageRoute(builder: (context) => HomePage());
    }

    if (settings.name == specialites) {
      return MaterialPageRoute(builder: (context) => ListSpecialites());
    }

    if (settings.name == medecins) {
      return MaterialPageRoute(builder: (context) => ListPraticiens());
    }

    if (settings.name == patients) {
      return MaterialPageRoute(builder: (context) => PatientPage());
    }
    if (settings.name == meetings) {
      return MaterialPageRoute(builder: (context) => MeetingsPage());
    }

    if (settings.name == logout || settings.name == login) {
      _storage.delete(key: 'token');
      _storage.delete(key: 'userDetails');
      _storage.delete(key: 'matricule');
      return MaterialPageRoute(builder: (context) => MyApp());
    }

    return MaterialPageRoute(builder: (context) => MyApp());
  }
}
