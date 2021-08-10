// import 'dart:convert';
// import 'package:epv/core/config/getImei.dart';
// import 'package:epv/core/model/pv/Delais.dart';
// import 'package:epv/core/model/pv/fautif.dart';
// import 'package:epv/core/model/pv/infraction.dart';
// import 'package:epv/core/model/pv/pv.dart';
// import 'package:epv/core/model/pv/vehicule.dart';
// import 'package:epv/core/service/pv-service.dart';
// import 'package:epv/core/util/MyAppColors.dart';
// import 'package:epv/core/util/permis-cartegrise-info-model.dart';
// import 'package:epv/ui/step-indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'app-drawer.dart';
// import 'impression.dart';
//
// MedecinService _medecinService = new MedecinService();
// Medecin _leMedecin=new Medecin();
// String text;
// Medecin detailsInfo;
// List<Speciliate> lesSpecialitesG;
// final storage = new FlutterSecureStorage();
// class DetailsMedecinPage extends StatefulWidget {
//   DetailsMedecinPage({this.title, this.details,this.lesSpecialites}){
//     detailsInfo=this.details;
//     lesSpecialitesG=this.lesSpecialites;
//   }
//   final String title;
//   final Medecin details;
//   final List<Specialite> lesSpecialites;
//   @override
//   _DetailsMedecinPageState createState() => _DetailsMedecinPageState();
// }
//
// class _DetailsMedecinPageState extends State<DetailsMedecinPage> {
//   @override
//   void initState()  {
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: new Text(
//             'Recapitulatif',
//             style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)
//         ),
//         centerTitle: true,
//         backgroundColor: MyAppColors.primaryColor,
//       ),
//       drawer: AppDrawer(),
//       body: Center(
//         child:
//         ListView(
//           children: [
//             Icon(Icons.featured_play_list_outlined,size:50,),
//             Container(
//               height: 500,
//               width: double.infinity,
//               //color: Colors.purple,
//               alignment: Alignment.center,
//               margin: EdgeInsets.all(10),
//               padding: EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 border: Border.all(color: MyAppColors.primaryColor, width: 3),
//               ),
//               child:
//               _myListView(),
//             ),
//             _createStepIndicatorCotainer(),
//
//           ],
//         ),
//
//       ),
//     );
//   }
//
//
//   String parseDate(String date){
//     RegExp exp = new RegExp(r"(\d{1,2}\/\d{1,2}\/\d{1,4})");
//     if(exp.hasMatch(date)){
//       String jour=date.substring(0,2);
//       print('le jour est'+jour);
//       String mois=date.substring(3,5);
//       print('le mois est'+mois);
//       String annee=date.substring(6,10);
//       print('lannee est'+annee);
//       print('le format est:'+annee+mois+jour);
//       return annee+mois+jour;
//     }
//     return null;
//   }
//
//   ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
//     title: Text(title,
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 20,
//         )),
//     subtitle: Text(subtitle),
//     leading: Icon(
//       icon,
//       color: Colors.blue[500],
//     ),
//   );
//
//   Widget _createStepIndicatorCotainer(){
//     var size = MediaQuery.of(context).size;
//     final double itemWidth = size.width-50;
//     return Container(
//       width: itemWidth,
//       margin: EdgeInsets.only(bottom: 25),
//       child: Center(
//         child: StepIndicator(currentStep: 5, size: 7,),
//       ),
//     );
//   }
//   String _dateTimeToStringJson(DateTime date){
//     try{
//       return date.toString().substring(0,10);
//     }catch(Exception){
//       return null;
//     }
//   }
//
//
//   String _dateTimeToFrenchFormat(DateTime date){
//     String dateStr;
//     try{
//       dateStr=_dateTimeToStringJson(date);
//       String jour=dateStr.substring(8,10);
//       String mois=dateStr.substring(5,7);
//       String annee=dateStr.substring(0,4);
//       return jour+"/"+mois+"/"+annee;
//     }
//     catch(e){
//       return null;
//     }
//   }
//
//   AlertDialog alert(String title, String text){
//     return AlertDialog(
//       title: Text(title),
//       content: Text(text),
//       shape: RoundedRectangleBorder(
//           borderRadius:
//           BorderRadius.circular(20.0)),
//       backgroundColor: MyAppColors.secondaryColor,
//       titleTextStyle: new TextStyle(color: Colors.white,fontSize: 30,decoration: TextDecoration.underline),
//       contentTextStyle: new TextStyle(color: Colors.white,fontSize: 20),
//       actions: [
//       ],
//     );
//   }
//
//   ListView _myListView(){
//     if(detailsInfo!=null){
//         return ListView(
//           children: [
//             _tile('Prénoms et Nom', detailsInfo.firstName+" "+detailsInfo.lastName, Icons.account_box_rounded),
//             _tile('Date naissance', detailsInfo.dateNaissance.toString().substring(0,10), Icons.date_range),
//             _tile('Adresse', detailsInfo.adresse, Icons.blur_linear),
//             _tile('Email', detailsInfo.email, Icons.email),
//             _tile("Nombre de specialités", lesSpecialitesG!=null?lesSpecialitesG.length.toString():"", Icons.car_repair),
//             SizedBox(height: 20),
//             FloatingActionButton.extended(
//               label: Text('Enregistrer'),
//               icon: Icon(Icons.navigation),
//               onPressed: () async {
//
//
//               },
//             ),
//           ],
//         );
//
//     }
//   }
//
// }
//
