import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:waarfira/core/model/app-file.dart';
import 'package:waarfira/core/model/consultation-file.dart';
import 'package:waarfira/core/model/consultation.dart';
import 'package:waarfira/core/model/rv.dart';
import 'package:waarfira/core/service/app-file-service.dart';
import 'package:waarfira/core/service/consultation-file-service.dart';
import 'package:waarfira/core/service/consultation-service.dart';
import 'package:waarfira/core/util/MyAppColors.dart';
import 'package:waarfira/ui/app-drawer.dart';

import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';

import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart';


Rv rvG;
Consultation consultationG;

class VisioConf extends StatefulWidget {
  final Consultation consultation;
  VisioConf({@required this.consultation}){
    consultationG=this.consultation;
  }

  @override
  _VisioConfState createState() => _VisioConfState();
}
enum Upload { fichier, dossier }
class _VisioConfState extends State<VisioConf> {
  final _appFileService = new AppFileService();
  final _consultationFileService = new ConsultationFileService();
  AppFile fichier;
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "plugintestroom");
  final subjectText = TextEditingController(text: "My Plugin Test Meeting");
  final nameText = TextEditingController(text: "Plugin Test User");
  //final emailText = TextEditingController(text: "fake@email.com");
  //final iosAppBarRGBAColor =
  //TextEditingController(text: "#0080FF80"); //transparent blue
  bool isAudioOnly = true;
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  List<File> filesSelected=[];
  List<ConsultationFile> filesConsultationSelected=[];
  Uint8List bytes;

  @override
  void initState() {
    super.initState();
    serverText.text= "";
    roomText.text= consultationG.roomName;
    subjectText.text = "Consultation par "+consultationG.rv.medecin.fullName;
    nameText.text = consultationG.rv!=null?consultationG.rv.patient.fullName:"";
    _fetchConsultationFiles();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Consultations'),
          centerTitle: true,
          backgroundColor: MyAppColors.secondaryColor,
        ),
        drawer: AppDrawer(),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: kIsWeb
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.30,
                child: meetConfig(),
              ),
              Container(
                  width: width * 0.60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        color: Colors.white54,
                        child: SizedBox(
                          width: width * 0.60 * 0.70,
                          height: width * 0.60 * 0.70,
                          child: JitsiMeetConferencing(
                            extraJS: [
                              // extraJs setup example
                              '<script>function echo(){console.log("echo!!!")};</script>',
                              '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                            ],
                          ),
                        )),
                  ))
            ],
          )
              : meetConfig(),
        ),
      ),
    );
  }

  Upload _typeUpload = Upload.fichier;

  Widget meetConfig() {

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
       /*   TextField(
            controller: serverText,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Server URL",
                hintText: "Hint: Leave empty for meet.jitsi.si"),
          ),*/

          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: subjectText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Titre",
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: nameText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nom complet",
            ),
          ),
          SizedBox(
            height: 14.0,
          ),


          SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: Text("Audio Only"),
            value: isAudioOnly,
            onChanged: _onAudioOnlyChanged,
          ),
          SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: Text("Audio Muted"),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),
          SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: Text("Video Muted"),
            value: isVideoMuted,
            onChanged: _onVideoMutedChanged,
          ),
          Divider(
            height: 48.0,
            thickness: 2.0,
          ),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                _joinMeeting();
              },
              child: Text(
                "Rejoindre",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => MyAppColors.secondaryColor)),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  <Widget>[
              Container(
                margin:EdgeInsets.only(right: 50),
                child: Text("Fichiers/Dossiers", style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              SizedBox(
                height: 5.0,
              ),

            GestureDetector(
              onTap: () =>{
                _fetchConsultationFiles(),
                print("nombre de fichiers joints:"+filesConsultationSelected.length.toString()),
              showModalBottomSheet<void>(

              // context and builder are
              // required properties in this widget
              context: context,
              builder: (BuildContext context) {
               return StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Les fichiers et dossiers partagés'),
                        for ( var item in filesConsultationSelected )
                          Container(
                            height: 50,
                            margin: EdgeInsets.only(left: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(item.fileName),
                                    GestureDetector(
                                      onTap: ()=>{
                                      },
                                      child: Icon(
                                        Icons.insert_drive_file_rounded,
                                        color: MyAppColors.secondaryColor,
                                        size: 40.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0)


                              ],
                            ),

                          ),
                        GestureDetector(
                          onTap: ()=>{
                            _loadFile(),
                          },
                          child: Icon(
                            Icons.add_circle,
                            color: Colors.black,
                            size: 40.0,
                          ),
                        ),

                        // This goes to the build method

                        RadioListTile<Upload>(
                          title: const Text('Fichier'),
                          value: Upload.fichier,
                          groupValue: _typeUpload,
                          onChanged: (Upload value) { setState(() { _typeUpload = value; print(_typeUpload); }); },
                        ),
                        RadioListTile<Upload>(
                          title: const Text('Dossier'),
                          value: Upload.dossier,
                          groupValue: _typeUpload,
                          onChanged: (Upload value) { setState(() { _typeUpload = value; print(_typeUpload); }); },
                        ),


                      ],
                    ),
                );
              },

                );

              },
              )
              },
              child: Container(
                width: 52.0,
                height: 52.0,
                margin: EdgeInsets.only(right: 55),
                decoration: new BoxDecoration(
                  color: MyAppColors.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.upload_file_sharp,
                  color: Colors.black,
                  size: 40.0,
                ),
              ),
            ),


            ],
          )
        ],
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  //Chargement de fichiers pour le partage de dossiers
  _loadFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'docx', 'png', 'jpeg', 'txt'],
    );

    if(result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      if(files.length >0){
        filesSelected=files;
        print("la taille:"+filesSelected.length.toString());
        filesSelected.forEach((file) async {
          print("le chemin "+file.path);
          await file.readAsBytes().then((value) => {
              bytes = Uint8List.fromList(value),
              print('reading of bytes is completed'),
          });
          await _appFileService.createAppFile(new AppFile(
          name: path.basename(file.path),
          fDataContentType: "document",
          fData:bytes
          )).then((value) async => {
            print("un fichier créé "+ value.toString()),
            fichier = AppFile.fromJson(jsonDecode(value.body)),
            if(fichier!=null)
              await _consultationFileService.createConsultationFile(new
                ConsultationFile(fileId: fichier.id,
                  consultation: consultationG,
                  fileName: fichier.name,
                  ownerId: consultationG.rv.patient.id))
          }).then((consultationFile) => {
            print("un fichier consultation créé"+ consultationFile.toString()),
          });
        });

      }

    } else {
      // User canceled the picker
    }
  }

  _joinMeeting() async {
    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: roomText.text)
      ..serverURL = "https://meet.jit.si/"
      ..subject = subjectText.text
      ..userDisplayName = nameText.text
      //..userEmail = emailText.text
      //..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": roomText.text,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": nameText.text}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  _fetchConsultationFiles() async {
    await _consultationFileService.getAllConsultationFiles().then((response) =>
    {
      if(response.statusCode == HttpStatus.ok){
        setState(() {
          filesConsultationSelected = (jsonDecode(response.body).
          map((i) => ConsultationFile.fromJson(i)).toList())
              .cast<ConsultationFile>().toList();
        }),
      }
    });
  }


}
