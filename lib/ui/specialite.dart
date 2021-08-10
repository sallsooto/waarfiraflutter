import 'package:flutter/material.dart';
import 'package:waarfira/core/service/specialite-service.dart';
import 'package:waarfira/core/util/MyAppColors.dart';

import '../core/model/specialite.dart';

class SpecialitePage extends StatefulWidget {
  @override
  _SpecialitePageState createState() => _SpecialitePageState();
}

class _SpecialitePageState extends State<SpecialitePage> {
  var nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final SpecialiteService _specialiteService = new SpecialiteService();
  // constructor
  _SpecialitePageState() {
    // build searchbar
  }

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    //double itemWidth = size.width;
    return Scaffold(
      key: _formKey,
      appBar: AppBar(
        title: Text('Spécialités'),
        centerTitle: true,
        backgroundColor: MyAppColors.primaryColor,
      ),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 50),
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: TextFormField(
                      controller: nameCtrl,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Libellé';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'Libellé',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: MyAppColors.secondaryColor,
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: ElevatedButton(
                      child: Text('Enregistrer',
                          style: TextStyle(fontSize: 25, color: Colors.white)),
                      onPressed: () async {
                        await _specialiteService
                            .createSpecialite(
                                new Specialite(name: nameCtrl.text))
                            .then((value) async => {print('enregistrer')});
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            MyAppColors.secondaryColor),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(10)),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(350, 40)),
                      ),
                    ),
                  ),
                ],
              ))),
        ],
      ),
    );
  }
}
