import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:waarfira/core/service/geolocation-service.dart';
import 'package:waarfira/core/util/DateConverter.dart';
import 'package:flutter/rendering.dart';
import 'package:waarfira/core/model/patient.dart';
import 'package:waarfira/core/model/praticien.dart';
import 'package:waarfira/core/service/praticien-service.dart';
import 'package:waarfira/core/util/MyAppColors.dart';
import 'package:waarfira/ui/meetings.dart';
import 'package:waarfira/ui/step-indicator.dart';

import 'app-drawer.dart';

Praticien medecinG;
Patient patientG;
class ListPraticiens extends StatefulWidget {
  @override
  _ListPraticiensState createState() => _ListPraticiensState();
}

class _ListPraticiensState extends State<ListPraticiens> {
  final _praticienService = new PraticienService();
  final _geolocationService = new GeolocationService();
  Position _currentPosition = new Position();
  List<Praticien> _praticiens = [],
      _filteredPraticiens = [],
      _selectedPraticiens = [];
  String _searchValue;
  List<int> _checkedIds = [];
  bool _loading = true,
      _noPraticienfounded = true;
  var dateCtrl = TextEditingController();
  double _rayonDeRecherche=20.0;

  @override
  void initState() {
    super.initState();
    _fetchPraticiens();
  }

  _fetchPraticiens() async {
    _currentPosition= await _geolocationService.determinePosition();
    await _praticienService.getMedecins().then((response) =>
    {
      if(response.statusCode == HttpStatus.ok){
        setState(() {
          _praticiens = (jsonDecode(response.body).
          map((i) => Praticien.fromJson(i)).toList())
              .cast<Praticien>().toList();
          _filteredPraticiens = _praticiens;
          _loading = false;
          if (_filteredPraticiens.isNotEmpty)
            _noPraticienfounded = false;
          else
            _noPraticienfounded = true;
          _checkedIds.clear();
        }),
      }
    });
  }

