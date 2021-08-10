import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:waarfira/core/model/specialite.dart';
import 'package:waarfira/core/model/praticien.dart';
import 'package:waarfira/core/model/specialite.dart';
import 'package:waarfira/core/service/specialite-service.dart';
import 'package:waarfira/core/service/praticien-service.dart';
import 'package:waarfira/core/service/specialite-service.dart';
import 'package:waarfira/core/service/user-details-service.dart';
import 'package:waarfira/core/service/user-service.dart';
import 'package:waarfira/core/util/MyAppColors.dart';
import 'package:waarfira/routes/routes.dart';
import 'package:waarfira/ui/step-indicator.dart';

import 'app-drawer.dart';

Specialite lesDonnees;
class ListSpecialites extends StatefulWidget {
  @override
  _ListSpecialitesState createState() => _ListSpecialitesState();
}

class _ListSpecialitesState extends State<ListSpecialites> {
  final _specialiteService = new SpecialiteService();
  List<Specialite> _specialites = [],
      _filteredSpecialites = [],
      _selectedSpecialites = [];
  String _searchValue;
  List<int> _checkedIds = [];
  bool _loading = true,
      _noSpecialitefounded = true;

  @override
  void initState() {
    super.initState();
    _fetchSpecialites();
  }

  _fetchSpecialites() async {
    await _specialiteService.getSpecialites().then((response) =>
    {
      if(response.statusCode == HttpStatus.ok){
        setState(() {
          _specialites = (jsonDecode(response.body).
          map((i) => Specialite.fromJson(i)).toList())
              .cast<Specialite>().toList();
          _filteredSpecialites = _specialites;
          _loading = false;
          if (_filteredSpecialites.isNotEmpty)
            _noSpecialitefounded = false;
          else
            _noSpecialitefounded = true;
          _checkedIds.clear();
        }),
      }
    });
  }

  void _filterSpecialites() {
    if (_searchValue != null && _searchValue != '') {
      _searchValue = _searchValue.toLowerCase().trim();
      setState(() {
        _filteredSpecialites = _specialites.where((specialite) =>
        specialite.name != null &&
            specialite.name.toLowerCase().contains(_searchValue)
        ).toList();
      });
    } else {
      setState(() {
        _filteredSpecialites = _specialites;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('SPECIALITES', style: TextStyle(color: MyAppColors.primaryColor)),
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
      if (_noSpecialitefounded) {
        return Container(
          margin: EdgeInsets.only(top: 30),
          child: Center(
            child: Text(
              'Acune specialite trouvé ', style: TextStyle(fontSize: 25),),
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
                  _filterSpecialites();
                });
              },
              decoration: InputDecoration(
                // labelText: "Search",
                hintText: "Choisissez une spécialité au moins...",
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
          child: _createSpecialiteListView(),
        ),
        //_createFloatingActionButon(),
        _createStepIndicatorContainer(),
      ],
    );
  }

  Widget _createSpecialiteListView() {
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
          itemCount: _filteredSpecialites.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) =>
              _createSpecialiteWidget(_filteredSpecialites[i]),
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

  Widget _createSpecialiteWidget(Specialite specialite) {
    return new Card(
      margin: EdgeInsets.only(bottom: 7,),
      child: new Container(
        padding: new EdgeInsets.all(3.0),
        child: new Column(
          children: <Widget>[
            new CheckboxListTile(
              value: _checkedIds.contains(specialite.id) ? true : false,
              title: new Text(
                specialite.name, style: TextStyle(fontSize: 20),),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool val) {
                _specialiteSelectChange(val, specialite.id);
              },
              selected: _checkedIds.contains(specialite.id) ? true : false,
              selectedTileColor: MyAppColors.primaryColor,
              subtitle: new Text((specialite.name != null
                  ? specialite.name
                  : "")),
              checkColor: MyAppColors.secondaryColor,
              activeColor: MyAppColors.secondaryColor,
              contentPadding: EdgeInsets.all(5.0),
            )
          ],
        ),
      ),
    );
  } // create specialite
  FloatingActionButton _createFloatingActionButon() {
    if (_checkedIds.length > 0) {
      return FloatingActionButton.extended(
        tooltip: _checkedIds.length.toString() +
            ' spécialités séléctionnée(s)',
        label: Text(_checkedIds.length.toString() + ' Suivant'),
        icon: Icon(Icons.navigation),
        onPressed: () {
          Navigator.pushNamed(context, Routes.medecins);
        },
      );
    }
    return null;
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
        child: StepIndicator(currentStep: 1, size: 3,totalSteps: 3,),
      ),
    );
  }

  void _specialiteSelectChange(bool val, int id) {
    setState(() {
      if (val)
        _checkedIds.add(id);
      else
        _checkedIds.remove(id);
    });

    _getSelectedSpecialites() {
      _selectedSpecialites.clear();
      _specialites.forEach((specialite) {
        if (_checkedIds.contains(specialite.id))
          _selectedSpecialites.add(specialite);
      });
    }
  }
}