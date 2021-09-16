import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:waarfira/core/model/consultation.dart';
import 'package:waarfira/core/model/patient.dart';
import 'package:waarfira/core/model/rv.dart';
import 'package:waarfira/core/model/user-details.dart';
import 'package:waarfira/core/service/consultation-service.dart';
import 'package:waarfira/core/service/patient-service.dart';
import 'package:waarfira/core/service/rv-service.dart';
import 'package:waarfira/core/service/user-details-service.dart';
import 'package:waarfira/core/service/user-service.dart';
import 'package:waarfira/core/util/MyAppColors.dart';
import 'package:waarfira/routes/routes.dart';
import 'package:waarfira/ui/app-drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:waarfira/ui/visio-conf.dart';

import 'liste-proches.dart';



int patientIdG;
List<Consultation> _patientConsultations;
class PatientRvsPage extends StatefulWidget {
  final int patientId;
  PatientRvsPage({@required this.patientId}){
    patientIdG=this.patientId;
  }
  @override
  _PatientRvsPageState createState() => _PatientRvsPageState();
}

class _PatientRvsPageState extends State<PatientRvsPage> {
  final storage = new FlutterSecureStorage();
  final UserDetailsService userDetailsService = new UserDetailsService();
  final PatientService patientService=new PatientService();
  final UserService userService=new UserService();
  final ConsultationService consultationService=new ConsultationService();
  final RvService rvService=new RvService();
  UserDetails userG=new UserDetails();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchConsultations();
  }



  _fetchConsultations() async {
    print('le patient id '+ patientIdG.toString());
    await consultationService.getInProgressPatientConsultation(patientIdG).then((response) =>
    {
      if(response.statusCode == HttpStatus.ok){
        print('consultation trouvée'),
        setState(() {
          _patientConsultations = consultationService.getConsultationByResponseBody(response.body);
          print(_patientConsultations.length);
        }),
      }
      else print('le statut '+response.body)
    });
  }

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    //double itemWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Consultations', style: TextStyle(color: MyAppColors.primaryColor),),
        centerTitle: true,
        backgroundColor: MyAppColors.secondaryColor,
        iconTheme: new IconThemeData(color: MyAppColors.primaryColor),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          if(_patientConsultations!=null && _patientConsultations.length > 0)
            for ( var i in _patientConsultations)
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          child:new ImageButton(
                            children: <Widget>[],
                            unpressedImage: Image.asset('assets/images/appointment.png'),
                            pressedImage:  Image.asset('assets/images/appointment.png'),
                            width: 150,
                            height: 150,
                            onTap: (){
                              Navigator.push(
                             context,
                               MaterialPageRoute(
                                   builder: (context) => VisioConf(consultation: i,)
                               ),
                             );
                            },
                          ),
                        ),
                        Text('Rendez-Vous', style: TextStyle(
                            fontSize: 25, color: MyAppColors.secondaryColor, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
          else
            new Text("Vous n'avez aucune consultation en cours", style: TextStyle(
                fontSize: 25, color: MyAppColors.secondaryColor, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