  void _filterPraticiens() {
    
      print('dans filter');
      print('rayon '+_rayonDeRecherche.toString());
      // ignore: unnecessary_statements
      _searchValue != null ?_searchValue.toLowerCase().trim():"";
      print('taille praticiens '+_praticiens.length.toString());
      setState(() {
        _praticiens.forEach((element) {
          print(element.fullName);
          print(_geolocationService.getDistanceInKm(_currentPosition.latitude,
              _currentPosition.longitude, element.latitude, element.longitude).toString());
        });
        if(_searchValue==null){
          _filteredPraticiens = _praticiens.where((praticien) =>
              _geolocationService.getDistanceInKm(_currentPosition.latitude,
                  _currentPosition.longitude, praticien.latitude, praticien.longitude) <= _rayonDeRecherche
          ).toList();
        }
        else{
          _filteredPraticiens = _praticiens.where((praticien) =>
          _geolocationService.getDistanceInKm(_currentPosition.latitude,
              _currentPosition.longitude, praticien.latitude, praticien.longitude) <= _rayonDeRecherche
              && praticien.fullName.toLowerCase().contains(_searchValue)
          ).toList();
        }
      });
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('PRATICIENS', style: TextStyle(color: MyAppColors.primaryColor)),
        centerTitle: true,
        backgroundColor: MyAppColors.secondaryColor,
        iconTheme: new IconThemeData(color: MyAppColors.primaryColor),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: _createBody(),
      ),
      floatingActionButton: _createFloatingActionButon(),
    );
  } // build

  Widget _createBody() {
    if (_loading) {
      return Container(
        margin: EdgeInsets.only(top: 30),
        child: Center(
          child: Text('Chargement...', style: TextStyle(fontSize: 25),),
        ),
      );
    } else {
      if (_noPraticienfounded) {
        return Container(
          margin: EdgeInsets.only(top: 30),
          child: Center(
            child: Text(
              'Aucun praticien trouvé ', style: TextStyle(fontSize: 25),),
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
                      top: 10, left: 7, right: 7, bottom: 7),
                  child: TextFormField(
                                           controller: dateCtrl,
                                           validator: (value) {
                                             if (value.isEmpty) {
                                               return 'Champ obligatoire';
                                             } else {
                                               return null;
                                             }
                                           },
                                           //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                           onTap: (){
                                             selectDate(context);
                                           },
                                           readOnly: true,
                                           decoration: new InputDecoration(
                                             suffixIcon: Icon(Icons.event_note),
                                             hintText: "Date Rv",
                                             border: OutlineInputBorder(borderRadius: BorderRadius.only(
                                                               topLeft: Radius.circular(20),
                                                               bottomRight: Radius.circular(20),
                                                             )),
                                              filled: true,
                                              fillColor: Colors.white70
                                           ),
                                           /* onChanged: (value) {
                                         _formFieldChangedHandler();
                                       }, */
                                         ),
                ),
                decoration: BoxDecoration(
                  color: MyAppColors.secondaryColor,
                ),
              ),

        Container(
          width: itemWidth,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 3, left: 7, right: 7, bottom: 7),
            child: SfLinearGauge(
              markerPointers: [
                LinearShapePointer(
                    value: _rayonDeRecherche,
                    borderColor: Colors.blue[800],
                    //Changes the value of shape pointer based on interaction
                    onValueChanged: (value) {
                      setState(() {
                        _rayonDeRecherche = value;
                        _filterPraticiens();
                      });
                    },
                    color: MyAppColors.secondaryColor),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: MyAppColors.primaryColor,
          ),
        ),

        Container(
          width: itemWidth,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 3, left: 7, right: 7, bottom: 7),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchValue = value;
                  _filterPraticiens();
                });
              },
              decoration: InputDecoration(
                hintText: "Rechercher un medecin...",
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
            color: MyAppColors.secondaryColor,
          ),
        ),
        Expanded(
          child: _createPraticienListView(),
        ),
        _createStepIndicatorContainer(),
      ],
    );
  }

  Widget _createPraticienListView() {
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
          itemCount: _filteredPraticiens.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) =>
              _createPraticienWidget(_filteredPraticiens[i]),
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

  Widget _createPraticienWidget(Praticien praticien) {
    return new Card(
      margin: EdgeInsets.only(bottom: 7,),
      child: new Container(
        padding: new EdgeInsets.all(3.0),
        child: new Column(
          children: <Widget>[
            new CheckboxListTile(
              value: _checkedIds.contains(praticien.id) ? true : false,
              title: new Text(
                praticien.fullName, style: TextStyle(fontSize: 20),),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool val) {
                _praticienSelectChange(val, praticien.id);
                medecinG=praticien;
              },
              selected: _checkedIds.contains(praticien.id) ? true : false,
              selectedTileColor: MyAppColors.primaryColor,
              subtitle: new Text((praticien.fullName != null
                  ? praticien.fullName
                  : "")),
              checkColor: MyAppColors.secondaryColor,
              activeColor: MyAppColors.secondaryColor,
              contentPadding: EdgeInsets.all(5.0),
            )
          ],
        ),
      ),
    );
  }// create praticien
  FloatingActionButton _createFloatingActionButon() {
    if (_checkedIds.length == 1) {
      return FloatingActionButton.extended(
        tooltip: _checkedIds.length.toString() +
            ' médécins séléctionnée(s)',
        label: Text(_checkedIds.length.toString() + ' Suivant'),
        icon: Icon(Icons.navigation),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MeetingsPage(praticien: medecinG)
            ),
          );
        },
      );
    }
    return null;
  }

  selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        helpText: 'Selectionnez une date svp!',
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
        dateCtrl.text=DateConverter.dateToString(datePickerG);
      });
    }


  Widget _createStepIndicatorContainer() {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemWidth = size.width - 50;
    return Container(
      width: itemWidth,
      margin: EdgeInsets.only(bottom: 25),
      child: Center(
        child: StepIndicator(currentStep: 2, size: 3, totalSteps: 3,),
      ),
    );
  }

  void _praticienSelectChange(bool val, int id) {
    setState(() {
      if (val)
        _checkedIds.add(id);
      else
        _checkedIds.remove(id);
    });


    _getSelectedPraticiens() {
      _selectedPraticiens.clear();
      _praticiens.forEach((praticien) {
        if (_checkedIds.contains(praticien.id))
          _selectedPraticiens.add(praticien);
      });
    }
  }
}