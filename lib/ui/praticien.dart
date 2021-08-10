import 'package:flutter/material.dart';
import 'package:waarfira/core/service/praticien-service.dart';
import 'package:waarfira/core/util/MyAppColors.dart';
import 'package:waarfira/ui/step-indicator.dart';

class PraticienPage extends StatefulWidget {
  @override
  _PraticienPageState createState() => _PraticienPageState();
}

class _PraticienPageState extends State<PraticienPage> {
  var adresseCtrl = TextEditingController();
  var dateNaisCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var fullNameCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();
  var userIdCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  var confirmPasswordCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final PraticienService _praticienService = new PraticienService();

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    // = size.width;
    return Scaffold(
      key: _formKey,
      appBar: AppBar(
        title: Text('Praticiens'),
        centerTitle: true,
        backgroundColor: MyAppColors.primaryColor,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Center(
              //child:  _toggleProgressIndicator(),
              ),
          /*Padding(
              padding: EdgeInsets.all(4),
              child: _buildImage(c),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: _buildResultArea(c),
            ),*/

          SizedBox(height: 50),
          Container(
            width: 300,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: fullNameCtrl,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              decoration: new InputDecoration(
                  hintText: "Nom et Prénom",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyAppColors.secondaryColor,
                    ),
                  )),
              //fillColor: Colors.green
            ),
            //onChanged: (value) { _formFieldChangedHandler();},
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: phoneCtrl,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              decoration: new InputDecoration(
                hintText: "Numero de téléphone",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: MyAppColors.secondaryColor,
                  ),
                ),
                //fillColor: Colors.green
              ),
              /* onChanged: (value) {
                _formFieldChangedHandler();
              }, */
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: emailCtrl,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              decoration: new InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyAppColors.secondaryColor,
                    ),
                  )),
              //fillColor: Colors.green
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: passwordCtrl,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              obscureText: true,
              decoration: new InputDecoration(
                  hintText: "Mot de passe",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyAppColors.secondaryColor,
                    ),
                  )),
              //fillColor: Colors.green
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: confirmPasswordCtrl,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              obscureText: true,
              decoration: new InputDecoration(
                  hintText: "Confirmation du mot de passe",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyAppColors.secondaryColor,
                    ),
                  )),
              //fillColor: Colors.green
            ),
          ),
          SizedBox(height: 60),
          _createStepIndicatorCotainer(),
        ],
      ),
      floatingActionButton: _createFloatingActionButon(),
    );
  }

  Widget _createStepIndicatorCotainer() {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width - 50;
    return Container(
      width: itemWidth,
      margin: EdgeInsets.only(bottom: 25),
      child: Center(
        child: StepIndicator(
          currentStep: 1,
          size: 3,
        ),
      ),
    );
  }
}

FloatingActionButton _createFloatingActionButon() {
  //if(_formIsValid){
  return FloatingActionButton.extended(
    label: Text('Continuer'),
    icon: Icon(Icons.navigation),
    onPressed: () {
      /* if(_formIsValid){

            Navigator.push(context, MaterialPageRoute(builder: (context) => ListInfraction(pcdata:
            new PermisCarteGriseInfoModel(numMatricule: numImmatCtrl.text,
                numTitulaire: numTitulCtrl.text,nomCondicteur: titulCtrl.text,ispermis: false),)));
          } */
    },
  );
  //}
  return null;
}
