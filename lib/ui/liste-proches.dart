import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:waarfira/core/model/patient.dart';
import 'package:waarfira/core/model/user-details.dart';
import 'package:waarfira/core/service/patient-service.dart';
import 'package:waarfira/core/service/user-details-service.dart';
import 'package:waarfira/core/service/user-service.dart';
import 'package:waarfira/core/util/MyAppColors.dart';
import 'package:waarfira/ui/patient-proche.dart';

import 'app-drawer.dart';

Patient lesDonnees;
Patient patientG;
class ListPatients extends StatefulWidget {
  final Patient patient;
  ListPatients({@required this.patient}){
    patientG=this.patient;
 }
  @override
  _ListPatientsState createState() => _ListPatientsState();
}

class _ListPatientsState extends State<ListPatients> {
  final _patientService = new PatientService();
  final UserService userService=new UserService();
  final UserDetailsService userDetailsService = new UserDetailsService();
  UserDetails userG=new UserDetails();
  List<Patient> _patients = [],
      _filteredPatients = [],
      _selectedPatients = [];
  String _searchValue;
  List<int> _checkedIds = [];
  bool _loading = true,
      _noPatientfounded = true;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  _fetchPatients() async {
    await _patientService.getPatients().then((response) =>
    {
      if(response.statusCode == HttpStatus.ok){
        setState(() {
          _patients = (jsonDecode(response.body).
          map((i) => Patient.fromJson(i)).toList())
              .cast<Patient>().toList();
          _filteredPatients = _patients;
          _loading = false;
          if (_filteredPatients.isNotEmpty)
            _noPatientfounded = false;
          else
            _noPatientfounded = true;
          _checkedIds.clear();
        }),
      }
    });
  }

  void _filterPatients() {
    if (_searchValue != null && _searchValue != '') {
      print('search in ' + _searchValue);
      _searchValue = _searchValue.toLowerCase().trim();
      setState(() {
        _filteredPatients = _patients.where((patient) =>
        patient.lastName != null &&
            patient.lastName.toLowerCase().contains(_searchValue)
        ).toList();
      });
    } else {
      setState(() {
        _filteredPatients = _patients;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('MES PROCHES', style: TextStyle(color: MyAppColors.primaryColor)),
        centerTitle: true,
        backgroundColor: MyAppColors.secondaryColor,
        iconTheme: new IconThemeData(color: MyAppColors.primaryColor),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: _createBody(),
      ),
      //floatingActionButton: _createFloatingActionButon(),
    );
  } // build

  Widget _createBody() {
    if (_loading) {
      return Container(
        margin: EdgeInsets.only(top: 30),
        child: Center(
          child: Text('loading...', style: TextStyle(fontSize: 25),),
        ),
      );
    } else {
      if (_noPatientfounded) {
        return Container(
          margin: EdgeInsets.only(top: 30),
          child: Center(
            child: Text(
              'Acune infraction trouvé ', style: TextStyle(fontSize: 25),),
          ),
        );
      } else {
        return _createMainBodyContent();
      }
    }
  }

  Widget _createMainBodyContent() {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemWidth = size.width;
    return Column(
      children: [
        Container(
          width: itemWidth,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 3, left: 7, right: 7, bottom: 7),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchValue = value;
                  _filterPatients();
                });
              },
              decoration: InputDecoration(
                // labelText: "Search",
                hintText: "Rechercher un proche...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: MyAppColors.primaryColor,
          ),
        ),
        Container(
          child:new ElevatedButton(
            child: Text('Ajouter',
                style: TextStyle(fontSize: 25, color: Colors.white)),
            onPressed: () async {
              userG=await userDetailsService.getStoredUserDetails().then((value) => value);
              if (userG!=null) {
                patientG=await _patientService.findByUserId(userG.id).then((value) => value);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientProchePage(patientG)
                      //builder: (context) => ListPatients()
                  ),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  MyAppColors.secondaryColor),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(10)),
              minimumSize: MaterialStateProperty.all<Size>(Size(350, 40)),
            ),
          ),
        ),
        Expanded(
          child: _createPatientListView(),
        ),
        _createStepIndicatorCotainer(),
      ],
    );
  }

  Widget _createPatientListView() {
    var size = MediaQuery
        .of(context)
        .size;
    /*24 is for notification bar on Android*/
    final double itemHeight = ((size.height - kToolbarHeight - 24) / 2) +
        ((size.height - kToolbarHeight - 24) / 6);
    final double itemWidth = size.width - 30;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: itemHeight,
        width: itemWidth,
        margin: EdgeInsets.only(top: 30, bottom: 0, left: 7, right: 7),
        padding: EdgeInsets.all(3.0),
        child: ListView.builder(
          itemCount: _filteredPatients.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) =>
              _createPatientWidget(_filteredPatients[i]),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: MyAppColors.primaryColor.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          // border: Border.all(color: MyAppColors.primaryColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  Widget _createPatientWidget(Patient patient) {
    return new Card(
      margin: EdgeInsets.only(bottom: 7,),
      child: new Container(
        padding: new EdgeInsets.all(3.0),
        child: new Column(
          children: <Widget>[
            new CheckboxListTile(
              value: _checkedIds.contains(patient.id) ? true : false,
              title: new Text(
                patient.fullName, style: TextStyle(fontSize: 20),),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool val) {
                _patientSelectChange(val, patient.id);
              },
              selected: _checkedIds.contains(patient.id) ? true : false,
              selectedTileColor: MyAppColors.primaryColor,
              subtitle: new Text((patient.email != null
                  ? patient.email
                  : "")),
              checkColor: MyAppColors.primaryColor,
              activeColor: Colors.white,
              contentPadding: EdgeInsets.all(5.0),
            )
          ],
        ),
      ),
    );
  } // create infraction
  Widget _createStepIndicatorCotainer() {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemWidth = size.width - 50;
    return Container(
      width: itemWidth,
      margin: EdgeInsets.only(bottom: 25),
      child: Center(
        //child: StepIndicator(currentStep: 4, size: 7,),
      ),
    );
  }

  void _patientSelectChange(bool val, int id) {
    setState(() {
      if (val)
        _checkedIds.add(id);
      else
        _checkedIds.remove(id);
    });

    FloatingActionButton _createFloatingActionButon() {
      if (_checkedIds.length > 0) {
        return FloatingActionButton.extended(
          tooltip: _checkedIds.length.toString() +
              ' spécialités séléctionnée(s)',
          label: Text(_checkedIds.length.toString() + ' Continuer'),
          icon: Icon(Icons.navigation),
          onPressed: () {
            // navigation to pv edition
            //_getSelectedPatients();
          },
        );
      }
      return null;
    } // _createFloatingActionButon

    _getSelectedPatients() {
      _selectedPatients.clear();
      _patients.forEach((patient) {
        if (_checkedIds.contains(patient.id))
          _selectedPatients.add(patient);
      });
    }
  }
}