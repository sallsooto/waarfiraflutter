import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waarfira/core/model/patient.dart';
import 'package:waarfira/core/model/praticien.dart';
import 'package:waarfira/core/model/rv.dart';
import 'package:waarfira/core/model/user-details.dart';
import 'package:waarfira/core/service/patient-service.dart';
import 'package:waarfira/core/service/user-details-service.dart';
import 'package:waarfira/core/util/DateConverter.dart';
import 'package:waarfira/core/util/MyAppColors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:waarfira/core/service/rv-service.dart';

import 'home-page.dart';

DateTime datePickerG=DateTime.now();
Patient patientG=new Patient();
Praticien medecinG;
UserDetails userG=new UserDetails();
final PatientService patientService=new PatientService();
class MeetingsPage extends StatefulWidget {
  final Praticien praticien;
  //const ListInfraction({Key key, @required this.pcdata}): super(key: key);
  MeetingsPage({@required this.praticien}){
    medecinG=this.praticien;
  }
  @override
  _MeetingsPageState createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  CalendarController myControl= new CalendarController();
  CalendarDataSource _dataSource;
  List<DateTime> _datesExclues=[];
  final RvService rvService=new RvService();
  final UserDetailsService userDetailsService = new UserDetailsService();

  @override
  void initState() {
    _getDataSource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Rendez-vous',style: TextStyle(color: MyAppColors.primaryColor),),
        centerTitle: true,
        backgroundColor: MyAppColors.secondaryColor,
      ),
      body:
      Center(
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            Container(
              height: 600.0,
              child: SfCalendar(
                initialDisplayDate: DateTime.now(),
                minDate: DateTime.now().subtract(Duration(hours: DateTime.now().hour)),
                showCurrentTimeIndicator: true,
                blackoutDates: _datesExclues,
                blackoutDatesTextStyle: TextStyle(backgroundColor: Colors.red,color: Colors.black),
                view: CalendarView.workWeek,
                onTap: calendarTapped,
                showDatePickerButton: true,
                dataSource:
                _dataSource,
                // by default the month appointment display mode set as Indicator, we can
                // change the display mode as appointment using the appointment display
                // mode property
                monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
              ),
            ),
            Container(
              alignment: Alignment.center,
              // margin: EdgeInsets.only(top: 70, left: 15, right: 15, bottom: 15),
              child: _buildLegend(),
              ),
          ],
        ),
      ),

    );
  }

  Widget _buildLegend() {
    return Container(
      color: MyAppColors.secondaryColor,
      child: Container(
        margin: EdgeInsets.only(top:10,bottom: 10),
        child: Row(
          children: <Widget>[
            Text('Non disponible', style: TextStyle(color: MyAppColors.primaryColor),),
            Container(
              margin: EdgeInsets.only(right: 30.0),
              height: 30.0,
              width: 50.0,
              color: Colors.teal,
            ),
            Text('Disponible', style: TextStyle(color: MyAppColors.primaryColor),),
            Container(
              height: 30.0,
              width: 50.0,
              color: MyAppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    print('dans calender tapped');
    bool exist=false;
    _datesExclues.forEach((element) {
      if (element.compareTo(calendarTapDetails.date)==0) {
        exist=true;
      }
    });
    if(!exist){
      _showMyDialog(calendarTapDetails);
    }

  }


   _getDataSource() async {

     userG=await userDetailsService.getStoredUserDetails().then((value) => value);
     if (userG!=null) {
       print('user id '+ userG.id.toString());
       print('affectation patient');
       await patientService.getPatientByUserId(userG.id).then((value) => {
         print('le body'),
         print(value.body),
         patientG=patientService.getPatientsByResponseBody(value.body)[0],
         print('id patient'),
         print(patientG.id),
       });
       print(patientG.id);
     }

    List<Rv> rvs=[];
    List<Appointment> appointments = <Appointment>[];
    await rvService.getRvByMedecinAndStatus(medecinG.id, 'VALID')
      .then((value) => {
      if(value.statusCode == HttpStatus.ok){
        setState(() {
        //rv=Rv.fromJson(jsonDecode(value.body)),
        rvs=rvService.getRvByResponseBody(value.body);
        if(rvs!=null){
          for(Rv rv in rvs){
            print('un ajout');
            print('date ');
            print(rv.dte);
            print('date Fin');
            print(rv.dte.add(Duration(hours: 1)));
            appointments.add(Appointment(
            startTime:rv.dte,
            endTime: rv.dte.add(Duration(hours: 1)),
            subject: rv.dte.hour.toString()+':'+rv.dte.minute.toString()+':'+rv.dte.second.toString(),
            color: Colors.teal,
            ));
            _datesExclues.add(rv.dte);
          }
          print('la taille '+appointments.length.toString());
         _dataSource=_DataSource(appointments);
        }
     }),
      }
    });
    /*appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 1)),
      subject: 'Meeting',
      color: Colors.teal,
    ));*/
    return _DataSource(appointments);
  }

  Future<void> _showMyDialog(CalendarTapDetails calendarTapDetails) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final insertionSnackBar = SnackBar(content: Text("Effectué avec succès, consultez votre boite mail"),
          backgroundColor: Colors.green,duration: Duration(seconds: 7, milliseconds: 500),);
        return AlertDialog(
          title: Text('Confirmation Rendez-vous'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Confirmez vous votre rendez-vous en date du '+
                    DateConverter.dateToString(calendarTapDetails.date) + " à "
                    + (calendarTapDetails.date.hour>9?calendarTapDetails.date.hour.toString():"0"
                        +calendarTapDetails.date.hour.toString())+
                    " h "+ (calendarTapDetails.date.minute>9?calendarTapDetails.date.minute.toString():"0"
                    +calendarTapDetails.date.minute.toString())+
                    " avec le praticien "+ medecinG.fullName +" ?" + "Après validation merci de consulter votre boite mail"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Valider'),
              onPressed: () {
                  Appointment app = Appointment(
                      startTime: calendarTapDetails.date,
                      endTime: calendarTapDetails.date.add(Duration(hours: 1)),
                      subject: 'Tapped appointment',
                      color: Colors.greenAccent);
                  _dataSource.appointments.add(app);
                  _dataSource.notifyListeners(
                      CalendarDataSourceAction.add, _dataSource.appointments);
                  print('medecin id '+medecinG.id.toString());
                  print('patient id '+patientG.id.toString());
                  rvService.createRv(new Rv(canceledByMedecin: false, dte:calendarTapDetails.date, status: 'VALID',
                      medecin: medecinG,patient: patientG))
                      .then((value) => {
                    print(value.body),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(insertionSnackBar);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (context) =>
                              HomePage()));
              },
            ),
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}


/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}

