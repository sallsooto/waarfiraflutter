import 'dart:convert';
import 'dart:io';

import 'package:waarfira/core/util/Fonctions.dart';
import 'package:waarfira/ui/visio-conf.dart';

import 'core/model/jwt-token.dart';
import 'core/model/user-details.dart';
import 'core/service/user-details-service.dart';
import 'core/util/MyAppColors.dart';
import 'routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:waarfira/ui/home-page.dart';

import 'core/service/user-service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  // authorisation de tous les certificats
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waarfira',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: MyAppColors.primaryColor,
        accentColor: MyAppColors.secondaryColor,
        // Define the default font family.
        fontFamily: 'Time News Romain',
        timePickerTheme:TimePickerThemeData(backgroundColor: MyAppColors.secondaryColor),

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Time News Romain'),
        ),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightBlue,
      ),
      onGenerateRoute: (settings) =>
          new Routes().makeNamedRoute(context, settings),
      home: MyHomePage(title: 'LOGIN'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print('dans init state');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      /**appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),**/
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.center,
              margin: EdgeInsets.fromLTRB(0, 100, 15, 0),
              height: 130,
              width: 130,
              child: new Image.asset('assets/images/logo.png'),
            ),
            Container(
              alignment: Alignment.center,
              // margin: EdgeInsets.only(top: 70, left: 15, right: 15, bottom: 15),
              child: Container(
                child: LoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*****
 * login form party
 */
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _username;
  String _password;
  String matriculeAgent;
  Map<String, dynamic> tokenJson;
  JWTToken jwtToken;
  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();
  bool _hidePwdText=true;

  UserDetails userDetails;
  final UserDetailsService userDetailsService = new UserDetailsService();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(25),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Email';
                  } else {
                    _username = value;
                    return null;
                  }
                },
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                decoration: InputDecoration(
                    hintText: 'Email',
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
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Entrez le mot passe';
                  } else {
                    _password = value;
                    return null;
                  }
                },
                obscureText: _hidePwdText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                decoration: InputDecoration(
                    hintText: 'Mot de passe',
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
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: ElevatedButton(
                child: Text('Se connecter',
                    style: TextStyle(fontSize: 25, color: Colors.white)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print('username ' + _username);
                    UserService.authenticate(_username.trim(), _password)
                        .then((response) => {
                              print(response.statusCode),
                              if (response.statusCode == HttpStatus.ok)
                                {
                                  tokenJson = json.decode(response.body),
                                  jwtToken = JWTToken.fromJson(tokenJson),
                                  // saving token
                                  storage.write(
                                      key: 'token', value: jwtToken.id_token),
                                  // finding user infromation details
                                  userDetailsService
                                      .getAndstoreUserDetails()
                                      .then((value) => {
                                            userDetailsService
                                                .getStoredUserDetails()
                                                .then((value) => {
                                                      setState(() {
                                                        userDetails = value;
                                                        if (userDetails !=
                                                                null &&
                                                            userDetails
                                                                .activated) {
                                                          storage
                                                              .read(
                                                                  key:
                                                                      'userDetails')
                                                              .then((value) =>
                                                                  print(value));
                                                          userDetails
                                                              .getRoles()
                                                              .forEach((element) =>
                                                              print(
                                                                  element));
                                                          if(userDetails.getRoles().contains("ROLE_PATIENT")){
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                        HomePage()));
                                                          }
                                                          else {
                                                            displayDialog(
                                                                context,
                                                                'Profil',
                                                                "Cet utilisateur n'est pas un patient !");
                                                          }


                                                        } else {
                                                          displayDialog(
                                                              context,
                                                              'Erreur',
                                                              'Compte inactif !');
                                                        }
                                                      }),
                                                    }),
                                          }),
                                }
                              else
                                {
                                  if (response.statusCode ==
                                      HttpStatus.unauthorized)
                                    {
                                      displayDialog(context, 'Erreur',
                                          'Identifiants invalides !'),
                                    }
                                  else
                                    {
                                      displayDialog(
                                          context,
                                          'Erreur ' +
                                              response.statusCode.toString(),
                                          'Connexion echouée!'),
                                    }
                                }
                            })
                        .catchError((e) => {
                              print(e),
                              displayDialog(
                                  context, 'Erreur', 'Echec de la connexion'),
                            });
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
            Padding(
              padding: EdgeInsets.all(25),
              child: FlatButton(
                color: MyAppColors.primaryColor,
                splashColor: Colors.black,
                child: Text(
                  "S'inscrire",
                  style: TextStyle(
                    color: MyAppColors.secondaryColor,
                    fontSize: 25,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.patients);


                  /*Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('fonctionality not disponible..'),
                    backgroundColor: MyAppColors.secondaryColor,
                  ));*/
                },
              ),
            )
          ],
        ));
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: new Expanded(
                child: Container(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Text(
                            title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 30,
                                color: MyAppColors.secondaryColor,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25),
                            )),
                        SizedBox(
                          width: 320.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyAppColors.secondaryColor),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(10)),
                              minimumSize: MaterialStateProperty.all<Size>(Size(350, 40)),
                            ),
                            child: Text(
                              "Ok",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
  void _togglePwd() {
    setState(() {
      _hidePwdText= !_hidePwdText;
    });
  }
/*     Widget _createLinkItem(
    {IconData icon, String text, GestureTapCallback onTap}) 
      {
        return ListTile(
          title: Row(
            children: <Widget>[
              Icon(icon),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(text),
              )
            ],
          ),
          onTap: onTap,
        );
      } */
}
