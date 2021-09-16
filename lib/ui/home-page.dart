import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:waarfira/core/model/patient.dart';
import 'package:waarfira/core/model/rv.dart';
import 'package:waarfira/core/model/user-details.dart';
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
import 'package:waarfira/ui/patient-rvs-page.dart';
import 'package:waarfira/ui/visio-conf.dart';

import 'liste-proches.dart';




Patient patientG;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = new FlutterSecureStorage();
  final UserDetailsService userDetailsService = new UserDetailsService();
  final PatientService patientService=new PatientService();
  final UserService userService=new UserService();
  final RvService rvService=new RvService();
  UserDetails userG=new UserDetails();
  // constructor
  _HomePageState() {
    // build searchbar
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double itemWidth = size.width;
    double itemHeight = size.height;
    return Scaffold(
        appBar: AppBar(
        title: Text('Accueil',style: TextStyle(color: MyAppColors.primaryColor)),
        centerTitle: true,
        backgroundColor: MyAppColors.secondaryColor,
        iconTheme: new IconThemeData(color: MyAppColors.primaryColor),
      ),
      drawer: AppDrawer(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      child:new ImageButton(
                        children: <Widget>[],
                        unpressedImage: Image.asset('assets/images/png/1.png'),
                        pressedImage:  Image.asset('assets/images/png/1.png'),
                        width: itemWidth/2,
                        height: itemWidth/2,
                        onTap: () async {
                          userG=await userDetailsService.getStoredUserDetails().then((value) => value);
                          if (userG!=null) {
                            patientG=await patientService.findByUserId(userG.id).then((value) => value);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                //builder: (context) => PatientProchePage(patientG)
                                  builder: (context) => ListPatients()
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Text('Mes proches', style: TextStyle(
                        fontSize: 25, color: MyAppColors.secondaryColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child:new ImageButton(
                        children: <Widget>[],
                        unpressedImage: Image.asset('assets/images/png/2.png'),
                        pressedImage:  Image.asset('assets/images/png/2.png'),
                        width: itemWidth/2,
                        height: itemWidth/2,
                        onTap: (){

                          Navigator.pushNamed(context, Routes.specialites);
                        },
                      ),
                    ),
                    Text('Rendez-Vous', style: TextStyle(
                        fontSize: 25, color: MyAppColors.secondaryColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child:new ImageButton(
                        children: <Widget>[],
                        unpressedImage: Image.asset('assets/images/png/3.png'),
                        pressedImage:  Image.asset('assets/images/png/3.png'),
                        width: itemWidth/2,
                        height: itemWidth/2,
                        onTap: () async {
                          userG=await userDetailsService.getStoredUserDetails().then((value) => value);
                          if(userG!=null){
                            print("email du user "+userG.email);
                            patientG=await patientService.findByUserId(userG.id).then((value) => value);
                            print('le patient id dans home page '+patientG.id.toString());
                          }
                          else print('le user est null');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PatientRvsPage(patientId: patientG.id,)
                            ),
                          );

                          /*Rv rv=new Rv();
                       await rvService.getRvByMedecinAndStatus(1151, 'VALID')
                                .then((value) => {
                                  print('la reponse'),
                                  print(value.body),
                         if(value.statusCode == HttpStatus.ok){
                           //rv=Rv.fromJson(jsonDecode(value.body)),
                           rv=rvService.getRvByResponseBody(value.body)[0],
                           print(rv.medecin.id)
                         },



                       });*/
                          //Navigator.pushNamed(context, Routes.specialites);
                        },
                      ),
                    ),
                    Text('Consultations', style: TextStyle(
                        fontSize: 25, color: MyAppColors.secondaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
