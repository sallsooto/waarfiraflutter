import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waarfira/core/model/patient.dart';
import 'package:waarfira/core/service/patient-service.dart';
import 'package:waarfira/core/util/DateConverter.dart';
import 'package:waarfira/core/util/MyAppColors.dart';
import 'package:waarfira/routes/routes.dart';
import 'package:waarfira/ui/app-drawer.dart';
import 'package:date_field/date_field.dart';

Patient patientG;
DateTime datePickerG=DateTime.now();
class PatientProchePage extends StatefulWidget {
  final Patient patient;
  PatientProchePage(this.patient){
    patientG=this.patient;
  }
  @override
  _PatientProchePageState createState() => _PatientProchePageState();
}

class _PatientProchePageState extends State<PatientProchePage> {
  var adresseCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var fullNameCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();
  var userIdCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  var confirmPasswordCtrl = TextEditingController();
  var dateNaissCtrl = TextEditingController();
  String dateNaissance;
  PatientService patientService=new PatientService();
  bool checkedValue=false;
  bool _obscurePwdText=true;
  bool _obscurePwdConfirmText=true;

  final _formKey = GlobalKey<FormState>();
  final PatientService _patientService = new PatientService();

  final conditionsSnackBar = SnackBar(content: Text("Vous n'avez pas accepter les conditions d'utilisation"),
      backgroundColor: Colors.red, duration: Duration(seconds: 4, milliseconds: 500));
  final insertionSnackBar = SnackBar(content: Text("Effectué avec succès, consultez votre boite mail"),
    backgroundColor: Colors.green,duration: Duration(seconds: 7, milliseconds: 500),);
  final faildSnackBar = SnackBar(content: Text("Un problème est survenu", ),
      backgroundColor: Colors.red,duration: Duration(seconds: 4, milliseconds: 500));
  final emptyFieldsSnackBar = SnackBar(content: Text("Veuillez remplir tous les champs!", ),
      backgroundColor: Colors.red,duration: Duration(seconds: 4, milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    // = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un proche',style: TextStyle(color: MyAppColors.primaryColor),),
        centerTitle: true,
        backgroundColor: MyAppColors.secondaryColor,
        iconTheme: new IconThemeData(color: MyAppColors.primaryColor),
      ),
      drawer: AppDrawer(),
      body: Form(
          key: _formKey,
          child:
          ListView(
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    } else {
                      return null;
                    }
                  },
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    } else {
                      return null;
                    }
                  },
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
                  validator: (value) {
                    RegExp exp = new RegExp(r"(^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$)");
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    }
                    else if(!exp.hasMatch(value)){
                      return 'Email non valide';
                    }
                    else {
                      return null;
                    }
                  },
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
                  controller: dateNaissCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  onTap: (){
                    selectDate(context);
                  },
                  readOnly: true,
                  decoration: new InputDecoration(
                    suffixIcon: Icon(Icons.event_note),
                    hintText: "Date Naissance",
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    } else {
                      return null;
                    }
                  },
                  controller: passwordCtrl,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  obscureText: _obscurePwdText,
                  decoration: new InputDecoration(
                      hintText: "Mot de passe",
                      suffixIcon: Padding(
                          padding: EdgeInsets.all(0),
                          child: IconButton(
                            color: Colors.black45,
                            icon: Icon(Icons.lock),
                            onPressed: _togglePwd,
                          )),
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    }
                    else if(value.compareTo(passwordCtrl.text)!=0){
                      return 'Mots de passe non conformes';
                    }
                    else {
                      return null;
                    }
                  },
                  controller: confirmPasswordCtrl,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  obscureText: _obscurePwdConfirmText,
                  decoration: new InputDecoration(
                      hintText: "Confirmation",
                      suffixIcon: Padding(
                          padding: EdgeInsets.all(0),
                          child: IconButton(
                            color: Colors.black45,
                            icon: Icon(Icons.lock),
                            onPressed: _toggleConfirmPwd,
                          )),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyAppColors.secondaryColor,
                        ),
                      )),
                  //fillColor: Colors.green
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(0),
                  child: CheckboxListTile(
                    title: Text("J'accepte les conditions d'utilisation",style: TextStyle(fontWeight: FontWeight.bold),),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  )
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(5),
                child: FlatButton(
                  color: MyAppColors.secondaryColor,
                  splashColor: Colors.black,
                  child: Text(
                    "Enregistrer",
                    style: TextStyle(
                      color: MyAppColors.primaryColor,
                      fontSize: 25,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (!checkedValue) {
                        ScaffoldMessenger.of(context).showSnackBar(conditionsSnackBar);
                        /*scaffold.showSnackBar(
                      SnackBar(
                        content: Text("Vous n'avez pas accepter les conditions d'utilisation"),
                        backgroundColor: MyAppColors.secondaryColor,
                      ),
                    );*/

                      }
                      else{
                        patientService.createPatient(new Patient(dateNais:dateNaissance,email: emailCtrl.text,firstName: fullNameCtrl.text,
                            adresse: adresseCtrl.text,phone: phoneCtrl.text,fullName: fullNameCtrl.text),
                            emailCtrl.text, passwordCtrl.text,patientG).then((value) =>
                        {
                          _formKey.currentState.reset(),
                          ScaffoldMessenger.of(context).showSnackBar(insertionSnackBar),
                        });
                      }

                    }
                    else ScaffoldMessenger.of(context).showSnackBar(emptyFieldsSnackBar);
                  },
                ),
              ),
            ],
          )),
    );
  }

  // Toggles the password show status
  void _togglePwd() {
    setState(() {
      _obscurePwdText = !_obscurePwdText;
    });
  }
  void _toggleConfirmPwd() {
    setState(() {
      _obscurePwdConfirmText = !_obscurePwdConfirmText;
    });
  }
   selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      helpText: 'Date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Valider',
      errorFormatText: 'Format invalide',
      errorInvalidText: 'Date Invalide',
      fieldLabelText: 'Date de naissance',
      fieldHintText: 'Mois/Jour/Année',
      context: context,
      initialDate: datePickerG,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
                primary: MyAppColors.secondaryColor,
            )
          ),
          child: child,
        );
      },
    );
    if(picked!=null && picked!=datePickerG)
    setState(() {
      datePickerG=picked;
      dateNaissCtrl.text=DateConverter.dateToString(datePickerG);
    });
  }
}


